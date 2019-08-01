# A Terraform module to deploy proxy solution for Kubernetes ingress based on NLB and VPC Endpoint Service

This module will create NLB with listeners and TargetGroup associated with AutoScalingGroup of Kubernetes cluster workers.
Then it will create an accompanying VPC Endpoint Service.
In overall, this solution allows to provide permanent access to K8s ingress (that must be exposed as NodePort) managed outside
of Kubernetes cluster (allowing e.g. for cluster redeployment without changing VPC Endpoint Service).

# Notes

Terraform version  `>= 0.12`

* In the event of cluster redeployment, association between Kubernetes workers' ASG and NLB's TG must be recreated manually (e.g. in AWS console) to reconnect new healthy targets.

## Preparations

* Deploy Kubernetes cluster with ingress service exposed via NodePort (__not__ LoadBalancer with K8s-managed LB).

## Usage

```hcl
module "vpc-endpoint-services-nlb" {
  source = "github.com/kentrikos/terraform-aws-k8s-ingress-proxy-vpc-endpoint-service.git"

  vpc_id      = "${var.nlb_vpc}"
  nlb_name    = "${var.nlb_name}"
  nlb_subnets = "${var.nlb_subnets}"

  k8s_ingress_service_nodeport = "${var.k8s_ingress_service_nodeport}"
  k8s_workers_asg_names        = "${var.k8s_workers_asg_names}"

  vpces_acceptance_required = "${var.vpces_acceptance_required}"
  vpces_allowed_principals  = "${var.vpces_allowed_principals}"

  common_tag = "${var.common_tag}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `common_tag` | Tags to be assigned to each resource (that supports tagging) created by this module | map(string) | n/a |  yes |
| `k8s_ingress_service_nodeport` | NodePort of ingress service | n/a | n/a |  yes |
| `k8s_workers_asg_names` | Names of the autoscaling groups containing workers | list(string) | n/a |  yes |
| `nlb_listener_port` | Port for the listener of NLB | n/a | n/a |  yes |
| `nlb_name` | The name of the LB. | n/a | n/a |  yes |
| `nlb_subnets` | A list of subnet IDs to attach to the LB | list(string) | n/a |  yes |
| `vpc_id` | The identifier of the VPC for NLB and K8s instances | n/a | n/a |  yes |
| `vpces_acceptance_required` | Whether or not VPC endpoint connection requests to the service must be accepted by the service owner | n/a | `"true"` |  no |
| `vpces_allowed_principals` | The ARNs of one or more principals allowed to discover the endpoint service | list(string) | n/a |  yes |

## Outputs

| Name | Description |
|------|-------------|
| `vpces_base_endpoint_dns_names` | The DNS names for the VPC endpoint service |
| `vpces_service_name` | Name of VPC Endpoint Service |


