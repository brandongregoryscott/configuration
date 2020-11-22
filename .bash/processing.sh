#!/bin/bash

#########################
# Processing helpers    #
#########################

function getBasename() {
	echo `basename $(pwd)`
}

function getJarname() {
	echo `getBasename | cut -d "." -f1`
}

# Replace any . with / to make recursive folder structure for java packaging
function getLibraryFolderStructure() {
	echo `getBasename | sed "s|\.|/|g"`
}

function libraryClean() {
	rm -rf bin/
	checkReturn "rm -rf bin/"
	rm -rf dist/
	checkReturn "rm -rf dist/"
}

function setupLibrary() {
	LIBRARY_FOLDER_STRUCTURE=`getLibraryFolderStructure`
	JAR_NAME=`getJarname`
	mkdirIfNotExists bin/$LIBRARY_FOLDER_STRUCTURE
	mkdirIfNotExists dist/$JAR_NAME/library
	mkdirIfNotExists lib
	mkdirIfNotExists src/$LIBRARY_FOLDER_STRUCTURE

	# Example: /Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home/jre/lib
	JVM_DIR="/Library/Java/JavaVirtualMachines"
	JDK=`ls $JVM_DIR | grep jdk | tail -1`

	cpIfNotExists $JVM_DIR/$JDK/Contents/Home/jre/lib/rt.jar lib/rt.jar
	cpIfNotExists /Applications/Processing.app/Contents/Java/core.jar lib/core.jar
}

function libraryMake() {
	LIBRARY_FOLDER_STRUCTURE=`getLibraryFolderStructure`
	JAR_NAME=`getJarname`

	# Attempt to setup library again to make sure rt.jar & core.jar files are present for compilation.
	setupLibrary

	javac -d bin -target 1.6 -source 1.6 -sourcepath src -cp lib/core.jar src/$LIBRARY_FOLDER_STRUCTURE/*.java  -bootclasspath lib/rt.jar
	checkReturn "javac -d bin -target 1.6 -source 1.6 -sourcepath src -cp lib/core.jar src/$LIBRARY_FOLDER_STRUCTURE/*.java  -bootclasspath lib/rt.jar"
	pushd bin
	jar cfv ../dist/$JAR_NAME/library/$JAR_NAME.jar *
	checkReturn "jar cfv ../dist/$JAR_NAME/library/$JAR_NAME.jar *"
	popd
}

function libraryDist() {
	SKETCHBOOK_LIBRARIES_FOLDER="/Users/Brandon/Documents/Processing/libraries"
	ok "cp -R dist/* $SKETCHBOOK_LIBRARIES_FOLDER"
	cp -R dist/* $SKETCHBOOK_LIBRARIES_FOLDER
}