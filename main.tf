provider "google" {
 credentials = "${file("keybernetes-key.json")}"
 project     = "prefab-breaker-276312"
 region      = "us-west1"
}


resource "google_compute_instance" "master_vm_instance" {
 name         = "master"
 machine_type = "n1-standard-4"
 zone         = "us-west1-a"

 tags = ["cm"]

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7"
     type = "pd-standard"
     size = "20"
   }
 }

 metadata_startup_script = "sudo sed -i 's #baseurl =/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo;sudo mkdir /root/startup/;sudo yum install git -y ;sudo git clone https://github.com/aruntony005/kubernetes-cluster-build.git /root/startup/; chmod -R 755 /root/startup; sh /root/startup/startup_master.sh"

 network_interface {
   network = "default"
   access_config {

 }
}
}

resource "google_compute_instance" "worker_vm_instance" {
 name         = "worker"
 machine_type = "n1-standard-2"
 zone         = "us-west1-a"

 tags = ["cm"]

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7"
     type = "pd-standard"
     size = "20"
   }
 }
 metadata_startup_script = "sudo sed -i 's #baseurl =/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo;sudo mkdir /root/startup/;sudo yum install git -y ;sudo git clone https://github.com/aruntony005/kubernetes-cluster-build.git /root/startup/; chmod -R 755 /root/startup; sh /root/startup/startup_worker.sh"
 
 network_interface {
   network = "default"
   access_config {

 }
}
}
