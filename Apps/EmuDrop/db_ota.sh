#!/bin/bash

# Repository name in the format "owner/repo"
REPO="ahmadteeb/EmuDrop"

# Local version file
VERSION_FILE="version-db.txt"

# GitHub API URL for tags
API_URL="https://api.github.com/repos/$REPO/tags"

# Expected db file name in the release
DB_FILE_NAME="catalog.db"

DOWNLOAD_DB="false"

# Function to get the local version
get_local_version() {
    if [[ -f "$VERSION_FILE" ]]; then
        cat "$VERSION_FILE" 
    else
        echo "v0.0.0" # Default version if the file does not exist
    fi
}

# Function to get the latest version from GitHub
get_latest_version() {
    local latest_version=$(curl -s -k "$API_URL" | grep -o '"name": "[^"]*' | grep '\-db' | head -n 1 | cut -d '"' -f 4)
    # If the version does not start with 'v', add the 'v'
    if [[ ! $latest_version =~ ^v ]]; then
        latest_version="v$latest_version"
    fi
    echo "${latest_version%-db}"
}

# Function to download the latest release
download_latest_release() {
    local version="$1"
    local url="https://github.com/$REPO/releases/download/$version-db/catalog-$version.db"
    echo "Cleaning local db file if exits"
    if [ -f "assets/$DB_FILE_NAME" ]; then
        rm "assets/$DB_FILE_NAME"
    fi
    echo "Downloading the latest release from: $url"
    if ! curl -L -k -o "assets/$DB_FILE_NAME" "$url"; then
        echo "Error downloading the release. The file was not deleted."
        exit 1
    fi
}

update_version_file() {
    local version="$1"
    echo "$version" > "$VERSION_FILE"
}

# Main flow
echo "Checking for update for database"

local_version=$(get_local_version)
latest_version=$(get_latest_version)

echo "Local version: $local_version"
echo "Latest version: $latest_version"

if ! [[ -f "assets/$DB_FILE_NAME" ]]; then
    echo "Your catalog database file is missing"
    DOWNLOAD_DB="true"
else
    if [[ "$local_version" == "$latest_version" ]]; then
        echo "Your catalog database is already on the latest version: $latest_version"
        DOWNLOAD_DB="false"
    else
        echo "Your catalog database version $local_version need to be updated to: $latest_version"
        DOWNLOAD_DB="true"
    fi
fi

if [[ "$DOWNLOAD_DB" == "true" ]]; then
   echo "Downloading latest catalog database: $latest_version"
   echo "Please wait, this may take a few moments..."
   download_latest_release "$latest_version"
   update_version_file "$latest_version"
   echo "Database update complete."
fi