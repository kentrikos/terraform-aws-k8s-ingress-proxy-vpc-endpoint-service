variable "vpc_id" {
  description = "The identifier of the VPC for NLB and K8s instances"
}

variable "nlb_name" {
  description = "The name of the LB."
}

variable "nlb_subnets" {
  type        = list(string)
  description = "A list of subnet IDs to attach to the LB"
}

variable "nlb_listener_port" {
  description = "Port for the listener of NLB"
}

variable "k8s_ingress_service_nodeport" {
  description = "NodePort of ingress service"
}

variable "k8s_workers_asg_names" {
  type        = list(string)
  description = "Names of the autoscaling groups containing workers"
}

variable "vpces_acceptance_required" {
  description = "Whether or not VPC endpoint connection requests to the service must be accepted by the service owner"
  default     = "true"
}

variable "vpces_allowed_principals" {
  type        = list(string)
  description = "The ARNs of one or more principals allowed to discover the endpoint service"
  default     = []
}

variable "common_tag" {
  type        = map(string)
  description = "Tags to be assigned to each resource (that supports tagging) created by this module"
}
