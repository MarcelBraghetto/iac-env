#!/usr/bin/env sh

set -e

# Utility script to automate the internal provisioning of the iac-env Docker image.

echo '----------------------------------------------------'
echo 'Operating system details:'
cat /etc/*release

echo '----------------------------------------------------'
echo 'Copying iac-env helper files ...'
# Help content
cp -r /tmp/resources/opt/iac-env /opt
# This Provides a nice welcome message.
cp /tmp/resources/bash.bashrc /etc/bash.bashrc
# This provides an 'iac-env-help' command.
cp /tmp/resources/iac-env-help /usr/local/bin/iac-env-help
chmod a+rx /usr/local/bin/iac-env-help

echo '----------------------------------------------------'
echo 'Installing APT packages ...'
apt-get update
apt-get --yes --no-install-recommends install \
        less=487-0.1 \
        groff=1.22.3-10 \
        curl=7.58.0-2ubuntu3.8 \
        unzip=6.0-21ubuntu1 \
        graphviz=2.40.1-2 \
        vim-tiny=2:8.0.1453-1ubuntu1.3 \
        ruby=1:2.5.1 \
        ruby-dev=1:2.5.1 \
        build-essential=12.4ubuntu1

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
echo '----------------------------------------------------'
echo 'Installing Amazon AWS CLI ...'
curl -o /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install
rm -rf /usr/local/aws-cli/v2/*/dist/aws_completer
rm -rf /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index
rm -rf /usr/local/aws-cli/v2/*/dist/awscli/examples

# https://www.terraform.io/docs/commands/index.html
echo '----------------------------------------------------'
echo 'Installing Terraform ...'
curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
unzip -q /tmp/terraform.zip -d /usr/local/bin

# https://www.terraform.io/docs/commands/cli-config.html
# Used by TF_PLUGIN_CACHE_DIR conifigured via the Dockerfile
echo '----------------------------------------------------'
echo 'Creating Terraform plugin cache directory ...'
mkdir -p /opt/iac-env/terraform-plugins/linux_amd64

echo '----------------------------------------------------'
echo 'Installing Terraform AWS Plugin ...'
curl -o /tmp/terraform-provider-aws.zip https://releases.hashicorp.com/terraform-provider-aws/2.57.0/terraform-provider-aws_2.57.0_linux_amd64.zip
unzip -q /tmp/terraform-provider-aws.zip -d /opt/iac-env/terraform-plugins/linux_amd64

echo '----------------------------------------------------'
echo 'Installing Terraform Null Resource Plugin ...'
curl -o /tmp/terraform-provider-null.zip https://releases.hashicorp.com/terraform-provider-null/2.1.2/terraform-provider-null_2.1.2_linux_amd64.zip
unzip -q /tmp/terraform-provider-null.zip -d /opt/iac-env/terraform-plugins/linux_amd64

# https://github.com/terraform-linters/tflint
echo '----------------------------------------------------'
echo 'Installing TFLint ...'
curl -L -o /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v0.15.4/tflint_linux_amd64.zip
unzip -q /tmp/tflint.zip -d /usr/local/bin

# https://kitchen.ci/docs/getting-started/introduction/
# https://github.com/newcontext-oss/kitchen-terraform
# https://newcontext-oss.github.io/kitchen-terraform/getting_started.html
echo 'Installing Kitchen - Terraform ...'
gem install rake --version 12.3.1 --no-ri --no-rdoc
gem install kitchen-terraform --version 5.3.0 --no-ri --no-rdoc

echo '----------------------------------------------------'
echo 'Removing redundant build tools ...'
apt-get remove --yes --purge ruby-dev build-essential
apt-get autoremove --yes
apt-get clean

echo '----------------------------------------------------'
echo 'Marking files in /opt as accessible to all users ...'
chmod -R +rx /opt

echo '----------------------------------------------------'
echo 'Running Terraform Kitchen test suite ...'
cd /tmp/resources/kitchen-setup
kitchen verify
kitchen destroy

echo '----------------------------------------------------'
echo 'Removing provisioning resources ...'
rm -r /tmp/*

echo '----------------------------------------------------'
echo 'Done, iac-env:latest Docker image is ready to use!'
echo '----------------------------------------------------'
