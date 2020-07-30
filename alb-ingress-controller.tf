resource "kubernetes_deployment" "alb_ingress_controller" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "alb-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "alb-ingress-controller"
        }
      }

      spec {
        container {
          name  = "alb-ingress-controller"
          image = "docker.io/amazon/aws-alb-ingress-controller:v1.1.8"
          args  = ["--ingress-class=alb", "--cluster-name=devCluster", "--aws-vpc-id=vpc-xxxxxx"]
        }

        service_account_name = "alb-ingress-controller"
      }
    }
  }
}

