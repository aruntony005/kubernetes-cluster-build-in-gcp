
mkdir /root/.ssh
curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/public_key > /root/.ssh/authorized_keys
curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/private_key > /root/.ssh/id_rsa
sudo sed -i '/PasswordAuthentication/d;/PermitRootLogin/d;/PubkeyAuthentication/d' /etc/ssh/sshd_config
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/id_rsa
sudo chmod 644 /root/.ssh/authorized_keys
sudo systemctl restart sshd
sudo echo -e "PermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes" >> /etc/ssh/sshd_config

