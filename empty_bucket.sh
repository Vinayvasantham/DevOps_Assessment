#!/bin/bash

BUCKET_NAME="agency-data-bucket"

# Step 1: Delete all objects
echo "Deleting all objects..."
aws s3 rm s3://$BUCKET_NAME --recursive

# Step 2: Delete all versions
echo "Deleting all versions..."
VERSIONS=$(aws s3api list-object-versions --bucket $BUCKET_NAME --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json)
MARKERS=$(aws s3api list-object-versions --bucket $BUCKET_NAME --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json)

if [ "$VERSIONS" != "[]" ]; then
  for row in $(echo "${VERSIONS}" | jq -r '.[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.Key')
    version=$(_jq '.VersionId')
    aws s3api delete-object --bucket $BUCKET_NAME --key "$key" --version-id "$version"
  done
else
  echo "No versions found."
fi

if [ "$MARKERS" != "[]" ]; then
  for row in $(echo "${MARKERS}" | jq -r '.[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r ${1}
    }
    key=$(_jq '.Key')
    version=$(_jq '.VersionId')
    if [ "$version" = "null" ]; then
      aws s3api delete-object --bucket $BUCKET_NAME --key "$key" --version-id null
    else
      aws s3api delete-object --bucket $BUCKET_NAME --key "$key" --version-id "$version"
    fi
  done
else
  echo "No delete markers found."
fi

# Step 3: Verify bucket is empty
echo "Verifying that the bucket is empty..."
REMAINING_OBJECTS=$(aws s3api list-object-versions --bucket $BUCKET_NAME --output json)
if [ -z "$REMAINING_OBJECTS" ]; then
  echo "Bucket is now empty."
else
  echo "Bucket is not empty. Remaining objects:"
  echo "$REMAINING_OBJECTS"
fi
