#!/bin/bash

#########################
# kill functions        #
#########################

function killdotnet() {
    dotnet build-server shutdown
	ok "Found dotnet processes: $(ps aux | grep 'dotnet' | awk '{print $1}')"
	kill $(ps aux | grep 'dotnet' | awk '{print $1}')
}

function killnode() {
	ok "Found node processes: $(ps aux | grep 'node' | awk '{print $2}')"
	kill $(ps aux | grep 'node' | awk '{print $2}')
}