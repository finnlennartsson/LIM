This folder contains scripts that uses [heudiconv](https://heudiconv.readthedocs.io/en/latest/) to convert DICOMs into [BIDS-format](https://bids-specification.readthedocs.io/en/stable/) NIfTIs

- DICOMs are expected to be in `"studyfolder"/dicomdir` (or optionally in "raw format" in `"studyfolder"/rawdicomdir`)
- Heuristics-files are located in code-subfolder `bids/heudiconv_heuristics`
- NIfTIs are written into a BIDS-organised folder `"studyfolder"/sourcedata` (SIC!)

## Running the conversion from DCM to NIfTI BIDS
This can be done by either in a two-step conversion `rawdicomdir => dicomdir => sourcedata` or directly `rawdicomdir => sourcedata`.  

If the DCMs are stored in a non-organised fashion (e.g. a exported from MR-scanner or SECTRA PACS), they should live in `"studydir"/rawdicomdir`. 

If the DCMs are stored in an organised human-readable fashion (e.g. after `DCMrawdicomdir_to_DCMdicomdir.sh`) they should live in `"studydir"/dicomdir`. 

### Two-step conversion 
1. Run script `DCMrawdicomdir_to_DCMdicomdir.sh`  
This uses `dcm2niix` to rename and reorder the DCMs into human-readable form in `"studydir"/dicomdir`.
2. Run script `DCMdicomdir_to_BIDSsourcedata.sh`  
This uses a [docker](https://www.docker.com/)-invoked call of [heudiconv](https://heudiconv.readthedocs.io/en/latest/) to convert DCMs in `"studydir"/dicomdir` into BIDS-organised NIfTIs in `"studydir"/sourcedata` (SIC!) with heuristics-files (governing the rules for the conversion)  located in code-subfolder `bids/heudiconv_heuristics`.

### Direct conversion  
1. Run script `DCMrawdicomdir_to_BIDSsourcedata.sh`  
This makes a conversion straight from non-organized DCMs in `"studydir"/rawdicomdir` to BIDS-organized NIfTIs in `"studydir"/sourcedata` (SIC!).  
The script uses the same [docker](https://www.docker.com/)-invoked call of [heudiconv](https://heudiconv.readthedocs.io/en/latest/) to convert DCMs in `"studydir"/rawdicomdir` into BIDS-organised NIfTIs in `"studydir"/sourcedata` (SIC!) with heuristics-files (governing the rules for the conversion)  located in code-subfolder `bids/heudiconv_heuristics`.  
The conversion assumes that there is a certain organisation of the DCMs given the call
https://github.com/finnlennartsson/LIM/blob/a2b0fa4523d35bd4abcc57a4d5190dd960f21c8c/bids/DCMrawdicomdir_to_BIDSsourcedata.sh#L63

## Resources
BIDS format: https://bids-specification.readthedocs.io/en/stable/

Heudiconv: https://heudiconv.readthedocs.io/en/latest/
