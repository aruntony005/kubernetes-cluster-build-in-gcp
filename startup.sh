#!/bin/bash


sudo mkdir /root/.ssh
sudo curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/public_key | base64 -d > /root/.ssh/public_key.gpg
sudo curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/private_key | base64 -d > /root/.ssh/private_key.gpg

gpg --quiet --batch --yes --decrypt --passphrase="aruntony" --output /root/.ssh/authorized_keys /root/.ssh/public_key.gpg

gpg --quiet --batch --yes --decrypt --passphrase="aruntony" --output /root/.ssh/id_rsa /root/.ssh/private_key.gpg

rm -rf /root/.ssh/public_key.gpg /root/.ssh/private_key.gpg

sudo sed -i '/PasswordAuthentication/d;/PermitRootLogin/d;/PubkeyAuthentication/d' /etc/ssh/sshd_config
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/id_rsa
sudo chmod 644 /root/.ssh/authorized_keys
sudo systemctl restart sshd
sudo echo -e "PermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes" >> /etc/ssh/sshd_config
sudo systemctl restart sshd
