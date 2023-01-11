#!/bin/bash

# run this script
# ./somescript.sh -u akshitadixit -y 2019 -o -f -a

username="akshitadixit"
year="2022"
org=""
followers=""
all=""

while getopts ":y:o:fau:" opt; do
  case $opt in
    y) year="$OPTARG" ;;
    o) org="$OPTARG" ;;
    f) followers="no" ;;
    a) all="no" ;;
    u) username="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

url="https://api.github.com/users/$username"

echo "---------------------------------------------------"
echo "------------ GitHub Stats for $username ------------"

if [ -n "$year" ]
then
    url+="?since=$year-01-01T00:00:00Z"
    echo "------------ Since Year: $year ------------"
fi

user_data=$(curl -s $url)

if [ -n "$followers" ]
then
    followers=$(echo $user_data | jq '.followers')
    echo "------------ Followers: ------------"
    echo $followers
    echo
    echo "------------ Following: ------------"
    following=$(echo $user_data | jq '.following')
    echo $following
    echo
fi

if [ -n "$all" ]
then
    stats=$user_data
    echo "------------ All Data: ------------"
    echo "------------ Followers: ------------"
    echo $followers
    echo "------------ Following: ------------"
    echo $following
else
    stats=$(echo $user_data | jq '.login, .bio, .avatar_url, .public_repos, .followers, .following')
fi

echo "Saving to file.............."
echo $stats
echo $stats | jq > script-output.txt

