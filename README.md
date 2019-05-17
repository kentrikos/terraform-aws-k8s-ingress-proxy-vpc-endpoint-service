# A Terraform module to deploy proxy solution for Kubernetes ingress based on NLB and VPC Endpoint Service

This module will create NLB with listeners and TargetGroup associated with AutoScalingGroup of Kubernetes cluster workers.
Then it will create an accompanying VPC Endpoint Service.
In overall, this solution allows to provide permanent access to K8s ingress (that must be exposed as NodePort) managed outside
of Kubernetes cluster (allowing e.g. for cluster redeployment without changing VPC Endpoint Service).

## Preparations

* Deploy Kubernetes cluster with ingress service exposed via NodePort (__not__ LoadBalancer with K8s-managed LB).

## Usage

```hcl
module "vpc-endpoint-services-nlb" {
  source = "github.com/kentrikos/terraform-aws-k8s-ingress-proxy-vpc-endpoint-service.git"

  vpc_id      = "${var.nlb_vpc}"
  nlb_name    = "${var.nlb_name}"
  nlb_subnets = "${var.nlb_subnets}"

  k8s_ingress_service_nodeport_http = "${var.k8s_ingress_service_nodeport_http}"
  k8s_workers_asg_names             = "${var.k8s_workers_asg_names}"

  vpces_acceptance_required = "${var.vpces_acceptance_required}"
  vpces_allowed_principals  = "${var.vpces_allowed_principals}"

  common_tag = "${var.common_tag}"
}
```

## Notes
* In the event of cluster redeployment, association between Kubernetes workers' ASG and NLB's TG must be recreated manually (e.g. in AWS console) to reconnect new healthy targets.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| common\_tag | Tags to be assigned to each resource (that supports tagging) created by this module | map | n/a | yes |
| k8s\_ingress\_service\_nodeport | NodePort of ingress service | string | n/a | yes |
| k8s\_workers\_asg\_names | Names of the autoscaling groups containing workers | list | n/a | yes |
| nlb\_listener\_port | Port for the listener of NLB | string | n/a | yes |
| nlb\_name | The name of the LB. | string | n/a | yes |
| nlb\_subnets | A list of subnet IDs to attach to the LB | list | n/a | yes |
| vpc\_id | The identifier of the VPC for NLB and K8s instances | string | n/a | yes |
| vpces\_acceptance\_required | Whether or not VPC endpoint connection requests to the service must be accepted by the service owner | string | `"true"` | no |
| vpces\_allowed\_principals | The ARNs of one or more principals allowed to discover the endpoint service | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpces\_base\_endpoint\_dns\_names | The DNS names for the VPC endpoint service |
| vpces\_service\_name | Name of VPC Endpoint Service |

