# aws-tf-iam-roles

Terraform configuration for AWS IAM roles used by GitHub Actions workflows in the `enpicie` org to provision AWS resources. Each role is scoped to a specific set of AWS services, published as an organization secret, and ready to reference in any workflow.

## How it works

- **OIDC authentication** — roles are assumed via GitHub's OIDC provider, no long-lived credentials required
- **Composable policies** — each AWS service has its own `policy-*.tf` file granting full access plus the supporting permissions needed to fully provision that service. Roles are composed by attaching the relevant policies.
- **Terraform backend** — `TerraformBackendAccess` (`policy-tf-backend.tf`) is attached to every role. It grants the S3 and DynamoDB permissions required to read/write remote state and acquire state locks.
- **Self-service secrets** — each role's ARN is automatically published as a GitHub organization secret. Workflows reference the secret directly; no manual ARN lookup needed.

## Using a role in a workflow

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN_LAMBDA_APIGW }}  # swap for your use case
          aws-region: us-east-2
```

## Role registry

All roles include `TerraformBackendAccess` for S3 state and DynamoDB state locking. The table below lists the additional service-specific policies per role.

| Role | IAM Role Name | Secret | Policies |
|---|---|---|---|
| [role-lambda-apigw.tf](terraform/role-lambda-apigw.tf) | `tf-apigw-lambda` | `AWS_ROLE_ARN_LAMBDA_APIGW` | Lambda, API Gateway |
| [role-lambda-apigw-ddb.tf](terraform/role-lambda-apigw-ddb.tf) | `tf-apigw-ddb-lambda` | `AWS_ROLE_ARN_LAMBDA_APIGW_DDB` | Lambda, API Gateway, DynamoDB |
| [role-lambda-apigw-ddb-sqs.tf](terraform/role-lambda-apigw-ddb-sqs.tf) | `tf-apigw-ddb-lambda-sqs` | `AWS_ROLE_ARN_LAMBDA_APIGW_DDB_SQS` | Lambda, API Gateway, DynamoDB, SQS |
| [role-s3-cloudfront.tf](terraform/role-s3-cloudfront.tf) | `tf-cloudfront-s3` | `AWS_ROLE_ARN_S3_CLOUDFRONT` | S3, CloudFront, ACM |
| [role-ecs-alb.tf](terraform/role-ecs-alb.tf) | `tf-alb-ecs` | `AWS_ROLE_ARN_ECS_ALB` | ECS, ALB |
| [role-route53.tf](terraform/role-route53.tf) | `tf-route53` | `AWS_ROLE_ARN_ROUTE53` | Route 53, ACM |
| [role-ecr.tf](terraform/role-ecr.tf) | `tf-ecr` | `AWS_ROLE_ARN_ECR` | ECR |

## Adding a new role

1. Create `terraform/role-{services}.tf` following the pattern of an existing role file
2. Set `name` to `tf-{services-alphabetical}` (e.g. `tf-apigw-lambda`)
3. Reference `data.aws_iam_policy_document.github_oidc_assume_role.json` for the trust policy
4. Attach policies from the existing `policy-*.tf` files via `aws_iam_role_policy_attachment`
5. Attach `aws_iam_policy.tf_backend` via an `aws_iam_role_policy_attachment` — this is required on every role
6. Add a `github_actions_organization_secret` resource — the secret name should match the file name in screaming snake case (e.g. `AWS_ROLE_ARN_{SERVICES}`)
7. Add the role to the registry table above

## Repository structure

```
terraform/
├── providers.tf              # AWS and GitHub provider configuration
├── trust.tf                  # Shared OIDC trust policy for all roles
├── variables.tf              # Input variables (e.g. secret visibility)
│
├── policy-tf-backend.tf      # Terraform backend access (S3 state, DynamoDB locking) — attached to all roles
├── policy-acm.tf             # ACM + supporting permissions (Route53 DNS validation)
├── policy-lambda.tf          # Lambda + supporting permissions (S3 artifacts, IAM, VPC, KMS)
├── policy-apigw.tf           # API Gateway + supporting permissions (CloudWatch logs, ACM)
├── policy-dynamodb.tf        # DynamoDB + supporting permissions (autoscaling, KMS, CloudWatch)
├── policy-sqs.tf             # SQS + supporting permissions (KMS, CloudWatch)
├── policy-s3.tf              # S3 + supporting permissions (KMS, IAM replication role)
├── policy-cloudfront.tf      # CloudFront + supporting permissions (S3, ACM, Route53, WAF)
├── policy-ecr.tf             # ECR + supporting permissions (KMS, STS)
├── policy-ecs.tf             # ECS + supporting permissions (IAM, ECR, CloudWatch, EC2, ELB)
├── policy-alb.tf             # ALB + supporting permissions (EC2, ACM, WAF)
├── policy-route53.tf         # Route53 + supporting permissions (CloudFront, ELB, EC2 VPC)
├── policy-cloudwatch.tf      # CloudWatch + supporting permissions (SNS, IAM)
│
├── role-lambda-apigw.tf
├── role-lambda-apigw-ddb.tf
├── role-lambda-apigw-ddb-sqs.tf
├── role-s3-cloudfront.tf
├── role-ecs-alb.tf
├── role-route53.tf
└── role-ecr.tf
```
