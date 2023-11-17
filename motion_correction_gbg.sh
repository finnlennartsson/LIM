#!/bin/bash

sID=$1

export PATH=/proj/metrimorphics0/software/niftyseg/build-git/seg-apps:$PATH

. /proj/metrimorphics0/util/prep-svrtk.sh

seg_maths GBG_T2MCRIB_2_tetralith/sub-$1_run-*_T2w.nii.gz -otsu -fill sub-$1-otsu-mask.nii.gz ; 

mv sub-$1-otsu-mask.nii.gz motion_corrected_gbg ; 

reconstruct sub-$1-motion-corrected.nii.gz 1 GBG_T2MCRIB_2_tetralith/sub-$1_run*_T2w.nii.gz --mask motion_corrected_gbg/sub-$1-otsu-mask.nii.gz --packages 2 --with_background --lastIter 0.008 --iteration 2 --svr_only --no_robust_statistics ; 

mv sub-$1-motion-corrected.nii.gz motion_corrected_gbg  
