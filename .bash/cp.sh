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

function cpsnippets() {
	if [[ $# -eq 0 ]] || [[ $1 == "--repo-to-local" ]] || [[ $1 == "-r" ]];
	then
		if isWindows;
		then
			cp -r ~/configuration/vscode/snippets/* $APPDATA/Code/User/snippets/
			checkReturn "cp -r ~/configuration/vscode/snippets/* $APPDATA/Code/User/snippets/"
		fi;

		if isLinux;
		then
			cp -r ~/configuration/vscode/snippets/ ~/.config/Code/User/snippets/
			checkReturn "cp -r ~/configuration/vscode/snippets/ ~/.config/Code/User/snippets/"
		fi;

		if isMac;
		then
			cp -a ~/configuration/vscode/snippets/* ~/Library/"Application Support"/Code/User/snippets/
			checkReturn "cp -a ~/configuration/vscode/snippets/* ~/Library/Application Support/Code/User/snippets/"
		fi;
	fi;

	if [[ $1 == "--local-to-repo" ]] || [[ $1 == "-l" ]];
	then
		if isWindows;
		then
			cp -r $APPDATA/Code/User/snippets/ ~/configuration/vscode/
			checkReturn "cp -r $APPDATA/Code/User/snippets/ ~/configuration/vscode/"
		fi;

		if isLinux;
		then
			cp -r ~/.config/Code/User/snippets/* ~/configuration/vscode/
			checkReturn "cp -r ~/.config/Code/User/snippets/* ~/configuration/vscode/"
		fi;

		if isMac;
		then
			cp -a ~/Library/"Application Support"/Code/User/snippets/. ~/configuration/vscode/
			checkReturn "cp -a ~/Library/Application Support/Code/User/snippets/. ~/configuration/vscode/"
		fi;
	fi;
}

function cpvscode() {
	if [[ $# -eq 0 ]] || [[ $1 == "--repo-to-local" ]] || [[ $1 == "-r" ]];
	then
		if isMac;
		then
			cp ~/configuration/vscode/settings.json ~/Library/"Application Support"/Code/User/
			checkReturn "cp ~/configuration/vscode/settings.json ~/Library/Application Support/Code/User/"
		fi;

		if isLinux;
		then
			cp ~/configuration/vscode/settings.json ~/.config/Code/User
			checkReturn "cp ~/configuration/vscode/settings.json ~/.config/Code/User"
		fi;

		if isWindows;
		then
			cp ~/configuration/vscode/settings.json $APPDATA/Code/User/
			checkReturn "cp ~/configuration/vscode/settings.json $APPDATA/Code/User/"
		fi;
	fi;

	if [[ $1 == "--local-to-repo" ]] || [[ $1 == "-l" ]];
	then
		if isMac;
		then
			cp ~/Library/"Application Support"/Code/User/settings.json ~/configuration/vscode/
			checkReturn "cp ~/Library/Application Support/Code/User/settings.json ~/configuration/vscode/"
		fi;

		if isLinux;
		then
			cp ~/.config/Code/User/settings.json ~/configuration/vscode/
			checkReturn "cp ~/.config/Code/User/settings.json ~/configuration/vscode/"
		fi;

		if isWindows;
		then
			cp $APPDATA/Code/User/settings.json ~/configuration/vscode/
			checkReturn "cp $APPDATA/Code/User/settings.json ~/configuration/vscode/"
		fi;
	fi;
}
