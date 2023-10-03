#!/usr/bin/env bash

STAGED_FILES=$(git --no-pager diff --name-only --cached --diff-filter=AM)

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
    SELECTED_STAGED_FILES=$(echo $LINE | xargs dialog --stdout --checklist "files to restore:" 0 0 0)
    echo $SELECTED_STAGED_FILES | xargs git restore --staged
else
    echo  "files to restore don´t exist"
fi
