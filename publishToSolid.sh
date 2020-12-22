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

export base="https://${target}.solidcommunity.net"
export base="https://localhost:8443"

# upload <localFile> [<remoteFile>]
upload() {
	localFile=$1
	remoteFile=$2
	if [ -z "$remoteFile" ]
	then
		remoteFile=$localFile
	fi
	remoteURL="${base}/${remoteFile}"

	filename=$(basename -- "$remoteFile")
	extension="${filename##*.}"
	filename="${filename%.*}"
	mimeType="application/octet-stream"

	extensionLC="$(tr [A-Z] [a-z] <<< "$extension")"
	if [ ${extensionLC} == "html" ]
	then
		mimeType="text/html"
	elif [ ${extensionLC} == "md" ]
	then
		mimeType="text/markdown"
	elif [ ${extensionLC} == "svg" ]
	then
		mimeType="image/svg+xml"
	elif [ ${extensionLC} == "png" ]
	then
		mimeType="image/png"
	elif [ ${extensionLC} == "css" ]
	then
		mimeType="text/css"
	else
		echo "# Unknown extension type: '${extensionLC}'"
	fi

	curl --insecure --cookie "nssidp.sid=${sid}" -H "Content-Type: ${mimeType}" --upload-file ${localFile} ${remoteURL}

	echo ""
}
export -f upload

# delete <remotePath>]
delete() {
	remotePath=$1
	remoteURL=${base}/${remotePath}
	curl --insecure --cookie "nssidp.sid=${sid}" -XDELETE ${remoteURL}
}
export -f delete


if [ $target == "doctorbud" ]
then

	# delete databrowser.html
	# delete index.html

	# delete public/PubSub/crossword.ttl
	# delete public/PubSub/state.ttl
	# delete public/PubSub/statePubSubAdd.ttl
	# delete public/PubSub/statePubSubSet.ttl
	# delete public/PubSub/

	# delete public/ReactNoJSXFunctionComponent.md
	# delete public/smartdown/
	# delete public/PubSubWithAdd.html
	# delete public/PubSubWithSet.html
	# delete public/foo.txt
	# delete public/Home.md
	# delete public/smartdown/starter.js

	# delete public/D3.md
	# delete public/Mobius.md
	# delete public/P5JS.md
	# delete index.html
	# delete public/index.html
	# delete public/smartdown/index.html

	# upload PubSubWithAdd.html public/PubSubWithAdd.html
	# upload PubSubWithSet.html public/PubSubWithSet.html
	# upload ../smartdown/src/starter.js public/smartdown/starter.js
	# upload public/smartdown/index_solid.html public/smartdown/index.html
	# upload indexSmartdownRoot.html index.html
	# upload databrowsers/root.html dbr/index.html
	upload databrowsers/markdown.html dbm/index.html
	upload public/HomeDoctorBud.md public/Home.md
	# upload public/D3.md
	upload public/Mobius.md
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


