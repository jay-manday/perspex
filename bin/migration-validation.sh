#!/usr/bin/env bash

set -e

BASE_BRANCH="unset"
MIGRATION_PATH="services/migration/db"

function validate_migration() {
    # Sets the diff filter to look for added, deleted, and modified files
    # See the docs for more info on other options https://git-scm.com/docs/git-diff
    OLDEST_NEW_MIGRATION_FILE=$(git diff --name-only origin/$BASE_BRANCH --diff-filter=adm | grep -m1 ${MIGRATION_PATH} | tr -s ' ')

    if [[ -z $OLDEST_NEW_MIGRATION_FILE ]]; then
        echo "no new migrations"
        exit 0
    fi

    NEWEST_EXISTING_MIGRATION_FILE=$(git ls-tree -r origin/$BASE_BRANCH --name-only | grep ${MIGRATION_PATH} | tail -1)

    if [[ -z $NEWEST_EXISTING_MIGRATION_FILE ]]; then
        echo "no existing migrations"
        exit 0
    fi

    echo "oldest new migration $OLDEST_NEW_MIGRATION_FILE"
    echo "newest existing migration $NEWEST_EXISTING_MIGRATION_FILE"

    EXISTING_TIMESTAMP="$(basename $NEWEST_EXISTING_MIGRATION_FILE | cut -d '_' -f 1)"

    NEW_TIMESTAMP="$(basename $OLDEST_NEW_MIGRATION_FILE | cut -d '_' -f 1)"

    if [[ $EXISTING_TIMESTAMP -ge $NEW_TIMESTAMP ]]; then
        echo "existing migration timestamp is greater than or equal to incoming migration timestamp. please update your migrations timestamp."
        exit 1
    fi

    echo "new migration(s) are safe to merge"
    exit 0
}

function main() {
    validate_migration
}

while getopts ":b:" option; do
   case $option in
      b) # Environment
         BASE_BRANCH=${OPTARG}
         ;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $((OPTIND -1))

main
