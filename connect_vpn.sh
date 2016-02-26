#!/bin/bash
set -e
if [[ $# < 1 ]]; then
    echo "./connect_vpn.sh connect server username password"
    echo "./connect_vpn.sh tunnel"
    exit -1
fi

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

case $1 in
    connect)
    echo "Connecting to VPN host..."
    echo "## After the VPN is set up, (displaying Connected tun0 as XX.XXX.XXX.XX, using SSL)" 
    echo "## hit CTRL-Z to be able to route the traffic by calling this script with tunnel parameter:"
    echo "## using ./connect_vpn.sh tunnel"
    echo "##"
    openconnect -u $3 --passwd-on-stdin $2 <<< $4	
    ;;
    tunnel)
    echo "Setting up tunnel through VPN"
    ip route replace default via 0.0.0.0 dev tun0	
    echo "## Route replaced, all traffic going trhough the VPN tunnel."
    echo "## If you used CTRL-Z earlier, you should now go back to Openconnect." 
    echo "## To bring it back, type: fg [ENTER]"
    echo "##"
    ;;
    *)
    echo "Invalid Parameter."
    exit -1
    ;;
esac
