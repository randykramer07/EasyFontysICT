#!/bin/bash

echo Voer het IP-adres in van jouw Zabbix Server

read SERVER_IP

echo Voer de Hostname in van jouw Zabbix Server

read SERVER_HOSTNAME

function editzabbixconf {
echo ============================================================
echo Zabbix Repository wordt momenteel gedownload en geinstaleerd
echo De Zabbix-Agent is succesvol geinstalleerd op dit systeem
echo ============================================================
sudo apt install zabbix-agent
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.original
sed -i "s+Server=127.0.0.1+Server=$SERVER_IP+g" /etc/zabbix/zabbix_agentd.conf
sed -i "s+ServerActive=127.0.0.1+ServerActive=$SERVER_IP:10051+g" /etc/zabbix/zabbix_agentd.conf
sed -i "s+Hostname=Zabbix server+Hostname=$SERVER_HOSTNAME+g" /etc/zabbix/zabbix_agentd.conf

echo ============================================================
echo Zabbix Configuratie Bestand
echo Het Zabbix Agent Configuratiebestand is aangepast
echo Locatie: /etc/zabbix/zabbix_agentd.conf
echo ============================================================
}

function ifexitiszero
{
if [[ $? == 0 ]];
then editzabbixconf
else echo Helaas kan dit script niet gebruikt worden voor deze zabbix-agent installatie && exit 0

fi
}

function ubuntu2022
{
ifexitiszero
ufw allow 10050
ufw allow 10051
systemctl enable zabbix-agent
systemctl restart zabbix-agent
}

function version_id_ubuntu
{
u1=$(cat /etc/*release* | grep VERSION_ID=)
echo !! 2 !! OS Version Gevonden $u1  #prints os version id like this : VERSION_ID="8.4"

u2=$(echo $u1 | cut -c13- | rev | cut -c2- |rev)
#echo $u2        #prints os version id like this : 8.4

u3=$(echo $u2 | awk '{print int($1)}')
#echo $u3       #prints os version id like this : 8

if [[ $u3 -eq 22 ]];      then ubuntu2022
elif [[ $u3 -eq 20 ]];    then ubuntu2022
elif [[ $u3 -eq 18 ]];    then ubuntu18
elif [[ $u3 -eq 16 ]];    then ubuntu16
elif [[ $u3 -eq 14 ]];	  then ubuntu14
else echo Je kunt helaas dit script niet op deze machine gebruiken && exit 0
fi
}

echo Zabbix-Agent Installatie Script
echo ========================================================================
echo Type en versie van het OS bepalen

if [[ $(cat /etc/*release*) == *"ubuntu"* ]];
then 	echo !! 1 !!  Op dit systeem is Ubuntu gedetecteerd
	echo Ubuntu Versie aan het bepalen
	version_id_ubuntu

else echo Je kunt helaas dit script niet op deze machine gebruiken && exit 0
fi

echo =================================================================
echo De Zabbix-Agent is succesvol geinstalleerd op dit systeem.
echo De Zabbix-Agent is automatisch geconfigureerd voor HSKIHW.
echo Hostname: $SERVER_HOSTNAME
echo Server: $SERVER_IP
echo Script by Randy Kramer
echo =================================================================
