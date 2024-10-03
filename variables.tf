variable "prefix" {
  description = "Prefix for all Google resources"
  type        = string
  default     = "myresources"
}

variable "project_id" {
  description = "ID of the Google Cloud Project for resource creation"
  type        = string
  default     = "myproject"
}

variable "region" {
  description = "Google Cloud region for resource deployment"
  type        = string
  default     = "us-west2"
}

variable "create_ssh_key_pair" {
  description = "Indicates if a new SSH key pair should be created"
  type        = bool
  default     = true
}

variable "ssh_private_key_path" {
  description = "Path to the pre-generated SSH private key"
  type        = string
  default     = null
}

variable "ssh_public_key_path" {
  description = "Path to the pre-generated SSH public key"
  type        = string
  default     = null
}

variable "ip_cidr_range" {
  description = "Private IP range for the Google subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "create_vpc" {
  description = "Indicates if VPC/Subnet should be created"
  type        = bool
  default     = true
}

variable "vpc" {
  description = "Google VPC for all resources"
  type        = string
  default     = null
}

variable "subnet" {
  description = "Google Subnet for all resources"
  type        = string
  default     = null
}

variable "create_firewall" {
  description = "Indicates if a Google Firewall should be created"
  type        = bool
  default     = true
}

variable "instance_count" {
  description = "Number of compute instances to create"
  type        = number
  default     = 1
}

variable "instance_disk_size" {
  description = "Disk size for each instance in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Disk type for each instance (e.g., 'pd-standard', 'pd-ssd')"
  type        = string
  default     = "pd-balanced"
}

variable "instance_type" {
  description = "Google Compute Engine machine type for instances"
  type        = string
  default     = "n2-standard-4"
}

variable "os_image" {
  description = "Ubuntu 22.04 LTS image for instances"
  type        = string
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230908"
}

variable "ssh_username" {
  description = "Username for SSH access"
  type        = string
  default     = "ubuntu"
}

variable "startup_script" {
  description = "Custom startup script for instances"
  type        = string
  default     = null
}

variable "devstack_adm_password" {
  description = "Password for DevStack Admin user"
  type        = string
  default     = "mypassword"
}

variable "devstack_db_password" {
  description = "Password for DevStack Database"
  type        = string
  default     = "mypassword"
}

variable "devstack_rabbit_password" {
  description = "Password for DevStack RabbitMQ service"
  type        = string
  default     = "mypassword"
}

variable "devstack_svc_password" {
  description = "Password for DevStack services"
  type        = string
  default     = "mypassword"
}

variable "devstack_image_name" {
  description = "Name for the image used within the DevStack environment"
  type        = string
  default     = "ubuntu22"
}

variable "devstack_image_source_url" {
  description = "URL for the source image to be used within the DevStack environment"
  type        = string
  default     = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "devstack_flavor_name" {
  description = "Name of the flavor to be used for instances in the DevStack environment"
  type        = string
  default     = "m1.medium"
}

variable "devstack_security_group" {
  description = "Name of the security group to be applied to instances in the DevStack environment"
  type        = string
  default     = "default"
}

variable "devstack_network_name" {
  description = "Name of the network to be used for instances in the DevStack environment"
  type        = string
  default     = "public"
}
