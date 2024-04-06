# evernode_interactive

https://github.com/jellicoe/evernode_interactive

Evernode Interactive(1)                     User Commands                     Evernode Interactive(1)

NAME

       ./interact.sh - Manage Evernode nodes remotely

SYNOPSIS

       ./interact.sh {restart|status_echo|status_reboot|status|config|push} {all|host #}
       ./interact.sh config [resources|leaseamt|xahaud|xahaud-fallback|email|instance|extrafee] [arguments]

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
              status         Retrieves status information using Evernode's internal status command.
              config         Pushes configuration to /usr/bin/evernode config
              push           Uploads the status check script to each node.
              ssh_key        Uploads your public ssh key to each node to perform ssh commands in this script.

       pattern
              Specifies the target Evernode node(s) to perform the action on. Can be either 'all' to
              target all Evernode nodes, or 'host #' to target a specific Evernode node, where # is the
              node's ID number.

       filename
              The filename of the script or configuration file to be pushed to the Evernode node(s).

EXAMPLES

       Push a configuration to all Evernode nodes using the evernode commands options & required arguments:
              $ ./interact.sh config all [resources|leaseamt|xahaud|xahaud-fallback|email|instance|extrafee] [arguments]

       Check node 07's xahaud-fallback server
              $ ./interact.sh config host 07 xahaud-fallback

       Change node 07's xahaud-fallback server - note use of quotes 
              $ ./interact.sh config host 07 "xahaud-fallback ws://xahau01.yourdomain.io:16006"

       Retrieve status information from a specific Evernode node:
              $ ./interact.sh status_echo host 01

       Reboot all Evernode nodes:
              $ ./interact.sh restart all 

       Get the 'active' status of all Evernode nodes:
              $ ./interact.sh status_echo all 

       Get the 'active' status of a single Evernode node 12:
              $ ./interact.sh status_echo host 12

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
