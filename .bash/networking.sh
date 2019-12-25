#!/bin/bash

function ufwblock() {
    for ip in "$@"
	do
		sudo ufw deny from $ip to any
	done
}