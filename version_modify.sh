#!/bin/sh
plist_path=$1
branchName=$2
ver1=$3
ver2=$4

if [ "$ver2" = "" ];then
	ver2=` /usr/libexec/PlistBuddy -c "Print CFBundleVersion" $plist_path | /usr/bin/perl -pe 's/(\d+\.\d+\.)(\d+)/$1.($2+1)/eg' `
fi

if [ "$ver1" = "" ];then
	ver1=` /usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $plist_path | /usr/bin/perl -pe 's/(\d+\.\d+\.)(\d+)/$1.($2+1)/eg' `
fi


echo "modify version to $ver1 $ver2"
/usr/libexec/PListBuddy -c "Set :CFBundleShortVersionString $ver1" "$plist_path"
/usr/libexec/PListBuddy -c "Set :CFBundleVersion $ver2" "$plist_path"

#echo "push to git"
echo "branchName="$branchName
git pull origin $branchName
git commit $plist_path  -m "modify plist version $ver1" $plist_path
git push  origin HEAD:$branchName

echo "version modify success"
exit 0
