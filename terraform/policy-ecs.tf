resource "aws_iam_policy" "ecs_full_access" {
  name        = "ECSFullAccess"
  description = "Full access to AWS ECS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "ECSFullAccess",
        Effect   = "Allow",
        Action   = ["ecs:*"],
        Resource = "*"
      },
      {
        # Allows passing task execution roles and task roles to ECS, and managing
        # the IAM roles that containers assume at runtime. Covers both the ECS* naming
        # convention and the {name}-ecs-execution / {name}-ecs-task pattern used by
        # tf-module-ecs-alb-service.
        Sid    = "IAMForECSRoles",
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:DeleteRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:PutRolePolicy",
          "iam:GetRolePolicy",
          "iam:DeleteRolePolicy"
        ],
        Resource = [
          "arn:aws:iam::637423387388:role/ECS*",
          "arn:aws:iam::637423387388:role/*-ecs-*"
        ]
      },
      {
        # Required to create the ECS service-linked role on first use in an account.
        Sid      = "IAMServiceLinkedRoleForECS",
        Effect   = "Allow",
        Action   = ["iam:CreateServiceLinkedRole"],
        Resource = "arn:aws:iam::637423387388:role/aws-service-role/ecs.amazonaws.com/*",
        Condition = {
          StringLikeIfExists = {
            "iam:AWSServiceName" = "ecs.amazonaws.com"
          }
        }
      },
      {
        # ECS task execution roles need these permissions to pull images from ECR.
        # Also allows the provisioner to verify image availability during planning.
        Sid    = "ECRForECSImagePull",
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ],
        Resource = "*"
      },
      {
        # ECS tasks write container logs to CloudWatch Logs. These permissions cover
        # creating/destroying log groups (with retention policies and tags), streaming
        # logs from running tasks, and reading group/stream state during plan/refresh.
        Sid    = "CloudWatchLogsForECS",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:TagResource",
          "logs:UntagResource",
          "logs:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        # ECS services require VPC networking context to place tasks in subnets
        # and attach security groups. Read-only EC2 describe permissions are needed
        # during planning; create/delete are needed when managing service security groups.
        Sid    = "EC2NetworkingForECS",
        Effect = "Allow",
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeAvailabilityZones",
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
        # ECS services that use an ALB/NLB need read access to describe the load
        # balancer and target groups, and to register/deregister task targets.
        Sid    = "ELBForECSServices",
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        Resource = "*"
      }
    ]
  })
}
