#!/usr/bin/perl
use strict;
use MIME::Lite;

my $body = $ARGV[0];
my $result = $ARGV[1];
chomp($body);

my $data = $body;
my $subject = "Guvenli Internet Hizmeti Gunluk Kontrol Raporu - $result",

my $msg = MIME::Lite->new(
    From    => 'gih-monitor@turk.net',
    To      => 'mdy@turknet.net.tr, networkoperasyon@turknet.net.tr, noc@turknet.net.tr, ict-o@turknet.net.tr',
    Subject => $subject,
    Type    => 'text/html',
    Data    => $data
);
#$msg->attach(
#   Type     => 'HTML',
#   Data     => $data
#);

### use Net:SMTP to do the sending
$msg->send('smtp','193.192.100.230', Debug=>0 );
