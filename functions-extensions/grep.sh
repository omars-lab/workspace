function optionally_filter() {
  # Only filters if $1 set ...
  test -n "${1}" && grep "${1}" || tee
}