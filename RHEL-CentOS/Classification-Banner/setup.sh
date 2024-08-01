#!/usr/bin/env bash

# For my purpose, I need to remove the old banner init
rm -f /etc/xdg/autostart/cyberteam-classbanner.desktop

# Deliver new files
\cp classification-banner.py /usr/local/sbin/
chmod 644 /usr/local/sbin/classification-banner.py
\cp classification_banner.conf /etc/
chmod 644 /etc/classification_banner.conf
\cp classification-banner.desktop /etc/xdg/autostart/
chmod 644 /etc/xdg/autostart/classification-banner.desktop

# You can manually test the installation by executing "python2 /usr/local/sbin/classification-banner.py"
echo -e "\e[32m\n\tSetup complete. Settings will not apply until next login.\e[0m"

# Execution file is /usr/local/sbin/classification-banner.py
# Configuration file is /etc/classificaiton-banner.conf
# Initiation file is /etc/xdg/autostart/classification-banner.desktop