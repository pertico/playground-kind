terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.13.0"
    }
  }
}

# Configure the Kind Provider
provider "kind" {}

# Create a cluster
resource "kind_cluster" "cluster" {
    name  = "playground"
    node_image = "kindest/node:v1.37.0"
    wait_for_ready = true
    kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"
      node {
          role = "control-plane"
          kubeadm_config_patches = [
              "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
          ]
          extra_port_mappings {
              container_port = 80
              host_port      = 80
          }
          extra_port_mappings {
              container_port = 443
              host_port      = 443
          }
      }
      node {
          role = "worker"
      }    
      node {
          role = "worker"
      }
    }  
}