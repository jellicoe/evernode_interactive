# evernode_interactive

https://github.com/jellicoe/evernode_interactive

Evernode Interactive(1)                     User Commands                     Evernode Interactive(1)

NAME

       ./interact.sh - Manage Evernode nodes remotely

SYNOPSIS

       ./interact.sh {list|restart|status_echo|status_reboot|status|config|push|ssh_key|server_reboot|apt_upgrade|release|offerlease} {all|host #}
       ./interact.sh config {all|host #} [resources|leaseamt|xahaud|xahaud-fallback|email|instance|extrafee] [arguments]

       -NOTE: config resources not yet configured to set changes.

DESCRIPTION

       ./interact.sh is a bash script designed to manage Evernode nodes remotely. It allows users
       to push configurations to remote nodes and execute commands on them to check their health,
       perform reboots, or retrieve status information.

       This script is based on nodes named consistently from 01 to 999 or more, and just issuing the command to the hosts number

       host01.domain.com
       ...
       host999.domain.com

       Copy config.cfg.sample to config.cfg and change the following fields to your deployment.

       MYHOSTNAME="yourhostsname"
       MYDOMAIN="yourdomain.com"
       NUMBER_OF_NODES="999"
       SSH_PRIVATE_KEY="/root/.ssh/id_rsa"
       SSH_PUBLIC_KEY="/root/.ssh/id_rsa.pub"

       This script assumes you have uploaded your public ssh key to each node during build time. 
       
       If not use the ssh_key command to copy the key to your node:

       $ ./interact.sh ssh_key host 21
       or
       $ ./interact.sh ssh_key all


OPTIONS

       option
              Specifies the action to perform. Valid options are:
              restart        Reboots the specified Evernode nodes.
              status_echo    Retrieves status information from the specified Evernode nodes.
              status_reboot  Retrieves status information and initiates a reboot if 'inactive'.
              server_reboot  Checks your VPS Server OS /run/motd.dynamic file for "restart" command advise and reboots.
              status         Retrieves full status information using Evernode's internal status command.
              list           List active instances running on each node.
              release        Will do "config resources 0 0 0 3" if all leases are used and reputation is 0.
              offerlease     Normal Offerlease command.
              config         Pushes configuration to /usr/bin/evernode config
              push           Uploads the status check script to each node. 
                             (Run this for status_echo and status_reboot commands to work)
              ssh_key        Uploads your public ssh key to each node to perform ssh commands in this script.

       pattern
              Specifies the target Evernode node(s) to perform the action on. Can be either 'all' to
              target all Evernode nodes, or 'host #' to target a specific Evernode node, where # is the
              node's ID number.

       filename
              The filename of the script or configuration file to be pushed to the Evernode node(s).

EXAMPLES

       Push the check_status script to your nodes to run status_echo and status_reboot commands
               $ ./interact.sh push all
               $ ./interact.sh push host 02

       Push a configuration to all Evernode nodes using the evernode commands options & required arguments:
              $ ./interact.sh config all [resources|leaseamt|xahaud|xahaud-fallback|email|instance|extrafee] [arguments]

              - note 'resources' not implemented yet.

       Check node 07's xahaud-fallback server
              $ ./interact.sh config host 07 xahaud-fallback

       Change node 07's xahaud-fallback server - note use of quotes 
              $ ./interact.sh config host 07 "xahaud-fallback ws://xahau01.yourdomain.io:16006"

       Change node 20's Lease Amount to 0.0001
              $ ./interact.sh config host 20 leaseamt 0.0001

       Change all node's Lease Amount to 0.002 - note this will only change nodes not already set, as teh evernode command checks this
              $ ./interact.sh config all leaseamt 0.002

       Retrieve status information from all or a specific Evernode node:
              $ ./interact.sh status_echo all
              $ ./interact.sh status_echo host 01

       Retrieve status information from all or a specific Evernode node, reboot if inactve:
              $ ./interact.sh status_reboot all
              $ ./interact.sh status_reboot host 01

       Reboot all Evernode nodes:
              $ ./interact.sh restart all
              $ ./interact.sh restart host 02 

       Reboot server if your VPS MOTD advises a restart in /run/motd.dynamic*
              $ ./interact.sh server_reboot all
              $ ./interact.sh server_reboot host 01


AUTHOR

       Written by Jellicoe
       Modified scripts/check_status.sh by justme_roms from Evernode Community Discord

REPORTING BUGS

       Report any bugs to Jellicoe on Discord Evernode Community.

SEE ALSO

       ssh(1), shutdown(8)

COPYRIGHT

       This script is released under the MIT License.

Evernode Interactive(1)                     User Commands                     Evernode Interactive(1)
