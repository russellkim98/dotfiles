setopt HIST_IGNORE_ALL_DUPS # remove all earlier duplicate lines
setopt APPEND_HISTORY # history appends to existing file
setopt SHARE_HISTORY # import new commands from the history file also in other zsh-session
setopt EXTENDED_HISTORY # save each commands beginning timestamp and the duration to the history file
setopt HIST_REDUCE_BLANKS # trim multiple insgnificant blanks in history
setopt HIST_IGNORE_SPACE # don’t store lines starting with space
setopt EXTENDED_GLOB # treat special characters as part of patterns
setopt CORRECT_ALL # try to correct the spelling of all arguments in a line
unsetopt FLOW_CONTROL # disable stupid annoying keys
setopt MULTIOS # allows multiple input and output redirections
setopt AUTO_CD # if the command is directory and cannot be executed, perfort cd to this directory
setopt CLOBBER # allow > redirection to truncate existing files
setopt BRACE_CCL # allow brace character class list expansion
unsetopt BEEP # do not beep on errors
unsetopt NOMATCH # try to avoid the 'zsh: no matches found...'
setopt INTERACTIVE_COMMENTS # allow use of comments in interactive code
setopt AUTO_PARAM_SLASH # complete folders with / at end
setopt LIST_TYPES # mark type of completion suggestions
setopt HASH_LIST_ALL # whenever a command completion is attempted, make sure the entire command path is hashed first
setopt COMPLETE_IN_WORD # allow completion from within a word/phrase
setopt ALWAYS_TO_END # move cursor to the end of a completed word
setopt LONG_LIST_JOBS # list jobs in the long format by default
setopt AUTO_RESUME # attempt to resume existing job before creating a new process
setopt NOTIFY # report status of background jobs immediately
unsetopt SHORT_LOOPS # disable short loop forms, can be confusing
unsetopt RM_STAR_SILENT # notify when rm is running with *
setopt RM_STAR_WAIT # wait for 10 seconds confirmation when running rm with *

# a bit fancy than default
PROMPT_EOL_MARK='%K{red} %k'



HISTSIZE=2000
SAVEHIST=2000



# Initialize colors
autoload -Uz colors
colors

# Fullscreen command line edit
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Ctrl+W stops on path delimiters
autoload -Uz select-word-style
select-word-style bash

# Enable run-help module
(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help
alias help=run-help

# enable bracketed paste
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# enable url-quote-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Use default provided history search widgets
autoload -Uz up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N down-line-or-beginning-search



# Make dot key autoexpand "..." to "../.." and so on
_zsh-dot () {
    if [[ ${LBUFFER} = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N _zsh-dot
bindkey . _zsh-dot


# Some handy suffix aliases
alias -s log=less

# Human file sizes
(( ${+commands[df]} )) && alias df="df --human-readable --print-type"
(( ${+commands[du]} )) && alias du="du --human-readable --total"

# Handy stuff and a bit of XDG compliance
(( ${+commands[grep]} )) && alias grep="grep --color=auto --binary-files=without-match --devices=skip"
(( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
(( ${+commands[tmux]} )) && {
    alias tmux="tmux -f ${DOTFILES}/tmux/tmux.conf"
    alias stmux="tmux new-session 'sudo --login'"
}
(( ${+commands[wget]} )) && alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
(( ${+commands[ls]} )) && alias ls="ls -a --color=always"

# History suppression
(( ${+commands[clear]} )) && alias clear=" clear"
alias pwd=" pwd"
alias exit=" exit"
alias v="nvim"

# Suppress suggestions and globbing, enable wrappers
(( ${+commands[find]} )) && alias find="noglob find"
(( ${+commands[touch]} )) && alias touch="nocorrect touch"
(( ${+commands[mkdir]} )) && alias mkdir="nocorrect mkdir"
(( ${+commands[cp]} )) && alias cp="nocorrect cp --verbose"
(( ${+commands[ag]} )) && alias ag="noglob ag"
(( ${+commands[fd]} )) && alias fd="noglob fd"
(( ${+commands[man]} )) && alias man="nocorrect wrap_man"
(( ${+commands[sudo]} )) && alias sudo="noglob wrap_sudo " # trailing space is needed to enable alias expansion


source /usr/local/opt/spaceship/spaceship.zsh
# Prefered editor and pager
export VISUAL=nvim
export EDITOR=nvim

