# Dotfiles Repository

This repository contains dotfiles and configuration for setting up a macOS development environment with AstroNvim.

## Quick Setup

To set up everything automatically, run:

```bash
./deploy.sh
```

This will:
1. Install Homebrew (if not already installed)
2. Install iTerm2 Shell Integration
3. Install Zsh plugin manager (Zgenom)
4. Apply macOS defaults
5. Install packages from Brewfile
6. Create symbolic links for dotfiles

## Manual Symlink Setup

If you only want to update the symbolic links (after making changes to configs), you can run:

```bash
./symlink.sh
```

This will create symlinks for:
- `astronvim_user_config/` → `~/.config/nvim` (Neovim/AstroNvim configuration)
- `.zshrc` → `~/.zshrc` (Zsh shell configuration)

## What Gets Installed

- **Terminal**: iTerm2 with custom themes
- **Shell**: Zsh with Starship prompt and useful plugins
- **Editor**: Neovim with AstroNvim configuration
- **Package Manager**: Homebrew with curated packages

---

## SSH Setup for GitHub

What to do after running `zsh deploy.sh`:
That's the best choice for a seamless, professional setup. By using a standard **ED25519** key now and configuring your **macOS Keychain**, you'll get the zero-prompt experience. The ED25519 key type is also easily converted to a hardware security key (SK) later.

Here are the step-by-step instructions to set up seamless SSH on your new MacBook:

-----

## Step 1: Generate the SSH Key Pair (ED25519)

**ED25519** is the modern, recommended, and most secure algorithm for general SSH keys.

1.  **Open Terminal** on your MacBook.
2.  Run the following command, replacing the example email with your actual GitHub-registered email:
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```
3.  **Key location prompt:** Press **Enter** to accept the default file location (`/Users/yourname/.ssh/id_ed25519`).
4.  **Passphrase prompt:** **ENTER A STRONG PASSPHRASE.** This is crucial for security. This passphrase protects your private key even if your laptop is stolen. You will only enter it once, as the macOS Keychain will store it securely.

You've now created two files in your `~/.ssh/` directory:

  * `id_ed25519` (The **private key** - **KEEP THIS SECRET**)
  * `id_ed25519.pub` (The **public key** - This is what you share)

-----

## Step 2: Configure SSH Agent and Keychain

The SSH Agent manages your keys, and the `UseKeychain` option on macOS stores the passphrase in your secure Keychain so you never have to type it again.

1.  **Create or edit the SSH config file:**

    ```bash
    touch ~/.ssh/config
    open ~/.ssh/config
    ```

2.  **Add the following configuration** to the file and save it. This tells Git/SSH to use the Keychain for your passphrase and automatically add the key to the agent.

    ```text
    Host github.com
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
    ```

3.  **Start the SSH agent and add your key:**

      * Start the agent:
        ```bash
        eval "$(ssh-agent -s)"
        ```
      * Add your private key. When prompted, **enter the passphrase you created in Step 1**. You will be prompted to save it to your Keychain. **Click 'Always Allow'.**
        ```bash
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
        ```

-----

## Step 3: Add the Public Key to GitHub

1.  **Copy the public key** to your clipboard:
    ```bash
    pbcopy < ~/.ssh/id_ed25519.pub
    ```
2.  **Go to GitHub:**
      * Log in to **GitHub**.
      * Go to **Settings** (click your profile picture $\rightarrow$ Settings).
      * In the left sidebar, go to **SSH and GPG keys**.
      * Click **New SSH key** (or **Add SSH key**).
      * **Title:** Give it a descriptive name (e.g., `MacBook-Pro-2025`).
      * **Key:** Paste the content from your clipboard (it starts with `ssh-ed25519...`).
      * Click **Add SSH key**.

-----

## Step 4: Test and Use SSH

1.  **Test the connection:**

    ```bash
    ssh -T git@github.com
    ```

      * The first time, you'll be asked to confirm the connection (type `yes`).
      * You should see a message like: `Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.` This means it works\!

2.  **Clone using the SSH URL:**
    Now, your original clone command needs to be changed to use the **SSH protocol URL**:

      * **Original (HTTPS):** `https://github.com/AstroNvim/user_template`
      * **New (SSH):** `git@github.com:AstroNvim/user_template.git`

    Run your clone command:

    ```bash
    git clone git@github.com:AstroNvim/user_template.git astronvim_user_config
    ```

    This should now clone **seamlessly** without asking for a username or password.

-----

## Hardware Key Option (Future-Proofing)

When you get a hardware key (like a YubiKey), the process is nearly identical to what you just completed, but you'll use a slightly different key generation command.

The key type that supports hardware security keys is the **FIDO/U2F variant**, which is named `ed25519-sk`.

1.  **Generate the Hardware Key:** Insert your key and run:
    ```bash
    ssh-keygen -t ed25519-sk -C "your_email@example.com - SK Key"
    ```
      * You'll be prompted to **tap the button** on your hardware key.
2.  **Add it to GitHub:** You would then copy the new `id_ed25519_sk.pub` file and add it as a **second key** in your GitHub SSH settings.
3.  **Update your config:** You can add a new block to your `~/.ssh/config` to tell Git to use your regular key first, and the hardware key second.

For now, your standard ED25519 key provides a seamless, secure experience.