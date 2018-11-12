#!/bin/bash

#########################
# variables             #
#########################

dv1="development-v1"
wv1="working-v1"
sv1="staging-v1"
true=0
false=1
PS1='\[\e[0;32m\]\u@\h\[\033[00m\] \[\033[01;33m\]`shortpwd`\[\033[00m\] \[\033[01;35m\]`branchName`\[\033[00m\] -> '

#########################
# misc functions        #
#########################


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

function sourceme() {
	echo "source ~/.bashrc"
	source ~/.bashrc
}

function killdotnet() {
	PIDS=`ps  | grep dotnet | sed -e 's/ \+/ /g' | cut -d" " -f2 | tr "\n" " "`
	echo "Found dotnet processes: ${PIDS[@]}"
	for PID in ${PIDS[@]};
	do
		echo "Killing dotnet process id $PID"
		kill -9 $PID
	done
}

function killnode() {
	PIDS=`ps  | grep node | sed -e 's/ \+/ /g' | cut -d" " -f2 | tr "\n" " "`
	echo "Found node processes: ${PIDS[@]}"
	for PID in ${PIDS[@]};
	do
		echo "Killing node process id $PID"
		kill -9 $PID
	done
}

function cpbashrc() {
	echo "cp ~/configuration/.bashrc ~/.bashrc"
	cp ~/configuration/.bashrc ~/.bashrc
}

function cpvscode() {
	if isMac;
	then
		echo "cp ~/configuration/vscode/settings.json ~/Library/Application Support/Code/User/"
		cp ~/configuration/vscode/settings.json ~/Library/"Application Support"/Code/User/
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

function gbd() {
	for branchName in "$@"
	do
		git branch -D $branchName
	done
}

function gb() {
	git branch
}

function gm() {
	git merge $1
}

# gp()
# runs git push & copies pull request url to clipboard
function gp() {
	git push | grep "https" | cut -d " " -f4 | clip
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

# mdv1()
# kills dotnet & node, checks out $dv1, pulls changes, and merges $dv1 into starting branch
function mdv1() {
	STARTING_BRANCH=`git branch | grep "* " | sed -e "s/* //g"`
	killnode && killdotnet && git checkout $dv1 && git pull && git checkout $STARTING_BRANCH && git merge $dv1
}