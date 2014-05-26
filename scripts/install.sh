#! /bin/bash
# Install-Script, run as root
echo "Don't forget to add /mnt to your fstab or change the paths in the scripts."
echo "Installing.."

cp dashcam_init /etc/init.d/dashcam
chmod 755 /etc/init.d/dashcam
cp dashcam /mnt/
chmod +x /mnt/dashcam
update-rc.d dashcam defaults
mkdir /mnt/stream /mnt/perm
echo "All done."
