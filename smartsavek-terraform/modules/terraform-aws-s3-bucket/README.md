![Terraform](https://lgallardo.com/images/terraform.jpg)

# AWS S3 bucket 

## Description

Terraform module which creates S3 bucket on AWS with all (or almost all) features provided by Terraform AWS provider.

These features of S3 bucket configurations are supported:

- static web-site hosting
- access logging
- versioning
- CORS
- lifecycle rules
- server-side encryption
- object locking
- Cross-Region Replication (CRR)
- ELB log delivery bucket policy

## Modules

[vimient-llc-infra-component-generic-s3](https://bitbucket.org/clearcaptions/vimient-llc-infra-component-generic-s3/src/master/)



## S3 bucket Usage

### Private bucket with versioning enabled

```hcl
module "s3_bucket" {
  source   = "../modules/terraform-aws-s3-bucket/"

  create_bucket = true
  bucket        = "<Name of the S3 Bucket>"
  acl           = var.acl                   # default = private
  kms_key_arn   = module.kms_key.key_arn    # KMS Key ARN. Value will be collected from kms module created along with this.

  versioning = {
    enabled = true
  }

}
```


## OUTPUTS 

| Name | Description |  
|-------------|---------------------------------|  
| s3_id | The ID of the S3 bucket|  
| s3_arn | The ARN of the S3 bucket |
