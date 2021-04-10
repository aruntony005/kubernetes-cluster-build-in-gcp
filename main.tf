provider "google" {
 credentials = "${file("kubernetes-key.json")}"
 project     = var.project_id
 region      = "us-west1"
}

locals {
  public_key = "${filebase64("public_key.gpg")}"
  private_key = "${filebase64("private_key.gpg")}"
}

resource "google_compute_instance_template" "master" {
  name        = "master-template"

  tags = ["master"]

  labels = {
    role = "master"
  }

  machine_type         = var.master_machine_type

  disk {
    source_image      = var.master_image
    auto_delete       = false
    boot              = true
  }

  network_interface {
    network = var.vpc_network 
    access_config {
    }
  }

  metadata = {
    role = "master",
    mig_name = var.instance_group_name
    public_key = "${local.public_key}"
    private_key = "${local.private_key}"
  }

  metadata_startup_script = "${file("startup.sh")}"
}



resource "google_compute_instance_template" "worker" {
  name        = "worker-template"
  
  tags = ["worker"]

  labels = {
    role = "worker"
  }

  machine_type         = var.worker_machine_type

  disk {
    source_image      = var.worker_image
    auto_delete       = false
    boot              = true
  }

  network_interface {
    network = var.vpc_network
    access_config {
    }
  }


  metadata = {
    role = "worker",
    mig_name = var.instance_group_name
    public_key = "${local.public_key}"
    private_key = "${local.private_key}"
  }

  metadata_startup_script = "${file("startup.sh")}"
}


resource "google_compute_instance_group_manager" "appserver" {
  name = var.instance_group_name
  base_instance_name = var.base_instance_name 
  zone               = var.zone

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

  target_size  = var.cluster_size
}
