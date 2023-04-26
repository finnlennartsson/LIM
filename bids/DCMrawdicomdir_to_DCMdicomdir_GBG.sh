#!/bin/bash
# Less is More - LIM
# To be used with GBG data
#
usage()
{
  base=$(basename "$0")
  echo "usage: $base DCMfolder sID [options]
Re-arrangement of raw DICOMs into structured DICOMs
The scripts uses dcm2niix
- Arranges DICOMs into labelled folders (incl renaming of dcm files) into $studydir/dicomdir
- Basename of input DCM-folder is preserved, i.e. output is $studydir/dicomdir/"DCMfolder"

Arguments:
  DCMfolder                     Folder with Raw DICOMs (path to DCM-folder, e.g. $studydir/rawdicomdir/615)
  sID                           Subject ID (i.e. LIMStudyID) 
Options:
  -h / -help / --help           Print usage.
"
  exit;
}

################ ARGUMENTS ################

[ $# -ge 1 ] || { usage; }
command=$@
DCMfolder=$1
sID=$2
shift; shift;

baseDCMfolder=`basename $DCMfolder`

# Read arguments
while [ $# -gt 0 ]; do
    case "$1" in
	-h|-help|--help) usage; ;;
	-*) echo "$0: Unrecognized option $1" >&2; usage; ;;
	*) break ;;
    esac
    shift
done

# Define Folders
codedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
studydir=`pwd` #studydir=`dirname -- "$codedir"`
dcmdir=$studydir/dicomdir;

# Re-arrange DICOMs into dicomdir
if [ ! -d $dcmdir ]; then mkdir $dcmdir; fi
dcm2niix -b o -r y -w 1 -o $dcmdir -f sub-$sID/s%2s_%d/%d_%5r.dcm $DCMfolder
