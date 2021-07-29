#Valid Registrar address checker for a list of assets.
#subs.txt is the list of assets.


#!/bin/bash

cat subs.txt | while read domain do;do curl -sk "https://who.is/whois/$domain" | if grep -q -F -e '  Belastingdienst Centrum voor Infrastructuur en Exp' -e '  Laan van Westenenk 490' -e '  7334DS Apeldoorn'
-e '  Netherlands'; then echo $domain-----OK_OK; else echo FAILED_FAILED;fi;done
