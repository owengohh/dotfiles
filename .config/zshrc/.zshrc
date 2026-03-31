# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# 
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# --- OH MY ZSH PERFORMANCE TUNING ---

# 1. Tell OMZ to skip the compinit security check (compaudit) which is slow
DISABLE_COMPFIX="true"

# 2. Set the cache file name (OMZ handles the creation/checking)
# We force it to check freshness using OMZ's internal logic only once.
# Note: OMZ checks file age by modification time automatically if configured.
# We rely on the .zcompdump file existing.

# 3. THEME
ZSH_THEME=""

# 4. PLUGINS
plugins=(git zsh-autosuggestions fzf zsh-syntax-highlighting)

# 5. LOAD OH MY ZSH
# This will load compinit.
source $ZSH/oh-my-zsh.sh

# --- POST-LOAD OPTIMIZATION ---

# If OMZ loaded compinit, it might have been slow.
# OMZ runs 'compinit' once. The slowness often comes from 'compaudit'.
# We already set DISABLE_COMPFIX="true" above to speed that up.

# Auto suggestions settings
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# --- Starship (prompt) ---
eval "$(starship init zsh)"

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

# --- History setup ---
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- Key Bindings ---
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# --- Lazy load jenv ---
# We must unset the functions defined by jenv init if they exist,
# but since we haven't loaded jenv yet, we just define the wrapper.
export PATH="$HOME/.jenv/bin:$PATH"

# Define a trap function for jenv
jenv() {
  echo "Initializing jenv..."
  unset -f jenv java javac mvn
  eval "$(jenv init -)"
  jenv "$@"
}
java() {
  unset -f jenv java javac mvn
  eval "$(jenv init -)"
  java "$@"
}
javac() {
  unset -f jenv java javac mvn
  eval "$(jenv init -)"
  javac "$@"
}
mvn() {
  unset -f jenv java javac mvn
  eval "$(jenv init -)"
  mvn "$@"
}

# --- Rust compile and run ---
rr() { rustc "$1" && ./"${1%.rs}"; }

# --- Custom Env ---
. "$HOME/.local/bin/env"

# --- Rust ---
. "$HOME/.cargo/env" 

# Vite+ bin (https://viteplus.dev) - Handles Node, so NVM is removed
. "$HOME/.vite-plus/env"