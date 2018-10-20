#!/bin/bash

#########################
# git wrapper functions #
#########################

function gd() {
	git diff $1
}

function gf() {
	git fetch
}

function gc() {
	git checkout "$@"
}

function gbd() {
	for branchName in "$@"
	do
		git branch -D $branchName
	done
}

function gb() {
	git branch
}

function gm() {
	git merge $1
}

function gp() {
	git push
}

function grh() {
	for file in "$@"
	do
		git reset head $file
	done
}

function ga() {
	for file in "$@"
	do
		git add $file
	done
}

function gs() {
	git status
}