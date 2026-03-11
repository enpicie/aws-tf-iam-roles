resource "aws_iam_policy" "alb_full_access" {
  name        = "ALBFullAccess"
  description = "Full access to AWS Elastic Load Balancing (ALB/NLB/CLB)"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "ELBFullAccess",
        Effect   = "Allow",
        Action   = ["elasticloadbalancing:*"],
        Resource = "*"
      },
      {
        # ALB requires VPC networking context to place load balancers in subnets,
        # attach security groups, and describe available AZs. Create/delete permissions
        # are needed when managing ALB-specific security groups via Terraform.
        Sid    = "EC2NetworkingForALB",
        Effect = "Allow",
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DeleteSecurityGroup"
        ],
        Resource = "*"
      },
      {
        # Needed to associate ACM certificates with HTTPS (port 443) listeners.
        Sid    = "ACMForALBCertificates",
        Effect = "Allow",
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate"
        ],
        Resource = "*"
      },
      {
        # Allows associating WAFv2 web ACLs with ALBs for request filtering.
        Sid    = "WAFv2ForALB",
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
        # Required to create the ELB service-linked role on first use in an account.
        Sid      = "IAMServiceLinkedRoleForELB",
        Effect   = "Allow",
        Action   = ["iam:CreateServiceLinkedRole"],
        Resource = "arn:aws:iam::637423387388:role/aws-service-role/elasticloadbalancing.amazonaws.com/*",
        Condition = {
          StringLikeIfExists = {
            "iam:AWSServiceName" = "elasticloadbalancing.amazonaws.com"
          }
        }
      }
    ]
  })
}
