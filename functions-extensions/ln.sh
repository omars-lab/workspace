# Creating my links ... 

## Create Noteplan link ...
### - [ ] auto make noteplan link ...

test -d ${HOME}/Library/Mobile\ Documents/iCloud~co~noteplan~NotePlan/Documents && \
    ! (test -L ${HOME}/.noteplan >/dev/null 2>/dev/null) && \
    ln -s ${HOME}/Library/Mobile\ Documents/iCloud~co~noteplan~NotePlan/Documents ${HOME}/.noteplan

test -d ${HOME}/Library/Containers/co.noteplan.NotePlan/Data/Library/Application\ Support/co.noteplan.NotePlan/Notes && \
    ! (test -L ${HOME}/.noteplan >/dev/null 2>/dev/null) && \
    ln -s ${HOME}/Library/Containers/co.noteplan.NotePlan/Data/Library/Application\ Support/co.noteplan.NotePlan/Notes ${HOME}/.noteplan
