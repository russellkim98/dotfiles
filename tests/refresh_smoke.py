#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["rich>=13.7.0"]
# ///
"""Smoke test for ../refresh. Runs no real commands.

Every subprocess is replaced by a fake that answers git's questions per scenario, and the
whole dashboard (DAG, rendering, summary) runs against it. It checks that:
  - every scenario finishes without a failed row
  - the dotfiles row only fast-forwards, and anything else turns into a yellow warning
  - refresh never runs `git pull --rebase`, `--autostash`, `stash` or `container ... prune`
  - `uv cache prune` is detached (refresh's own `uv run` holds the cache lock)

Run: tests/refresh_smoke.py   (the pre-commit hook runs it when refresh is staged)
"""

from __future__ import annotations

import asyncio
import importlib.machinery
import importlib.util
import io
import os
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = os.path.dirname(os.path.abspath(__file__))
REFRESH = os.path.join(HERE, "..", "refresh")

loader = importlib.machinery.SourceFileLoader("refresh_under_test", REFRESH)
spec = importlib.util.spec_from_loader(loader.name, loader)
mod = importlib.util.module_from_spec(spec)
sys.modules[loader.name] = mod
loader.exec_module(mod)

from rich.console import Console  # noqa: E402

REAL_EXEC = asyncio.create_subprocess_exec
FORBIDDEN = ("--rebase", "--autostash", " stash", "container image prune", "container prune")

# scenario: (ahead, behind, dirty, in_progress_marker, fetch_rc) -> expected dotfiles status
SCENARIOS = {
    "up-to-date": ((0, 0, False, None, 0), "done"),
    "behind-clean": ((0, 3, False, None, 0), "done"),
    "ahead": ((2, 0, False, None, 0), "warn"),
    "diverged": ((2, 3, False, None, 0), "warn"),
    "behind-dirty": ((0, 1, True, None, 0), "warn"),
    "mid-rebase": ((0, 0, False, "rebase-merge", 0), "warn"),
    "offline": ((0, 0, False, None, 1), "warn"),
}


def run_scenario(name: str, state: tuple, git_dir: str) -> tuple[str, list[str], str]:
    ahead, behind, dirty, marker, fetch_rc = state
    for n in ("rebase-merge", "rebase-apply", "MERGE_HEAD", "CHERRY_PICK_HEAD"):
        path = os.path.join(git_dir, n)
        if os.path.isdir(path):
            os.rmdir(path)
        elif os.path.exists(path):
            os.remove(path)
    if marker:
        os.mkdir(os.path.join(git_dir, marker))

    calls: list[str] = []

    async def fake_exec(*cmd, **kw):
        line = " ".join(map(str, cmd))
        calls.append(line)
        out, rc = "fake output\n", 0
        if "rev-parse --absolute-git-dir" in line:
            out = git_dir
        elif "rev-list --left-right --count" in line:
            out = f"{ahead}\t{behind}"
        elif "status --porcelain" in line:
            out = " M .zshrc\n" if dirty else ""
        elif " fetch " in f" {line} ":
            rc = fetch_rc
        elif "npm list -g" in line:
            out = "/opt/homebrew/lib\n"
        kw.pop("cwd", None)
        env = dict(kw.pop("env", None) or os.environ)
        env.update(FAKE_OUT=out, FAKE_RC=str(rc))
        return await REAL_EXEC("/bin/sh", "-c", 'printf "%s" "$FAKE_OUT"; exit "$FAKE_RC"', env=env, **kw)

    mod.asyncio.create_subprocess_exec = fake_exec
    dash = mod.RefreshDashboard()
    dash.console = Console(file=io.StringIO(), force_terminal=True, width=120, height=40)
    rc = asyncio.run(dash.run())
    mod.asyncio.create_subprocess_exec = REAL_EXEC
    failed = [t.name for t in dash.tasks if t.status == "failed"]
    if failed or rc != 0:
        raise AssertionError(f"{name}: failed rows {failed}, rc={rc}")
    return dash.task_map["dotfiles"].status, calls, dash.task_map["dotfiles"].last_line


def main() -> int:
    problems = []
    with tempfile.TemporaryDirectory() as git_dir:
        for name, (state, want) in SCENARIOS.items():
            try:
                got, calls, detail = run_scenario(name, state, git_dir)
            except AssertionError as exc:
                problems.append(str(exc))
                continue
            bad = [c for c in calls if any(f in f" {c}" for f in FORBIDDEN)]
            pulled = [c for c in calls if " pull" in c]
            fg_prune = [c for c in calls if "uv cache prune" in c and "nohup" not in c]
            if fg_prune:
                problems.append(f"{name}: foreground uv cache prune deadlocks on refresh's own uv lock: {fg_prune}")
            if got != want:
                problems.append(f"{name}: dotfiles status {got!r}, expected {want!r} ({detail})")
            if bad:
                problems.append(f"{name}: forbidden command(s): {bad}")
            if name == "behind-clean" and not any("--ff-only" in c for c in pulled):
                problems.append(f"{name}: expected a git pull --ff-only, got {pulled}")
            if name != "behind-clean" and pulled:
                problems.append(f"{name}: should not pull, but ran {pulled}")
            print(f"  {'ok ' if got == want and not bad else 'BAD'} {name:<13} -> {got:<4}  {detail}")
    if problems:
        print("refresh smoke test FAILED:\n  " + "\n  ".join(problems))
        return 1
    print("refresh smoke test passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
