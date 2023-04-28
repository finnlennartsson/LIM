#!/bin/bash
# LIM
#
usage()
{
  base=$(basename "$0")
  echo "usage: $base sID [options]
Conversion of DICOMs to BIDS and BIDS-validation of BIDS dataset
The scripts uses Docker for heudiconv and BIDS-validator 
- DICOMs are expected to be in "studydir"/dicomdir/sub-sID
- Heuristics-file gbg_lim_heuristic.py is in code-subfolder "codedir"/heudiconv_heuristics
- NIfTIs are written into a BIDS-organised folder "studydir"/sourcedata (SIC!)

Arguments:
  sID				Subject ID (i.e. LIMStudyID) 
Options:
  -h / -help / --help           Print usage.
"
  exit;
}

################ ARGUMENTS ################

[ $# -ge 1 ] || { usage; }
command=$@
sID=$1

# Define Folders
codedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
studydir=`pwd` #studydir=`dirname -- "$codedir"`
sourcedatadir=$studydir/sourcedata;
dcmdir=$studydir/dicomdir;
logdir=${studydir}/derivatives/preprocessing_logs/sub-${sID}
scriptname=`basename $0 .sh`

if [ ! -d $sourcedatadir ]; then mkdir -p $sourcedatadir; fi
if [ ! -d $logdir ]; then mkdir -p $logdir; fi

# We place a .bidsignore here
if [ ! -f $sourcedatadir/.bidsignore ]; then
echo -e "# Exclude following from BIDS-validator\n" > $sourcedatadir/.bidsignore;
fi

# we'll be running the Docker containers as yourself, not as root:
userID=$(id -u):$(id -g)

###   Get docker images:   ###
docker pull nipy/heudiconv:latest
docker pull bids/validator:latest

###   Extract DICOMs into BIDS:   ###
# The images were extracted and organized in BIDS format:

docker run --name heudiconv_container \
           --user $userID \
           --rm \
           -it \
           --volume $studydir:/base \
	   --volume $codedir:/code \
           --volume $dcmdir:/dataIn:ro \
           --volume $sourcedatadir:/dataOut \
           nipy/heudiconv \
               -d /dataIn/sub-{subject}/*/*.dcm \
               -f /code/heudiconv_heuristics/gbg_lim_heuristic.py \
               -s ${sID} \
               -c dcm2niix \
               -b \
               -o /dataOut \
               --overwrite \
           > ${logdir}/sub-${sID}_$scriptname.log 2>&1 
           
# heudiconv makes files read only
#    We need some files to be writable, eg for dHCP pipelines
chmod -R u+wr,g+wr $sourcedatadir


# We run the BIDS-validator:
docker run --name BIDSvalidation_container \
           --user $userID \
           --rm \
           --volume $sourcedatadir:/data:ro \
           bids/validator \
               /data \
           > ${studydir}/derivatives/bids-validator_report.txt 2>&1
           #> ${logdir}/bids-validator_report.txt 2>&1                   
           # For BIDS compliance, we want the validator report to go to the top level of derivatives. But for debugging, we want all logs from a given script to go to a script-specific folder
           
