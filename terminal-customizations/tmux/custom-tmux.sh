#!/bin/bash

brew install tmux
brew install reattach-to-user-namespace
yes | cp rf tmux.conf ~/.tmux.conf
