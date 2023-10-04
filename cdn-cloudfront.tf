resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for franciscobalart.io"
}

# cloudfront terraform - creating AWS Cloudfront distribution :
resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  aliases             = ["franciscobalart.io", "www.franciscobalart.io"]
  default_root_object = "index.html"
  origin {
    domain_name = aws_s3_bucket.example.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.example.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.example.id
    viewer_protocol_policy = "redirect-to-https" # other options - https only, http
    forwarded_values {
      headers      = []
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  depends_on = [module.acm]

}

resource "aws_route53_record" "route53-record" {
  zone_id = module.public_hosted_zone.zone_id
  name    = "www.franciscobalart.io"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.cf_dist.domain_name
    #name                   = replace(aws_cloudfront_distribution.cf_dist.domain_name, "/[.]$/", "")
    #"${aws_cloudfront_distribution.my-website.domain_name}"
    zone_id                = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "route53-record-two" {
  zone_id = module.public_hosted_zone.zone_id
  name    = "franciscobalart.io"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.cf_dist.domain_name
    #name                   = replace(aws_cloudfront_distribution.cf_dist.domain_name, "/[.]$/", "")
    #"${aws_cloudfront_distribution.my-website.domain_name}"
    zone_id                = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = false
  }
}