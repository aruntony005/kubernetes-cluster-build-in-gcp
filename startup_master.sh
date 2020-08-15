# !/bin/bash
sudo mkdir /root/.ssh
sudo cat /root/startup/private_key > /root/.ssh/id_rsa
sudo cat /root/startup/public_key >> /root/.ssh/authorized_keys
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/id_rsa
sudo chmod 644 /root/.ssh/authorized_keys
i=`cat /etc/ssh/sshd_config | grep -n PermitRootLogin\ no | awk -F: '{print $1}'`
sudo sed -i "$i"d /etc/ssh/sshd_config
i=`cat /etc/ssh/sshd_config | grep -n \#PubkeyAuthentication\ yes | awk -F: '{print $1}'`
sudo sed -i "$i"d /etc/ssh/sshd_config
i=`cat /etc/ssh/sshd_config | grep -n PasswordAuthentication\ no | awk -F: '{print $1}'`
sudo sed -i "$i"d /etc/ssh/sshd_config

sudo echo -e "PermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes" >> /etc/ssh/sshd_config

sudo systemctl restart sshd
sudo sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
sudo setenforce 0

### kubernetes installation ###

sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


sudo yum clean all
sudo yum install -y docker kubelet kubeadm kubectl kubernetes-cni
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start kubelet
sudo systemctl enable kubelet

sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo echo "net.bridge.bridge-nf-call-iptables=1" > /etc/sysctl.d/k8s.conf
sudo swapoff -a &&  sed -i '/ swap / s/^/#/' /etc/fstab
sudo yum install bind-utils -y

sudo kubeadm init > /root/kubeinit
sudo mkdir .kube
sudo cat /etc/kubernetes/admin.conf > .kube/config

sudo cat kubeinit | grep -E 'kubeadm join|--discovery' >> /root/kubeinit.sh
sudo chmod 755 /root/kubeinit.sh
sudo ssh worker < /root/kubeinit.sh
