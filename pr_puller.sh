#!/bin/bash

# ./pr_puller.sh
# Purpose: rudimentary manual CI/CD for Atmosphere stack on Atmosphere Docker
# Usage: ./pr_puller.sh <repo> <pr_num>

repo=$1
pr_num=$2

# check number of args
if [ "$#" -ne 2 ]; then
    echo "Usage: ./pr_puller.sh <repo> <pr_num>"
    exit 1
fi

# check valid repo
if ! [[ "$repo" =~ ^(atmosphere|troposphere|atmosphere-ansible)$ ]]; then
  echo "Repository $1 is not compatible with this script. Please use 'atmosphere', 'troposphere', or 'atmosphere-ansible'"
  exit 2
fi

# go to repo directory if it exists
echo "Changing directory to ../$repo"
if ! cd ../$repo; then
  echo "Unable to change directory to ../$repo"
  exit 3
fi

# fetch and checkout PR if it exists
echo "Fetching and checking out PR #$pr_num to branch pull_$pr_num"
if git fetch origin pull/$pr_num/head:pull_$pr_num; then
  git checkout pull_$pr_num
else
  echo "Pull request #$pr_num does not exist for $repo"
  exit 4
fi

# go to atmosphere-docker and restart
echo "Changing directory to atmosphere-docker and restarting"
cd ../atmosphere-docker
docker-compose down
docker volume prune -f
docker-compose up -d
