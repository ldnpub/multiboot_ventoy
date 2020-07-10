# Ventoy Personnalisation

Projet de clé USB multiboot (principalement Ubuntu)
Un mode persistence
Une partition chiffrée LUKS

## 2 DO

Utiliser la particion chiffrée comme /home
Grace à 2 partitions de persistence, la première non chiffrée permet d'installer des applications et contient un script permettant de monter la partition luks à la place du /home. Après s'être deconnecté de la partition et s'être reconnecté sur le profil situé sur la partition LUKS, on se retrouve dans un environnement "sécurisé".
En définitive grace à cette technique la perte de la clé ne nécessite pas que toutes les données personnelles se retrouveront dans la nature. En effet celles-ci sont protégées dans le contenaire luks :)
