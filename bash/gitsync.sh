#!/bin/bash

repositories_dir="../repos/"

ORANGE='\033[0;33m'  # Orange
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
WHITE='\033[1;37m'   # White
TURQUOISE='\033[0;36m'  # Turquoise
NC='\033[0m'         # No Color

sync_repository() {
  local repository_name="$1"
  local repository_path="$repositories_dir/$repository_name"
  cd "$repository_path" || return
  if [ -d .git ]; then
    echo -e "${TURQUOISE}Syncing repository: $repository_name${NC}"
    git fetch > /dev/null 2>&1

    git checkout master > /dev/null 2>&1
    git pull origin master > /dev/null 2>&1

    # Loop over all local branches
    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
      if [ "$branch" != "master" ]; then
        git checkout $branch > /dev/null 2>&1

        # Suppress output
        git pull origin master > /dev/null 2>&1

        # Check for conflicts
        if [ $? -eq 0 ]; then
          echo -e "${ORANGE}Updated${NC} $branch"
        else
          echo -e "${RED}Conflict${NC} in $branch."
          read -p "Do you want to (1) resolve conflicts or (2) delete branch and discard changes?: " choice
          if [ "$choice" = "1" ]; then
            code "$PWD"
            read -p "Press Enter to continue..."
            git add .
            git commit
            echo -e "${GREEN}Resolved${NC} $branch"
          fi
          if [ "$choice" = "2" ]; then
            git reset --hard > /dev/null 2>&1
            git checkout master > /dev/null 2>&1
            git branch -D $branch
            continue
          fi
        fi
        git push origin $branch > /dev/null 2>&1
      fi
    done
  fi
}

if [ $# -eq 0 ]; then
  echo "Usage: $0 [-n <repo_name1> <repo_name2> ...] or $0 ."
  exit 1
fi
if [ "$1" == "." ]; then
  for dir in "$repositories_dir"/*; do
    echo $dir
    if [ -d "$dir" ]; then
      repository_name=$(basename "$dir")
      sync_repository "$repository_name"
    fi
  done
else
  while [ "$1" != "" ]; do
    case $1 in
      -n)
        shift
        while [ "$1" != "" ]; do
          sync_repository "$1"
          shift
        done
        ;;
      *)
        echo "Invalid option: $1"
        exit 1
        ;;
    esac
  done
fi
