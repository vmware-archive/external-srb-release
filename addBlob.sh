#!/bin/bash

function usage() {
  echo "Error!! Needs 2 arguments: <Path to Blob file> <Directory or folder under ./blobs to save it>"
  echo ""
  echo "Example: ./addBlob.sh my-service-broker.jar srb-broker "
  echo "This would add the 'my-service-broker.jar' as blob under 'blobs/srb-broker' "
  echo ""
}

if [ "$#" -lt 2 ]; then
  usage
  exit -1
fi

givenBlobFile=$1

# The path to the file can have other directories
# Trim the directories
blobFile=`echo $givenBlobFile | awk  -F '/' '{print $NF } '`
blobPath=$2

echo "Removing older versions of the $blobFile previously added"
./removeBlob.sh $blobFile

bosh -n add blob $givenBlobFile $blobPath
bosh -n upload blobs

printf "Is this blob the actual app binary? Respond with y or n:"
read response

if [ "$blobPath" != "cf_cli" ]; then
  PACKAGE_SPEC_FILE=`echo packages/*_broker/spec`
  blobExists=`grep "$blobPath/$blobFile" $PACKAGE_SPEC_FILE | awk '{print $NF}' `
  if [ "$blobExists" == "" ]; then
    echo "- ${blobPath}/${blobFile}" >> $PACKAGE_SPEC_FILE
  fi
fi


find jobs/deploy-service-broker -name "*.bak" | xargs rm 
find packages/*_broker -name "*.bak" | xargs rm 

echo ""
