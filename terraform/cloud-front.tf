locals {
  s3_contents_origin_id = "wri-prod-website.s3.ap-southeast-1.amazonaws.com"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.wri_image.bucket_regional_domain_name
    origin_id   = local.s3_contents_origin_id
  }
  tags                 = {
          "project" = " JP/KR" 
      }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
#   aliases = ["contents.hiltonhotels.jp"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    target_origin_id = local.s3_contents_origin_id

     forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    # acm_certificate_arn = "arn:aws:acm:us-east-1:141454811163:certificate/56977345-e1fd-40ee-add8-4be47bfb5baa"
    # ssl_support_method = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}