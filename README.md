sans_ex2rcr
===========

multiwhere.pm
-------------


DESCRIPTION
Package d'interogation du webservice Multiwhere.
A partir de multiwhere (Abes), renvoie la liste des bibliothèques (RCR) d'un réseau (ILN) localisé sous une notice du Sudoc (PPN)
Permet une première analyse des notices sans exemplaire dans le SIGB local.
Si il n'y a pas d'exemplaire en local, il ne devrait pas y avoir de localisation dans le Sudoc.

 UTILISATION

Utilisation du package depuis un script .pl
Accepte un PPN en parametre ($ppn_a_chercher)

my @localisation = multiwhere::mwhere($ppn_a_chercher)

Renvoie une liste de RCR dans @localisation.
Renvoie 0 si le PPN n'est pas localisé dans l'ILN.
Renvoie "Erreur, mauvais PPN : " si le PPN n'existe pas dans le Sudoc.

Peut être utilisé à partir d'une de PPN.


sans_ex2rcr.pl
--------------


 DESCRIPTION
A partir du package multiwhere.pm, qui interroge le webservice de l'Abes, renvoie la liste des bibliothèques (RCR) d'un réseau (ILN) localisé sous une notice du Sudoc (PPN)
Permet une première analyse des notices sans exemplaire dans le SIGB local.
Si il n'y a pas d'exemplaire en local, il ne devrait pas y avoir de localisation dans le Sudoc.

 UTILISATION

Nécessite les packages : multiwhere, LWP::Simple
Accepte une liste PPN en paramètre, par l'intermédiaire d'un fichier : "liste_de_ppn"
my $fichier_de_base = "liste_de_ppn" 
L'ILN concerné est paramétré dans le package multiwhere.pm pour une utilisation plus générique du package.
Les PPN trouvés sont renvoyés dans le fichier de chaque RCR localisés.
Les PPN non localisés dans l'ILN sont renvoyés dans PPN_Absents_de_l-ILN.txt
Les PPN "erronés" sont renvoyés dans PPN_inexistants.txt

 LICENCE

GNU/GPL