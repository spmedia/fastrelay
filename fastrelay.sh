#!/bin/bash -
#===============================================================================================================================================
# (C) Copyright 2016 TorWorld (https://torworld.org/) a project under the CryptoWorld Foundation (https://cryptoworld.is).
#
# Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#===============================================================================================================================================
#title			:FastRelay
#description		:This script will make it super easy to run a Tor Relay Node.
#author			:TorWorld A Project Under The CryptoWorld Foundation.
#contributors		:KsaRedFx
#date			:10-06-2016
#version		:0.0.2 Alpha
#os			:Debian/Ubuntu
#usuage			:bash fastrelay.sh
#notes			:If you have any problems feel free to email us: security[at]torworld.org
#===============================================================================================================================================

# Getting Codename of the OS
flavor=`lsb_release -cs`

# Installing dependencies for Tor
read -p "We need to get the dependecies for Tor (y,n) " REPLY

if [ "${REPLY,,}" == "y" ]; then

   echo deb http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list

   echo deb-src http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list

   gpg --keyserver keys.gnupg.net --recv 886DDD89

   gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

fi

# Updating / Upgrading System
read -p "We need to update/upgrade the system (y,n ) " REPLY

if [ "${REPLY,,}" == "y" ]; then

   apt-get update

   apt-get dist-upgrade

fi

# Installing Tor
read -p "Do you want to install Tor? (MAKE SURE YOU'RE 100% SURE ABOUT THIS!) (y,n) " REPLY

if [ "${REPLY,,}" == "y" ]; then

   apt-get install tor
   
   echo "Getting status of Tor.."
   
   service tor status
   
   echo "Stopping Tor service..."
   
   service tor stop

fi

# Customizing Torrc to suit Relay
# Nickname for Relay
read -p "Enter your desired Nickname for your Relay: "  Name
echo "Nickname $Name" > /etc/tor/torrc

# DirPort for Relay
read -p "Enter what port number you want DirPort to look at: " DirPort
echo "DirPort $DirPort" >> /etc/tor/torrc

# ORPort for Relay
read -p "Enter what port number you want ORPort to look at: " ORPort
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
