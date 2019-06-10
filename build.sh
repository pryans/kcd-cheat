#!/bin/bash -xe

DEV_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# ensure lua 5.3 is installed
if ! which lua5.3 >/dev/null 2>&1; then
  echo "Need to install lua 5.4"
  sudo apt install lua5.3
fi

# tells the lua code that we are building on commandline and run in game
export KCD_CHEAT_BUILD="true"

# folder that contains the Source folder, used for help.txt and commands.txt out
export KCD_CHEAT_HOME="${DEV_HOME}"

# Running main.lua will do three things:
# 1. catch some synatx errors
# 2. run the unit tests
# 3. regenerate ./Source/Docs/help.txt and ./Source/Docs/commands.txt
lua5.3 ./Source/Scripts/Startup/main.lua
