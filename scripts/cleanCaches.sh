#!/bin/bash
DIR=~/Library/Caches/org.carthage.CarthageKit
echo -n "Cleaning:"
du -hd 0 $DIR
rm -rf $DIR
