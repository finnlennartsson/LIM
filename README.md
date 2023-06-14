# Less is More - LIM
These are [dHCP](http://www.developingconnectome.org/project) inspired processing pipelines for neonatal MRI data.

This repository can go inside the /code folder within of a [BIDS](https://bids.neuroimaging.io/) `"studyfolder"`.

The data is organized in the same way as the [2nd data release](https://drive.google.com/file/d/197g9afbg9uzBt04qYYAIhmTOvI3nXrhI/view) for the dHCP and expects the NIfTI sourcedata files to be located in the BIDS folder `/sourcedata` (SIC!). 

Processed data/Processing pipelines store results in `/derivatives`

The processing pipelines and processing scripts are organised as followed: 

## Data organisation in /bids
To organise the data in BIDS datastructure format

## Structural pipeline in /sMRI
To process the sMRI data within the framework of the [dhcp-structural-pipeline](https://github.com/BioMedIA/dhcp-structural-pipeline).
These includes neonatal segmentation with DrawEM and surface generation and analysis. 

NOTE - current version of [DrawEM version 1.3](https://github.com/MIRTK/DrawEM) has incorporated optional segmentation according to the [M-CRIB_2.0 atlas](https://osf.io/4vthr/)

## Labels for sMRI data in /label_names
Various LUTs for anatomical parcellations for the ALBERTs and M-CRIB atlases.
Also for conversions into MRtrix's 5TT format.
