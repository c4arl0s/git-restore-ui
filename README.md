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

<img width="339" alt="Screenshot 2023-12-04 at 11 29 34 p m" src="https://github.com/c4arl0s/git-restore-ui/assets/24994818/47fc39b9-1a47-49f3-815c-3b23f0b90014">

```bash
#!/usr/bin/env bash
#
# git-restore-ui script uses an user interface to restore files from stage area

readonly ERROR_MSG='It seems current directoy is not a git project'
readonly ERROR_REPO="Current directory is not a git repository"
readonly WARN_MSG='Files to restore don´t exist'
readonly FILES_TO_RESTORE_MSG='Files to restore:'
readonly DIDNT_SELECT_ANY_FILE_MSG='You did not select any file to restore'
readonly SUCCESS_MSG='Selected files were unstaged'

#######################################
# A function to print out error messages 
# Globals:
#   
# Arguments:
#   None
#######################################
function error() {
  echo "[🔴 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# A function to print out warning messages 
# Globals:
#   
# Arguments:
#   None
#######################################
function warning() {
  echo "[🟡 $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { error ${ERROR_REPO}; return 1; }

staged_files=$(git --no-pager diff --name-only --cached --diff-filter=AM)

if [[ -n ${staged_files} ]]; then
  let counter=0
  line=$(git --no-pager diff --name-only --cached --diff-filter=AM \
    | while read staged_file; do
        let "counter+=1" 
        echo "\"${staged_file}\" \"${counter}\" off"
      done)
  echo ${line};
  selected_staged_files=$(echo ${line} \
    | xargs dialog --stdout --checklist ${FILES_TO_RESTORE_MSG} 0 0 0)
  [[ -n "${selected_staged_files}" ]] \
    && echo "${selected_staged_files}" | xargs git restore --staged \
    && echo "🟢 ${SUCCESS_MSG}" \
    || warning "${DIDNT_SELECT_ANY_FILE_MSG}"
else
  error ${WARN_MSG}
  return  1
fi
```
