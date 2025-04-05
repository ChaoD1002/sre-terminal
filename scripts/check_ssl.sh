#!/bin/bash
domain=$1
if [ -z "$domain" ]; then echo "用法: $0 example.com"; exit 1; fi
echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | openssl x509 -noout -dates
