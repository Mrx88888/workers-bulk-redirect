#!/bin/bash

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.github.com/choirulanam217/script/master/conf/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs less screen psmisc apt-file whois ptunnel ngrep git zsh snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# install screenfetch
cd
wget https://github.com/KittyKatt/screenFetch/raw/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/choirulanam217/script/master/conf/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.github.com/choirulanam217/script/master/conf/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# downlaod script
cd
wget -O speedtest_cli.py "https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py"
wget -O bench-network.sh "https://raw.github.com/choirulanam217/script/master/conf/bench-network.sh"
wget -O ps_mem.py "https://raw.github.com/pixelb/ps_mem/master/ps_mem.py"
wget -O limit.sh "https://raw.github.com/choirulanam217/script/master/conf/limit.sh"
curl http://script.jualssh.com/user-login.sh > user-login.sh
curl http://script.jualssh.com/user-expire.sh > user-expire.sh
curl http://script.jualssh.com/user-limit.sh > user-limit.sh
echo "0 0 * * * root /root/user-expire.sh" > /etc/cron.d/user-expire
sed -i '$ i\screen -AmdS limit /root/limit.sh' /etc/rc.local
chmod +x bench-network.sh
chmod +x speedtest_cli.py
chmod +x ps_mem.py
chmod +x user-login.sh
chmod +x user-expire.sh
chmod +x user-limit.sh
chmod +x limit.sh

# finalisasi
chown -R www-data:www-data /home/vps/public_html
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart

# info
clear
echo "Auto Installer by Choirul Anam" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP/client.tar)"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 109, 110, 443"  | tee -a log-install.txt
echo "Squid3   : 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Tools"  | tee -a log-install.txt
echo "-----"  | tee -a log-install.txt
echo "axel"  | tee -a log-install.txt
echo "bmon"  | tee -a log-install.txt
echo "htop"  | tee -a log-install.txt
echo "iftop"  | tee -a log-install.txt
echo "mtr"  | tee -a log-install.txt
echo "nethogs"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "screenfetch"  | tee -a log-install.txt
echo "./ps_mem.py"  | tee -a log-install.txt
echo "./speedtest_cli.py --share"  | tee -a log-install.txt
echo "./bench-network.sh"  | tee -a log-install.txt
echo "./user-login.sh"  | tee -a log-install.txt
echo "./user-expire.sh"  | tee -a log-install.txt
echo "./user-limit.sh 2"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Account Default (utk SSH dan VPN)"  | tee -a log-install.txt
echo "---------------"  | tee -a log-install.txt
echo "User     : Choirul"  | tee -a log-install.txt
echo "Password : PASS"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : https://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Installasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
