#!/bin/bash
# Less is More - LIM
#
usage()
{
  base=$(basename "$0")
  echo "usage: $base subjectID [options]
Re-arrangement of raw DICOMs into structured DICOMs
The scripts uses Docker and heudiconv
- Arranges DICOMs into labelled folders (incl renaming of dcm files) into $studyfolder/dicomdir

Arguments:
  sID				  Subject ID (i.e. LIMStudyID) 
Options:
  -DCMfolder   Raw DICOMs (default: $studyfolder/rawdicomdir/sID)
  -h / -help / --help           Print usage.
"
  exit;
}

################ ARGUMENTS ################

[ $# -ge 1 ] || { usage; }
command=$@
sID=$1
shift

# Default 
inputdcmfolder = $rawdcmdir/$sID

# Read arguments
while [ $# -gt 0 ]; do
    case "$1" in
	-DCMfolder  shift; inputdcmfolder=$1; ;;
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
rawdcmdir=$studydir/rawdicomdir;
scriptname=`basename $0 .sh`

# Re-arrange DICOMs into dicomdir
if [ ! -d $dcmdir ]; then mkdir $dcmdir; fi
dcm2niix -b o -r y -w 1 -o $dcmdir -f sub-$sID/s%2s_%d/%d_%5r.dcm $inputdcmfolder
