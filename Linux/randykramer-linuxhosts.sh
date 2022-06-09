echo Welke hostname wil je gebruiken voor dit systeem?

read HOSTNAME

sudo echo "$HOSTNAME" > /etc/hostname
sed -i "s+127.0.1.1 student-virtual-machine+127.0.1.1 $HOSTNAME+g" /etc/hosts
sed -i "s+127.0.1.1 ubuntu-server-20+127.0.1.1 $HOSTNAME+g" /etc/hosts