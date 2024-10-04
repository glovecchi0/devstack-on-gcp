## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.32.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | >= 1.53.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | 5.32.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.firewall](https://registry.terraform.io/providers/hashicorp/google/5.32.0/docs/resources/compute_firewall) | resource |
| [google_compute_instance.vm](https://registry.terraform.io/providers/hashicorp/google/5.32.0/docs/resources/compute_instance) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/5.32.0/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/5.32.0/docs/resources/compute_subnetwork) | resource |
| [local_file.cloud_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.horizon_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.update_endpoints_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.copy_horizon_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.copy_update_endpoints_script](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_devstack_services_startup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.ssh_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [cloudinit_config.conf](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/5.32.0/docs/data-sources/compute_zones) | data source |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Indicates if a Google Firewall should be created | `bool` | `true` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Indicates if a new SSH key pair should be created | `bool` | `true` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Indicates if VPC/Subnet should be created | `bool` | `true` | no |
| <a name="input_devstack_adm_password"></a> [devstack\_adm\_password](#input\_devstack\_adm\_password) | Password for DevStack Admin user | `string` | `"mypassword"` | no |
| <a name="input_devstack_blockstorage_volume_size"></a> [devstack\_blockstorage\_volume\_size](#input\_devstack\_blockstorage\_volume\_size) | Size of the block storage volume in GB for the DevStack environment | `number` | `5` | no |
| <a name="input_devstack_db_password"></a> [devstack\_db\_password](#input\_devstack\_db\_password) | Password for DevStack Database | `string` | `"mypassword"` | no |
| <a name="input_devstack_flavor_name"></a> [devstack\_flavor\_name](#input\_devstack\_flavor\_name) | Name of the flavor to be used for instances in the DevStack environment | `string` | `"m1.medium"` | no |
| <a name="input_devstack_image_name"></a> [devstack\_image\_name](#input\_devstack\_image\_name) | Name for the image used within the DevStack environment | `string` | `"ubuntu22"` | no |
| <a name="input_devstack_image_source_url"></a> [devstack\_image\_source\_url](#input\_devstack\_image\_source\_url) | URL for the source image to be used within the DevStack environment | `string` | `"https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"` | no |
| <a name="input_devstack_network_name"></a> [devstack\_network\_name](#input\_devstack\_network\_name) | Name of the network to be used for instances in the DevStack environment | `string` | `"public"` | no |
| <a name="input_devstack_rabbit_password"></a> [devstack\_rabbit\_password](#input\_devstack\_rabbit\_password) | Password for DevStack RabbitMQ service | `string` | `"mypassword"` | no |
| <a name="input_devstack_security_group"></a> [devstack\_security\_group](#input\_devstack\_security\_group) | Name of the security group to be applied to instances in the DevStack environment | `string` | `"default"` | no |
| <a name="input_devstack_svc_password"></a> [devstack\_svc\_password](#input\_devstack\_svc\_password) | Password for DevStack services | `string` | `"mypassword"` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Disk type for each instance (e.g., 'pd-standard', 'pd-ssd') | `string` | `"pd-balanced"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of compute instances to create | `number` | `1` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Disk size for each instance in GB | `number` | `50` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Google Compute Engine machine type for instances | `string` | `"n2-standard-4"` | no |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | Private IP range for the Google subnet | `string` | `"10.10.0.0/24"` | no |
| <a name="input_os_image"></a> [os\_image](#input\_os\_image) | Ubuntu 22.04 LTS image for instances | `string` | `"projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230908"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all Google resources | `string` | `"myresources"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID of the Google Cloud Project for resource creation | `string` | `"myproject"` | no |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud region for resource deployment | `string` | `"us-west2"` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to the pre-generated SSH private key | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | Path to the pre-generated SSH public key | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username for SSH access | `string` | `"ubuntu"` | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Custom startup script for instances | `string` | `null` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Google Subnet for all resources | `string` | `null` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Google VPC for all resources | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_devstack_adm_password"></a> [devstack\_adm\_password](#output\_devstack\_adm\_password) | Password for DevStack Admin user |
| <a name="output_devstack_url"></a> [devstack\_url](#output\_devstack\_url) | DevStack URL |
| <a name="output_instance_ips"></a> [instance\_ips](#output\_instance\_ips) | List of instances' public and private IPs |
