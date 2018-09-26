# Contains general Linux/Unix helper functions

function extract_functions(){
    echo $(cat $1 | grep -Eo "^(?:function )(\w+)" | grep -Eo "\\w+$" | grep -E "^[a-zA-Z]" | xargs echo -n)
}

function extract_variables(){
    echo $(cat $1 | grep -Eo "^(?:export )(\w+)" | grep -Eo "\w+$")
}

function print_variables(){
    echo $@ | xargs printenv
}

# Recusively source all .sh files within a directory
# The first param is the directoy.
# The second param is an expression of files to ignore.
function recursive-source(){
    rdir=$1
    ignore=${2:-"^\s*$"}
    $SILENT || echo "Recursively Sourcing $rdir, ignoring: $ignore"
    for i in $(ls -c1 $rdir | grep -e ".*[.]sh" | grep -vE "$ignore"); do
        $SILENT || echo Sourcing $rdir/$i;
        source $rdir/$i ;
    done
}

# Re-source the bash profile
# function re-source(){
#     source ~/.bash_profile
# }
