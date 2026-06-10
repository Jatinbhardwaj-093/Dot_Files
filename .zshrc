# export PATH=$HOME/bin:/usr/local/bin:$PATH
#echo source ~/.bash_profile

eval "$(brew shellenv)"

# Add local ~/scripts to the PATH
export PATH="$HOME/scripts:$PATH"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"


# Set XDG config home
export XDG_CONFIG_HOME="$HOME/.config"

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion



# Path to your oh-my-zsh installation.
# NOTE : Disabled Shell Prompt: Currently using Starship
# NOTE: using oh-my-zsh only for zsh plugins management
export ZSH="$HOME/.oh-my-zsh"



# HACK: zsh plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# Starship 
eval "$(starship init zsh)"
# set Starship PATH
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

# NOTE: Zoxide
eval "$(zoxide init zsh)"

# NOTE: FZF
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  


#User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Console Ninja
PATH=~/.console-ninja/.bin:$PATH

# python aliases
alias python="python3"
alias pip="pip3"
alias uvr="uv run"
alias uvpi="uv pip install"
alias uvv="uv venv"
alias activate="source .venv/bin/activate"

# clear alias
alias clr="clear"
alias yz="yazi"

# fzf 
# called from ~/scripts/
alias nlof="~/scripts/fzf_listoldfiles.sh"
# opens documentation through fzf (eg: git,zsh etc.)
alias fman="compgen -c | fzf | xargs man"

# zoxide (called from ~/scripts/)
alias nzo="~/scripts/zoxide_openfiles_nvim.sh"

# Next level of an ls 
# options :  --no-filesize --no-time --no-permissions 
alias ls="eza --no-filesize --long --color=always --icons=always --no-user" 

# tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# git aliases
alias gt="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -am'
alias gp='git push'
alias gu='git upstream'
alias glog='git log --oneline --graph --all'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

# tmux aliases
alias tmuxl="tmux list-sessions"
alias tmuxa="tmux attach -t"
alias tmuxn="tmux new -s"

# Open files with fzf and nvim
alias fnvim='nvim $(fzf)'

# cd into a directory interactively
alias fcd='cd $(find . -type d | fzf)'

# Search command history and run it
alias fhist='eval $(history | fzf | sed "s/ *[0-9]* *//")'

# Kill a process interactively
alias fkill='kill -9 $(ps -ef | fzf | awk "{print \$2}")'

# Git branch checkout with fzf
alias fgitbranch='git checkout $(git branch --all | fzf | sed "s/* //;s/remotes\///")'

# Git file checkout
alias fgitfile='git checkout $(git ls-files | fzf)'

# Git commit browser
alias fgitlog='git log --oneline --decorate | fzf | cut -d" " -f1 | xargs git show'

# Open recent files with fzf
alias frecent='nvim $(ls -t | fzf)'

# Find and grep inside files interactively
alias fgrep="grep -r '' . | fzf"

# Tmux session switcher
alias ftmux='tmux switch-client -t $(tmux list-sessions -F "#S" | fzf)'

# lazygit
alias lz = "lazygit"

# obsidian icloud path
alias sethvault="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/sethVault/"

# unbind ctrl g in terminal
bindkey -r "^G"


# bun completions
[ -s "/Users/personal/.bun/_bun" ] && source "/Users/personal/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

set OLLAMA_ORIGINS="*"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/jatinbhardwaj/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Added by Antigravity
export PATH="/Users/jatinbhardwaj/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/Library/Python/3.*/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/qemu/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/jatinbhardwaj/.local/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/jatinbhardwaj/.antigravity-ide/antigravity-ide/bin:$PATH"

# Enable custom Gruvbox Dark style for all Charm/Glamour CLI utilities (including agy)
export GLAMOUR_STYLE="/Users/jatinbhardwaj/.config/glow/gruvbox-dark.json"

# Load local private secrets securely (keeps API keys out of public Git repos)
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

# Launch custom premium welcome dashboard for interactive shells
if [[ $- == *i* ]]; then
    python3 ~/scripts/welcome.py
fi
