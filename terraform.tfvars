project_id = "prefab-breaker-276312"

master_machine_type = "n1-standard-2"
master_image = "centos-cloud/centos-8"
vpc_network = "default"

worker_machine_type = "n1-standard-2"
worker_image = "centos-cloud/centos-8"

instance_group_name = "kube-cluster-mig"
base_instance_name = "kube"

zone = "us-central1-a"

cluster_size = 3


