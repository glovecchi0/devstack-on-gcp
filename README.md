# devstack-on-gcp

Install DevStack, the development version of OpenStack, in All-In-One mode on a Google Cloud Compute Engine.

# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `devstack_adm_password` to change the default DevStack Admin password
    -  `devstack_db_password` to change the default DevStack DB password
    -  `devstack_rabbit_password` to change the default DevStack RabbitMQ password
    -  `devstack_svc_password` to change the default DevStack Service password
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](./gcloud.md).

#### Terraform Apply (Infrastructure only)
```bash
terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Apply (Infrastructure + OS Image + Compute Instance)
```bash
terraform init -upgrade && terraform apply -auto-approve && sed -i '' 's|/\*|#/\*|g; s|\*/|#\*/|g' main.tf provider.tf && terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Destroy (Infrastructure only)
```bash
terraform destroy -auto-approve
```

#### Terraform Destroy (Infrastructure + OS Image + Compute Instance)
```bash
terraform destroy -auto-approve && sed -i '' 's/#//g' main.tf provider.tf
```

#### OpenTofu Apply (Infrastructure only)
```bash
tofu init -upgrade && tofu apply -auto-approve
```

#### OpenTofu Apply (Infrastructure + OS Image + Compute Instance)
```bash
tofu init -upgrade && tofu apply -auto-approve && sed -i '' 's|/\*|#/\*|g; s|\*/|#\*/|g' main.tf provider.tf && tofu init -upgrade && tofu apply -auto-approve
```

#### OpenTofu Destroy (Infrastructure only)
```bash
tofu destroy -auto-approve
```

#### OpenTofu Destroy (Infrastructure + OS Image + Compute Instance)
```bash
tofu destroy -auto-approve && sed -i '' 's/#//g' main.tf provider.tf
```

## How to access Google Cloud VMs and check DevStack logs

#### Run the following command

```bash
$ ssh -oStrictHostKeyChecking=no -i <PREFIX>-ssh_private_key.pem <SSH_USERNAME>@<PUBLIC_IPV4>
$ sudo su -
$ tail -100f /var/log/cloud-init-output.log
```

**These scripts work perfectly from the macOS terminal; if you use any other Linux distribution, remove '' from the sed command.**
