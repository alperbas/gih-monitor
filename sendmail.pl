#!/usr/bin/perl
use strict;
use MIME::Lite;

my $body = $ARGV[0];
chomp($body);

my $data = $body;


my $msg = MIME::Lite->new(
    From    => 'gih-monitor@turk.net',
#    To      => 'sistem@turknet.net.tr, alper.bassarac@turknet.net.tr',
    To      => 'vahit.tabak@turknet.net.tr, alper.bassarac@turknet.net.tr',
#    Cc      => 'tardu.demirel@turknet.net.tr',
    Subject => 'Güvenli İnternet Hizmeti Günlük Kontrol Raporu',
    Type    => 'text/html',
    Data    => $data
);
$msg->attach(
    Type     => 'HTML',
    Data     => $data
);

### use Net:SMTP to do the sending
$msg->send('smtp','193.192.100.230', Debug=>0 );
