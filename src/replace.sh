#!/bin/bash
SCRIPTPATH=/etc/nginx

# insert optional custom dns resolver ip
dns_resolver=${DNS_RESOLVER:-1.1.1.1}
sed -i -e "s/?replace_label_dns_resolver?/$dns_resolver/g" $SCRIPTPATH/nginx.conf

# insert domain name to listen on
domain=${DOMAIN:-uni-bonn.de}
domainr=$(echo "$domain" | sed "s/\./\\\\\\\\./g")
domainr=$(echo "$domainr" | sed "s/:[0-9]*//g")
sed -i -e "s/?replace_label_short_domain?/$domain/g" $SCRIPTPATH/nginx.conf
sed -i -e "s/?replace_label_short_domain_regex?/$domainr/g" $SCRIPTPATH/nginx.conf

# insert string substitutions
while IFS="" read -r p || [ -n "$p" ]
do
  sub="subs_filter \"$(echo "$p" | tr -d '\n' | sed -e "s/;/\" \"/g")\";"
  escaped_sub=$(printf '%s' "$sub" | sed -e 's/[\/&]/\\&/g')
  sed -i -e "s/?replace_label_subs?/$escaped_sub\n      ?replace_label_subs?/g" $SCRIPTPATH/nginx.conf
done < subs.txt

# insert regex string substitutions
while IFS="" read -r p || [ -n "$p" ]
do
  sub="subs_filter \"$(echo "$p" | tr -d '\n' | sed -e "s/;/\" \"/g")\" r;"
  escaped_sub=$(printf '%s' "$sub" | sed -e 's/[\/&]/\\&/g')
  sed -i -e "s/?replace_label_subs?/$escaped_sub\n      ?replace_label_subs?/g" $SCRIPTPATH/nginx.conf
done < subs_regex.txt
sed -i -e "s/?replace_label_subs?//g" $SCRIPTPATH/nginx.conf

# insert resources substitutions
while IFS="" read -r p || [ -n "$p" ]
do
  sub="location $(echo "$p" | tr -d '\n' | sed -e "s/;/ {?new_line_label?      alias \/usr\/share\/nginx\/html\//g");"
  escaped_sub=$(printf '%s' "$sub" | sed -e 's/[\/&]/\\&/g')
  escaped_sub=$(printf '%s' "$escaped_sub" | sed -e 's/?new_line_label?/\\n/g')
  sed -i -e "s/?replace_label_res_subs?/$escaped_sub\n      add_header Access-Control-Allow-Origin \"*\" always;\n    }\n    ?replace_label_res_subs?/g" $SCRIPTPATH/nginx.conf
done < res_subs.txt

# insert regex resources substitutions
while IFS="" read -r p || [ -n "$p" ]
do
  sub="location ~$(echo "$p" | tr -d '\n' | sed -e "s/;/ {?new_line_label?      alias \/usr\/share\/nginx\/html\//g");"
  escaped_sub=$(printf '%s' "$sub" | sed -e 's/[\/&]/\\&/g')
  escaped_sub=$(printf '%s' "$escaped_sub" | sed -e 's/?new_line_label?/\\n/g')
  sed -i -e "s/?replace_label_res_subs?/$escaped_sub\n      add_header Access-Control-Allow-Origin \"*\" always;\n    }\n    ?replace_label_res_subs?/g" $SCRIPTPATH/nginx.conf
done < res_subs_regex.txt
sed -i -e "s/?replace_label_res_subs?//g" $SCRIPTPATH/nginx.conf
