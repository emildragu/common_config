#!/bin/bash
# Checks all the cyphers supported by a web server
# Usage: check_cyphers.sh mydomain.com 

nmap --script ssl-enum-ciphers -p 443 $1
