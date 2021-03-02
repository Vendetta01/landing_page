#!/bin/bash

# Exit immediatley if a command exits with a non-zero status.
set -e

# Variables
source /usr/bin/environment.sh


initialize() {
    touch "$FIRST_START_FILE_URL"
    logit "INFO" "Initialization done"
}


# main
if [[ ! -e "$FIRST_START_FILE_URL" ]]; then
	# Do stuff
	initialize
fi


# Start services
logit "INFO" "Starting app..."
exec gunicorn --bind 0.0.0.0:8000 landing_page:app
