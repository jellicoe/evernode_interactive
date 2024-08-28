#!/bin/bash
apt install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban
fail2ban-client status
#fail2ban-client get sshd banned
