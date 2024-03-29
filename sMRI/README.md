# Processing of sMRI files

This folder harbours scripts for processing sMRI files

## 1. Conversion from DICOM to NIfTI
- Using DCMrawdicomdir_to_BIDSsourcedata.sh
- Visual inspection of images

## 2. Preprocessing
Run script preprocess.sh

- Motion-correction (not yet implemented)
- Upsamples inplane 2D anatomical (to 0.68 mm³, file tag/name "desc-hires")
- Creates brain mask (file tag/name "space-T2w_mask")
- Makes symbolic link to point at final file in preprocess pipeline (file tag/name "desc-preproc_T2w" -> final file in pipeline)

![Screenshot (61)](https://user-images.githubusercontent.com/80758491/227244469-068f382c-0857-4683-a686-454c817121fe.png)



## 3. Neonatal segmentation
Run script neonatal-segmentation.sh

This runs DrawEM algorithm on anatomical T2w data.

NOTE: 
- The current parameters from DrawEM in dhcp performs better than DrawEM1p3. To run dhcp's neonatal-segmentation, run script neonatal-segmentation_dhcp-structural-pipeline_only.sh

![image](https://user-images.githubusercontent.com/80758491/227246242-cc0cdd3b-7d2f-421c-8953-2df15188a288.png)


## 4. Quality assurance and editing
Run the command itksnap on the acquired neonatal segmentation
- Visual assurance that the segementation is accurate with no glaring mistakes that would affect the volumetry results
- In the case of larger mistakes (e.g. big areas of CSF labeled as brain tissue), editing is done using manual or semi-automatic (mainly voxel-based) methods. Example below with ventricular correction:

![image](https://user-images.githubusercontent.com/80758491/227248214-9f1ce0e1-d08f-4802-bee6-1b8cf41f4445.png)






## 5. Volumetry
Run the scripts Gray_White_Hippocampus_Thalamus_Extractor.sh and then Volume_calculator.sh
- Creates labels with these structures of interest based on the previously obtained segmentations (based on the command fslmaths)
- Volume calculation where the structures are quantified based on the command fslstats -V. Alternatively, itksnap can be used where it displays the volumes visually in the program (concordance of results between itksnap and fsleyes command upon inspection). 
