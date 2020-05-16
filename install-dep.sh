#!/bin/bash

set -e

sudo apt install ruby-full build-essential zlib1g-dev -y

TMPFILE="/tmp/rcfile$$.tmp"

echo '' > "$TMPFILE"
echo '# Install Ruby Gems to ~/.gems' >> "$TMPFILE"
echo 'export GEM_HOME="$HOME/.gems"' >> "$TMPFILE"
echo 'export PATH="$HOME/.gems/bin:$PATH"' >> "$TMPFILE"

# First is for sh, bash and related shells
cat "$TMPFILE" >> ~/.profile

if [ -f ~/.bash_login ] ; then
  cat "$TMPFILE" >> ~/.bash_login
fi

if [ -f ~/.bash_profile ] ; then
  cat "$TMPFILE" >> ~/.bash_profile
fi

# Second is for zsh
cat "$TMPFILE" >> ~/.zprofile

# I source the file in tmp because it is shell-agnostic
# and the only part that counts is the latter one
source "$TMPFILE" || . "$TMPFILE"
rm "$TMPFILE"

export GEM_HOME="$HOME/.gems"

gem install bundler
bundle update
