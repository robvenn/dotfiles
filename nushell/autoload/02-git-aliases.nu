# 02-git-aliases.nu — Git shell aliases for interactive use

alias gst = git status
alias ga = git add
alias gaa = git add --all
alias gc = git commit
alias gcm = git commit -m
alias gd = git diff
alias gds = git diff --staged
alias gp = git push
alias gl = git pull
alias gsw = git switch
alias gcb = git switch -c
alias grb = git rebase
alias gsta = git stash push
alias gstp = git stash pop

def --env grt [] { cd (git rev-parse --show-toplevel) }
