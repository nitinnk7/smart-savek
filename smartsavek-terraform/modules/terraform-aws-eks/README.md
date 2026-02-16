# Terraform module for creating EKS Cluster

## Available features

- IAM Roles and permissions
- Security Groups for Control plane and Worker Nodes
- Cloud-watch Log Group for EKS logs

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
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_instance_profile.eks-node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.eks-master-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks-node-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ec2_fullaccess_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3_readonly_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.demo-node-CloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_service_linked_role.elbservicerole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_egress_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_https_worker_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_shared_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_egress_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_ingress_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_ingress_cluster_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_ingress_cluster_kubelet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.eks_oidc_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | CIDR ranges that you want to allow commumication to EKS API | `list(any)` | `[]` | no |
| <a name="input_aws_service_name"></a> [aws\_service\_name](#input\_aws\_service\_name) | description | `string` | `"elasticloadbalancing.amazonaws.com"` | no |
| <a name="input_cluster_encryption_config"></a> [cluster\_encryption\_config](#input\_cluster\_encryption\_config) | Configuration block with encryption configuration for the cluster. See examples/secrets\_encryption/main.tf for example format | <pre>list(object({<br>    provider_key_arn = string<br>    resources        = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_log_retention_in_days"></a> [cluster\_log\_retention\_in\_days](#input\_cluster\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `400` | no |
| <a name="input_cluster_security_group_ids"></a> [cluster\_security\_group\_ids](#input\_cluster\_security\_group\_ids) | List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane. | `list(any)` | `[]` | no |
| <a name="input_create_eks"></a> [create\_eks](#input\_create\_eks) | Do you want to create EKS | `bool` | `true` | no |
| <a name="input_create_elb_service_linked_role"></a> [create\_elb\_service\_linked\_role](#input\_create\_elb\_service\_linked\_role) | Whether to create the service linked role for the elasticloadbalancing service. Without this EKS cannot create ELBs. | `bool` | `true` | no |
| <a name="input_create_kms"></a> [create\_kms](#input\_create\_kms) | Specifies whether to create KMS key to encrypt cloudwatch log group | `bool` | `false` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1. Defaults to SYMMETRIC\_DEFAULT | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | `number` | `30` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled. Defaults to false | `bool` | `true` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable | `list(any)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default is false. | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is true. | `bool` | `false` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Specifies whether the key is enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Desired Kubernetes master version. | `string` | `"1.17"` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | Specifies the intended use of the key. Valid values: ENCRYPT\_DECRYPT or SIGN\_VERIFY. Defaults to ENCRYPT\_DECRYPT. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_kubernetes_network_config"></a> [kubernetes\_network\_config](#input\_kubernetes\_network\_config) | (Optional) Configuration block with kubernetes network configuration for the cluster. Detailed below. If removed, Terraform will only perform drift detection if a configuration value is provided. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the cluster | `string` | `"example-dev"` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled | `list(any)` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane. | `list(any)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "Managed By": "Terraform"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC associated with your cluster. | `string` | n/a | yes |
| <a name="input_worker_security_group_ids"></a> [worker\_security\_group\_ids](#input\_worker\_security\_group\_ids) | Security Group ID for Allowing pods to communicate with the EKS cluster API. only needed if you are not passing 'security\_group\_ids' | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_arn"></a> [eks\_arn](#output\_eks\_arn) | The Amazon Resource Name (ARN) of the cluster. |
| <a name="output_eks_certificate_authority"></a> [eks\_certificate\_authority](#output\_eks\_certificate\_authority) | The base64 encoded certificate data required to communicate with your cluster. |
| <a name="output_eks_clg_arn"></a> [eks\_clg\_arn](#output\_eks\_clg\_arn) | The Amazon Resource Name (ARN) specifying the log group |
| <a name="output_eks_endpoint"></a> [eks\_endpoint](#output\_eks\_endpoint) | The endpoint for your Kubernetes API server. |
| <a name="output_eks_id"></a> [eks\_id](#output\_eks\_id) | The name of the cluster |
| <a name="output_eks_platform_version"></a> [eks\_platform\_version](#output\_eks\_platform\_version) | The platform version for the cluster |
| <a name="output_eks_status"></a> [eks\_status](#output\_eks\_status) | The status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED |
| <a name="output_eks_version"></a> [eks\_version](#output\_eks\_version) | The Kubernetes server version for the cluster. |
| <a name="output_eks_vpc_config"></a> [eks\_vpc\_config](#output\_eks\_vpc\_config) | The cluster security group that was created by Amazon EKS for the cluster. |
| <a name="output_master_role_arn"></a> [master\_role\_arn](#output\_master\_role\_arn) | The Amazon Resource Name (ARN) specifying the role |
| <a name="output_master_role_create_date"></a> [master\_role\_create\_date](#output\_master\_role\_create\_date) | The creation date of the IAM role |
| <a name="output_master_role_id"></a> [master\_role\_id](#output\_master\_role\_id) | The name of the role |
| <a name="output_master_role_name"></a> [master\_role\_name](#output\_master\_role\_name) | The name of the role |
| <a name="output_master_role_unique_id"></a> [master\_role\_unique\_id](#output\_master\_role\_unique\_id) | The stable and unique string identifying the role |
| <a name="output_master_sg_arn"></a> [master\_sg\_arn](#output\_master\_sg\_arn) | The ARN of the security group |
| <a name="output_master_sg_egress_rules"></a> [master\_sg\_egress\_rules](#output\_master\_sg\_egress\_rules) | The egress rules |
| <a name="output_master_sg_id"></a> [master\_sg\_id](#output\_master\_sg\_id) | The ID of the security group |
| <a name="output_master_sg_ingress_rules"></a> [master\_sg\_ingress\_rules](#output\_master\_sg\_ingress\_rules) | The ingress rules |
| <a name="output_nodes_role_arn"></a> [nodes\_role\_arn](#output\_nodes\_role\_arn) | The Amazon Resource Name (ARN) specifying the role |
| <a name="output_nodes_role_create_date"></a> [nodes\_role\_create\_date](#output\_nodes\_role\_create\_date) | The creation date of the IAM role |
| <a name="output_nodes_role_id"></a> [nodes\_role\_id](#output\_nodes\_role\_id) | The name of the role |
| <a name="output_nodes_role_name"></a> [nodes\_role\_name](#output\_nodes\_role\_name) | The name of the role |
| <a name="output_nodes_role_unique_id"></a> [nodes\_role\_unique\_id](#output\_nodes\_role\_unique\_id) | The stable and unique string identifying the role |
| <a name="output_oidc_arn"></a> [oidc\_arn](#output\_oidc\_arn) | n/a |
| <a name="output_oidc_url"></a> [oidc\_url](#output\_oidc\_url) | n/a |
| <a name="output_worker_nodes_sg_arn"></a> [worker\_nodes\_sg\_arn](#output\_worker\_nodes\_sg\_arn) | The ARN of the security group |
| <a name="output_worker_nodes_sg_egress_rules"></a> [worker\_nodes\_sg\_egress\_rules](#output\_worker\_nodes\_sg\_egress\_rules) | The egress rules |
| <a name="output_worker_nodes_sg_id"></a> [worker\_nodes\_sg\_id](#output\_worker\_nodes\_sg\_id) | The ID of the security group |
| <a name="output_worker_nodes_sg_ingress_rules"></a> [worker\_nodes\_sg\_ingress\_rules](#output\_worker\_nodes\_sg\_ingress\_rules) | The ingress rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### To-DO
