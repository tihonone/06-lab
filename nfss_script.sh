#!/bin/bash
yum install nfs-utils -y

systemctl enable firewalld --now

#systemctl status firewalld
sed -i -e '$a\
[nfsd]\
udp=y\
vers3=y' /etc/nfs.conf
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent
firewall-cmd --reload
systemctl enable nfs --now

#check for /etc/nfs.conf & uncomment section [nfsd] and lines und & vers3=y
#ss -tnplu
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
cat << EOF > /etc/exports
/srv/share 192.168.50.11/32(rw,sync,root_squash)
EOF
exportfs -r
#exportfs -S