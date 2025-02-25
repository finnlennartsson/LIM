#!/bin/bash
# LIM
#
usage()
{
  base=$(basename "$0")
  echo "usage: $base all_labels
Script for generating "labels" and "tissue_labels" from a "all_labels" file 

Arguments:
  all_labels        Edited "all_labels" file 
Options:
  -h / -help / --help           Print usage.
"
  exit;
}

segmentationFile_edit=$1
shift;
while [ $# -gt 0 ]; do
  case "$1" in
	-h|-help|--help) usage; ;;
	-*) echo "$0: Unrecognized option $1" >&2; usage; ;;
	*) break ;;
  esac
  shift
done

# Create new "labels" and "tissue_labels" accordning to "all_labels_edit" (see https://github.com/MIRTK/DrawEM/blob/master/parameters/ALBERT/configuration.sh)
# labels
ALL_LABELS_TO_LABELS="1 51 5 1 52 6 1 53 7 1 54 8 1 55 9 1 56 10 1 57 11 1 58 12 1 59 13 1 60 14 1 61 15 1 62 16 1 63 20 1 64 21 1 65 22 1 66 23 1 67 24 1 68 25 1 69 26 1 70 27 1 71 28 1 72 29 1 73 30 1 74 31 1 75 32 1 76 33 1 77 34 1 78 35 1 79 36 1 80 37 1 81 38 1 82 39 3 83 84 85 0 1 86 42 1 87 43"
segmentationFile_labels_edit=`echo $segmentationFile_edit | sed 's/all\_labels/labels/g'`
echo "Create $segmentationFile_labels_edit"
mirtk padding $segmentationFile_edit $segmentationFile_edit $segmentationFile_labels_edit $ALL_LABELS_TO_LABELS
# tissue labels
ALL_LABELS_TO_TISSUE_LABELS="1 83 1 32 5 6 7 8 9 10 11 12 13 14 15 16 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 2 33 48 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 3 1 84 4 2 49 50 5 2 17 18 6 11 40 41 42 43 44 45 46 47 85 86 87 7 1 19 8 4 1 2 3 4 9"
segmentationFile_tissue_labels_edit=`echo $segmentationFile_edit | sed 's/all\_labels/tissue\_labels/g'`
echo "Create  $segmentationFile_tissue_labels_edit"
mirtk padding $segmentationFile_edit $segmentationFile_edit $segmentationFile_tissue_labels_edit $ALL_LABELS_TO_TISSUE_LABELS
