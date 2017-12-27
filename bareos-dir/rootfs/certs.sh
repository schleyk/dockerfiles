#!/bin/sh
# Based on https://coderwall.com/p/ez1x2w/send-mail-like-a-boss
if [ "$SMTP_SERVER" = "" ]
then
    	echo "Will not configure certs"
        exit
else
    	echo "Configuring certs for sending mails ..."
fi

PWD="somepass"
echo $PWD > /pwd
rm -Rf ~/.certs
mkdir ~/.certs
certutil -N -d ~/.certs -f /pwd
echo -n | openssl s_client -connect $SMTP_SERVER:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/.certs/cert.crt
certutil -A -n "Authority" -t "C,," -d ~/.certs -i ~/.certs/cert.crt