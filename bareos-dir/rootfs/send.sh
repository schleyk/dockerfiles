#!/bin/sh

echo $1 | mailx -v -s "Bareos" \
    -S smtp-use-starttls \
    -S ssl-verify=ignore \
    -S smtp-auth=login \
    -S smtp=smtp://$SMTP_SERVER \
    -S from="$SMTP_FROM_ACCOUNT" \
    -S smtp-auth-user=$SMTP_ACCOUNT \
    -S smtp-auth-password=$SMTP_PASSWORD \
    -S ssl-verify=ignore \
    -S nss-config-dir=/root/.certs $2 > /dev/null 2>&1
