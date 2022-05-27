ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search pyenv)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
# HOMEBREW Environment Variables
export HOMEBREW_INSTALL_CLEANUP=TRUE
export HOMEBREW_PREFIX=$(brew --prefix)
export PATH=“$HOMEBREW_PREFIX/opt/tcl-tk/bin:$PATH”
# Use PyEnv to set Python Environment
export PYENV_SHELL=zsh
export PYENV_ROOT=$(pyenv root)
export PYENV_VERSION=$(pyenv version-name)
export PYTHONPATH=$PYENV_ROOT/shims
# PyEnv & HOMEBREW Build variables
PYTHON_CONFIGURE_OPTS=“--with-tcltk-includes=‘-I$HOMEBREW_PREFIX/opt/tcl-tk/include’”
export PYTHON_CONFIGURE_OPTS=“$PYTHON_CONFIGURE_OPTS --with-tcltk-libs=‘-L$HOMEBREW_PREFIX/opt/tcl-tk/lib -ltcl8.6 -ltk8.6’”
export CFLAGS=“-O2 -I$HOMEBREW_PREFIX/include”
CPPFLAGS=“-I$HOMEBREW_PREFIX/opt/sqlite/include -I$HOMEBREW_PREFIX/opt/tcl-tk/include”
CPPFLAGS=“$CPPFLAGS -I$HOMEBREW_PREFIX/opt/zlib/include”
CPPFLAGS=“$CPPFLAGS -I$HOMEBREW_PREFIX/opt/bzip2/include”
export CPPFLAGS=“$CPPFLAGS -I$HOMEBREW_PREFIX/opt/openssl@1.1/include”
LDFLAGS=“-L$HOMEBREW_PREFIX/opt/sqlite/lib -L$HOMEBREW_PREFIX/opt/tcl-tk/lib”
LDFLAGS=“$LDFLAGS -L$HOMEBREW_PREFIX/opt/zlib/lib”
LDFLAGS=“$LDFLAGS -L$HOMEBREW_PREFIX/opt/bzip2/lib”
export LDFLAGS=“$LDFLAGS -L$HOMEBREW_PREFIX/opt/openssl@1.1/lib -L$HOMEBREW_PREFIX/opt/readline/lib”
PKG_CONFIG_PATH=“$HOMEBREW_PREFIX/opt/sqlite/lib/pkgconfig:$HOMEBREW_PREFIX/opt/tcl-tk/lib/pkgconfig”
PKG_CONFIG_PATH=“$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig”
PKG_CONFIG_PATH=“$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/bzip2/lib/pkgconfig”
PKG_CONFIG_PATH=“$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig”
export PKG_CONFIG_PATH=“$PKG_CONFIG_PATH:$PYENV_ROOT/versions/$PYENV_VERSION/lib/pkgconfig”
