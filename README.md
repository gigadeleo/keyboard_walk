# keyboard_walk
A minimalist host discovery and password bruteforce-over-SSH tool, by gigadeleo.

Follow @gigadeleo on Twitter.

----------------------------------------------
INSTALLATION NOTES:
----------------------------------------------

  1) Copy 'keyboard_walk.sh' file to a Linux host of your choice.
  
  2) Give 'keyboard_walk.sh' execute rights.
  
  3) Copy 'subnets' in the same directory; 'subnets' is a list of CIDR Subnet Mask notation IPs (such as: 10.0.0.0/24) for host discovery
  
  4) Copy 'unames' in the same directory; 'unames' is a list of possible usernames to try.
  
  5) Copy 'pwords' in the same directory; 'pwords' is a list of possible passwords to try.
  

  The script expects four (4) arguments:
    1) subnet file
    
    2) username file
    
    3) password file
    
    4) Force Rescan Flag (0 to force host-discovery; 1 to use previously identified hosts)
    
  Usage Example:
    ./keyboard_walk.sh subnets unames pwords 0
    
----------------------------------------------
