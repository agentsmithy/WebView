SCRIPTDIR=${BASH_SOURCE%/*}
. $SCRIPTDIR/myAMPEnv.sh

echo "First running Carthage Checkout"
$PROJECT_ROOT/carthage checkout

if ! type "rome" > /dev/null; then
	echo "rome command not found. Attempting install using brew."
	brew install blender/homebrew-tap/rome
fi
if [ ! -d ~/.aws ]; then
	echo "Copying contents of .aws to home directory"
	cp -r .aws ~/
	exit 0
else
	echo "You already have a .aws folder in your home. You need to manually add the entries for the AWS folder."
	echo "See instructions here: https://github.com/blender/Rome#setting-up-aws-credentials"
fi

