#!/bin/bash

source config.cfg

# Check atleast 3 arguments are given #
if [ $# -lt 2 ]
then
        echo "Usage : $0 option pattern filename"
        echo "Option: {restart|status_echo|status_reboot|status|config|push|ssh_key} {all|host #}"
        echo "config [resources|leaseamt|xahaud|xahaud-fallback|email|instance|extrafee] [arguments]"
        exit
fi

#from terminal command
COMMAND=$1
ALL_OR_HOST=$2

do_ssh() {

#from do_ssh args
local hostie=$1

case $COMMAND in

restart)
    echo "Restarting : $hostie";
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "shutdown -r now"
;;

status_echo)
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "bash -s < /root/scripts/check_status.sh"
    ;;

status_reboot)
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "bash -s < /root/scripts/check_status.sh reboot"
    ;;

status) 
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "bash -s < /usr/bin/evernode status"
;;

list) 
    echo "Instances running on node $hostie" 
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "bash -s < /usr/bin/evernode list"
;;

config) 
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "bash -s < /usr/bin/evernode config $CONFIG_COMMANDS"
;;

push)
    echo "connecting to: $hostie";
    # StrictHostKeyChecking auto adds ssh fingerprint with out asking
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "rm -rf /root/scripts"
    ssh -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY root@$hostie "mkdir /root/scripts"
    scp -o "StrictHostKeyChecking no" -i $SSH_PRIVATE_KEY ./scripts/*.sh root@$hostie:/root/scripts
;;

ssh_key)
    echo "uploading public key to node $hostie" 
    ssh-copy-id -i $SSH_PUBLIC_KEY $hostie

esac

}


case $ALL_OR_HOST in

all)
    CONFIG_COMMANDS=$3
    for ((i=1; i<$NUMBER_OF_NODES+1; i++))
    do
        if (( i < 10 )); then
            #pad myhostname with "0" for first 9 hosts 01-09
            MYHOST=$MYHOSTNAME"0"$i.$MYDOMAIN
        else
            #for nodes from 10 to 999 or more
            MYHOST=$MYHOSTNAME$i.$MYDOMAIN
        fi
        #echo $MYHOST
        do_ssh $MYHOST
    done
;;

host)
    CONFIG_COMMANDS=$4
    #$3 is the HOSTS ID Number 01-20 from commandline ''./interact status host 01'
    MYHOST=$MYHOSTNAME$3.$MYDOMAIN
    do_ssh $MYHOST
;;
esac


