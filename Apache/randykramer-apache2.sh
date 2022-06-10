#!/bin/env bash

apacheIntro() {
echo =================================================================================
echo                     Apache2 Installatie Script by Randy Kramer
echo 
echo Aan de hand van dit script kun jij makkelijk in 1x een Apache website installeren
echo =================================================================================
echo Wil jij een eigen URL gebruiken?
read -p "(J)a / (N)ee " jn
	case $jn in
        	[Jj]* ) eigenURL;;
        	[Nn]* ) geenURL;;
        	* ) echo "Er gaat iets fout";;
	esac
}

eigenURL() {
echo =================================================================================
echo Wat is de URL die je wilt gebruiken?
read WEBURL
ApacheInstallatieMetURL
}

ApacheInstallatieMetURL() {
echo =================================================================================
echo                                 Apache Installatie
echo
echo       Een klein moment geduld, de installatie van Apache2 gaat nu beginnen!
echo
echo =================================================================================
yes | apt update
yes | apt upgrade
yes | apt install apache2
mkdir /var/www/$WEBURL
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$WEBURL.conf
sed -i "s+DocumentRoot /var/www/html+DocumentRoot /var/www/$WEBURL/+g" /etc/apache2/sites-available/$WEBURL.conf
sed -i "s+webmaster@localhost+$ServerAdmin+g" /etc/apache2/sites-available/$WEBURL.conf
sed -i "13 i    ServerName www.$WEBURL" /etc/apache2/sites-available/$WEBURL.conf
sed -i "13 i    ServerAlias $WEBURL" /etc/apache2/sites-available/$WEBURL.conf
a2ensite $WEBURL.conf

systemctl reload apache2
systemctl enable apache2

SuccesvolMetURL
}
ApacheInstallatieZonderURL() {
echo =================================================================================
echo                                 Apache Installatie
echo
echo       Een klein moment geduld, de installatie van Apache2 gaat nu beginnen!
echo
echo =================================================================================
yes | apt update
yes | apt upgrade
yes | apt install apache2
a2ensite 000-default.conf
systemctl reload apache2
systemctl enable apache2
}
SuccesvolMetURL() {

echo ================================================================================================
echo                                        Succesvolle Installatie
echo
echo De installatie van Apache is succesvol verlopen, je gaf aan gebruik te willen maken van een URL.
echo
echo   Je koos er voor om gebruik te maken van het URL $WEBURL, dit heb ik overal voor je ingesteld.
echo ================================================================================================
echo
echo Wil je SSL activeren aan de hand van LetsEncrypt?
read -p "(J)a / (N)ee " jn
case $jn in 
	[jJ] ) welSSL;;
	[nN] ) geenSSL;;
	* ) echo Ongeldige invoer, voer een goed antwoord in;;
esac
}

welSSL() {
echo =================================================================================
echo                              LetsEncrypt SSL Certificering
echo
echo    Je hebt er voor gekozen om een SSL Certificaat in te stellen op je website.
echo        We gaan beginnen met het installeren van je eigen SSL Certificaat.
echo
echo =================================================================================
yes | apt update
yes | apt upgrade
yes | apt install certbot python3-certbot-apache
certbot

ufw disable Apache
ufw allow 'Apache Secure'

echo ================================================================================================
echo                                            Einde Installatie              
echo 
echo            We hebben je SSL Certificaat geinstalleerd en ingeschakeld op je website.
echo                    Je kunt nu met alle plezier je website bezoeken op HTTPS. 
echo
echo                        Tip: Heb je je Firewall en NAT Rules al aangemaakt??
echo
echo ================================================================================================     
}

geenSSL() {
echo ================================================================================================
echo                                            Einde Installatie              
echo 
echo Je hebt er voor gekozen om geen SSL certificaat te generen, daarbij ben je aan het einde gekomen
echo                    van deze Apache Installatie, veel succes met je website!  
echo
echo                        Tip: Heb je je Firewall en NAT Rules al aangemaakt??
echo
echo ================================================================================================                  
}

apacheIntro
