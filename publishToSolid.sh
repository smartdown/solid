#!/usr/bin/env bash

#
# This script assumes that you have captured your browser's
# nssidp.sid cookie value and placed it into a file
# publishToSolid.smartdown.nssidp.sid that is included below.
# This file should consist of a single line of text with the
# nssidp.sid value.
#
# For instructions on how to capture this Cookie value, please
# consult:
#  https://github.com/megoth/solid-update-index-tutorial#get-cookie-value
#

target=doctorbud

export sid="`cat publishToSolid.${target}.connect.sid`"
if [ -z "$sid" ]
then
	echo "# No 'publishToSolid.connect.sid' found"
	echo "#"
	echo "# You need to create a publishToSolid.${target}.connect.sid that has your"
	echo "# nssidp.sid from your web browser."
	echo "# See https://github.com/megoth/solid-update-index-tutorial for"
	echo "# how to get your nssidp.sid Cookie."
	echo "#"
	exit 1
fi

export base="https://${target}.solid.community"

# upload <localFile> [<remoteFile>]
upload() {
	localFile=$1
	remoteFile=$2
	if [ -z "$remoteFile" ]
	then
		remoteFile=$localFile
	fi
	remoteURL=${base}/${remoteFile}

	filename=$(basename -- "$remoteFile")
	extension="${filename##*.}"
	filename="${filename%.*}"

	extensionLC="$(tr [A-Z] [a-z] <<< "$extension")"
	if [ ${extensionLC} == "html" ]
	then
		curl --cookie "nssidp.sid=${sid}" -H "Content-Type: text/html" --upload-file ${localFile} ${remoteURL}
	elif [ ${extensionLC} == "svg" ]
	then
		curl --cookie "nssidp.sid=${sid}" -H "Content-Type: image/svg+xml" --upload-file ${localFile} ${remoteURL}
	elif [ ${extensionLC} == "png" ]
	then
		curl --cookie "nssidp.sid=${sid}" -H "Content-Type: image/png" --upload-file ${localFile} ${remoteURL}
	elif [ ${extensionLC} == "css" ]
	then
		curl --cookie "nssidp.sid=${sid}" -H "Content-Type: text/css" --upload-file ${localFile} ${remoteURL}
	else
		curl --cookie "nssidp.sid=${sid}" ${mimeHeaders} --upload-file ${localFile} ${remoteURL}
	fi
	echo ""
}
export -f upload

# delete <remotePath>]
delete() {
	remotePath=$1
	remoteURL=${base}/${remotePath}
	curl --cookie "nssidp.sid=${sid}" -XDELETE ${remoteURL}
}
export -f delete


if [ $target == "doctorbud" ]
then
	# delete public/PubSubWithAdd.html
	# delete public/PubSubWithSet.html
	# delete public/Home.md
	# delete public/smartdown/index.html
	# delete public/index.html
	# delete public/D3.md
	# delete public/Mobius.md
	# delete public/P5JS.md

	# upload PubSubWithAdd.html public/PubSubWithAdd.html
	# upload PubSubWithSet.html public/PubSubWithSet.html
	upload public/databrowser_with_markdown.html public/index.html
	# upload public/HomeDoctorBud.md public/Home.md
	# upload public/D3.md
	# upload public/Mobius.md
	# upload public/P5JS.md

	exit
elif [ $target == "smartdown" ]
then
	# delete public/D3.md
	# delete public/Graphviz.md
	# delete public/Home.md
	# delete public/Inlines.md
	# delete public/LDF.md
	# delete public/Mobius.md
	# delete public/P5JS.md
	# delete public/README.md
	# delete public/SolidLDFlex.md
	# delete public/SolidLDFlexContainer.md
	# delete public/SolidQueries.md
	# delete public/dokieli/index.html
	# delete public/dokieli/dokieli.html
	# delete public/dokieli/dokieli_markdown.html
	# delete public/dokieli/dokieli_smartdown.html
	# delete public/dokieli/
	# delete public/folder1/folder2/Nested.md
	# delete public/folder1/folder2/
	# delete public/folder1/
	# delete public/smartdown/index.html
	# delete public/smartdown/
	# delete public/logo.png
	# delete public/logo.svg


	# upload indexSmartdownRoot.html index.html
	# upload public/login/index.html
	# upload public/folder1/folder2/Nested.md
	# upload public/D3.md
	# upload public/Graphviz.md
	# upload public/Home.md
	# upload public/Inlines.md
	# upload public/LDF.md
	# upload public/Mobius.md
	# upload public/P5JS.md
	# upload README.md public/README.md
	# upload public/SolidLDFlex.md
	upload public/SolidLDFlexContainer.md
	# upload public/SolidLDFlexMutation.md
	# upload public/SolidQueries.md

	upload public/exolve/exolve-multi.js
	upload public/exolve/exolve-multi.css
	upload public/SolidCrossword.md

	upload public/smartdown/index_solid.html public/smartdown/index.html
	upload ../dokieli/indexoverview.html public/dokieli/index.html
	upload ../dokieli/index.html public/dokieli/dokieli.html
	upload ../dokieli/indexmarkdown.html public/dokieli/dokieli_markdown.html
	upload ../dokieli/indexsmartdown.html public/dokieli/dokieli_smartdown.html
	upload public/logo.png
	upload public/logo.svg
else
	echo "# Unknown target: $target"
fi


