#!/usr/bin/perl
package multiwhere;
use strict;
use warnings;
use LWP::Simple;	# get(url)


# ~~~~~~~ VERSIONS~~~~~~~~
# 01.03.2013 : Création.
# 29.03.2013 : Doc
# ~~~~~~~ VERSIONS~~~~~~~~
#
# romain.vanel@gmail.com
# rugbis@ujf-grenoble.fr



=head1 NAME
multiwhere.pm
=cut

=head1 DESCRIPTION
Package d'interogation du webservice Multiwhere.
A partir de multiwhere (Abes), renvoie la liste des bibliothèques (RCR) d'un réseau (ILN) localisé sous une notice du Sudoc (PPN)
Permet une première analyse des notices sans exemplaire dans le SIGB local.
Si il n'y a pas d'exemplaire en local, il ne devrait pas y avoir de localisation dans le Sudoc.

=cut

=head1 UTILISATION

Utilisation du package depuis un script .pl
Accepte un PPN en parametre ($ppn_a_chercher)

my @localisation = multiwhere::mwhere($ppn_a_chercher)

Renvoie une liste de RCR dans @localisation.
Renvoie 0 si le PPN n'est pas localisé dans l'ILN.
Renvoie "Erreur, mauvais PPN : " si le PPN n'existe pas dans le Sudoc.

Peut être utilisé à partir d'une de PPN.

=cut

=head1 LICENCE

GNU/GPL

=cut



#------------------------------------------------------------------------------
sub mwhere {

my ($ppn_a_localiser) = @_ ;

#ILN à contrôler
my $iln = "26";

#URL Abes Multiwhere
my $url_abes_multiwhere_basique = "http://www.sudoc.fr/services/multiwhere/";

#URL Abes iln2rcr
my $url_abes_iln2rcr_basique = "http://www.idref.fr/services/iln2rcr/";



my $ppn_2 = $ppn_a_localiser;
  chomp($ppn_2); 
my $url = &url_generator($ppn_a_localiser,$url_abes_multiwhere_basique);
my $page_multiwhere = &downloader_de_page($url,$ppn_2);

 if ($page_multiwhere) {
   my @rcr_trouve = &chercheur_de_rcr($page_multiwhere,$ppn_2,$url_abes_iln2rcr_basique,$iln);
   return @rcr_trouve;
  }  
  else {
    return "Erreur, mauvais PPN : $ppn_2";
  } ;
}

#------------------------------------------------------------------------------
sub url_generator {
  my ($ppn_a_chercher, $url_basique) = @_;
  chomp($url_basique);
  my $url_construite = "$url_basique$ppn_a_chercher\n" ;
  return $url_construite;
}

#------------------------------------------------------------------------------
sub downloader_de_page {
  my ($url,$ppn2) = @_ ;
  if (my $page = get($url)) {
  	 return $page;
	}
    else {
      return 0;
    };

} 


#------------------------------------------------------------------------------
sub chercheur_de_rcr {
   my ($notice_localisation,$ppn_a_chercher,$url_iln2rcr,$iln) = @_ ;
   my $url_iln_construite = &url_generator($iln,$url_iln2rcr);
   my $page_iln = get($url_iln_construite);
   $page_iln =~ s/<rcr>([0-9]+)<\/rcr>/$1\n/g;
   $page_iln =~ s/.*>//g;
   $page_iln =~ s/\n\n//g;
   $page_iln =~ s/\n/|/g;
   my $liste_rcr = $page_iln;
      if ($notice_localisation =~ /error/) { 
        print "PPN non trouve : $ppn_a_chercher"; 
      }
        else { 
          $notice_localisation =~ s/<rcr>([0-9]+)<\/rcr>/$1\n/g;
          $notice_localisation =~ s/.*>//g;
          my  @XML = split /\n/, $notice_localisation;
          my  @res = grep { $_ =~ $liste_rcr } @XML;
          return @res;
        } 
}
  
1;