data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

data "tls_certificate" "eks_oidc_certificate" {
  url          = join("", aws_eks_cluster.this.*.identity.0.oidc.0.issuer)
  verify_chain = true
}
