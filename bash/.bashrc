# Display git branch in bash prompt
git_branch() {
    git branch 2> /dev/null | awk '/*/ {print "("$NF")"}'
}
export -p PS1="\u@\h:\[\033[32m\]\W\[\033[33m\]\$(git_branch)\[\033[00m\]\~> "
