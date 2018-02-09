SCRIPTDIR=${BASH_SOURCE%/*}
. $SCRIPTDIR/myAMPEnv.sh

function usage() {
  
  echo "This script configures your environment to run with either xcode8 or xcode9, using either the pure carthage mode, or the symlink method for framework development"
  echo ""
  echo "usage: $0 (init|carthage|symlink) (xcode8|xcode9)"
  echo ""
  echo "- init - clean slate. Wipes any existing carthage folders and pulls everythiing down. Be prepared to wait."
  echo "- carthage - Removes any sym-linked frameworks, and restores any backed-up carthage builds. Rebuilds latest if nothign is cached"
  echo "- symlink - AMPCore and ClientLibrary frameworks are symlinked to the output of Xcode Builds."
  exit 0
}

function init() {
    echo "This will wipe your Carthage Built folders and re-build everything. It takes some time.\n Are you sure?[y/n]:"
    read shouldContinue
    if [[ $shouldContinue = "y" ]]; then
        echo "erasing $CLIENT_LIB_CARTHAGE"
        rm -rf $CLIENT_LIB_CARTHAGE
        echo "erasing $AMPCORE_CARTHAGE"
        rm -rf $AMPCORE_CARTHAGE
        echo "erasing $SCRIPTDIR/Carthage"
        rm -rf Carthage
    fi
    $SCRIPTDIR/carthageMode.sh force
    exit 0
}


function switchXcode() {
    case "$1" in
        xcode9)
            $SCRIPTDIR/xcodeSwitch.sh 9

            ;;
        xcode8)
            $SCRIPTDIR/xcodeSwitch.sh 8
            ;;
        *)
            echo "error: Unexpected second parameter $2. defaulting to xcode9"
            $SCRIPTDIR/xcodeSwitch.sh 9
            ;;

    esac
    if [[ $? -ne 0 ]]; then 
        exit $?
    fi
}


if [ $# -lt 2 ]; then 
    usage
fi

case "$1" in
      init)
          init
          switchXcode $2
          ;;
      carthage)
          switchXcode $2
          
          ;;
      symlink)
          switchXcode $2
          $SCRIPTDIR/symlinkMode.sh
          ;;
      *)
          echo "error: Unexpected parameter $1"
          usage
          ;;
esac




