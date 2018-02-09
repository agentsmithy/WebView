SCRIPTDIR=${BASH_SOURCE%/*}

function  fullPath() {
	dir=`cd $1 && pwd`
	echo ${dir}
}

export PROJECT_ROOT=`fullPath $SCRIPTDIR/..`
export AMPCORE_ROOT=$PROJECT_ROOT/AMPCore
export CLIENT_LIB_ROOT=$PROJECT_ROOT/MyAMP-iOS-Client-Library
export MOBILE_UTILS=$PROJECT_ROOT/AMPMobileUtils
export CLIENT_LIB_CARTHAGE=$CLIENT_LIB_ROOT/Carthage
export AMPCORE_CARTHAGE=$AMPCORE_ROOT/Carthage
export LOCAL_CARTHAGE=$PROJECT_ROOT/Carthage
export WORKSPACE_BUILD_DIR=$PROJECT_ROOT/Build/Products/Debug-iphonesimulator

