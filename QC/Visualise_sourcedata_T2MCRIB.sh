#!/bin/bash
# LIM Study
#
usage()
{
  base=$(basename "$0")
  echo "usage: $base sID [options]
Simple script to visualize anatomy NII-images BIDS folder (sourcedata/sub-\$sID/anat) in order to do QC of sourcedata 
Arguments:
  sID    Subject ID   (e.g. 2001) 
Options:
  -anatfolder		BIDS dwi folder location (default: $studyfolder/sourcedata/sub-\$s/anat)
  -h / -help / --help	Print usage.
"
  exit;
}

#Defaults

[ $# -ge 1 ] || { usage; }
command=$@
sID=$1

studyfolder=$PWD
anatfolder=$studyfolder/sourcedata/sub-$sID/anat

shift
while [ $# -gt 0 ]; do
    case "$1" in
	-anatfolder) shift; anatfolder=$1; ;;
	-h|-help|--help) usage; ;;
	-*) echo "$0: Unrecognized option $1" >&2; usage; ;;
	*) break ;;
    esac
    shift
done

##############################################
# START

cd $anatfolder

files=`ls sub-${sID}_run*T2w.nii.gz*`
echo
echo "Subject: $sID"
echo "All files: $files"
for file in $files; do
    echo -e "\n$file"
	mrview $file -mode 2; 
done

cd $studyfolder
