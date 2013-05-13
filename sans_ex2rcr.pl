#!/usr/bin/perl
use strict;
use warnings;
use multiwhere;
use LWP::Simple;


# ~~~~~~~ VERSIONS~~~~~~~~
# 04.04.2013 : Création.
# 05.04.2013 : Tableaux
# # ~~~~~~~ VERSIONS~~~~~~~~
#
# romain.vanel@gmail.com
# rugbis@ujf-grenoble.fr

=head1 NAME
multiwhere_tableau.pl
=cut

=head1 DESCRIPTION
A partir du package multiwhere.pm, qui interroge le webservice de l'Abes, renvoie la liste des bibliothèques (RCR) d'un réseau (ILN) localisé sous une notice du Sudoc (PPN)
Permet une première analyse des notices sans exemplaire dans le SIGB local.
Si il n'y a pas d'exemplaire en local, il ne devrait pas y avoir de localisation dans le Sudoc.

=cut

=head1 UTILISATION

Nécessite les packages : multiwhere, LWP::Simple

Accepte une liste PPN en paramètre, par l'intermédiaire d'un fichier : "liste_de_ppn"

my $fichier_de_base = "liste_de_ppn" 

L'ILN concerné est paramétré dans le package multiwhere.pm pour une utilisation plus générique du package.

Les PPN trouvés sont renvoyés dans le fichier de chaque RCR localisés.
Les PPN non localisés dans l'ILN sont renvoyés dans PPN_Absents_de_l-ILN.txt
Les PPN "erronés" sont renvoyés dans PPN_inexistants.txt

=cut

=head1 LICENCE

GNU/GPL

=cut

#Indiquer l'ILN recherché (pour le rapport). L'indiquer aussi dans multiwhere.pm
my $iln_rapport = "26";

print "Recherche multiwhere de l'ILN $iln_rapport\n";

my $fichier_de_base = "liste_de_ppn"  ;

open(FICHIER_DE_BASE, $fichier_de_base) ||
  die "ficher $fichier_de_base introuvable : $!";

my @fichier_de_base = <FICHIER_DE_BASE>;
close FICHIER_DE_BASE ;


my $nb_erreur = 0;
my $nb_absent = 0;
my $nb_loc = 0;


  foreach my $ligne_fichier_de_base (@fichier_de_base) {
  my $ppn_a_chercher = $ligne_fichier_de_base;
    my (@localisation) = multiwhere::mwhere($ppn_a_chercher) ;
    if (@localisation) {
        foreach my $loc (@localisation ) {
          if ($loc =~ /Erreur/) {
            chomp $ppn_a_chercher;
            $nb_erreur +=1;
            open(FILE, ">>PPN_inexistants.txt") || die "Erreur E/S:$!\n";
            print FILE  "$ppn_a_chercher\n";
            close FILE;
          }
          else {
            chomp $ppn_a_chercher;
            $nb_loc +=1;
            open(FILE, ">>$loc.txt") || die "Erreur E/S:$!\n";
            print FILE  "$ppn_a_chercher\n";
            close FILE;
            }
        }
  }
  else {
            chomp $ppn_a_chercher;
            $nb_absent +=1;
            open(FILE, ">>PPN_Absents_de_l-ILN.txt") || die "Erreur E/S:$!\n";
            print FILE  "$ppn_a_chercher\n";
            close FILE;
  	
  }
  }

my $nb_ppn_a_traiter = @fichier_de_base;

open(LOG, ">rapport.log") || die "Erreur E/S:$!\n";
print LOG  "Recherche multiwhere de l'ILN $iln_rapport\n";
print LOG  "Nombre de PPN analysés : $nb_ppn_a_traiter\n";
print "Nombre de PPN analysés : $nb_ppn_a_traiter\n";
print LOG  "\n";
print "\n";
print LOG  "Nombre de PPN localisés à vérifer (fichiers RCR): $nb_loc\n";
print "Nombre de PPN localisés à vérifer (fichiers RCR): $nb_loc\n";
print LOG  "Nombre de PPN existant mais non localisés dans l'ILN $iln_rapport : $nb_absent\n";
print "Nombre de PPN existant mais non localisés dans l'ILN $iln_rapport : $nb_absent\n";
print LOG  "Nombre de PPN erronés ou inexistants : $nb_erreur (dans PPN_inexistants.txt)\n";
print "Nombre de PPN erronés ou inexistants : $nb_erreur (dans PPN_inexistants.txt)\n";

close LOG;
