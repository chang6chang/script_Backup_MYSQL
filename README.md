# Script_entretien
Ce code permet de creer un full backup d'une base de donnees Mysql (database, user, ...), avec 14 jours de retention. Un fichier zip est envoyé vers l'adresse du hote fournie en parametre, si l'hote n'est pas joingnable (50 x ping), alors un email est envoye à l'utilisateur (email a verifier dans les spams).
Les tests ont ete realises en utilisant une machine Amazon EC2 basé sur Red Hat. 

#Pré-requis
- Installation de Mysql

#Execution du script
```bash
sudo chmod +x "mybackup.sh"
sudo ./mybackup.sh <user> <ip_host> <port>
##si le port n'est pas spécifie, c'est le port 22 qui est utilise par defaut
