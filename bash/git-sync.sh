#!/bin/bash

remote_name="origin"  # Your remote's name (e.g., "origin")
remote_branch="master"  # The branch you want to sync with (e.g., "master")

# ANSI color codes
ORANGE='\033[0;33m'  # Orange
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
WHITE='\033[1;37m'   # White
TURQUOISE='\033[0;36m'  # Turquoise
NC='\033[0m'         # No Color

# Fetch the latest changes from the remote repository
git fetch $remote_name > /dev/null 2>&1

git checkout master > /dev/null 2>&1
git pull $remote_name $remote_branch > /dev/null 2>&1

# Iterate through all local branches
for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
  if [ "$branch" != "$remote_branch" ]; then
   git checkout $branch > /dev/null 2>&1

    # Pull from the remote master with suppressed output
    git pull $remote_name $remote_branch > /dev/null 2>&1

    # Check for conflicts
    if [ $? -eq 0 ]; then
      echo -e "${ORANGE}Updated${NC} $branch"
    else
      echo -e "${RED}Conflict${NC} in $branch."
      read -p "Do you want to (1) open VSCode to resolve conflicts or (2) delete the branch and discard the changes? (1/2): " choice
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

    # Push the changes to the remote branch with suppressed output
    git push $remote_name $branch > /dev/null 2>&1
  fi
done

