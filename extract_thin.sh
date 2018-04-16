#!/bin/bash
clear; printf '\033[3J'
BASE_IPA=app.ipa
FRAMEWORKS_EXTRACT=false
if [ -d "screenshots" ]; then
	rm -R screenshots
fi
echo -e "\033[1mExtract Thin Started\033[0m"
if [ "$1" = "help" ]
	then
    echo -e "\033[2mBasic Usage\033[0m"
    echo -e "\033[1mbash extract_thin.sh\033[0m"
    echo ""
    echo -e "\033[2mExtract with frameworks\033[0m"
    echo -e "\033[1mbash extract_thin.sh frameworks\033[0m"
    echo ""
    exit
elif [ "$1" = "frameworks" ]
	then
	FRAMEWORKS_EXTRACT=true
fi
if [ ! -f $BASE_IPA ]
then
  echo "There is no app.ipa in this directory, trying to grab automatically"
  IPA="$(find . -not -path '*/\.*' -not -path './orginal_app.ipa' -type f -name '*.ipa*' | awk -F / '{print $2}')"
  echo "Found: $IPA"
  cp "$IPA" "$BASE_IPA"
fi
if [ -d "tmp" ]
  then
  rm -r tmp
fi
echo "Creating temporary work dir"
mkdir tmp
echo "Unzipping ipa file"
unzip -o app.ipa -d tmp
BINARY_NAME=$(ls tmp/Payload/ | tail -1)
if [[ $BINARY_NAME != *".app"* ]]
  	then
  	echo "Can't get .app name - shouldn't happen!"
  	echo "File name: $BINARY_NAME"
fi
BINARY_NAME=$(echo $BINARY_NAME | awk -F . '{print $1}')
echo "Binary name: $BINARY_NAME"
if [ "$FRAMEWORKS_EXTRACT" = true ]
	then
  	echo "Extracting framework binaries"
  	if [ -d "tmp/Payload/$BINARY_NAME.app/Frameworks" ]
    	then
    	cd tmp/Payload/$BINARY_NAME.app/Frameworks
       	FRAMEWORK_COUNT=$(ls | wc -l | xargs)
    	echo "Frameworks count: $FRAMEWORK_COUNT"
    	if [[ "$FRAMEWORK_COUNT" != "0" ]]; then
    		cd ..;cd ..;cd ..;cd ..
    		if [ ! -d "tmp_frameworks" ]
      			then
       			mkdir tmp_frameworks
    		fi
    		cd tmp/Payload/$BINARY_NAME.app/Frameworks
    		for filename in *; do
      			binary=`echo "$filename" | cut -d'.' -f1`
      			echo $binary
      			cp $filename/$binary ../../../../tmp_frameworks/$binary
      			echo "Extracting thin from fat"
      			lipo -thin armv7 ../../../../tmp_frameworks/$binary -o "../../../../tmp_frameworks/$binary"_armv7
      			lipo -thin arm64 ../../../../tmp_frameworks/$binary -o "../../../../tmp_frameworks/$binary"_arm64
    		done
    	else
    		echo "No frameworks detected"
    	fi
    	cd ..;cd ..;cd ..;cd ..
  	else
    	echo "No frameworks detected"
  	fi
fi
lipo -thin armv7 tmp/Payload/$BINARY_NAME.app/$BINARY_NAME -o "$BINARY_NAME"_armv7
lipo -thin arm64 tmp/Payload/$BINARY_NAME.app/$BINARY_NAME -o "$BINARY_NAME"_arm64
echo "Extracted thin from fat"
echo "Cleaning workspace..."
rm -R tmp
echo "Done. Now you can work on thin binaries"
echo -e "\033[2mList of files\033[0m"
ls