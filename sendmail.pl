#!/usr/bin/perl

use MIME::Lite;

my $attachpath = $ARGV[0];
chomp($attachpath);

my $attachfile = $ARGV[1];
chomp($attachfile);

$msg = MIME::Lite->new(
    From    => 'gih-monitor@turk.net',
#    To      => 'sistem@turknet.net.tr, alper.bassarac@turknet.net.tr',
    To      => 'vahit.tabak@turknet.net.tr, alper.bassarac@turknet.net.tr',
##  Cc      => 'tardu.demirel@turknet.net.tr',
    Subject => 'Guvenli Internet Kontrol Sonuclari Bilgisi',
    Type    => 'multipart/mixed'
);

### Add parts (each "attach" has same arguments as "new"):
$msg->attach(
    Type     => 'TEXT',
    Data     => "Guvenli internet kontrol sonuclari ekte bulunmaktadir."
);
$msg->attach(
    Type     => 'image/gif',
    Path     => "$attachpath",
    Filename => "$attachfile",
    Disposition => 'attachment'
);
### use Net:SMTP to do the sending
$msg->send('smtp','193.192.100.230', Debug=>0 );
