resource "aws_iam_group" "wri" {
  name = "wri"
}

resource "aws_iam_policy" "wri_bucket_access" {
  name        = "wri-bucket-all-access"

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
          "arn:aws:s3:::${aws_s3_bucket.wri_image.bucket}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*Object",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.wri_image.bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "wri" {
  name     = "wri"
}

resource "aws_iam_user_group_membership" "wri" {
  user = aws_iam_user.wri.name

  groups = [
    aws_iam_group.wri.name
  ]
}

resource "aws_iam_group_policy_attachment" "wri_image_policy_attach" {
  group      = aws_iam_group.wri.name
  policy_arn = aws_iam_policy.wri_bucket_access.arn
}

resource "aws_s3_bucket" "wri_image" {
  bucket = "wri-prod-website"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_website_configuration" "wri_image" {
  bucket = aws_s3_bucket.wri_image.bucket

  index_document {
    suffix = "index.html"
  }

}


resource "aws_s3_bucket_acl" "hilton_apac_acl" {
  bucket = aws_s3_bucket.wri_image.id
  acl    = "private"
}

data "aws_iam_policy_document" "wri_image" {
  statement {
    sid        = "1"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions    = ["s3:GetObject"]
    resources  = ["arn:aws:s3:::wri-prod-website/*"]
  }
}

resource "aws_s3_bucket_policy" "wri_image" {
  bucket = aws_s3_bucket.wri_image.id
  policy = data.aws_iam_policy_document.wri_image.json
}

