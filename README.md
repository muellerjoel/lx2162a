## Ubuntu 22.04 for SolidRun ClearFog LX2162a as a Image
https://drive.google.com/drive/folders/1EKuu6Y7Sct6z43dolX5TYeRq_qsaARR6?usp=sharingdd 
## Extract Image to SD-Card on /dev/sdX
dd if=lx2160acex7_2000_700_3200_LX2162A_CLEARFOG_18_9_0-3fbd680.img of=/dev/sdX bs=4M conv=fdatasync status=progress
## Sync to check if is extracted correctly
sync
## Insert SD-Card in the slot
## Power on
## Press a key innert 10 sec to stop autoboot
### To flash to eMMC run the following commands (it will wipe your data on the eMMC device).
load mmc 0:1 0xa4000000 ubuntu-core.img

mmc dev 1

mmc write 0xa4000000 0 0xd2000
## Boot the Ubuntu 22.04 Image
boot
## Password for login as root
root
## resize eMMC with fdisk
fdisk /dev/mmcblk1
## delete partition
d
## new partion
n
## primary partition
p
## fist partition
1
## start sector
131072
## end sector
Press Enter
## remove signature
n
## write to disk
w
## Finish resizing 
resize2fs /dev/mmcblk0p1
