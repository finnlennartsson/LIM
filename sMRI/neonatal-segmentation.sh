#!/bin/bash
# LIM
#
usage()
{
  base=$(basename "$0")
  echo "usage: $base subjectID age [options]
Script to run the mirtk neonatal-segmentation on sMRI_processed data
Arguments:
  sID				Subject ID (e.g. 108) 
  age				Age at scanning in weeks (e.g. 40)
Options:
  -T2				T2 image to segment (default: derivatives/sMRI/preproc/sub-sID/sub-sID_T2w.nii.gz)
  -m / -mask			mask (default: is no mask) #derivatives/sMRI/preproc/sub-sID/sub-sID_space-T2w_mask.nii.gz)
  -d / -data-dir  <directory>   The directory used to run the script and output the files (default: derivatives/sMRI/neonatal-segmentation/sub-sID)
  -a / -atlas	  		Atlas to use for DrawEM neonatal segmentation (default: ALBERT)    
  -t / -threads  <number>       Number of threads (CPU cores) allowed for the registration to run in parallel (default: 10)
  -h / -help / --help           Print usage.
"
  exit;
}

################ ARGUMENTS ################

[ $# -ge 2 ] || { usage; }
command=$@
sID=$1
age=$2

currdir=`pwd`
T2=derivatives/sMRI/preproc/sub-$sID/sub-${sID}_desc-preproc_T2w.nii.gz
mask="";#mask=derivatives/sMRI/preproc/sub-$sID/sub-${sID}_space-T2w_mask.nii.gz
datadir=derivatives/sMRI/neonatal-segmentation/sub-$sID
threads=10
atlas=ALBERT

# check whether the different tools are set and load parameters
codedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
currdir=`pwd`

shift; shift
while [ $# -gt 0 ]; do
    case "$1" in
	-T2) shift; T2=$1; ;;
	-m|-mask) shift; mask=$1; ;;
	-d|-data-dir)  shift; datadir=$1; ;;
	-t|-threads)  shift; threads=$1; ;;
	-a|-atlas)  shift; atlas=$1; ;; 
	-h|-help|--help) usage; ;;
	-*) echo "$0: Unrecognized option $1" >&2; usage; ;;
	*) break ;;
    esac
    shift
done

echo "Neonatal segmentation using DrawEM
Subject:    $sID 
Age:        $age
T2:         $T2 
Mask:	    $mask 
Directory:  $datadir 
Threads:    $threads
$BASH_SOURCE $command
----------------------------"

# Set up log
script=`basename $BASH_SOURCE .sh`
logdir=$datadir/logs
if [ ! -d $logdir ]; then mkdir -p $logdir; fi


################ PIPELINE ################

# Make sure mirtk neonatal-segmentation is in the path
#source ~/Software/DrawEM/parameters/path.sh

# Update T2 to point to T2 basename
T2=`basename $T2 .nii.gz`

################################################################
## 1. Run neonatal-segmentation
if [ -f $datadir/segmentations/${T2}_all_labels.nii.gz ];then
    echo "Segmentation already run/exists in $datadir"
else
    if [ "$mask" = "" ];then
	# No mask provided
	mirtk neonatal-segmentation $T2 $age -d $datadir -atlas $atlas -p 1 -c 0 -t $threads \
	      > $logdir/sub-${sID}_$script.txt 2>&1;
    else
	# Use provided mask
	mirtk neonatal-segmentation $T2 $age -m $mask -d $datadir -atlas $atlas -p 1 -c 0 -t $threads \
	      > $logdir/sub-${sID}_$script.txt 2>&1;
    fi
fi

cd $currdir




