resource "aws_iam_policy" "cloudfront_full_access" {
  name        = "CloudFrontFullAccess"
  description = "Full access to AWS CloudFront"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "CloudFrontFullAccess",
        Effect   = "Allow",
        Action   = ["cloudfront:*"],
        Resource = "*"
      },
      {
        # CloudFront uses Origin Access Control (OAC) to access S3 origins.
        # PutBucketPolicy is required to grant the CloudFront OAC access to the bucket.
        Sid    = "S3ForCloudFrontOrigin",
        Effect = "Allow",
        Action = [
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy"
        ],
        Resource = "*"
      },
      {
        # ACM certificates for CloudFront must be provisioned in us-east-1.
        # These permissions allow looking up and associating certificates with distributions.
        Sid    = "ACMForCloudFrontCertificates",
        Effect = "Allow",
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "acm:RequestCertificate",
          "acm:DeleteCertificate",
          "acm:AddTagsToCertificate"
        ],
        Resource = "*"
      },
      {
        # Route 53 records are required to point custom domains at CloudFront
        # distributions and to complete DNS validation for ACM certificates.
        Sid    = "Route53ForCloudFrontDomains",
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetChange"
        ],
        Resource = "*"
      },
      {
        # Allows associating and disassociating WAFv2 web ACLs with CloudFront
        # distributions for request filtering and rate limiting.
        Sid    = "WAFv2ForCloudFront",
        Effect = "Allow",
        Action = [
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "wafv2:GetWebACL",
          "wafv2:ListWebACLs"
        ],
        Resource = "*"
      },
      {
        # Required to create the CloudFront service-linked role on first use in an account.
        Sid    = "IAMServiceLinkedRoleForCloudFront",
        Effect = "Allow",
        Action = ["iam:CreateServiceLinkedRole"],
        Resource = "arn:aws:iam::637423387388:role/aws-service-role/cloudfront.amazonaws.com/*",
        Condition = {
          StringLikeIfExists = {
            "iam:AWSServiceName" = "cloudfront.amazonaws.com"
          }
        }
      }
    ]
  })
}
