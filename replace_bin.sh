#!/bin/bash
BASE_IPA=app.ipa
echo -e "\033[1mReplace Bin Started\033[0m"
if [ $# -eq 0 ]
  then
    echo -e "\033[4mSpecify binary/app name, case sensitivite.\033[0m"
    echo ""
    echo -e "\033[2mBasic Usage\033[0m"
    echo -e "\033[1mbash extract_thin.sh AppName fat trim\033[0m"
    echo ""
    echo -e "\033[2mAdvanced Usage - patch thin binaries\033[0m"
    echo -e "\033[1mbash extract_thin.sh AppName\033[0m"
    echo ""
    echo -e "\033[2mAdvanced Usage - keep plugins\033[0m"
    echo -e "\033[1mbash extract_thin.sh AppName fat\033[0m"
    echo ""
    exit
fi
if [ "$2" = "fat" ]
	then
	echo "Creating fat binary"
	lipo -create "$1"_armv7 "$1"_arm64 -output $1
fi
echo "app.ipa will be patched with $1 binary"
echo "Creating temporary work dir"
mkdir tmp
echo "Backing up ipa"
cp $BASE_IPA orginal_$BASE_IPA
echo "Unzipping ipa file"
unzip -o $BASE_IPA -d tmp
rm tmp/Payload/$1.app/$1
cp $1 tmp/Payload/$1.app/$1
echo "Checking for frameworks"
if [ -d "tmp_frameworks" ]
	then
	echo "Found frameworks to patch"
	cd tmp_frameworks
 	for filename in *; do
 		if [[ $filename == *"arm64"* ]]
 			then
 			base=`echo "$filename" | cut -d'_' -f1`
 			if [ -f $base ]
				then
				echo "Remove old fat framework"
				rm $base
			fi
 			echo $base
 			lipo -create "$base"_armv7 "$base"_arm64 -output $base
 			rm "../tmp/Payload/$1.app/Frameworks/$base".framework/$base
 			cp $base "../tmp/Payload/$1.app/Frameworks/$base".framework/$base
		fi
    done
    cd ..
else
	echo "No frameworks to pack"
fi
echo "Patching done. Binaries replaced"
rm $BASE_IPA
if [ "$3" = "trim" ]
	then
	echo "Trimming PlugIns"
	if [ -d "tmp/Payload/$1.app/PlugIns" ]
		then
 		rm -R tmp/Payload/$1.app/PlugIns
		echo "PlugIns Removed"	
	else
		echo "PlugIns aleady removed or never existed"
	fi
fi
cd tmp
echo "Packing ipa file"
zip -r $BASE_IPA Payload
cd ..
mv tmp/$BASE_IPA $BASE_IPA
echo "Cleaning workspace..."
rm -R tmp
echo "Done"
