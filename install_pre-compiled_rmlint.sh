#!/bin/bash

# Download the compiled program
wget https://abc.com/rmlint -O rmlint

# Check that the download was successful
if [ $? -ne 0 ]; then
    echo "Error downloading rmlint"
    exit 1
fi

# Set the permissions for the rmlint binary
chmod +x rmlint

# Move the rmlint binary to /usr/bin
sudo mv rmlint /usr/bin/

# Check that the move was successful
if [ $? -ne 0 ]; then
    echo "Error moving rmlint to /usr/bin"
    exit 1
fi

echo "rmlint was successfully downloaded and installed in /usr/bin"
