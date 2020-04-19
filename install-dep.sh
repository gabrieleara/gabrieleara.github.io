#!/bin/sh

set -e

sudo apt install ruby-full build-essential zlib1g-dev -y

echo '' > /tmp/rcfile.tmp
echo '# Install Ruby Gems to ~/.gems' >> /tmp/rcfile.tmp
echo 'export GEM_HOME="$HOME/.gems"' >> /tmp/rcfile.tmp
echo 'export PATH="$HOME/.gems/bin:$PATH"' >> /tmp/rcfile.tmp

# First is for sh, bash and related shells
cat /tmp/rcfile.tmp >> ~/.profile

if [ -f ~/.bash_login ] ; then
  cat /tmp/rcfile.tmp >> ~/.bash_login
fi

if [ -f ~/.bash_profile ] ; then
  cat /tmp/rcfile.tmp >> ~/.bash_profile
fi

# Second is for zsh
cat /tmp/rcfile.tmp >> ~/.zprofile

# I source the file in tmp because it is shell-agnostic
# and the only part that counts is the latter one
source /tmp/rcfile.tmp || . /tmp/rcfile.tmp
rm /tmp/rcfile.tmp

export GEM_HOME="$HOME/.gems"

gem install bundler
bundle update
