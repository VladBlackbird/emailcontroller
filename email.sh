#!/bin/bash

# Determine the script's directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load API keys from .env file
source $BASE_DIR/.env

# Define usage function
usage() {
  echo "This script is used to fetch emails and send emails. It accepts the following options and arguments:"
  echo ""
  echo "Usage: $0 [-fetch] [-h|--help] [to subject body from]"
  echo ""
  echo "Options:"
  echo "  -fetch: This option is used to fetch emails. If a new email is found, a notification will be displayed."
  echo "  -h, --help: This option is used to display this help message."
  echo ""
  echo "Arguments:"
  echo "  to: This argument is used to specify the recipient's email address."
  echo "  subject: This argument is used to specify the subject of the email."
  echo "  body: This argument is used to specify the body of the email."
  echo "  from: This argument is used to specify the sender's email address."
  echo ""
  echo "If no arguments are provided, the script will prompt for them."
  exit 1
}

# Parse command line options
while getopts ":fh" opt; do
  case ${opt} in
    f)
      # Fetch emails
      fetchmail -s -u "${USER}" -p IMAP --password "${PASSWORD}" "${SERVER}"
      # Check if a new email was fetched
      if [ $? -eq 0 ]; then
        echo "A new email has been fetched."
      fi
      exit 0
      ;;
    h)
      # Display usage information
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if the required arguments are provided
if [ $# -ne 4 ]; then
  read -p "To: " TO
  read -p "Subject: " SUBJECT
  read -p "Body: " BODY
  read -p "From: " FROM
else
  TO=$1
  SUBJECT=$2
  BODY=$3
  FROM=$4
fi

# Send email
echo "${BODY}" | mail -s "${SUBJECT}" -r "${FROM}" "${TO}"