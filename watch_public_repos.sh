#!/bin/bash
# Script to watch for changes in a Github organization's list of public repositories
# Run in Cron:
# 0 9 * * * ~/watch_public_repos.sh

# Configure these
ORG_NAME="name-of-organization"
NOTIFY_EMAIL="email-to-notify@domain.whatever"

# We need to store the list of repositories
KNOWN_REPOS_FILE="/tmp/known-repos-${ORG_NAME}.list"

# Get the list of repositories from the Github API
REPOS=$(curl -s https://api.github.com/orgs/$ORG_NAME/repos | grep full_name | cut -d'"' -f4)

# Send a notification if changes have been made
if [[ "$(cat $KNOWN_REPOS_FILE)" != "$REPOS" ]]; then
    echo -e "Please review the list of public repositories under the $ORG_NAME Github account:\n\n$REPOS\n\n-- \nThis script is running on $(hostname), and will notify $NOTIFY_EMAIL of changes to the list of public repositories under the Github organization $ORG_NAME." | mail -s "Changes to public repositories" $NOTIFY_EMAIL
    echo "Changes detected, sent a message to $NOTIFY_EMAIL."
    echo $REPOS | tr ' ' '\n' > $KNOWN_REPOS_FILE
fi

