#!/bin/bash

# Configure the environment variables for OpenStack authentication
export OS_AUTH_URL="http://${public_ip}/identity"
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${devstack_adm_password}
export OS_REGION_NAME=RegionOne
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3

# Update OpenStack endpoints to use the public IP
PUBLIC_IP="${public_ip}"
services=("image" "compute_legacy" "volumev3" "network" "compute" "block-storage" "identity" "placement")
urls=(
    "http://$PUBLIC_IP/image"
    "http://$PUBLIC_IP/compute/v2/\$(project_id)s"
    "http://$PUBLIC_IP/volume/v3/\$(project_id)s"
    "http://$PUBLIC_IP:9696/networking"
    "http://$PUBLIC_IP/compute/v2.1"
    "http://$PUBLIC_IP/volume/v3/\$(project_id)s"
    "http://$PUBLIC_IP/identity"
    "http://$PUBLIC_IP/placement"
)
        
# Loop through services to update their endpoints
for i in $${!services[@]}; do
  endpoint_id=$(openstack endpoint list --service $${services[$i]} --interface public -c ID -f value)
  [[ -n $endpoint_id ]] && openstack endpoint set --url "$${urls[$i]}" $endpoint_id
done

echo "Endpoints have been updated."
openstack endpoint list
