FROM mcr.microsoft.com/vscode/devcontainers/base:0-buster

# [Optional] Uncomment this section to install additional packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends python3-setuptools python3-pip


RUN pip3 install wheel && pip3 install \
    mkdocs-material \
    mkdocs-git-revision-date-plugin \
    mkdocs-git-revision-date-localized-plugin
