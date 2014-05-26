#! /bin/bash
# Install-Script, run as root
echo "Don't forget to add /mnt to your fstab or change the paths in the scripts."
echo "Installing.."

cp dashcam_init /etc/init.d/dashcam
chmod 755 /etc/init.d/dashcam
cp dashcam.sh /mnt/dashcam
cp server.sh /mnt/server
chmod +x /mnt/dashcam /mnt/server
update-rc.d dashcam defaults

cp conf.sample.cfg /etc/dashcam.cfg
source /etc/dashcam.cfg

mkdir "$VIDEO_PATH" "$PERMANENT_PATH"

echo "All done. Check /mnt for the scripts and /etc/dashcam.cfg for configuration."
echo "Keep in mind: Your Raspberry Pi will start recording on boot. You can stop the service anytime running /etc/init.d/dashcam stop"
