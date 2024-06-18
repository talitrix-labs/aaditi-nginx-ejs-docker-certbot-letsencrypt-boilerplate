#!/bin/bash
set -e

# If you are using Visual Studio on Windows make sure the File is Set to LF as End of Line Sequence 
# By default windows creates files with CRLF, this will casuse the docker-entrypoint.sh file not found error if left CRLF
#
# Function to initialize the application environment
initialize() {
    echo "Setting the SSL Certificate"
    nginx
    domains="sub.yourdomain.com"
    email="email-reg@yourdomain.com"

    # Don't change these values unless you know what you're doing
    rsa_key_size=4096
    certbot_path="/usr/bin/certbot"
    le_live="/etc/letsencrypt/live"

    # Check if certificates already exist
    if [ -d "$le_live/$domains" ]; then
      echo "SSL certificates already exist for $domains."
      exit 0
    fi

    # Obtain SSL certificate
    echo "Obtaining new SSL certificate..."
    $certbot_path --non-interactive --nginx --agree-tos --email $email -d $domains --rsa-key-size $rsa_key_size --redirect || exit 1

    # Reload Nginx to apply changes
    echo "Reloading Nginx..."
    nginx -s reload

    echo "SSL certificate setup complete for $domains."
}

# Function to start the application
start() {
    echo "Starting application..."
    # Command to start the application, e.g., starting a web server
    node /ejs-code/server.js &
    wait $!
}

# Main entry point
main() {
    # Initialize the environment
    initialize
    start
}

# Call the main function with all arguments passed to the script
main "$@"
