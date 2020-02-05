
variable "endpoint" {}
variable "cer" {}
variable "cluster-name" {}

#variable "url" {}
variable "POD_REPLICAS" {}
data "aws_eks_cluster" "ddemo" {
  name = "${var.cluster-name}"
}
data "aws_eks_cluster_auth" "eksauth" {
  name = "${var.cluster-name}"
}
provider "kubernetes" {
  host                   = "${var.endpoint}"
  cluster_ca_certificate = "${base64decode(var.cer)}"
  token                  = "${data.aws_eks_cluster_auth.eksauth.token}"
  load_config_file       = false
}
resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "myapp"
    labels = {
      test = "myapp"
    }
  }

  spec {
    replicas = "${var.POD_REPLICAS}"

    selector {
      match_labels = {
        test = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          test = "myapp"
        }
      }

      spec {
        container {
      #    image = "${aws_ecr_repository.myapp.repository_url}:latest"
          image = "nagamalli/webapp1:latest"
          name  = "webapp"
           port {
                container_port = 3000
              }
              port {
                container_port = 80
              }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
              
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "appserv" {
  metadata {
    name = "webappserv"
  }
  spec {
    selector = {
      test = "myapp"
    }
    port {
      port = 3000
      target_port = 3000
    }

    type = "NodePort"
   
  }
}



resource "kubernetes_deployment" "apis" {
  metadata {
    name = "apis"
    labels = {
      app = "apis"
    }
  }

  spec {
    replicas = "${var.POD_REPLICAS}"

    selector {
      match_labels = {
        app = "apis"
      }
    }

    template {
      metadata {
        labels = {
          app = "apis"
        }
      }

      spec {
        container {
        #  image = "${aws_ecr_repository.myapp.repository_url}:latest"
         image = "nagamalli/microsvs1:latest"
          name  = "apis"
           port {
                container_port = 4000
              }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
              
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "apiserv" {
  metadata {
    name = "mymicrosrv"
  }
  spec {
    selector = {
      app = "apis"
    }
    port {
      port = 4000
      target_port = 4000
    }

    type = "ClusterIP"
    
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name = "mongo"
    labels = {
      db = "mongo"
    }
  }

  spec {
    replicas = "${var.POD_REPLICAS}"

    selector {
      match_labels = {
        db = "mongo"
      }
    }

    template {
      metadata {
        labels = {
          db = "mongo"
        }
      }

      spec {
        container {
        #  image = "${aws_ecr_repository.myapp.repository_url}:latest"
         image = "mongo:latest"
          name  = "mongo"
           port {
                container_port = 27017
              }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
              
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongoerv" {
  metadata {
    name = "mongosrv"
  }
  spec {
    selector = {
      db = "mongo"
    }
    port {
      port = 27017
      target_port = 27017
    }

    type = "ClusterIP"
    
  }
}



