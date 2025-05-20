#!/bin/bash

# Get the current year
YEAR=$(date +%Y)

# Get the latest tag for the current year
LATEST_TAG=$(git tag -l "${YEAR}.*" | sort -V | tail -n 1)

if [ -z "$LATEST_TAG" ]; then
  # If no tag exists for this year, start with 1
  NEW_VERSION="${YEAR}.1.0"
else
  # Extract the version number and increment it
  CURRENT_VERSION=$(echo $LATEST_TAG | cut -d'.' -f2)
  NEW_VERSION="${YEAR}.$((CURRENT_VERSION + 1)).0"
fi

# Create and push the new tag
git tag $NEW_VERSION
git push origin $NEW_VERSION

echo "Created and pushed tag: $NEW_VERSION" 
