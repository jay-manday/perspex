#!/usr/bin/env bash

set -e

function verify_hashes() {
  branch=$(find -s "${path}" -type f -exec md5sum {} \; | md5sum)

  git checkout main "${path}"
  
  main=$(find -s "${path}" -type f -exec md5sum {} \; | md5sum)

  if [[ "${branch}" == "${main}" ]]; then
    echo "Error: Generated ${tool} code is out of phase, please commit generated code."
    exit 1;
  fi
}

function lint_codegen() {
  if [[ "$(git diff --quiet HEAD main -- services/migration/src/perspex || echo $?)" == 1 ]]; then
    path="services/backend/pkg/models"
    tool="sqlboiler"
    verify_hashes
  elif [[ "$(git diff --quiet HEAD main -- schemas/graphql || echo $?)" == 1 ]]; then
    path="services/backend/pkg/graphql"
    tool="gqlgen"
    verify_hashes
  else
    echo "Generated code is up to date"
  fi

  exit 0;
}

function display_help() {
    echo "This script will run a database migration validation service"
    echo ""
    echo "Parameters:"
    echo "    -l | --lint             Lint to verify codegen changes have been committed."
    echo "    -h                      Display this help message."
    echo "Usage:"
    echo "   bin/codegen-linter.sh -l"
    echo "   bin/codegen-linter.sh -h"
}

main() {
  while [[ "$#" -gt 0 ]]; do 
    case $1 in
      -l | --lint )
        lint_codegen
        shift
        ;;
      -h | --help )
        display_help
        shift
        ;;
      \? )
        display_help
        exit 1
        ;;
    esac;
    shift;
  done
}

main "${@}"
