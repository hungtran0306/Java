#!/bin/bash
# Hook Script for Java OOME.

host=`hostname`

# Set up path and log directory
path=/tmp
cd ${path}
oomelog=${host}.`date +'%m%d%y%H%M%S'`
touch ${oomelog}
# Build the email msg
echo 'OOME has occured in ' ${host} >> ${oomelog}
hprof=`ls | grep hprof | grep -v .gz`

pid=`echo ${hprof} | awk -F"." '{print $1}' | cut -c1-8 --complement`
gzip ${hprof}
echo 'The Java Process that causes the OOME ==> ' ${pid} >> ${oomelog}
echo "The hprof file for this process is in ==> ${path}/${hprof}.gz" >> ${oomelog}
echo "The java cmd is:" >> ${oomelog}
ps ${pid} >> ${oomelog}

# and mail it
cat ${oomelog} | mail -s "OOME has occured in ${host}" YourEmail
rm ${oomelog}
