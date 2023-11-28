#!/usr/bin/env bash

STAGED_FILES=$(git --no-pager diff --name-only --cached --diff-filter=AM)

ERROR_MSG="files to restore don´t exist"
FILES_TO_RESTORE_MSG="files to restore:"

if [[ $STAGED_FILES ]]; then
    let COUNTER=0
    LINE=$(git --no-pager diff --name-only --cached --diff-filter=AM | 
           while read STAGED_FILE
           do
               let "COUNTER+=1" 
               echo "\"$STAGED_FILE\" \"$COUNTER\" off"
           done
          )
    echo $LINE;
    SELECTED_STAGED_FILES=$(echo $LINE | xargs dialog --stdout --checklist $FILES_TO_RESTORE_MSG 0 0 0)
    echo $SELECTED_STAGED_FILES | xargs git restore --staged
    [ ! -z "$SELECTED_STAGED_FILES" ] && echo $SELECTED_STAGED_FILES | xargs git restore --staged || echo "🟡 You did not select any file to restore"
else
    echo $ERROR_MSG
fi
