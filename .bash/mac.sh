#!/bin/bash

#########################
# macOS functions       #
#########################

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

function showdotfiles() {
	if isMac;
	then
		ok "defaults write com.apple.finder AppleShowAllFiles YES"
		defaults write com.apple.finder AppleShowAllFiles YES
		ok "killall Finder /System/Library/CoreServices/Finder.app"
		killall Finder /System/Library/CoreServices/Finder.app
	fi;
}