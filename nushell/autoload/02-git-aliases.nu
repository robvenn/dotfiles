# 02-git-aliases.nu — Git shell aliases for interactive use

alias gst = git status
alias ga = git add
alias gaa = git add --all
alias gc = git commit
alias gcm = git commit -m
alias gd = git diff
alias gds = git diff --staged
alias gp = git push
alias gpf = git push --force-with-lease
alias gl = git pull
alias gsw = git switch
alias gcb = git switch -c
alias grb = git rebase
alias gsta = git stash push
alias gstp = git stash pop

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
