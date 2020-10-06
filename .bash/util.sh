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

function confirm() {
#
# syntax: confirm [<prompt>]
#
# Prompts the user to enter Yes or No and returns 0/1.
#
# This  program  is free software: you can redistribute it and/or modify  it
# under the terms of the GNU General Public License as published by the Free
# Software  Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This  program  is  distributed  in the hope that it will  be  useful,  but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public  License
# for more details.
#
# You  should  have received a copy of the GNU General Public License  along
# with this program. If not, see <http://www.gnu.org/licenses/>
#
#  04 Jul 17   0.1   - Initial version - MEJT
#
	local _prompt _default _response

	if [ "$1" ]; then _prompt="$1"; else _prompt="Are you sure"; fi
	_prompt="$_prompt [y/N]?"

	# Loop forever until the user enters a valid response (Y/N or Yes/No).
	while true; do
		read -r -p "$_prompt " _response
		case "$_response" in
		[Yy][Ee][Ss]|[Yy]) # Yes or Y (case-insensitive).
			echo $true
			return $true;
			;;
		[Nn][Oo]|[Nn])  # No or N.
			echo $false
			return $false;
			;;
		*) # Anything else (including a blank) is invalid.
			;;
		esac
	done
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
	source ~/.bashrc
	checkReturn "source ~/.bashrc"
}

# Wrapper function for clearing out node modules, package-lock and clearing npm cache.
# This "super clear" seems to be the only way to get a local reference to a repository for a package
# to sync back up...
function ssnpmi() {
	pushd frontend
	rm package-lock.json
	npm cache clear -f
	rm -rf node_modules
	npm i
	popd
}

function updateReleaseVersion() {
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

# Unzips a tar.gz file
function untar() {
	tar -xzvf $@
}