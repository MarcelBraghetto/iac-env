FROM ubuntu:bionic
LABEL description 'Infrastructure as Code - Environment (iac-env).'
ENV TF_PLUGIN_CACHE_DIR=/opt/iac-env/terraform-plugins
ENV CHEF_LICENSE=accept-silent
COPY resources/docker /tmp/resources
RUN /tmp/resources/provision.sh
