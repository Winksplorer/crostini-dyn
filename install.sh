#!/bin/bash

echo "Installing crostini-dyn..."
curl -L -s https://raw.githubusercontent.com/Winksplorer/crostini-dyn/main/crostini-dyn.sh >/dev/null | sudo tee /usr/bin/crostini-dyn > /dev/null
sudo chmod +x /usr/bin/crostini-dyn

echo "Installing libnotify..."
command -v notify-send
if [[ "$?" == "1" ]]; then
    sudo apt install libnotify-bin
else
    echo "nevermind... libnotify was already installed"
fi

echo "Installing cron..."
command -v crontab
if [[ "$?" == "1" ]]; then
    sudo apt install anacron
else
    echo "nevermind... cron was already installed"
fi

echo "Adding to cron..."
nomsg="no crontab for"
if [[ "$(crontab -l 2>/dev/null)" == $nomsg* ]] ;
then
    echo "cron was newly installed"
    touch crostini-cron.txt
else
    echo "cron already exists"
    crontab -l > crostini-cron.txt 2>/dev/null
fi

echo "0 * * * * /usr/bin/crostini-dyn" > crostini-cron.txt
crontab crostini-cron.txt
rm crostini-cron.txt

echo "Done."
exit 0
