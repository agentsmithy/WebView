#!/bin/bash
SCRIPTDIR=${BASH_SOURCE%/*}
. $SCRIPTDIR/myAMPEnv.sh
echo "This script should be run from the Project Root."
echo "It expects AMPCore to be in the immediate subfolder"
#Fail on any error.
#set -e 
NEW_TAG=""
OLD_TAG=""
CARTFILE="Cartfile"
function incrementTag() {
    #get highest tag number
    VERSION=`git describe --abbrev=0 --tags`
    OLD_TAG=$VERSION
    #replace . with space so can split into an array
    VERSION_BITS=(${VERSION//./ })

    #get number parts and increase last one by 1
    VNUM1=${VERSION_BITS[0]}
    VNUM2=${VERSION_BITS[1]}
    VNUM3=${VERSION_BITS[2]}
    VNUM3=$((VNUM3+1))

    #create new tag
    NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

    echo "Updating $VERSION to $NEW_TAG"

    #get current hash and see if it already has a tag
    GIT_COMMIT=`git rev-parse HEAD`
    NEEDS_TAG=`git describe --contains $GIT_COMMIT`

    #only tag if no tag already (would be better if the git describe command above could have a silent option)
    if [ -z "$NEEDS_TAG" ]; then
        echo "Tagged with $NEW_TAG (Ignoring fatal:cannot describe - this means commit is untagged) "
        git tag $NEW_TAG
        git push origin $NEW_TAG
        echo "Response is $?"
    else
        echo "Already a tag on this commit"
        NEW_TAG=$VERSION
    fi
}

function checkErr() {
    if [ $? -ne 0 ]; then
        exit $?
    fi
}

echo "Updating local repo from remote"
git checkout jenkins
checkErr
git pull
checkErr
echo "Updating AMPCore from remote"
cd AMPCore
git checkout develop
checkErr
git pull
checkErr
echo "Incrementing tag"
incrementTag
cd ..

echo "Updating cartfile with tag $NEW_TAG"
echo "sed  -Ei bkp s/(.*AMPCore.*)(\"develop\")/\\1==\ $NEW_TAG/ $CARTFILE"
sed  -Ei bkp s/\(.*AMPCore.*\)\(\"develop\"\)/\\1==\ $NEW_TAG/ $CARTFILE
echo "sed -Ei bkp s/(.*AMPCore.*==\)(.*)/\\1\ $NEW_TAG/ $CARTFILE"
sed  -Ei bkp s/\(.*AMPCore.*==\)\(.*\)/\\1\ $NEW_TAG/ $CARTFILE

cat  $CARTFILE
echo "Running carthage update"
carthage update --platform iOS --cache-builds

echo git commit -m
echo git push