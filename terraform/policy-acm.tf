resource "aws_iam_policy" "acm_full_access" {
  name        = "ACMFullAccess"
  description = "Full access to AWS Certificate Manager for provisioning and managing TLS certificates"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "ACMFullAccess",
        Effect   = "Allow",
        Action   = ["acm:*"],
        Resource = "*"
      },
      {
        # Terraform uses these Route 53 actions to create DNS validation CNAME records
        # when ACM requests a certificate with DNS validation. GetChange is needed to
        # poll until the record is propagated and the certificate reaches ISSUED status.
        Sid    = "Route53ForACMDNSValidation",
        Effect = "Allow",
        Action = [
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:ListResourceRecordSets",
          "route53:ChangeResourceRecordSets",
          "route53:GetChange"
        ],
        Resource = "*"
      }
    ]
  })
}
