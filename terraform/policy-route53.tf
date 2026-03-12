resource "aws_iam_policy" "route53_full_access" {
  name        = "Route53FullAccess"
  description = "Full access to AWS Route 53 (hosted zones and domains)"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "Route53FullAccess",
        Effect   = "Allow",
        Action   = ["route53:*", "route53domains:*"],
        Resource = "*"
      },
      {
        # Read-only access to CloudFront and ELB so that alias records pointing
        # to distributions and load balancers can be looked up during provisioning.
        Sid    = "ReadAliasTargetsForRoute53",
        Effect = "Allow",
        Action = [
          "cloudfront:ListDistributions",
          "cloudfront:GetDistribution",
          "elasticloadbalancing:DescribeLoadBalancers"
        ],
        Resource = "*"
      },
      {
        # DescribeVpcs is required when associating a VPC with a private hosted zone.
        Sid      = "EC2VPCForPrivateHostedZones",
        Effect   = "Allow",
        Action   = ["ec2:DescribeVpcs"],
        Resource = "*"
      }
    ]
  })
}
