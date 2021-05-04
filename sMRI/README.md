# Processing of sMRI files

This folder harbours scripts for processing sMRI files

## 1. Preprocessing
Run script preprocess.sh

- Motion-correction (not yet implemented)
- Upsamples inplane 2D anatomical (to 0.68 mm³, file tag/name "desc-hires")
- Creates brain mask (file tag/name "space-T2w_mask")
- Makes symbolic link to point at final file in preprocess pipeline (file tag/name "desc-preproc_T2w" -> final file in pipeline)

## 2. Neonatal segmentation
Run script neonatal-segmentation.sh

This runs DrawEM algorithm on anatomical T2w data.

NOTE: 
- The current parameters from DrawEM in dhcp performs better than DrawEM1p3. To run dhcp's neonatal-segmentation, run script neonatal-segmentation_dhcp-structural-pipeline_only.sh

