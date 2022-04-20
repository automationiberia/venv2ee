#!/usr/bin/env bash

# Create the source testing virtual environment
virtualenv awscliv2

# Install the awscli V2
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip -q awscli-exe-linux-x86_64.zip
aws/install -i ${PWD}/awscliv2 -b ${PWD}/awscliv2/bin
source awscliv2/bin/activate
type aws
aws --version

