provider "google" {
 credentials = "${file("keybernetes-key.json")}"
 project     = "prefab-breaker-276312"
 region      = "us-west1"
}



resource "google_compute_instance_template" "master" {
  name        = "master-template"

  tags = ["master"]

  labels = {
    role = "master"
  }

  machine_type         = "n1-standard-2"

  disk {
    source_image      = "centos-cloud/centos-8"
    auto_delete       = false
    boot              = true
  }

  network_interface {
    network = "default"
  }

  metadata = {
    role = "master"
  }

}



resource "google_compute_instance_template" "worker" {
  name        = "worker-template"
  
  tags = ["worker"]

  labels = {
    role = "worker"
  }

  machine_type         = "n1-standard-2"

  disk {
    source_image      = "centos-cloud/centos-8"
    auto_delete       = false
    boot              = true
  }

  network_interface {
    network = "default"
  }

  metadata = {
    role = "worker"
  }

}


resource "google_compute_instance_group_manager" "appserver" {
  name = "kube-cluster"
  base_instance_name = "kube"
  zone               = "us-central1-a"
//  wait_for_instances = "true"

  version {
    name = "worker"
    instance_template  = google_compute_instance_template.worker.id
  }

  version {
    name = "master"
    instance_template  = google_compute_instance_template.master.id
    target_size {
      fixed = 1
    }
  }

  target_size  = 2
}


