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
true=0
false=1
PS1='\[\e[0;32m\]\u@\h\[\033[00m\] \[\033[01;33m\]`shortpwd`\[\033[00m\]\[\033[01;35m\]`branchName`\[\033[00m\]-> '
PWD=`pwd`
BASENAME=`basename $PWD`
JAR_NAME=`basename $PWD | cut -d "." -f1`
# Replace any . with / to make recursive folder structure for java packaging
LIBRARY_FOLDER_STRUCTURE=`echo $BASENAME | sed "s|\.|/|"`
export PATH="/apps/:/apps/processing-3.5.3/:$PATH"

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
		ok "defaults write com.apple.finder AppleShowAllFiles NO"
		defaults write com.apple.finder AppleShowAllFiles NO
		ok "killall Finder /System/Library/CoreServices/Finder.app"
		killall Finder /System/Library/CoreServices/Finder.app
	fi;
}

function showdotfiles() {
	if isMac;
	then
		ok "defaults write com.apple.finder AppleShowAllFiles YES"
		defaults write com.apple.finder AppleShowAllFiles YES
		ok "killall Finder /System/Library/CoreServices/Finder.app"
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
		echo " ($BRANCH_NAME) "
	else
		echo " "
	fi
}

function isLinux() {
	uname=`uname`
	if [[ $uname == "Linux" ]];
	then
		return $true
	else
		return $false
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
		ok "source ~/.bash_profile"
		source ~/.bash_profile
	fi;

	if isWindows;
	then
		ok "source ~/.bashrc"
		source ~/.bashrc
	fi;
}

function killdotnet() {
    dotnet build-server shutdown
	ok "Found dotnet processes: $(ps aux | grep 'dotnet' | awk '{print $1}')"
	kill $(ps aux | grep 'dotnet' | awk '{print $1}')
}

function killnode() {
	ok "Found node processes: $(ps aux | grep 'node' | awk '{print $2}')"
	kill $(ps aux | grep 'node' | awk '{print $2}')
}

function cpbashrc() {
	if [[ $# -eq 0 ]] || [[ $1 == "--repo-to-local" ]] || [[ $1 == "-r" ]];
	then
		if isMac;
		then
			ok "cp ~/configuration/.bashrc ~/.bash_profile"
			cp ~/configuration/.bashrc ~/.bash_profile
		fi;
		if [[ isWindows || isLinux ]];
		then
			ok "cp ~/configuration/.bashrc ~/.bashrc"
			cp ~/configuration/.bashrc ~/.bashrc
		fi;
	fi;

	if [[ $1 == "--local-to-repo" ]] || [[ $1 == "-l" ]];
	then
		if isMac;
		then
			ok "cp ~/.bash_profile ~/configuration/.bashrc"
			cp ~/.bash_profile ~/configuration/.bashrc
		fi;
		if [[ isWindows || isLinux ]];
		then
			ok "cp ~/.bashrc ~/configuration/.bashrc"
			cp ~/.bashrc ~/configuration/.bashrc
		fi;
	fi;
}

function cpvscode() {
	if [[ $# -eq 0 ]] || [[ $1 == "--repo-to-local" ]] || [[ $1 == "-r" ]];
	then
		if isMac;
		then
			ok "cp ~/configuration/vscode/settings.json ~/Library/Application Support/Code/User/"
			cp ~/configuration/vscode/settings.json ~/Library/"Application Support"/Code/User/
		fi;

		if isWindows;
		then
			ok "cp ~/configuration/vscode/settings.json $APPDATA/Code/User/"
			cp ~/configuration/vscode/settings.json $APPDATA/Code/User/
		fi;
	fi;

	if [[ $1 == "--local-to-repo" ]] || [[ $1 == "-l" ]];
	then
		if isMac;
		then
			ok "cp ~/Library/Application Support/Code/User/settings.json ~/configuration/vscode/"
			cp ~/Library/"Application Support"/Code/User/settings.json ~/configuration/vscode/
		fi;

		if isWindows;
		then
			ok "cp $APPDATA/Code/User/settings.json ~/configuration/vscode/"
			cp $APPDATA/Code/User/settings.json ~/configuration/vscode/
		fi;
	fi;
}

function cpsnippets() {
	if [[ $# -eq 0 ]] || [[ $1 == "--repo-to-local" ]] || [[ $1 == "-r" ]];
	then
		if isWindows;
		then
			ok "cp -r ~/configuration/vscode/snippets/* $APPDATA/Code/User/snippets/"
			cp -r ~/configuration/vscode/snippets/* $APPDATA/Code/User/snippets/
		fi;
	fi;

	if [[ $1 == "--local-to-repo" ]] || [[ $1 == "-l" ]];
	then
		if isWindows;
		then
			ok "cp -r $APPDATA/Code/User/snippets/ ~/configuration/vscode/"
			cp -r $APPDATA/Code/User/snippets/ ~/configuration/vscode/
		fi;
	fi;

}

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
	OUTPUT=$(git push $@ 2>&1)
	echo -e "$OUTPUT" | sed "s/\&t=1/\&t=1\&dest=development\&w=1/g"
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

#########################
# mkdrumkit			    #
#########################

function mkdrumkit() {
	ORIG_IFS=$IFS
	IFS=$'\n'

    TMP=tmp.mkdrumkit
    rm -rf $TMP
    mkdir $TMP

	COUNT=0
    for FILE in `find . -type f | grep .wav | grep -v joined.wav | sort`;
    do
		let "COUNT++"
        # FILENAME=`echo $FILE | sed 's/\.\///g'`
		# Converts file just incase file has errors
        ffmpeg -i $FILE -ac 2 -f wav -ar 48000 "$TMP/$COUNT.wav" &> /dev/null
		checkReturn "$FILE => $TMP/$COUNT.wav"
    done

	pushd $TMP

	FILES=`find . -type f | egrep "(([1-9]+)|([1]{1}[0-9]+))(.wav)"`
	shnjoin -O always $FILES
	checkReturn "Joined all files"

	mv joined.wav ..
	checkReturn "Moving joined file back into parent directory"

	popd

	rm -rf $TMP
	checkReturn "Cleaning up $TMP"

	IFS=$ORIG_IFS
}