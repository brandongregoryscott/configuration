#!/bin/bash

#########################
# mkdrumkit			    #
#########################

function mkdrumkit() {
	ORIG_IFS=$IFS
	IFS=$'\n'

    TMP=tmp.mkdrumkit
    rm -rf $TMP
    mkdir $TMP

	COUNT=0
    for FILE in `find . -type f | grep .wav | grep -v joined.wav | sort`;
    do
		let "COUNT++"
        # FILENAME=`echo $FILE | sed 's/\.\///g'`
		# Converts file just incase file has errors
        ffmpeg -i $FILE -ac 2 -f wav -ar 48000 "$TMP/$COUNT.wav" &> /dev/null
		checkReturn "$FILE => $TMP/$COUNT.wav"
    done

	pushd $TMP

	FILES=`find . -type f | egrep "(([1-9]+)|([1]{1}[0-9]+))(.wav)"`
	shnjoin -O always $FILES
	checkReturn "Joined all files"

	mv joined.wav ..
	checkReturn "Moving joined file back into parent directory"

	popd

	rm -rf $TMP
	checkReturn "Cleaning up $TMP"

	IFS=$ORIG_IFS
}