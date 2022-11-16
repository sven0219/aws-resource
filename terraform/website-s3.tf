resource "aws_iam_group" "website" {
  name = "website"
}

resource "aws_iam_policy" "website_bucket_access" {
  name = "website-bucket-all-access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.website_image.bucket}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*Object",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.website_image.bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "website" {
  name = "website"
}

resource "aws_iam_user_group_membership" "website" {
  user = aws_iam_user.website.name

  groups = [
    aws_iam_group.website.name
  ]
}

resource "aws_iam_group_policy_attachment" "website_image_policy_attach" {
  group      = aws_iam_group.website.name
  policy_arn = aws_iam_policy.website_bucket_access.arn
}

resource "aws_s3_bucket" "website_image" {
  bucket = "website-prod-website"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_website_configuration" "website_image" {
  bucket = aws_s3_bucket.website_image.bucket

  index_document {
    suffix = "index.html"
  }

}


resource "aws_s3_bucket_acl" "wr_acl" {
  bucket = aws_s3_bucket.website_image.id
  acl    = "private"
}

data "aws_iam_policy_document" "website_image" {
  statement {
    sid = "1"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::website-prod-website/*"]
  }
}

resource "aws_s3_bucket_policy" "website_image" {
  bucket = aws_s3_bucket.website_image.id
  policy = data.aws_iam_policy_document.website_image.json
}

