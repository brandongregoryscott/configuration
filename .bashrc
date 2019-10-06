#!/bin/bash

###########################
# Main Entrypoint/Imports #
###########################
BASH_FOLDER=~/.bash
CONFIGURATION_BASH_FOLDER=~/configuration/.bash
VARIBLES_FILE=$BASH_FOLDER/variables.sh
IMPORTS=(
	$BASH_FOLDER/cp.sh
	$BASH_FOLDER/echo.sh
	$BASH_FOLDER/git.sh
	$BASH_FOLDER/kill.sh
	$BASH_FOLDER/mac.sh
	$BASH_FOLDER/mkdrumkit.sh
	$BASH_FOLDER/processing.sh
	$BASH_FOLDER/util.sh
)

# Variable to hold imports that failed
FAILED_IMPORTS=()

# Copy .bash folder from configuration repo to home directory if it does not exist
if test -d $CONFIGURATION_BASH_FOLDER && ! test -d $BASH_FOLDER; then
	cp -R $CONFIGURATION_BASH_FOLDER $BASH_FOLDER
fi

if test -f $VARIBLES_FILE; then
	source $VARIBLES_FILE
else
	FAILED_IMPORTS+=($VARIBLES_FILE)
fi

for IMPORT in ${IMPORTS[@]};
do
	if test -f $IMPORT; then
		source $IMPORT
	else
		FAILED_IMPORTS+=($IMPORT)
	fi
done

for FILE in ${FAILED_IMPORTS[@]};
do
	echo -e "\033[1;33mWARN:\033[0m Failed to import $FILE"
done;
