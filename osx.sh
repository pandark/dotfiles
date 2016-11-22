#!/usr/bin/env zsh

######################
#        OS X        #
######################
#
#### dock ###
## remove all application
#defaults delete com.apple.dock persistent-apps
#defaults delete com.apple.dock persistent-others
#
## add application
#defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/System Preferences.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm 2.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#
## change dock size
#defaults write com.apple.dock tilesize -int 40
#
## set the dock on the right of the screen
#defaults write com.apple.dock orientation -string "bottom"
#
## do not rearrange space based on recent use
#defaults write com.apple.dock mru-spaces -bool false
#
## restart dock to apply changes
#killall Dock
#
#### dock end ###
#
#### finder ###
#
## set preferred view style
#defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
#
## New window points to home
#defaults write com.apple.finder NewWindowTarget -string "PfHm"
#
## Avoid creating .DS_Store files on network volumes
#defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
#
## show path bar
#defaults write com.apple.finder ShowPathbar -int 1
#
## show Library folder
#chflags nohidden ~/Library/
#
#### finder end ###
#
#### mouse ###
