#!/bin/bash

#########################
# macOS functions       #
#########################

function hideCrashReports() {
	if isMac;
	then
		defaults write com.apple.CrashReporter DialogType none
		checkReturn "defaults write com.apple.CrashReporter DialogType none"
	fi;
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

function openRunelite() {
    if isMac;
    then
        open -n /Applications/Runelite.app
    fi;
}

function showCrashReports() {
	if isMac;
	then
		defaults write com.apple.CrashReporter DialogType crashreport
		checkReturn "defaults write com.apple.CrashReporter DialogType crashreport"
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

if isMac;
then
	export PATH="$PATH:/usr/local/share/dotnet/"
	if [ ! -d "$HOME/.nvm" ];
	then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
	fi

	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	nvm install 8.16.2 --latest-npm
fi;