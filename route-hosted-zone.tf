module "public_hosted_zone" {
  source  = "brunordias/route53-zone/aws"

  domain      = "franciscobalart.io"
  description = "route53 hosted zone Created by Terraform module example"
}