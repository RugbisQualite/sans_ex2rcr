sans_ex2rcr
===========

multiwhere.pm
-------------


DESCRIPTION
Package d'interogation du webservice Multiwhere.
A partir de multiwhere (Abes), renvoie la liste des biblioth�ques (RCR) d'un r�seau (ILN) localis� sous une notice du Sudoc (PPN)
Permet une premi�re analyse des notices sans exemplaire dans le SIGB local.
Si il n'y a pas d'exemplaire en local, il ne devrait pas y avoir de localisation dans le Sudoc.

 UTILISATION

Utilisation du package depuis un script .pl
Accepte un PPN en parametre ($ppn_a_chercher)

my @localisation = multiwhere::mwhere($ppn_a_chercher)

Renvoie une liste de RCR dans @localisation.
Renvoie 0 si le PPN n'est pas localis� dans l'ILN.
Renvoie "Erreur, mauvais PPN : " si le PPN n'existe pas dans le Sudoc.

Peut �tre utilis� � partir d'une de PPN.


sans_ex2rcr.pl
--------------


 DESCRIPTION
A partir du package multiwhere.pm, qui interroge le webservice de l'Abes, renvoie la liste des biblioth�ques (RCR) d'un r�seau (ILN) localis� sous une notice du Sudoc (PPN)
Permet une premi�re analyse des notices sans exemplaire dans le SIGB local.
Si il n'y a pas d'exemplaire en local, il ne devrait pas y avoir de localisation dans le Sudoc.

 UTILISATION

N�cessite les packages : multiwhere, LWP::Simple
Accepte une liste PPN en param�tre, par l'interm�diaire d'un fichier : "liste_de_ppn"
my $fichier_de_base = "liste_de_ppn" 
L'ILN concern� est param�tr� dans le package multiwhere.pm pour une utilisation plus g�n�rique du package.
Les PPN trouv�s sont renvoy�s dans le fichier de chaque RCR localis�s.
Les PPN non localis�s dans l'ILN sont renvoy�s dans PPN_Absents_de_l-ILN.txt
Les PPN "erron�s" sont renvoy�s dans PPN_inexistants.txt

 LICENCE

GNU/GPL