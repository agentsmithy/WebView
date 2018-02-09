#!/bin/bash
#get the common variables
SCRIPTDIR=${BASH_SOURCE%/*}
. $SCRIPTDIR/myAMPEnv.sh
localHook=$SCRIPTDIR/pre-commit
ampCoreHook=$SCRIPTDIR/pre-commit.ampCore
hookPath=$PROJECT_ROOT/.git/hooks
hookPathCore=$PROJECT_ROOT/.git/modules/AMPCore/hooks/pre-commit

echo "Added pre commit hook to your repo"
cp $localHook $hookPath 
cp $ampCoreHook $hookPathCore


