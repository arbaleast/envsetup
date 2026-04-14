[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# PATH - 去重并按优先级排序
export PATH="/usr/local/go/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# OllAMA
export OLLAMA_HOST=127.0.0.1
export OLLAMA_MODELS=/home/al/.ollama/models

# Tavily
export TAVILY_API_KEY="tvly-d...yot7"

alias qmd='/home/al/.local/bin/qmd-fast'
