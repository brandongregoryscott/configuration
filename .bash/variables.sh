#!/bin/bash

#########################
# Colors                #
#########################

BLACK="\033[0;30m"
BLUE="\033[0;34m"
BROWN="\033[0;33m"
CYAN="\033[0;36m"
DARK_GRAY="\033[1;30m"
GREEN="\033[0;32m"
LIGHT_BLUE="\033[1;34m"
LIGHT_CYAN="\033[1;36m"
LIGHT_GREEN="\033[1;32m"
LIGHT_GREY="\033[0;37m"
LIGHT_PURPLE="\033[1;35m"
LIGHT_RED="\033[1;31m"
NO_COLOR="\033[0m"
PURPLE="\033[0;35m"
RED="\033[0;31m"
WHITE="\033[1;37m"
YELLOW="\033[1;33m"

#########################
# Variables             #
#########################

true=0
false=1
PS1='\[\e[0;32m\]\u@\h\[\033[00m\] \[\033[01;33m\]`shortpwd`\[\033[00m\]\[\033[01;35m\]`branchName`\[\033[00m\]-> '
PWD=`pwd`
BASENAME=`basename $PWD`
JAR_NAME=`basename $PWD | cut -d "." -f1`
# Replace any . with / to make recursive folder structure for java packaging
LIBRARY_FOLDER_STRUCTURE=`echo $BASENAME | sed "s|\.|/|"`

export PATH="/usr/local/bin/:/opt/mssql-tools/bin/:~/.dotnet/tools/:/apps/:/apps/processing-3.5.3/:$PATH"
export ASPNETCORE_ENVIRONMENT=Development