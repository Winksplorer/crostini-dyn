#!/bin/bash

# Get the current hour
hour=$(date +%H)

# Perform different actions based on the current hour
if [ $hour -ge 0 ] && [ $hour -lt 18 ]; then
    # Day
    desired_content="[Service]\nEnvironment=\"SOMMELIER_FRAME_COLOR=#f2f2f2\""

    # Create a temporary file with the desired content, ensuring proper newline
    tempfile=$(mktemp)
    echo -e "$desired_content" > "$tempfile"

    if diff -q "$tempfile" ~/.config/systemd/user/sommelier-x@0.service.d/override.conf; then
        echo "No work needed."
    else
        echo "The file content does not match exactly."
        cp "$tempfile" ~/.config/systemd/user/sommelier-x@0.service.d/override.conf
        # https://askubuntu.com/questions/161851/how-do-i-use-notify-send-to-immediately-replace-an-existing-notification
        NID=0
        for i in {0..60}; do
            # This is actual crap... couldn't find a way to get changes to apply without restarting sommelier, this is the closest way.
            NID=$(notify-send -u critical -r $NID "Linux environment will reboot in $((60-$i)) seconds, please save unfinished work." -p)
            sleep 1
        done
        systemctl --user daemon-reload
        systemctl --user restart sommelier-x@0.service
    fi
    rm "$tempfile"
    exit 0

elif [ $hour -ge 18 ] && [ $hour -lt 23 ]; then
    # Day
    desired_content="[Service]\nEnvironment=\"SOMMELIER_FRAME_COLOR=282c34\""

    # Create a temporary file with the desired content, ensuring proper newline
    tempfile=$(mktemp)
    echo -e "$desired_content" > "$tempfile"

    if diff -q "$tempfile" ~/.config/systemd/user/sommelier-x@0.service.d/override.conf; then
        echo "No work needed."
    else
        echo "The file content does not match exactly."
        cp "$tempfile" ~/.config/systemd/user/sommelier-x@0.service.d/override.conf
        # https://askubuntu.com/questions/161851/how-do-i-use-notify-send-to-immediately-replace-an-existing-notification
        NID=0
        for i in {0..60}; do
            # This is actual crap... couldn't find a way to get changes to apply without restarting sommelier, this is the closest way.
            NID=$(notify-send -u critical -r $NID "Linux environment will reboot in $((60-$i)) seconds, please save unfinished work." -p)
            sleep 1
        done
        systemctl --user daemon-reload
        systemctl --user restart sommelier-x@0.service
    fi
    rm "$tempfile"
    exit 0
else
    exit 1 # Assume the condition where time doesn't exist
fi
