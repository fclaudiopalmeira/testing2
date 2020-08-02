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
          args  = ["--ingress-class=alb", "--cluster-name=${var.cluster-name}", "--aws-vpc-id=${var.vpc_id}"]
        }

        service_account_name = "alb-ingress-controller"
      }
    }
  }
  depends_on = [
    aws_eks_cluster.observ-sec-eks,
    aws_eks_node_group.observ-sec-eks-node-group,
  ]
}

