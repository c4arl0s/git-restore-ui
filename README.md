# [go back to overview](https://github.com/c4arl0s#bash-scripts)

# [git-add-restore-interface-script](https://github.com/c4arl0s/git-restore-user-interface-script#go-back-to-overview)

1. Find out how to list all staged files

```console
git --no-pager diff --name-only --cached --diff-filter=AM 
```

# [Dependencies](https://github.com/c4arl0s/git-restore-user-interface-script#git-restore-user-interface-script)

```console
brew install dialog
```

# [How to use it](https://github.com/c4arl0s/git-restore-user-interface-script#git-restore-user-interface-script)

You just run the script without any parameter

```console
./git-restore-ui.sh
```

<img width="1624" alt="Screenshot 2023-11-29 at 9 08 06 p m" src="https://github.com/c4arl0s/git-add-with-extension-ui/assets/24994818/e8481b06-ef5d-4e67-9903-968cf8a3a268">

```bash
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
```
