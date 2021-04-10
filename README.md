# kubernetes-cluster-build

## Preparation

yum install epel-release  
yum install git unzip wget ansible -y  
git clone -b develop https://github.com/aruntony005/kubernetes-cluster-build.git  

wget https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip  
unzip terraform_0.14.9_linux_amd64.zip  
install terraform /usr/local/bin/  
---
The keys and secrets in this repos are encrypted using gpg.
```
gpg --symmetric --cipher-algo AES256 file_name

gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" --output $HOME/secrets/my_secret.json my_secret.json.gpg
```

