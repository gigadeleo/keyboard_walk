# keyboard_walk
A host discovery and password bruteforce-over-SSH tool, by gigadeleo.

Follow [@gigadeleo](https://twitter.com/gigadeleo) on Twitter.

Installation Notes:
----------------------------------------------

To run this tool you need to do the following:

  1. Copy 'keyboard_walk.sh' file to a Linux host of your choice.
  2. Give 'keyboard_walk.sh' execute rights.
  3. Copy 'subnets' in the same directory; 'subnets' is a list of CIDR Subnet Mask notation IPs (such as: 10.0.0.0/24) for host discovery.
  4. Copy 'unames' in the same directory; 'unames' is a list of possible usernames to try.
  5. Copy 'pwords' in the same directory; 'pwords' is a list of possible passwords to try.

The script expects four (4) arguments:

  1. [FILE] subnet file
  2. [FILE] username file
  3. [FILE] password file
  4. [FLAG] Force Rescan Flag (0 to force host-discovery (longer); 1 to use previously identified hosts (quicker but less accurate)).
    
Usage Example:
  ```sh
  ./keyboard_walk.sh subnets unames pwords 0
  ```
  
The script requires 2 tools:
  1. nmap - for host discovery  
  2. medusa - for password bruteforcing
  
Script in Detail:
----------------------------------------------

The script will perform the following: 

  1. Check whether all necessary files are available.
  2. Extract the subnets file and attempt to find live hosts by using a very fast nmap scan on the SSH Port (tcp/22), all extracted files are persistently stored  to a 'livehost_list' file (for future use). 
  3. Attempt a brutefore attack of username/password combinations on all live hosts.
  4. Report results in the log subdirectory

-----------------------------------------------
