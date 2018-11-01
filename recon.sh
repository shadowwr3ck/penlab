#!/bin/bash
#poo
scantodir_file="/some/dir/scanto.log"
getip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
#Attack programs
# Location of nikto prgram #
niktodir="/home/$USER/fun/nikto-master/program/"  # Where is the nikto directory???? #
nikprog="nikto.pl"  # What have you named nikto ie instead of nikto.pl  it becomes web
#Whatever you name nikto  always chmod +x newnam.  # 
#End nikto stuff

# DNSMAP #
dnsmapdir="/someplace/somedir/dir/"
dnsprog="yourfilename"
# END DNSMAP 
#Password Bruteforcer


# END attack programs #

# How are you going to flood the bitch #
#viassh="$(ssh somename /usr/bin/perl $floodprog  $ip)"
#floodprog="/somedir/somemoredir/floodthing"

# lists for password bruteforcing #
#rainbowtbl="/somedir/someplace/somefile"
wordlist="/somedir/someplace/somefile"


### END VARIABLES ###


# If nmap doesnt exist in your system Than install it "

## Program installation ##
if ! which nmap > /dev/null; then
   echo -e "nmap doesnt exist! Install? (y/n) \c"
   read REPLY
	if "$REPLY" = "y"; then
		sudo apt-get install -y nmap
	fi	
fi


#Program installation
#sudo apt install nmap proxychains -y 

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




echo "Please be aware that web attacks differ greatly from network attacks"

# CHOSE YOUR ATTACK #

# IP attack  #

      echo "Enter IP address.  You will be asked for hostname if the attack requires it"
        read ip 
        nmap -Pn $ip | grep open   # Get the ports from the ip  #


# Port attack selection #
read -r -p " Choose a port to attack " portresponse
  case "$portresponse" in 
     22)  # If you type 22 Do this attack else do another attack 
  	echo "Time for an ssh bruteforce"
		thc-hydra 	
  ;;
      flood)
	echo " Flood the bitch " 
	echo "${viassh}"
 # placeholder commands
  ;;

	  80|443)
	echo " Enter hostname "
	read web
		 /usr/bin/proxychains /usr/bin/perl $niktodir$nikprog -url $web
			echo " Initiating dnsmap "
			dnsmap $web
  ;;
	*)
		echo " Either no attack for selected port, or something went wrong"
;;
esac
