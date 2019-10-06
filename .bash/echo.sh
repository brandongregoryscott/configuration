#!/bin/bash

#########################
# Echo                  #
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