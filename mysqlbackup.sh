#!/bin/bash

if [ -n "$1" ] && [ -n "$2" ]; then
	user=$1
	host=$2
	if [ -n "$3" ]; then

		port=$3
  	else
  		port=22
  	fi
  	
else
  echo "Veuillez spécifier tous les parametres (user, host, et port si non specifie port 22 qui sera utiliser )"
  exit 0
fi

#Parametre pour l'envoi de l'email
email="amarlamzaoui1@gmail.com"
subject="Script result"

#Partie Backup de la BDD

#CONFIG DE BASE
DATE=$(date +"%Y%m%d")

#DOSSIER  DE SAUVEGARDE DES BACKUPS
BACKUP_DIR="/home/sidharta/Bureau/backup-d"

#ID MYSQL
MYSQL_USER="root"
MYSQL_PWD="Motdepasse1*"

#COMMANDE MYSQL
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

#NB JOUR DE RETENTION
RETENTION=14

#CREATE NEW DIRECTORY INTO BACHUP DIRECTORY FOR THIS DATE
mkdir -p $BACKUP_DIR/$DATE

#Copie du backup
$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PWD --skip-lock-tables --events --all-databases | gzip > "$BACKUP_DIR/$DATE/alldb.sql.gz"

find $BACKUP_DIR/* -mtime +$RETENTION -delete


# Partie envoie du fichier zip
i=0

#chemin vers les cles RSA SSH
keys="/home/sidharta/Bureau/test.pem"

while ((i < 50))
do 
	if ping -q -c 1 $host >/dev/null
	then

		scp -i $keys "$BACKUP_DIR/$DATE/alldb.sql.gz" $user@$host:/home/ec2-user/test
		break
	else
		sleep 30
		echo "fail, tentative $i"
		i=$[$i+1]
	fi
done

#envoie de l'email si 50 tentatives ont echouees
if (( $i == 50 ))
then

	message="The machine does not ping"
	echo "$message" | mail -s "$subject" $email;

fi







