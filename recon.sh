#!/bin/bash
scantodir_file="/some/dir/scanto.log"
getip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
#Attack programs
# Location of nikto prgram #
niktodir="/home/$USER/fun/nikto-master/program/"  # Where is the nikto directory???? #
nikprog="nikto.pl"  # What have you named nikto ie instead of nikto.pl  it becomes web
#Whatever you name nikto  always chmox +x newnam.  # 
#End nikto stuff

# DNSMAP #
dnsmapdir="/someplace/somedir/dir/"
dnsprog="yourfilename"
# END DNSMAP 


# END attack programs #

# How are you going to flood the bitch #
#viassh="$(ssh somename /usr/bin/perl $floodprog  $ip)"
#floodprog="/somedir/somemoredir/floodthing"

# lists for password bruteforcing #
#rainbowtbl="/somedir/someplace/somefile"
wordlist="/somedir/someplace/somefile"


### END VARIABLES ###



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

# Is your network even secure? #

echo "Are you using network protection Example;Direct to ISP or VPN/Proxy"

read -r -p "Are you secure? [y/N] " response
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
read -r -p "ip or web attack? [ip/web] " attack
if [ "$attack" = "web" ]; then  #If you typed web, Do the below.  If you chose, IP do the ip attack#
	# Web attack #
        echo "Enter web url without http/https ie www.whatever.tld or whatever.tld"

        read web
sleep 1
# Initiating dnsmap

   dnsmap $web
		echo "Sleeping for 8 seconds before next attack. Take this time to change your ip and mac"
sleep 8
		echo "Time testing with nikto"

   /usr/bin/proxychains /usr/bin/perl $niktodir$nikprog -url $web
#        nmap -Pn $web > $scantodir_file

else
	#IP attack  #
      echo "Enter IP address"
        read ip 
        nmap -Pn $ip | grep open 

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
	  *)
	echo "Nothing chosen, exiting script"
exit 0
  ;;
esac

fi














