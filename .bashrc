#!/bin/bash

#########################
# colors                #
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
# variables             #
#########################

dv="development"
wv="working-"
sv="staging-v1"
pd="production-v1"
true=0
false=1
PS1='\[\e[0;32m\]\u@\h\[\033[00m\] \[\033[01;33m\]`shortpwd`\[\033[00m\] \[\033[01;35m\]`branchName`\[\033[00m\] -> '
PWD=`pwd`
BASENAME=`basename $PWD`
JAR_NAME=`basename $PWD | cut -d "." -f1`
# Replace any . with / to make recursive folder structure for java packaging
LIBRARY_FOLDER_STRUCTURE=`echo $BASENAME | sed "s|\.|/|"`

#########################
# misc functions        #
#########################


function error() {
	echo -e "${RED}ERROR: ${NO_COLOR}$@"
}

function ok() {
	echo -e "${GREEN}OK: ${NO_COLOR}$@"
}

function warn() {
	echo -e "${YELLOW}WARN: ${NO_COLOR}$@"
}

function cpIfNotExists() {
	if [ ! -f $2 ]; then
		cp $1 $2
		checkReturn "cp $1 $2"
	else
		warn "$2 already exists. Not copying again."
	fi
}

function mkdirIfNotExists() {
	if [ ! -d $1 ]; then
		mkdir -p $1
		checkReturn "mkdir -p $1"
	else
		warn "$1 already exists. Not creating directory again."
	fi
}

function checkReturn() {
	if [ $? -ne 0 ];
	then
		error $@
	else
		ok $@
	fi
}

function hidedotfiles() {
	if isMac;
	then
		echo "defaults write com.apple.finder AppleShowAllFiles NO"
		defaults write com.apple.finder AppleShowAllFiles NO
		echo "killall Finder /System/Library/CoreServices/Finder.app"
		killall Finder /System/Library/CoreServices/Finder.app
	fi;
}

function showdotfiles() {
	if isMac;
	then
		echo "defaults write com.apple.finder AppleShowAllFiles YES"
		defaults write com.apple.finder AppleShowAllFiles YES
		echo "killall Finder /System/Library/CoreServices/Finder.app"
		killall Finder /System/Library/CoreServices/Finder.app
	fi;
}

function shortpwd() {
  pwd | sed s.$HOME.~.g | awk -F\/ '
  BEGIN { ORS="/" }
  END {
  for (i=1; i<= NF; i++) {
      if ((i == 1 && $1 != "") || i == 2 || i == NF-1 || i == NF) {
        print $i
      }
      else if (i == 1 && $1 == "") {
        print "/"$2
        i++
      }
      else {
        print ".."
      }
    }
  }'
}

function branchName() {
	if [[ -d .git ]];
	then
		BRANCH_NAME=`git branch | grep "* " | sed "s/* //g"`
		echo "($BRANCH_NAME)"
	else
		echo ""
	fi
}

function isMac() {
	uname=`uname`
	if [[ $uname == "Darwin" ]];
	then
		return $true;
	else
		return $false;
	fi
}

function isWindows() {
	uname=`uname | grep -c "MINGW"`
	if [[ $uname -eq 0 ]];
	then
		return $false;
	else
		return $true;
	fi
}

function sourceme() {
	if isMac;
	then
		echo "source ~/.bash_profile"
		source ~/.bash_profile
	fi;

	if isWindows;
	then
		echo "source ~/.bashrc"
		source ~/.bashrc
	fi;
}

function killdotnet() {
    dotnet build-server shutdown
	echo "Found dotnet processes: $(ps aux | grep 'dotnet' | awk '{print $1}')"
	kill $(ps aux | grep 'dotnet' | awk '{print $1}')
}

function killnode() {
	echo "Found node processes: $(ps aux | grep 'node' | awk '{print $2}')"
	kill $(ps aux | grep 'node' | awk '{print $2}')
}

function cpbashrc() {
	if isMac;
	then
		echo "cp ~/configuration/.bashrc ~/.bash_profile"
		cp ~/configuration/.bashrc ~/.bash_profile
	fi;
	if isWindows;
	then
		echo "cp ~/configuration/.bashrc ~/.bashrc"
		cp ~/configuration/.bashrc ~/.bashrc
	fi;
}

function cpvscode() {
	if isMac;
	then
		echo "cp ~/configuration/vscode/settings.json ~/Library/Application Support/Code/User/"
		cp ~/configuration/vscode/settings.json ~/Library/"Application Support"/Code/User/
	fi;

	if isWindows;
	then
		echo "cp ~/configuration/vscode/settings.json $APPDATA/Code/User/"
		cp ~/configuration/vscode/settings.json $APPDATA/Code/User/
	fi;
}

#########################
# git wrapper functions #
#########################

function gca() {
	git commit --amend
}

function gcm() {
	git commit -m "$@"
}

function gcj() {
	if [[ -d .git ]];
	then
		JIRA_TASK=`git branch | grep "* " | sed "s/* //g" | cut -d "/" -f2 | cut -d "-" -f1-2`
		if [[ $1 == "--soft" ]] || [[ $1 == "-s" ]];
		then
			shift
			echo "git commit -m \"$JIRA_TASK $@\""
		else
			git commit -m "$JIRA_TASK $@"
		fi
	else
		echo "No git repository found."
	fi
}

function gd() {
	git diff $1
}

function gf() {
	git fetch
}

function gc() {
	git checkout "$@"
}

function gcb() {
	git checkout -b "$1"
}

# gbd($@)
# deletes a local branch (or list of branches separated by spaces)
function gbd() {
	for branchName in "$@"
	do
		git branch -D $branchName
	done
}

# gbdr($1)
# deletes a remote branch from the origin repository
function gbdr() {
	git push --delete origin $1
}

function gb() {
	git branch $@
}

function gm() {
	git merge $1
}

function gp() {
	if isWindows;
	then
		echo `git push $@` | grep "https" | cut -d " " -f4 > /dev/clipboard
	else
		git push $@
	fi
}

function grh() {
	for file in "$@"
	do
		git reset head $file
	done
}

function ga() {
	for file in "$@"
	do
		git add $file
	done
}

function gs() {
	git status
}

# lcb($a, $b)
# lists commits between branch a and branch b
# output format is <abbrev commit> <author name> <date> <commit msg>
function lcb() {
	 git log --cherry-pick --pretty="%h	%an	%ad	%s" --abbrev-commit $1 --not $2
}

# gss($stash?)
# git stash show (optionally, number of stashes behind to show)
function gss {
	if [[ $# -eq 0 ]];
	then
		git stash show -p
	else
		git stash show -p stash@{$1}
	fi
}

#########################
# Processing helpers    #
#########################

function libraryClean() {
	rm -rf bin/
	checkReturn "rm -rf bin/"
	rm -rf dist/
	checkReturn "rm -rf dust/"
}

function setupLibrary() {
	mkdirIfNotExists bin/$LIBRARY_FOLDER_STRUCTURE
	mkdirIfNotExists dist/$JAR_NAME/library
	mkdirIfNotExists lib
	mkdirIfNotExists src/$LIBRARY_FOLDER_STRUCTURE

	# Example: /Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home/jre/lib
	JVM_DIR="/Library/Java/JavaVirtualMachines"
	JDK=`ls $JVM_DIR | grep jdk | tail -1`

	cpIfNotExists $JVM_DIR/$JDK/Contents/Home/jre/lib/rt.jar lib/rt.jar
	cpIfNotExists /Applications/Processing.app/Contents/Java/core.jar lib/core.jar
}

function libraryMake() {
	# Attempt to setup library again to make sure rt.jar & core.jar files are present for compilation.
	setupLibrary

	javac -d bin -target 1.6 -source 1.6 -sourcepath src -cp lib/core.jar src/$LIBRARY_FOLDER_STRUCTURE/*.java  -bootclasspath lib/rt.jar
	checkReturn "javac -d bin -target 1.6 -source 1.6 -sourcepath src -cp lib/core.jar src/$LIBRARY_FOLDER_STRUCTURE/*.java  -bootclasspath lib/rt.jar"
	pushd bin
	jar cfv ../dist/$JAR_NAME/library/$JAR_NAME.jar *
	checkReturn "jar cfv ../dist/$JAR_NAME/library/$JAR_NAME.jar *"
	popd
}

function libraryDist() {
	SKETCHBOOK_LIBRARIES_FOLDER="/Users/Brandon/Documents/Processing/libraries"
	ok "cp -R dist/* $SKETCHBOOK_LIBRARIES_FOLDER"
	cp -R dist/* $SKETCHBOOK_LIBRARIES_FOLDER
}