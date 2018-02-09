export AWS_ACCESS_KEY_ID=AKIAIX5ESCHNGHMM64VQ
export AWS_SECRET_ACCESS_KEY=lEoOn0hYFDIl2glu4ZOX0rW8Kv0L9NPk1cUTMvCx
prefix=Xcode92

if [ "$1" == "help" ]; then
    echo "This script will manage your Carthage dependencies and your Rome Cache"
    echo "Usage: rome.sh with no parameters will cause rome to look at your Cartfile.resolved and attempt to download the versions listed there from the S3 cache"
    echo "  If a version in resolved is not in Cache, rome will call carthage to build it, and will the upload it to cache when/if the build succeeds"
    echo "rome.sh update : Adding the update flag will first call carthage update --no-build to cause Carthage to update the Cartfile.resolved before running the rest of the script (as listed above"
    echo "rome.sh deploy : Adding the deploy flag will force a full rebuild of all carthage depdencies, and will ensure that all deps have codeCoverageEnabled set to NO (if it's set to YES)."
    exit 0
fi
if [ "$1" == "deploy" ]; then
        prefix=Swift4Deploy
        echo "Deploy mode: changing prefix to ${prefix}."
        rome download --skip-local-cache --platform iOS --cache-prefix ${prefix}
	    carthage update --platform iOS --use-ssh --no-build
        echo "Replacing Code Coverage Settings"
        find Carthage -type f -name "*.xcscheme" -print0 | xargs -0 perl -pi -e 's/codeCoverageEnabled = "YES"/codeCoverageEnabled = "NO"/g'
        echo "Verifying code coverage settings"
        find Carthage -type f -name "*.xcscheme" -print0 | xargs -0 grep "codeCoverageEnabled"
        carthage build --platform iOS
        if [ $? -eq 0 ]; then
            rome upload --platform iOS  --cache-prefix ${prefix}
            say app ready for deploy
        else
            echo "Carthage bootstrap failed.. Investigate and try running this script again when completed"
            say carthage build failed
        exit 1
    fi
        
else
    if [ "$1" == "update" ]; then  
         carthage update --platform iOS --use-ssh --no-build
    fi
    #otherwise, ignore the carthage update
    rome download --skip-local-cache --platform iOS --cache-prefix ${prefix} # download missing frameworks (or copy from local cache)
    rome list --missing --platform iOS  --cache-prefix ${prefix} | awk '{print $1}' | xargs carthage bootstrap --platform iOS --cache-builds --use-ssh # list what is missing and update/build if needed
    if [ $? -eq 0 ]; then
        rome list --missing --platform iOS  --cache-prefix ${prefix} | awk '{print $1}' | xargs rome upload --platform iOS  --cache-prefix ${prefix} # upload what is missing
    else
        echo "Carthage bootstrap failed.. Investigate and try running this script again when completed"
        say "error with rome"
        exit 1
    fi
    say dependencies downloaded

fi




