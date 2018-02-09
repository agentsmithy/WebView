#get the common variables
SCRIPTDIR=${BASH_SOURCE%/*}
. $SCRIPTDIR/myAMPEnv.sh


RED='\033[0;31m'
NC='\033[0m' # No Color
echo "$RED Reseting Project Root $NC "
echo "$RED erasing AMPCore framework from $LOCAL_CARTHAGE  $NC "
rm -rf $LOCAL_CARTHAGE/Build/iOS/AMPCore*
echo "erasing MyAMPClient frameworks  $NC "
rm -rf $LOCAL_CARTHAGE/Build/iOS/MyAMPClient*


echo "$RED Reseting  CL $NC "
cd $CLIENT_LIB_ROOT
$CLIENT_LIB_ROOT/rome.sh 

echo "$RED Reseting AMPCore  $NC  "
cd $AMPCORE_ROOT
$AMPCORE_ROOT/rome.sh
echo "$RED Reseting  Root $NC "
cd $PROJECT_ROOT
$PROJECT_ROOT/rome.sh 
