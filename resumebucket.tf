resource "aws_s3_bucket" "example" {
  bucket = "franciscobalart.io"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
# https://stackoverflow.com/questions/76049290/error-accesscontrollistnotsupported-when-trying-to-create-a-bucket-acl-in-aws
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.example.id
  rule {
    #object_ownership = "ObjectWriter"
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = "franciscobalart.io"  # Replace with your bucket name
  key    = "index.html"
  content_type = "text/html"
  content = <<-EOF
  <!DOCTYPE html>
  <html>
  <head>
      <title>Francisco Balart Resume</title>
  </head>
  <body>
      <center>
          <h1 style="color: white; background-color: rgb(22,22, 24); font-family: -apple-system BlinkMacSystemFont, sans-serif">MsC Francisco Eduardo Balart Sanchez</h1>
          <object data="franciscoresume2023.pdf" style="min-height:100vh;width:100%">
          </object>
      </center>
  </body>
  </html>
  EOF
  depends_on = [aws_s3_bucket.example]
  acl = "public-read"
}

resource "aws_s3_bucket_object" "error_html" {
  bucket = aws_s3_bucket.example.bucket
  key    = "error.html"
  content_type = "text/html"
  content = <<-EOF
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Error</title>
    </head>
    <body style="background-color: rgb(22,22, 24)">
        <p style="color: white; font-family: -apple-system BlinkMacSystemFont, sans-serif">ThePrimeAgen</p>
    </body>
    </html>
  EOF
  depends_on = [aws_s3_bucket.example]
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}

output "website_url" {
  value = aws_s3_bucket.example.website_endpoint
}

output "bucket_domain_name" {
  value = aws_s3_bucket.example.bucket_regional_domain_name
}