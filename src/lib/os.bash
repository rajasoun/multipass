#!/usr/bin/env bash

# Create Directory if the given directory does not exists
# @param $1 The directory to create
function create_directory_if_not_exists(){
    DIR_NAME=$1
    ## Create Directory If Not Exists
    if [ ! -d "$DIR_NAME"  ]; then
      mkdir -p "$DIR_NAME"
    fi
}

# ls, with chmod-like permissions and more.
# @param $1 The directory to ls
function lls() {
  #If Not Paramter is Passed assumes current directory
  local LLS_PATH=${1:-"."}
  # shellcheck disable=SC2012 # Reason: This is for human consumption
  ls -AHl "$LLS_PATH" | awk "{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/) \
                            *2^(8-i));if(k)printf(\"%0o \",k);print}"
}
################################################################################
# 👉                            Color                                      👈 #
################################################################################
function function_Color {
    export BLUE='\033[1;34m'
    export GREEN='\033[0;32m'
    export RED='\033[0;31m'
    export NC='\033[0m'
}
################################################################################
# 👉                            multipass                                  👈 #
################################################################################
function multipass(){
## Nothing to change after this line
function_Color
if [ -x "$(command -v multipass.exe)" > /dev/null 2>&1 ]; then
  # Windows
  MULTIPASSCMD="multipass.exe"
elif [ -x "$(command -v multipass)" > /dev/null 2>&1 ]; then
  # Linux/MacOS
  MULTIPASSCMD="multipass"
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SET="sed -i \"\""
  fi
else
   echo -e "${RED} Error: ${GREEN} (multipass or multipass.exe)  not found. Please install by yourself ${NC}"
   echo -e "PATH ${GREEN}\$PATH${NC}"
   exit 1
fi
  ${MULTIPASSCMD} "$@"
}
# Returns true (0) if this the given command/app is installed and on the PATH or false (1) otherwise.
function os_command_is_installed {
  local -r name="$1"
  command -v "$name" > /dev/null
}

# Displays Time in misn and seconds
function display_time {
    local T=$1
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    (( D > 0 )) && printf '%d days ' $D
    (( H > 0 )) && printf '%d hours ' $H
    (( M > 0 )) && printf '%d minutes ' $M
    (( D > 0 || H > 0 || M > 0 )) && printf 'and '
    printf '%d seconds\n' $S
}

# Returns true (0) if the given file exists and is a file and false (1) otherwise
function file_exists() {
  local -r file="$1"
  [[ -f "$file" ]]
}

# Returns true (0) if the given file exists contains the given text and false (1) otherwise. The given text is a
# regular expression.
function file_contains_text {
  local -r text="$1"
  local -r file="$2"
  grep -q "$text" "$file"
}

# Replace a line of text that matches the given regular expression in a file with the given replacement.
# Only works for single-line replacements.
function file_replace_text {
  local -r original_text_regex="$1"
  local -r replacement_text="$2"
  local -r file="$3"

  local args=()
  args+=("-i")

  if os_is_darwin; then
    # OS X requires an extra argument for the -i flag (which we set to empty string) which Linux does no:
    # https://stackoverflow.com/a/2321958/483528
    args+=("")
  fi

  args+=("s|$original_text_regex|$replacement_text|")
  args+=("$file")

  sed "${args[@]}" > /dev/null
}

# Returns true (0) if this is an OS X server or false (1) otherwise.
function os_is_darwin {
  [[ $(uname -s) == "Darwin" ]]
}

# Returns the IP or .
function get_local_ip(){
    case "$OSTYPE" in
        darwin*) IP=$(ifconfig en0 | grep inet | grep -v inet6 | cut -d" " -f2)
                 echo "$IP"
                 return 0
                 ;;
        linux*)  IP=$(hostname -I |  cut -d" " -f1)
                 echo "$IP"
                 return 0
                 ;;
        cygwin* | mingw* | msys*)
                IP=$(netstat -rn | grep -w '0.0.0.0' | awk '{ print $4 }')
                 echo "$IP"
                 return 0
                 ;;
        *)echo "unknown: $OSTYPE"
                 return 1
                 ;;
    esac
}

function run_main() {
    create_directory_if_not_exists "$@"
    lls "$@"
    os_command_is_installed "$@"
    display_time "$@"
    file_exists "$@"
    file_contains_text "$@"
    file_replace_text "$@"
    os_is_darwin
    get_local_ip
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi