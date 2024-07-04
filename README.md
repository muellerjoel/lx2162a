## Ubuntu 22.04 for SolidRun ClearFog LX2162a as a Image
https://drive.google.com/drive/folders/1EKuu6Y7Sct6z43dolX5TYeRq_qsaARR6?usp=sharingdd 
## Extract Image to SD-Card on /dev/sdX
dd if=lx2160acex7_2000_700_3200_LX2162A_CLEARFOG_18_9_0-3fbd680.img of=/dev/sdX bs=4M conv=fdatasync status=progress
## Sync to check if is extracted correctly
sync
