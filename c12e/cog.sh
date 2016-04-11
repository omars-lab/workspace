# A list of cognitivescale commands compiled from code repos

alias gmap='/Users/oeid/git/cognitivescale/gmap/mapping-cli/build/install/gmap/bin/gmap'

# This script is intended to make running agents easier
# Instuction on making bash auto completion wrappers can be found here:
# https://www.debian-administration.org/article/317/An_introduction_to_bash_completion_part_2
function _agent_runner_options(){
  local cur  # Pointer to current completion word.
  COMPREPLY=() # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  case "$prev" in
    sourcing)
        AGENTS=$(find $DFO_AGENTS_ROOT/sourcing -type d -depth 1 | xargs -I {} basename {} | xargs echo -n)
        COMPREPLY=( $( compgen -W "$AGENTS" -- $cur ) )
    ;;
    learning|enrichment)
        AGENTS=$(find $DFO_AGENTS_ROOT/$prev -type d -depth 1 | xargs -I {} basename {} | xargs echo -n)
        COMPREPLY=( $( compgen -W "$AGENTS" -- $cur ) )
    ;;
    run)
        COMPREPLY=( $( compgen -W "sourcing learning enrichment" -- $cur ) )
    ;;
  esac
  return 0
}
function run(){
    AGENT=$2
    case $1 in
        sourcing)
            HARNESS="source"
        DIRECTORY=$1
        ;;
        learning)
            HARNESS="$1"
        DIRECTORY=$1
        ;;
        enrichment)
            HARNESS="$1"
        DIRECTORY=$1
        ;;
    esac
    AGENT_DIR=$_cognitive_projects_/dfo-agents/$DIRECTORY/$AGENT/src
    cd $AGENT_DIR;
    agent_harness $HARNESS --output ../temp/output.json --config-file ../config/config.json $AGENT/$AGENT.py $AGENT --limit 1
    cd -
    return 0
}
echo $0 | grep "bash" && complete -F _agent_runner_options run
