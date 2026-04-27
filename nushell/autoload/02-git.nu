# 02-git.nu — Git aliases and utilities for interactive use

alias ga = git add
alias gaa = git add --all
alias gb = git branch
alias gc = git commit
alias gcb = git switch -c
alias gcl = git clean
alias gcm = git commit -m
alias gcp = git cherry-pick
alias gd = git diff
alias gds = git diff --staged
alias gdh = git diff HEAD
alias gdft = git dft
alias gdfts = git dft --staged
alias gdfth = git dft HEAD
alias gl = git pull
alias gp = git push
alias gpf = git push --force-with-lease
alias grb = git rebase
alias gre = git restore
alias gst = git status
alias gsta = git stash push
alias gstp = git stash pop
alias gsw = git switch
alias gw = git worktree
alias gwa = git worktree add
alias gwl = git worktree list
alias gwr = git worktree remove
alias gwrf = git worktree remove --force

def --env grt [] { cd (git rev-parse --show-toplevel) }

# Show current git identity and signing config for the working directory
def git-profile [] {
    let name = (git config user.name)
    let email = (git config user.email)
    let signing_key = (git config user.signingKey | str trim)
    let sign_commits = (git config commit.gpgSign | str trim)
    let ssh_command = (do { git config core.sshCommand } | complete | if $in.exit_code == 0 { $in.stdout | str trim } else { "(default)" })
    let gpg_format = (git config gpg.format | str trim)

    print $"Name:         ($name)"
    print $"Email:        ($email)"
    print $"GPG format:   ($gpg_format)"
    print $"Signing key:  ($signing_key)"
    print $"Sign commits: ($sign_commits)"
    print $"SSH command:  ($ssh_command)"
}
