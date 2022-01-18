#!/bin/bash

"""This is a testing file."""


timezonegui=$(python3 timezone_gui.py)




if [[ $timezonegui == 23 ]]; then
	time_zone='America/New_York'
    echo $time_zone
elif [[ $timezonegui == 24 ]]; then
	time_zone='America/Chicago'
    echo $time_zone
elif [[ $timezonegui == 25 ]]; then
	time_zone='America/Denver'
    echo $time_zone
elif [[ $timezonegui == 26 ]]; then
	time_zone='America/Los_Angeles'
    echo $time_zone
elif [[ $timezonegui == 27 ]]; then
	time_zone='GMT'
    echo $time_zone
else
	echo "error"
fi


