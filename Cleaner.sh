#!/bin/bash

should_log=0
if [[ "$1" == "-p" || "$1" == "--print" ]]; then
	should_log=1
fi

function clean_glob {
	# don't do anything if argument count is zero (unmatched glob).
	if [ -z "$1" ]; then
		return 0
	fi

	if [ $should_log -eq 1 ]; then
		for arg in "$@"; do
			du -sh "$arg" 2>/dev/null
		done
	fi

	/bin/rm -rf "$@" &>/dev/null

	return 0
}

function clean {
	# to avoid printing empty lines
	# or unnecessarily calling /bin/rm
	# we resolve unmatched globs as empty strings.
	shopt -s nullglob

	echo -ne "\033[38;5;208m"

	#42 Caches
	clean_glob "$HOME"/.var/*.42*
	clean_glob "$HOME"/*.42*
	clean_glob "$HOME"/.zcompdump*
	clean_glob "$HOME"/.cocoapods.42_cache_bak*

	#Trash
	clean_glob "$HOME"/.var/app/com.google.Chrome/cache/google-chrome/Default/Cache/Cache_Data/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/config/Slack/Service Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/com.brave.Browser/cache/*
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/cache/*
	clean_glob "$HOME"/.local/share/Trash/files/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/cache/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/Cache/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/CachedData/*
	clean_glob "$HOME"/.var/app/com.visualstudio.code/config/Code/Cache/Cache_Data/*
	clean_glob "$HOME"/.config/Code/CachedData/*
	clean_glob "$HOME"/.config/Code/CachedProfileData/*
	clean_glob "$HOME"/.config/Code/CachedExtensionVSIXs/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/cache/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/config/Slack/Cache/Cache_Data/*
	clean_glob "$HOME"/.var/app/com.sublimetext.three/cache/*
	clean_glob "$HOME"/snap/firefox/common/.cache/*
	clean_glob "$HOME"/.var/app/com.slack.Slack/config/Slack/Service\ Worker/CacheStorage/*
	clean_glob "$HOME"/.var/app/org.mozilla.firefox/cache/mozilla/firefox/qu9gx1im.default-release/cache2/*
	#General Caches files
	#giving access rights on Homebrew caches, so the script can delete them

	echo -ne "\033[0m"
}
clean

if [ $should_log -eq 1 ]; then
	echo
fi

#calculating the new available storage after cleaning
Storage=$(df -h "$HOME" | grep "$HOME" | awk '{print($4)}' | tr 'i' 'B')
if [ "$Storage" == "0BB" ];
then
	Storage="0B"
fi
sleep 1
echo -e "\033[32m Cleaning \033[0m"
echo -e "\033[36m Now Storage : $Storage \n\033[0m"

#installer
