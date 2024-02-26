#!/bin/bash

# Determine the script's directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if .env file exists
if [ ! -f "$BASE_DIR/.env" ]; then
    printf "Error: .env file not found.\n"
    exit 1
fi

# Load API keys from .env file
source $BASE_DIR/.env

# Check if the required environment variables are set
if [ -z "$SERVER" ] || [ -z "$USER" ] || [ -z "$PASSWORD" ]; then
    printf "Error: Required environment variables are not set.\n"
    exit 1
fi

# Create a temporary .fetchmailrc file
FETCHMAILRC=$(mktemp)
printf "poll $SERVER protocol IMAP user $USER password $PASSWORD" > $FETCHMAILRC

# Set the permissions of the .fetchmailrc file to 600
chmod 600 $FETCHMAILRC

# Ensure that the .fetchmailrc file is deleted when the script exits
trap 'rm -f $FETCHMAILRC' EXIT

# Check if mailx and fetchmail commands are installed
if ! command -v mailx &> /dev/null
then
    printf "The 'mailx' command could not be found. Please install it by running 'sudo apt-get install mailutils'\n"
    exit
fi

if ! command -v fetchmail &> /dev/null
then
    printf "The 'fetchmail' command could not be found. Please install it by running 'sudo apt-get install fetchmail'\n"
    exit
fi

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
  echo ""
  echo "To read your emails, you can use the 'mail' command. For example, 'mail -N' will show new emails, 'mail -r' will read all emails."
  echo "You can also use 'mail -d' to delete emails. For example, 'mail -d 1' will delete the first email."
  echo "To configure your mail settings, you can edit the '.fetchmailrc' file in your home directory."
  echo "For example, you can specify the mail server, user, and password like this:"
  echo "poll mail.example.com protocol IMAP user 'yourusername' password 'yourpassword'"
  exit 1
}

# Function to validate email
validate_email() {
  if [[ $1 =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]
  then
    return 0
  else
    echo "Invalid email format. Please input a correct format of email."
    return 1
  fi
}

# Function to fetch and read emails
fetch_and_read_emails() {
  # Fetch emails
  fetchmail -f $BASE_DIR/.fetchmailrc -s
  # Check if a new email was fetched
  if [ $? -eq 0 ]; then
    echo "A new email has been fetched."
  fi
  # Get the username of the user that launched the script
  local username=$(whoami)
  # Read the last email
  echo "The last email received is:"
  tail -n 1 /var/mail/$username
  # Ask the user if they want to search for an email with a particular keyword
  read -p "Do you want to search for an email with a particular keyword? (yes/no): " answer
  if [[ $answer == "yes" ]]; then
    read -p "Enter the keyword: " keyword
    grep -i $keyword /var/mail/$username
  fi
}

# Parse command line options
while getopts ":fh" opt; do
  case ${opt} in
    f)
      # Fetch and read emails
      fetch_and_read_emails
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
  while ! validate_email $TO
  do
    read -p "To: " TO
  done
  read -p "Subject: " SUBJECT
  read -p "Body: " BODY
  read -p "From: " FROM
  while ! validate_email $FROM
  do
    read -p "From: " FROM
  done
else
  TO=$1
  SUBJECT=$2
  BODY=$3
  FROM=$4
fi

# Send email
echo "${BODY}" | mail -s "${SUBJECT}" -r "${FROM}" "${TO}"

# Ensure that the temporary .fetchmailrc file is deleted when the script exits
trap 'rm -f $FETCHMAILRC' EXIT
