#!/bin/bash

#########################
# cp wrappers           #
#########################

function cpbashrc() {
	if [[ $# -eq 0 ]] || [[ $1 == "--repo-to-local" ]] || [[ $1 == "-r" ]];
	then
		if isMac;
		then
			cp ~/configuration/.bashrc ~/.bash_profile
			checkReturn "cp ~/configuration/.bashrc ~/.bash_profile"
            cp -r ~/configuration/.bash/* ~/.bash/
			checkReturn "cp -r ~/configuration/.bash/* ~/.bash/"
		fi;
		if [[ isWindows || isLinux ]];
		then
			cp ~/configuration/.bashrc ~/.bashrc
			checkReturn "cp ~/configuration/.bashrc ~/.bashrc"
            cp -r ~/configuration/.bash/* ~/.bash/
			checkReturn "cp -r ~/configuration/.bash/* ~/.bash/"
		fi;
	fi;

	if [[ $1 == "--local-to-repo" ]] || [[ $1 == "-l" ]];
	then
		if isMac;
		then
			cp ~/.bash_profile ~/configuration/.bashrc
			checkReturn "cp ~/.bash_profile ~/configuration/.bashrc"
            cp -r ~/.bash ~/configuration/.bash
			checkReturn "cp -r ~/.bash ~/configuration/.bash"
		fi;
		if [[ isWindows || isLinux ]];
		then
			cp ~/.bashrc ~/configuration/.bashrc
			checkReturn "cp ~/.bashrc ~/configuration/.bashrc"
			cp -r ~/.bash ~/configuration/.bash
			checkReturn "cp -r ~/.bash ~/configuration/.bash"
		fi;
	fi;
}

function cplmsworkspace() {
	PWD=`pwd`
	CURRENT_DIR=`basename $PWD`
	if [ $CURRENT_DIR = "cca-lms" ];
	then
		cat .vscode/settings.json | sed "s|frontend/tslint.json|tslint.json|" > ./frontend/.vscode/settings.json
		checkReturn ".vscode/settings.json | sed 's|frontend/tslint.json|tslint.json|' > ./frontend/.vscode/settings.json"
		cat .vscode/launch.json.example | sed "s|/frontend||" > ./frontend/.vscode/launch.json
		checkReturn ".vscode/launch.json.example | sed 's|/frontend||' > ./frontend/.vscode/launch.json"
		cp .vscode/launch.json.example ./dotnet/.vscode/launch.json
		checkReturn ".vscode/launch.json.example ./dotnet/.vscode/launch.json"
	fi
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
