#!/usr/bin/env bash

# SOURCES:
# https://gist.github.com/opshope/de0801a36b5438e9baa4
# https://www.jamf.com/jamf-nation/third-party-products/files/854/settimeserver-sh
# https://www.jamf.com/jamf-nation/discussions/28478/network-system-preferences-for-non-admins

# activate verbose standard output (stdout)
set -v
# activate debugging (execution shown)
set -x

# logs
log_time=$(date +%Y%m%d_%H%M%S)
log_file="/tmp/set_time_server_$log_time.log"
exec &> >(tee -a "$log_file")   # redirect standard error (stderr) and stdout to log
# exec 1>> >(tee -a "$log_file")	# redirect stdout to log

# $USER
# Param $3 is logged in user in JSS
# local `parent_command`: /usr/local/bin/bash
parent_cmd=$(ps -o comm= $PPID)
if [[ "$parent_cmd" = '/usr/local/jamf/bin/jamf' ]]; then
    logged_in_user=$3
elif [[ "$(uname)" = 'Darwin' ]]; then
    logged_in_user=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ {print $3}')
else
    logged_in_user=$(logname)    # posix alternative to /dev/console
fi

# $UID
logged_in_uid=$(id -u "${logged_in_user}")

# $HOME
logged_in_home=$(eval echo "~${logged_in_user}")

raise_error() {
	# LOCAL
	# sudo -u "$logged_in_user" bash -c "jamf displayMessage -message 'Lorem ipsum dolor'"

	# JSS
	jamf displayMessage -message "Unexpected error occurred. Please contact IT support at itsupport@greenhouse.io and attach the log file located at $logged_in_home/Desktop "
}  >> $log_file

# Static time server (DEFAULT: time.apple.com)
time_server='time.apple.com'

# Dynamic time zone
# time_zone=$(systemsetup -gettimezone | awk '/Time Zone/ {print $3}')

"""pulls in int from timezone_gui.py, goes through if statement to figure out which time zone it's called, I think this may be better suited 
in the original .py program, but I can't figure out how to do that."""
timezonegui=$(python3 timezone_gui.py)

if [[ $timezonegui == 23 ]]; then
	time_zone='America/New_York'
elif [[ $timezonegui == 24 ]]; then
	time_zone='America/Chicago'
elif [[ $timezonegui == 25 ]]; then
	time_zone='America/Denver'
elif [[ $timezonegui == 26 ]]; then
	time_zone='America/Los_Angeles'
elif [[ $timezonegui == 27 ]]; then
	time_zone='GMT'
else
	raise_error
fi


# TODO: create a GUI for dynamically selecting any of these. Can be done with jamfHelper or Python (e.g., tkinter)
# Time Zones
# sudo systemsetup -listtimezones
# 'America/Los_Angeles'		# PT
# 'America/Denver'			# MT
# 'America/Chicago'			# CT
# 'America/New_York'		# ET
# 'GMT'						# Greenwich Mean Time (Dublin/London/UTC)

# Verify that $4 param was passed and static $time_server var is empty, then assign value
#if [[ ! -z "$4" ]]; then
    time_zone=$4
#else
	# Static time zone (disabled in JSS)
#	time_zone='America/New_York'
#fi

# Temporarily disable network time
systemsetup -setusingnetworktime off

# Set time server and network time

"""If $time_zone isn't empty then go into the If statement by setting the network time using the variable from $time_zone"""

if [[ ! -z "$time_zone" ]]; then
	echo "Setting network time server to: $time_server..."
	systemsetup -setnetworktimeserver $time_server
	# Set time zone
	systemsetup -settimezone $time_zone
else
	echo "Error: The parameter 'time_zone' is blank. Please supply within 'JSS > Policies > <policy_name>' "
	echo "'Options > Scripts > Parameter Values' "
fi

# Enable location services
echo 'Set time zone automatically using current location '
defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup. LocationServicesEnabled -int 1
chown -R _locationd:_locationd /var/db/locationd
launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

# Set time zone automatically using current location
defaults write /Library/Preferences/com.apple.timezone.auto Active -bool false

# Turn network time on and verify results
systemsetup -setusingnetworktime on
systemsetup -gettimezone
systemsetup -getnetworktimeserver

# Unlock date/time preferences for standard user (i.e., all users -- admin's redundant, of course)
security authorizationdb write system.preferences.datetime allow

# Sync with time server
# sntp -sS time.apple.com
sntp -sS $time_server

# deactivate verbose and debugging stdout
set +v
set +x

exit 0
