module "acm" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = "franciscobalart.io"
  zone_id      = "your-hosted-zone-id"

  subject_alternative_names = [
    "www.franciscobalart.io",
  ]

  wait_for_validation = false

  tags = {
    Name = "franciscobalart.io"
  }

  key_algorithm ="RSA_2048"
}