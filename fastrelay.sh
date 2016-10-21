
# Getting Codename of the OS
flavor=`lsb_release -cs`

# Installing dependencies for Tor
read -p "Do you want to fetch the core Tor dependances? (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   echo deb http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list
   echo deb-src http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list
   gpg --keyserver keys.gnupg.net --recv 886DDD89
   gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
fi

# Updating / Upgrading System
read -p "Do you wish to upgrade system packages? (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   apt-get update
   apt-get dist-upgrade
fi

# Installing Tor
read -p "Do you wish to install Tor? (Make sure you're 100% certain you want to do this) (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   apt-get install tor
   echo "Getting status of Tor.."
   service tor status
   echo "Stopping Tor service..."
   service tor stop
fi

# Customizing Tor RC file to suit your Relay
# Nickname for Exit
read -p "Enter your desired Relay nickname: "  Name
echo "Nickname $Name" > /etc/tor/torrc

# DirPort for Relay
read -p "Enter your desired DirPort: " DirPort
echo "DirPort $DirPort" >> /etc/tor/torrc

# ORPort for Relay
read -p "Enter your desired ORPort: " ORPort
echo "ORPort $ORPort" >> /etc/tor/torrc

# Exit Policy for Relay
echo "By default we do not allow exit policies for Relays (So this content is static.)"
echo "Exitpolicy reject *:*" >> /etc/tor/torrc

# Contact Info for Relay
read -p "Enter your contact info for your Relay: " Info
echo "ContactInfo $Info" >> /etc/tor/torrc

# Restarting Tor service
echo "Restarting the Tor service..."
service tor restart
