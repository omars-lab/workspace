#!/bin/bash

# Deal with issue of carrot only matching first line ... not after..
# How do I debug bytes in bash?

# Useful Sed Links ..
# https://www.atlassian.com/git/tutorials/git-log
# https://superuser.com/questions/112834/how-to-match-whitespace-in-sed
# https://unix.stackexchange.com/questions/13711/differences-between-sed-on-mac-osx-and-other-standard-sed
# - [ ] USE gsed instead of mac sed!

# Sample output ...
# 9081251 More learning restructuring
#  roles/The Learner/{Capturing Topics of Interest => Listing Learning Topics}/Overview.txt | 0
#  1 file changed, 0 insertions(+), 0 deletions(-)
# f995d56 Reorganzied alot of stuff
#  roles/The Learner/Capturing Topics of Interest/Overview.txt | 3 +++
#  1 file changed, 3 insertions(+)
# 0099dab Consolidating things with regards to ideating
#  roles/The Learner/Capturing Topics of Interest/Overview.txt | 1 +
#  1 file changed, 1 insertion(+)

function header() {
  # https://stackoverflow.com/questions/949314/how-to-retrieve-the-hash-for-the-current-commit-in-git
  # git log --pretty=format:'%h' -n 1
  { \
    echo -n "\\\"${1}\\\","; \
    git --no-pager log --pretty=format:'%h' -n 1 | tr -d '\n'; \
    echo -n ','; \
  }
}

function get_rid_of_commit_text() {
  sed -E 's/^([a-zA-Z0-9]+).*/SEPERATOR \1/'
}

HEADER=$(header "${1}")

git --no-pager log --oneline -M --stat --follow "${1}" \
  | get_rid_of_commit_text \
  | tr -d '\n' \
  | gsed 's/SEPERATOR\s*\([a-zA-Z0-9]\+\)\s*\([^|]\+\(\w\|[}]\)\)\s\+[|]\s\+[0-9]\+\s\+[+-]*\s*1 file changed\(,\s*\([0-9]\+\)\s*insertions\?...\)*\(,\s*\([0-9]\+\)\s*deletions\?...\)*/\1,"\2",\5,\7--NEWLINE--/g' \
  | gsed 's/--NEWLINE--/\r\n/g' \
  | gsed "s#^#${HEADER}#g"

# -------------------------------------- Learnings ----------------------------------------
# https://stackoverflow.com/questions/10748453/replace-comma-with-newline-in-sed-on-macos
# \r is supper important! ... old appraoch was resulting in the following:
#      ceae061,"roles/The Learner/Maintaining a Learning Mindset.txt",12,0
#      be15e8d,".../Curating Learning Resources/Learning from Presentations.txt",1,0
#      be15e8d,".../Curating Learning Resources/Learning from Mentors.txt",11,0tors.txt",0,0
#      55b93fa,".../The Learner/Listing Learning Resources/Learning with Platforms.md",3,0
#      be15e8d,"roles/The Learner/Curating Learning Resources/Overview.txt",4,02
#      2315e8f,".../The Learner/Listing Learning Resources/Learning from Patterns.md",4,0
