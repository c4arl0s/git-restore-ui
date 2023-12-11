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
