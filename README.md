# Ventoy Personnalisation

- Projet de clé USB multiboot (principalement Ubuntu)
- Un mode persistence
- Une partition chiffrée LUKS

## Ce que vous apportent ces scripts

* Utiliser la particion chiffrée comme /home.

La partitions de persistence (non chiffrée) permet d'installer des applications et contient un script permettant de monter la partition luks à la place du /home.<br>
Ce script n'est à lancer qu'une fois pour la création du nouveau compte et le changement du mot de passe par défaut.<br>
A chaque autre redémarrage il suffit de lancer le script *login.sh*<br>
Après s'être deconnecté de la session et s'être reconnecté sur le profil situé sur la partition LUKS, on se retrouve dans un environnement "sécurisé".

En définitive grace à cette technique la perte de la clé ne signifie pas que toutes les données personnelles se retrouveront dans la nature. En effet celles-ci sont protégées dans le contenaire luks :)
