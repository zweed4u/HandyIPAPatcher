#!/bin/bash
BASE_IPA=app.ipa
echo -e "\033[1mExtract Thin Started\033[0m"
if [ $# -eq 0 ]
  then
    echo -e "\033[4mSpecify binary/app name, case sensitivite.\033[0m"
    echo ""
    echo -e "\033[2mBasic Usage\033[0m"
    echo -e "\033[1mbash extract_thin.sh AppName\033[0m"
    echo ""
    echo -e "\033[2mExtract with frameworks\033[0m"
    echo -e "\033[1mbash extract_thin.sh AppName frameworks\033[0m"
    echo ""
    exit
fi
if [ ! -f $BASE_IPA ]
then
  echo "There is no app.ipa in this directory, trying to grab automatically"
  IPA="$(ls *.ipa | head -1)"
  cp $IPA $BASE_IPA
fi
if [ -d "tmp" ]
  then
  rm -r tmp
fi
echo "Creating temporary work dir"
mkdir tmp
echo "Unzipping ipa file"
unzip -o app.ipa -d tmp
if [ "$2" = "frameworks" ]
  then
  echo "Extracting framework binaries"
  if [ -d "tmp/Payload/$1.app/Frameworks" ]
    then
    if [ ! -d "tmp_frameworks" ]
      then
        mkdir tmp_frameworks
    fi
    cd tmp/Payload/$1.app/Frameworks
    for filename in *; do
      binary=`echo "$filename" | cut -d'.' -f1`
      echo $binary
      cp $filename/$binary ../../../../tmp_frameworks/$binary
      echo "Extracting thin from fat"
      lipo -thin armv7 ../../../../tmp_frameworks/$binary -o "../../../../tmp_frameworks/$binary"_armv7
      lipo -thin arm64 ../../../../tmp_frameworks/$binary -o "../../../../tmp_frameworks/$binary"_arm64
    done
    cd ..;cd ..;cd ..;cd ..
  else
    echo "No frameworks detected"
  fi
fi
lipo -thin armv7 tmp/Payload/$1.app/$1 -o $1_armv7
lipo -thin arm64 tmp/Payload/$1.app/$1 -o $1_arm64
echo "Extracted thin from fat"
echo "Cleaning workspace..."
rm -R tmp
echo "Done. Now you can work on thin binaries"