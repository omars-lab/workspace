FILE=~/Workspace/git/environment/requirements.txt
cat ${FILE} | xargs -n 1 echo https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz
