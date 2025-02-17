#!/bin/bash
 #service monitoring
 EMAIL='hasansab.takked@sirmaindia.com,radhakrishna@sirmaindia.com,syed.maqsood@sirmaindia.com,piyush.merchant@sirmaindia.com,infra@sirmaindia.com,sandeep.gowda@sirmaindia.com,basavaraj_s@sirmaindia.com,harshitha.a@sirmaindia.com'
 /bin/netstat -tulpn | awk '{print $4}' | grep 27070 > /root/mongolog   2>/root/mongolog 
 a=$(echo $?)
 if test $a -ne 0
 then
 echo "Dev-MongoDB" | mail -s "MongoDB Service DOWN" $EMAIL
 else
 sleep 0
 fi
 /bin/netstat -tulpn | awk '{print $4}' | grep 63003 > /root/mongolog   2>/root/mongolog
 b=$(echo $?)
 if test $b -ne 0
 then
 echo "Dev-Wildfly_Server" | mail -s "Wildfly Service DOWN " $EMAIL
 else
 sleep 0
 fi
