function md-unlink() {
  # Remove links from md content ...
  sed 's/\[\([^]]*\)\]([^)]*)/\1/g'
}
