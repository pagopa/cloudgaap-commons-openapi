#!/bin/bash

VERSION=""

# Get parameters
while getopts ":v:d" flag
do
  case "${flag}" in
    v) VERSION=${OPTARG};;
    d) dry=true
  esac
done

if [ "$VERSION" != 'major' ] && [ "$VERSION" != 'minor' ] && [ "$VERSION" != 'patch' ]
then
  echo "No version type (https://semver.org/) or incorrect type specified, try: -v [major, minor, patch]"
  exit 1
fi

CURRENT_VERSION=$(node -p -e "require('./package.json').version")

# Replace . with space so can split into an array
CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })

# Get number parts
VNUM1=${CURRENT_VERSION_PARTS[0]}
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${CURRENT_VERSION_PARTS[2]}

if [[ $VERSION == 'major' ]]
then
  VNUM1=$((VNUM1+1))
elif [[ $VERSION == 'minor' ]]
then
  VNUM2=$((VNUM2+1))
elif [[ $VERSION == 'patch' ]]
then
  VNUM3=$((VNUM3+1))
fi

# Create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo "Performing $VERSION update from $CURRENT_VERSION to $NEW_TAG"

if [ ! -z $dry ]
then
  exit 0
fi

# Update package.json with the new version
echo "`jq --arg v "$NEW_TAG" '.version=$v' package.json`" > package.json

# Stage the new package.json
git add package.json

# Git commit
git commit -m "Release v$NEW_TAG"

# Create tag
git tag -a "v$NEW_TAG" -m "Release v$NEW_TAG"

exit 0