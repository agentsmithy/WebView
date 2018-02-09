#get the common variables
SCRIPTDIR=${BASH_SOURCE%/*}
. $SCRIPTDIR/myAMPEnv.sh

#$SCRIPTDIR/carthageMode.sh

RED='\033[0;31m'
NC='\033[0m' # No Color
CARTHAGE_IOS=Build/iOS
AMPCORE_CARTHAGE_IOS=$AMPCORE_CARTHAGE/$CARTHAGE_IOS
LOCAL_CARTHAGE_IOS=$LOCAL_CARTHAGE/$CARTHAGE_IOS
CLIENT_LIB_CARTHAGE_IOS=$CLIENT_LIB_CARTHAGE/$CARTHAGE_IOS

LINK="ln -s"
LOCK_LINK=$LOCAL_CARTHAGE_IOS/"link.lock"
UNLINK_LOCK=$LOCAL_CARTHAGE_IOS/"unlink.lock"
if [ -L $LOCAL_CARTHAGE_IOS/AMPCore.framework ]; then
echo "Frameworks are already linked"
echo "run ${RED}./carthageMode.sh && ./symLinkMode.sh${NC} to reset "
exit 0
fi

echo "$RED Client Library -> AMPCore Symlinks $NC"
echo "\t erasing carthage built Client Library from the MyAMP Carthage Folder"
rm -r $AMPCORE_CARTHAGE_IOS/MyAMPClientLibrary.framework*
echo "\t symlinking xcode built Client Library to he MyAMP Carthage Folder"
$LINK $WORKSPACE_BUILD_DIR/MyAMPClientLibrary.framework $AMPCORE_CARTHAGE_IOS/
$LINK $WORKSPACE_BUILD_DIR/MyAMPClientLibrary.framework.dsym $AMPCORE_CARTHAGE_IOS/


echo "$RED AMP Core -> Root Symlinks $NC"
echo "\t erasing carthage built AMPCore from the MyAMP Carthage Folder"
rm -r $LOCAL_CARTHAGE_IOS/AMPCore.framework*
echo "\t symlinking xcode built AMPCore into the MyAMP Carthage Folder"
$LINK $WORKSPACE_BUILD_DIR/AMPCore.framework $LOCAL_CARTHAGE_IOS/
$LINK $WORKSPACE_BUILD_DIR/AMPCore.framework.dsym $LOCAL_CARTHAGE_IOS/

echo "$RED Client Library -> Root Symlinks $NC"
echo "\t erasing carthage built Client Library from the MyAMP Carthage Folder"
rm -r $LOCAL_CARTHAGE_IOS/MyAMPClientLibrary.framework*
echo "\t symlinking xcode built Client Library to he MyAMP Carthage Folder"
$LINK $WORKSPACE_BUILD_DIR/MyAMPClientLibrary.framework $LOCAL_CARTHAGE_IOS/
$LINK $WORKSPACE_BUILD_DIR/MyAMPClientLibrary.framework.dsym $LOCAL_CARTHAGE_IOS/

if ! type "say" > /dev/null; then
	say Symlink Mode Ready
fi

