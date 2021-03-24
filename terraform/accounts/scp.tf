# Service Control Policies allow to set top-level limits (or "guardrails") for what resources can be used/accessed within an AWS account

# We only work in a very small number of AWS regions, and we can thus deny using any services or resources in other regions
# However, several services are "global", and must therefore be excluded from this limitation
resource "aws_organizations_policy" "regions_limit" {
  provider = aws.root

  name = "RegionsLimit"

  content = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RegionsLimit",
            "Effect": "Deny",
            "NotAction": [
                "a4b:*",
                "acm:*",
                "aws-marketplace-management:*",
                "aws-marketplace:*",
                "aws-portal:*",
                "awsbillingconsole:*",
                "budgets:*",
                "ce:*",
                "chime:*",
                "cloudfront:*",
                "config:*",
                "cur:*",
                "directconnect:*",
                "ec2:DescribeRegions",
                "ec2:DescribeTransitGateways",
                "ec2:DescribeVpnGateways",
                "fms:*",
                "globalaccelerator:*",
                "health:*",
                "iam:*",
                "importexport:*",
                "kms:*",
                "mobileanalytics:*",
                "networkmanager:*",
                "organizations:*",
                "pricing:*",
                "route53:*",
                "route53domains:*",
                "s3:GetAccountPublic*",
                "s3:ListAllMyBuckets",
                "s3:PutAccountPublic*",
                "shield:*",
                "sts:*",
                "support:*",
                "trustedadvisor:*",
                "waf-regional:*",
                "waf:*",
                "wafv2:*",
                "wellarchitected:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringNotEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "eu-central-1",
                        "eu-west-1"
                    ]
                }
            }
        }
    ]
}
EOT
}


# We do run servers in our infra accounts, but only in one region
resource "aws_organizations_policy" "infra_ec2_region_limit" {
  provider = aws.root

  name = "InfraEC2RegionLimit"

  content = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InfraEC2RegionLimit",
      "Effect": "Deny",
      "Action": "ec2:*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
            "aws:RequestedRegion": [
                "eu-central-1"
            ]
        }
      }
    }
  ]
}
EOT
}


# Limit the type of EC2 instances that can be launched within infra accounts
resource "aws_organizations_policy" "infra_ec2_instance_type_limit" {
  provider = aws.root

  name = "InfraEC2InstanceTypeLimit"

  content = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InfraEC2InstanceTypeLimit",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringNotEquals": {
          "ec2:InstanceType": [
            "t2.nano",
            "t3.small",
            "c5.xlarge",
            "m5.8xlarge"
          ]
        }
      }
    }
  ]
}
EOT
}


# No need to run any EC2 stuff within our org accounts
resource "aws_organizations_policy" "org_ec2_limit" {
  provider = aws.root

  name = "OrgEC2Limit"

  content = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OrgEC2Limit",
      "Effect": "Deny",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOT
}

data "aws_organizations_organization" "main" {
  provider = aws.root
}

data "aws_organizations_organizational_units" "org" {
  provider = aws.root
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_policy_attachment" "org_ec2_limit_to_org_ou" {
  provider = aws.root

  policy_id = aws_organizations_policy.org_ec2_limit.id
  target_id = data.aws_organizations_organizational_units.org.id
}


resource "aws_organizations_policy" "full_limit" {
  provider = aws.root

  name = "FullLimit"

  content = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "FullLimit",
      "Effect": "Deny",
      "NotAction": [
        "iam:*",
        "awsbillingconsole:*",
        "sts:*",
        "organizations:*",
        "budgets:*",
        "support:*",
        "access-analyzer:*"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

# As we only do very basic IAM stuff within the org-iam account, but never want to
# provision/use any substantial resources there, we also disallow everything substantial.
resource "aws_organizations_policy_attachment" "full_limit_to_org_iam_account" {
  provider = aws.root

  policy_id = aws_organizations_policy.full_limit.id
  target_id = local.account_info_org_iam.id
}
