function c() {
    export OPENAI_API_KEY=${OPENAI_API_KEY:-$(lpass-get-note automation/chatgpt-apikey)}
    codex $@
}

alias d="open-document-link"
alias e=fzf-executables
alias f='fzf'
alias g=open-glue-link
alias i="open-iawriter-link"
alias n=open-noteplan-documents
alias r=open-noteplan-references
# alias n="iawriter:personalbook"
alias v=open-vscode-link
alias i="open-iawriter-link"