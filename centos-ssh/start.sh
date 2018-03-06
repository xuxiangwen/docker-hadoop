#!/bin/bash

__create_user() {
# Create a user to SSH into as.
useradd grid
SSH_USERPASS=grid
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin grid)
echo ssh user password: $SSH_USERPASS
}

# Call all functions
__create_user
