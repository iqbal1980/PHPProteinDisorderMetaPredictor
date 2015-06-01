sudo umount tmpfs
mkdir -p /tmp/ram
sudo mount -t tmpfs -o size=50M tmpfs /tmp/ram/
cp -d -r /usr/share/nginx/html/idpdemo/predictorsbin/* /tmp/ram
sudo touch /tmp/ram/VSL2

