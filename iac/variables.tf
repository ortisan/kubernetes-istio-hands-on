variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "k8s-demo"
}


variable "cluster_version" {
  type    = string
  default = "1.27"
}


variable "vpc_id" {
  type    = string
  default = "vpc-08ccd18714a2e8437"
}

variable "subnets_id" {
  type    = list(string)
  default = ["subnet-01459f2806e7d9f24", "subnet-080509807e667e94e"]
}

variable "docker_hub" {
  type    = string
  default = "779882487479.dkr.ecr.us-east-1.amazonaws.com"
}

variable "create_istio" {
  type    = bool
  default = true
}

variable "istio_charts_url" {
  type    = string
  default = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_target_group_type" {
  type    = string
  default = "instance" # instance for ec2, ip for fargate
}

variable "istio_version" {
  type    = string
  default = "1.18.0"
}

variable "rancher_version" {
  type    = string
  default = "2.7.5"
}

variable "tags" {
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only."
  type        = map(string)
  default     = { "name" = "k8s-demo" }
}
