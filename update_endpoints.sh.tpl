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

# Retrieve all current public endpoints
endpoint_list=$(openstack endpoint list --interface public -c ID -c URL -f value)

# Loop through each endpoint and update the URL to replace the existing IP with the new one
while IFS= read -r line; do
  endpoint_id=$(echo $line | awk '{print $1}')
  current_url=$(echo $line | awk '{print $2}')

  # Extract the current IP from the URL (assumes URL is of the form http://IP:port/service)
  current_ip=$(echo $current_url | sed -n 's#http://\([0-9.]*\).*#\1#p')

  # If the current IP is different from the new public IP, update the endpoint
  if [[ "$current_ip" != "$PUBLIC_IP" ]]; then
    # Replace the current IP with the new public IP in the URL
    new_url=$(echo $current_url | sed "s/$current_ip/$PUBLIC_IP/")

    # Update the endpoint with the new URL
    echo "Updating endpoint $endpoint_id: $current_url -> $new_url"
    openstack endpoint set --url "$new_url" $endpoint_id
  else
    echo "Endpoint $endpoint_id is already using $PUBLIC_IP, no update needed."
  fi
done <<< "$endpoint_list"

echo "Endpoints have been updated."
openstack endpoint list
