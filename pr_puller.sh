#!/bin/bash

# ./pr_puller.sh
# Purpose: rudimentary manual CI/CD for Atmosphere stack on Atmosphere Docker
# Usage: ./pr_puller.sh <repo> <pr_num> [<remote>]

repo=$1
pr_num=$2
remote=$3

branch="pull_$pr_num"

# check number of args
if [ "$#" -lt 2 ]; then
    echo "Usage: ./pr_puller.sh <repo> <pr_num> [<remote>]"
    exit 1
fi

# default remote if not given
if [ -z $remote ]; then
  echo "Using default remote 'origin'"
  remote="origin"
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

# checkout master to avoid error if pull already checked out
git checkout master &> /dev/null

# fetch and checkout PR if it exists
echo "Fetching and checking out PR #$pr_num to branch $branch"
if ! git fetch $remote pull/$pr_num/head:$branch; then
  echo "Pull request #$pr_num does not exist for $repo"
  exit 4
fi
git checkout $branch

exit 10

# go to atmosphere-docker and restart
echo "Changing directory to atmosphere-docker and restarting"
cd ../atmosphere-docker
docker-compose down
docker volume prune -f
docker-compose up -d
