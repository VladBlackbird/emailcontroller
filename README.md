# Email Automation Script

This script is designed to fetch emails from an SMTP server and send emails to a specified recipient.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have `mail` and `fetchmail` installed on your system to run this script. If not installed, you can install them using the following commands:

For mail:
```
sudo apt-get install mailutils
```

For fetchmail:
```
sudo apt-get install fetchmail
```

### Installing

Clone the repository to your local machine:

```
git clone https://github.com/VladBlackbird/emailcontroller.git
```

Navigate to the project directory:

```
cd emailcontroller
```
Make the script executable:

```
chmod +x email.sh
```

### Configuration

Before running this script, you need to setup your SMTP server, user, and password. These should be stored in a `.env` file in the same directory as the script. The `.env` file should have the following format:

```
SERVER=your_smtp_server
USER=your_username
PASSWORD=your_password
```

Replace `your_smtp_server`, `your_username`, and `your_password` with your actual SMTP server, username, and password respectively.


### Usage

The script can be run with the following command:

```
./email.sh [-fetch] [-h|--help] [to subject body from]
```

The options are as follows:

- `-fetch`: Fetch email and notify if a new email is found
- `-h, --help`: Display the help message
- `to`: Recipient email address
- `subject`: Email subject
- `body`: Email body
- `from`: Sender email address

If the `to`, `subject`, `body`, and `from` arguments are not provided, the script will prompt you to enter them.

## Built With

- Bash: The GNU Project's shell
- Mail: A command-line email client for Unix-like operating systems
- Fetchmail: A full-featured, robust, well-documented remote-mail retrieval and forwarding utility

## Authors

* **Vlad BlackBird** - *Initial work* - [ScoobiDoge](https://github.com/VladBlackbird)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgements

This script uses several tools and libraries. We would like to acknowledge and thank the creators of these tools:

- `fetchmail`: Eric Raymond, first released in 1996
- `mail`: Kurt Shoens, first released in 1978
- `bash`: Brian Fox and Chet Ramey, first released in 1989

Please note that these dates are for the first release of the tools and they may have been updated or maintained by different individuals or groups since then.
