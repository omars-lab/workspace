# https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command
function find_files() {
    find . -type d -name .Trash -prune -o -type f -depth 2
}