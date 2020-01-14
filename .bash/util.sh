#!/bin/bash

#########################
# Util                  #
#########################

function branchName() {
	if [[ -d .git ]];
	then
		BRANCH_NAME=`git branch | grep "* " | sed "s/* //g"`
		echo " ($BRANCH_NAME) "
	else
		echo " "
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

function cpIfNotExists() {
	if [ ! -f $2 ]; then
		cp $1 $2
		checkReturn "cp $1 $2"
	else
		warn "$2 already exists. Not copying again."
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

function mkdirIfNotExists() {
	if [ ! -d $1 ]; then
		mkdir -p $1
		checkReturn "mkdir -p $1"
	else
		warn "$1 already exists. Not creating directory again."
	fi
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

function sourceme() {
	if isMac;
	then
		source ~/.bash_profile
		checkReturn "source ~/.bash_profile"
	fi;

	if isWindows || isLinux;
	then
		source ~/.bashrc
        checkReturn "source ~/.bashrc"
	fi;
}

updateReleaseVersion() {
    version=$1

    echo Updating all assemblies to version $1

	if isMac;
	then
		# macOS workaround https://stackoverflow.com/a/44864004
		find . -type f -name '*.csproj' -exec sed -i.bak -E "s:<(AssemblyFileVersion|AssemblyVersion|PackageVersion|Version)>[0-9]+.[0-9]+.[0-9]+<\/(AssemblyFileVersion|AssemblyVersion|PackageVersion|Version)>:<\1>$version<\/\2>:g" {} \;
		# Cleanup leftover .bak files
		find . -type f -name '*.csproj.bak' | xargs rm
	fi;
}