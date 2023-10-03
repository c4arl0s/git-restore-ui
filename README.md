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

<img width="1624" alt="Screen Shot 2022-05-10 at 8 54 56 p m" src="https://user-images.githubusercontent.com/24994818/167753922-98e4a7a0-e0d4-495f-bb8f-b2eef3dd61a1.png">

```bash
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
```
