# Terraform Module for AWS EKS Managed Node Group

## Prerequisites

- Terraform 0.12.x
- aws cli

### Use as a Module

```hcl
module "on_demand_group" {
  source            = "./"
  create_node_group = true
  cluster_name      = "Example"
  node_group_name   = "testgroup"
  k8s_version       = 1.19
  node_role_arn     = "arn:aws:iam::xxx:role/xxxxeks-node-iam-role"
  scaling_config = {
    "desired_size" = 1
    "max_size"     = 1
    "min_size"     = 1
  }
  subnet_ids = ["subnet-xxxx", "subnet-yyyy", "subnet-zzzz"]
  additional_tags = {
    Environment = "dev"
  }
}

module "spot_group" {
  source            = "./"
  capacity_type     = "SPOT"
  create_node_group = true
  cluster_name      = "Example"
  node_group_name   = "testgroup2"
  k8s_version       = 1.19
  node_role_arn     = "arn:aws:iam::xxx:role/xxxxeks-node-iam-role"
  scaling_config = {
    "desired_size" = 1
    "max_size"     = 1
    "min_size"     = 1
  }
  subnet_ids = ["subnet-xxxx", "subnet-yyyy", "subnet-zzzz"]
  additional_tags = {
    Environment = "dev"
  }
}

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14, < 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2\_x86\_64. Valid values: AL2\_x86\_64, AL2\_x86\_64\_GPU. | `string` | `"AL2_x86_64"` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | The instance capacity type used for the group e.g ON\_DEMAND or SPOT | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS Cluster | `string` | n/a | yes |
| <a name="input_create_node_group"></a> [create\_node\_group](#input\_create\_node\_group) | Do you want to create Node Group | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Disk size in GiB for worker nodes. Defaults to 40. Terraform will only perform drift detection if a configuration value is provided | `number` | `40` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Set of instance types associated with the EKS Node Group. Defaults to ["t3.medium"] | `list(string)` | <pre>[<br>  "t2.medium"<br>]</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided. | `string` | `"1.17"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. | `map(string)` | <pre>{<br>  "node_group": "dev"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name Used to create like project\_name-environment ex: stuff-qa-dev | `string` | n/a | yes |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | Name of the Node Group | `string` | n/a | yes |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group. | `string` | n/a | yes |
| <a name="input_release_version"></a> [release\_version](#input\_release\_version) | AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version | `string` | `"1.17.9-20200821"` | no |
| <a name="input_remote_access"></a> [remote\_access](#input\_remote\_access) | Configuration block with remote access settings | `map(any)` | <pre>{<br>  "ec2_ssh_key": null,<br>  "source_security_group_ids": null<br>}</pre> | no |
| <a name="input_scaling_config"></a> [scaling\_config](#input\_scaling\_config) | Configuration block with scaling settings | `map(string)` | <pre>{<br>  "desired_size": 1,<br>  "max_size": 1,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Identifiers of EC2 Subnets to associate with the EKS Node Group. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "Managed By": "Terraform"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC associated with your cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the EKS Node Group. |
| <a name="output_id"></a> [id](#output\_id) | EKS Cluster name and EKS Node Group name separated by a colon |
| <a name="output_resources_autoscaling_groups"></a> [resources\_autoscaling\_groups](#output\_resources\_autoscaling\_groups) | List of objects containing information about AutoScaling Groups |
| <a name="output_resources_autoscaling_groups_remote_access_security_group_id"></a> [resources\_autoscaling\_groups\_remote\_access\_security\_group\_id](#output\_resources\_autoscaling\_groups\_remote\_access\_security\_group\_id) | Identifier of the remote access EC2 Security Group |
| <a name="output_status"></a> [status](#output\_status) | Status of the EKS Node Group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
