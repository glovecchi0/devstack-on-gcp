#cloud-config

users:
  - default
  - name: stack
    lock_passwd: False
    sudo: ["ALL=(ALL) NOPASSWD:ALL\nDefaults:stack !requiretty"]
    shell: /bin/bash

write_files:
  - content: |
        #!/bin/sh
        DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update
        DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy git apache2
        sudo chown stack:stack /home/stack
        cd /home/stack
        git clone https://git.openstack.org/openstack-dev/devstack
        cd devstack
        echo '[[local|localrc]]' > local.conf
        echo ADMIN_PASSWORD="${devstack_adm_password}" >> local.conf
        echo DATABASE_PASSWORD="${devstack_db_password}" >> local.conf
        echo RABBIT_PASSWORD="${devstack_rabbit_password}" >> local.conf
        echo SERVICE_PASSWORD="${devstack_svc_password}" >> local.conf
        echo USE_SSL=True >> local.conf
       
        # SSL configuration for Horizon
        echo HORIZON_SSL_CERT="/etc/ssl/certs/devstack/selfsigned.crt" >> local.conf
        echo HORIZON_SSL_KEY="/etc/ssl/certs/devstack/selfsigned.key" >> local.conf
        echo ENABLE_HTTPD_MOD_SSL=True >> local.conf

        # Generate self-signed SSL certificate
        sudo mkdir -p /etc/ssl/certs/devstack
        sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
          -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)" \
          -keyout /etc/ssl/certs/devstack/selfsigned.key \
          -out /etc/ssl/certs/devstack/selfsigned.crt \
          -addext "subjectAltName = IP:$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)"

        # Start DevStack
        ./stack.sh
    path: /home/stack/start.sh
    permissions: 0755

runcmd:
  - su -l stack ./start.sh
