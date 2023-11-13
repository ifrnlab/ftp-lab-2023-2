#!/bin/sh

while read conta senha; do 
    mkdir /home/vsftpd/$conta;
    echo -e "${conta}\n${senha}" >> /etc/vsftpd/virtual_users.txt;
done < contas.txt

/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

exit

docker restart vsftpd

