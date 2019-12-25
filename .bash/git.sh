#!/bin/bash

#########################
# git wrapper functions #
#########################

# gca()
# amends a commit
function gca() {
	git commit --amend
}

# gcm($@)
# commits staged files with a message
function gcm() {
	git commit -m "$@"
}

# gcj($@)
# commits staged files with a message prefixed by a Jira PBI
function gcj() {
	if [[ -d .git ]];
	then
		JIRA_TASK=`git branch | grep "* " | sed "s/* //g" | cut -d "/" -f2 | cut -d "-" -f1-2`
		if [[ $1 == "--soft" ]] || [[ $1 == "-s" ]];
		then
			shift
			ok "git commit -m \"$JIRA_TASK $@\""
		else
			git commit -m "$JIRA_TASK $@"
		fi
	else
		warn "No git repository found."
	fi
}

function gd() {
	git diff $1
}

function gf() {
	if [[ $1 == "--remote-to-local" ]] || [[ $1 == "-r" ]];
	then
		for remote in `git branch -r | grep -v '\->'`;
		do
			git branch --track ${remote#origin/} $remote
		done
		return
	fi
	git fetch
}

# gc($@)
# checks out a file/branch/commit
function gc() {
	git checkout "$@"
}

# gcd()
# checks out development branch
function gcd() {
	git checkout development
}

# gcw()
# checks out working branch
function gcw() {
	git checkout working
}

# gcs()
# checks out staging branch
function gcs() {
	git checkout staging
}

# gcp()
# checks out production (master) branch
function gcp() {
	git checkout master
}

function gcb() {
	git checkout -b "$1"
}

# gbd($@)
# deletes a branch (or list of branches separated by spaces)
function gbd() {
	if [[ $1 == "--remote" ]] || [[ $1 == "-r" ]];
	then
		shift
		gbdr $@
	fi

	for branchName in "$@"
	do
		ok "git branch -D $branchName"
		git branch -D $branchName
	done
}

# gbdr($1)
# deletes a remote branch from the origin repository
function gbdr() {
	for branchName in "$@"
	do
		warn "git push --delete origin $branchName"
		git push --delete origin $branchName
	done
}

function gb() {
	git branch $@
}

# gm($1)
# merges specified branch into the current one
function gm() {
	git merge $1
}

# gmd()
# merges development branch into the current one
function gmd() {
	git merge --no-edit development
}

# gmw()
# merges working branch into the current one
function gmw() {
	git merge --no-edit working
}

# gms()
# merges staging branch into the current one
function gms() {
	git merge --no-edit staging
}

# gmp()
# merges production (master) branch into the current one
function gmp() {
	git merge --no-edit master
}

# gp
# pushes commits to remote branch
function gp() {
	# Commenting this out until needed agin. This redirects stderr to stdout for parsing via sed,
	# for the purpose of transforming the pull request URL.
	# OUTPUT=$(git push $@ 2>&1)
	# echo -e "$OUTPUT" | sed "s/\&t=1/\&t=1\&dest=development\&w=1/g"
	git push $@
}

# gpum
# pulls an upstream master branch (from a forked repository) into the local master
function gpum() {
	git pull upstream master
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

# gsp($stash?)
# git stash pop (optionally, number of stashes behind to pop)
function gsp {
	if [[ $# -eq 0 ]];
	then
		git stash pop
	else
		git stash pop stash@{$1}
	fi
}

# gitFixRepack
# Fixes weird repacking issue (https://stackoverflow.com/a/53737530)
function gitFixRepack {
	git gc --aggressive --prune=now
}

# checkAllGitDirectories($dir)
# Recursively finds all git directories and checks for unstaged changes, staged + uncommitted changes,
# and untracked files.
function checkAllGitDirectories() {
	if [[ "$#" -lt 1 ]];
	then
		error "No directory provided."
		return
	fi;
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")
	find $1 -name ".git" -type d 2> /dev/null | while read GIT_DIR
	do
		BASE_DIR=`echo $GIT_DIR | rev | cut -d "/" -f 2-100 | rev`
		checkForUnstagedChanges $BASE_DIR
		checkForStagedUncommittedChanges $BASE_DIR
		checkForUntrackedFiles $BASE_DIR
	done
	IFS=$SAVEIFS
}

function checkForUnstagedChanges() {
	if [[ "$#" -lt 1 ]];
	then
		error "No directory provided."
		return
	fi;

	cd "$@"
	git diff --exit-code &> /dev/null

	if [[ $? -ne 0 ]]
	then
		warn "There are unstashed changes in $@"
	fi
}

function checkForStagedUncommittedChanges() {
	if [[ "$#" -lt 1 ]];
	then
		error "No directory provided."
		return
	fi;

	cd $@
	git diff --cached --exit-code &> /dev/null

	if [[ $? -ne 0 ]]
	then
		warn "There are staged, uncommitted changes in $@"
	fi
}

function checkForUntrackedFiles() {
	if [[ "$#" -lt 1 ]];
	then
		error "No directory provided."
		return
	fi;

	cd "$@"
	COUNT=`git ls-files --other --exclude-standard --directory | wc -l`

	if [[ $COUNT -ne 0 ]]
	then
		warn "There are untracked files in $@"
	fi
}
