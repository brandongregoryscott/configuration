#!/bin/bash

function showfailedlogins() {
    sudo grep sshd.\*Failed /var/log/auth.log | tac | grep -v "grep" | less
}

function showfailed2ban() {
    sudo cat /var/log/fail2ban.log | tac | less
}

function ufwblock() {
    for ip in "$@"
	do
		sudo ufw deny from $ip to any
	done

    sudo ufw reload
}