#Valid Registrar address checker for a list of assets.
#subs.txt is the list of assets.

#!/bin/bash

cat subs.txt | while read domain do;do curl -sk "https://who.is/whois/$domain" | if  grep -q -A 5 Registrar: ; then echo $domain-----OK_OK; else echo FAILED_FAILED;fi;done
