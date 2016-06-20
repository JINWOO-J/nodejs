#!/bin/sh
cat /etc/resolv.conf
print_w(){
    RESET='\e[0m'  # RESET
    BWhite='\e[7m';    # backgroud White
    printf "${BWhite} ${1} ${RESET}\n";
}

echo $@
for npm in ${@};
do
	print_w "installing ${npm}  ...."
	/usr/local/node/bin/npm install -g ${npm};
done
