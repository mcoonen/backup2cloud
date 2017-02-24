#!/bin/bash
SCRIPTVERSION=1.0

version () { echo "backup2cloud.sh version $SCRIPTVERSION"; exit 1; }

# Get CLI arguments
while getopts c:dsv option
do
        case "${option}"
        in
                c) CONFIGFILE=${OPTARG};;
                d) DEBUG=true;;
                s) SIMULATION=true;;
                v) version;;
        esac
done

# Default options
SEPARATE_SUBDIRS=false
LOGDIR="./duplicity-logs"

# Source config file to override default options
if [ ! $CONFIGFILE ]; then
  echo "ERROR: You must specify a config file!"; exit 1;
else
  source $CONFIGFILE
fi

# Check presence of required options
if [ "$SOURCEDIR" == "" ]; then SOURCEDIR="."; fi
if [ "$TARGETDIR" == "" ]; then echo "ERROR: You MUST specify a TARGETDIR in the config file!"; exit 1; fi
if [ "$GPGPASS" == "" ]; then echo "ERROR: You MUST specify a GPG Password in the config file!"; exit 1; fi

################################################
### Conditional prep an array of all subdirs ###
################################################

if [ $SEPARATE_SUBDIRS == "true" ]; then
  #echo "Separate archive for each subfolder"

  # save and change IFS (IFS are the separators, defaults to space, which we have to avoid here)
  OLDIFS=$IFS 
  IFS=$'\n' 
 
  # read all file names into an array
  fileArray=($(find $SOURCEDIR -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))
 
  # restore IFS
  IFS=$OLDIFS
   
else
  #echo "1 large archive"
  fileArray=$(basename $SOURCEDIR)
fi

# get length of an array
tLen=${#fileArray[@]}



########################
### DEBUG STATEMENTS ###
########################
if [ $DEBUG ]; then
  echo "SIMULATION is '${SIMULATION}'"
  echo "GPGPASS is '${GPGPASS}'"
  echo "SOURCEDIR is '${SOURCEDIR}'"
  echo "TARGETDIR is '${TARGETDIR}'"
  echo "SEPARATE_SUBDIRS is '${SEPARATE_SUBDIRS}'"
  echo "LOGDIR is '${LOGDIR}'"
  echo "No. of archives to create is ${tLen}"
  echo "VOLSIZE is ${VOLSIZE}"
  exit 1;
fi

##########################
### Final preparations ###
##########################
TODAY=`date "+%Y-%m-%d"`
DIRNAME=$(basename $SOURCEDIR)
LOGFILE="${LOGDIR}/duplicity_log_${DIRNAME}_${TODAY}.log"

# Check if logdir exists, or create it
if [ ! -d "${LOGDIR}" ]; then
  mkdir -p ${LOGDIR}
fi

 
#################################
### Perform duplicity backup  ###
#################################
echo "Backup job on $TODAY with backup2cloud version $SCRIPTVERSION" > $LOGFILE

for (( i=0; i<${tLen}; i++ ));
do
  echo "============================================================" >> $LOGFILE
  echo "Starting backup for ${fileArray[$i]}" >> $LOGFILE
  echo "" >> $LOGFILE
  if [ ! $SIMULATION ]; then
    PASSPHRASE=${GPGPASS} /usr/bin/duplicity --volsize $VOLSIZE "$SOURCEDIR/${fileArray[$i]}" "${TARGETDIR}/${fileArray[$i]}" >> $LOGFILE
  else
    echo "Simulation run..." >> $LOGFILE
  fi
  echo "" >> $LOGFILE
  echo "Finished backup for ${fileArray[$i]}" >> $LOGFILE
  echo "============================================================" >> $LOGFILE
done

