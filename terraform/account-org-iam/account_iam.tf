resource "aws_iam_group" "everyone" {
  name = "Everyone"
  provider = aws.org_iam
}

resource "aws_iam_policy" "allow_get_account_password_policy" {
  name = "AllowGetAccountPasswordPolicy"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:GetAccountPasswordPolicy",
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_group_policy_attachment" "allow_get_account_password_policy_to_everyone" {
  group = aws_iam_group.everyone.name
  policy_arn = aws_iam_policy.allow_get_account_password_policy.arn
}


resource "aws_iam_group" "readonlyaccountmanagers_org_iam" {
  name = "ReadOnly${local.account_manager_group_name}"
  provider = aws.org_iam
}


module "allow-readonlyaccountmanagers-in-org-iam-to-assume-readonlyaccountmanager-in-webapp-infra-prod" {
  source = "../accounts/modules/allow-group-in-sourceaccount-to-assume-role-in-targetaccount"

  group_in_sourceaccount = aws_iam_group.readonlyaccountmanagers_org_iam.name
  role_in_targetaccount = module.create-readonlyaccountmanager-role-without-policy-in-webapp-infra-prod-assumable-from-org-iam.rolename
  targetaccount_info = local.account_info_infra_webapp_prod

  providers = {
    aws = aws.org_iam
  }
}


module "create-user-manuel-kiessling" {
  source = "./modules/create-user"

  user_name = "manuel@kiessling.net"
  groups = [
    aws_iam_group.everyone.name,
    local.account_manager_group_name,
    aws_iam_group.readonlyaccountmanagers_org_iam.name,
  ]
  iam_account_id = local.account_info_org_iam.id

  providers = {
    aws = aws.org_iam
  }
}
