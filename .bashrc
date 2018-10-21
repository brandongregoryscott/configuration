#!/bin/bash
true=0
false=1
#########################
# misc functions        #
#########################

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
	echo "${PIDS[@]}"
	for PID in ${PIDS[@]};
	do
		echo "Killing dotnet process id $PID"
		kill -9 $PID
	done
}

function killnode() {
	PIDS=`ps  | grep node | sed -e 's/ \+/ /g' | cut -d" " -f2 | tr "\n" " "`
	echo "${PIDS[@]}"
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

function gp() {
	git push
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