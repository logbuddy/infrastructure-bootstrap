resource "aws_iam_group" "accountmanagers_org_iam" {
  name = local.account_manager_group_name
  provider = aws.org_iam
}

resource "aws_iam_policy" "accountmanagement_org_iam" {
  policy = local.account_management_policy
  provider = aws.org_iam
}

resource "aws_iam_group_policy_attachment" "accountmanagers_org_iam" {
  group = aws_iam_group.accountmanagers_org_iam.id
  policy_arn = aws_iam_policy.accountmanagement_org_iam.arn
  provider = aws.org_iam
}

resource "aws_iam_user" "accountmanager_org_iam" {
  name = local.account_manager_user_name
  provider = aws.org_iam
}

resource "aws_iam_user_group_membership" "accountmanager_org_iam" {
  groups = [aws_iam_group.accountmanagers_org_iam.name]
  user = aws_iam_user.accountmanager_org_iam.name
  provider = aws.org_iam
}


module "create-accountmanager-role-with-policy-in-webapp-infra-prod-assumable-from-org-iam" {
  source = "./modules/create-role-with-policy-in-targetaccount-assumable-from-sourceaccount"

  sourceaccount_id = local.account_info_org_iam.id
  rolename = local.account_manager_role_name
  policyname = local.account_management_policy_name
  policy = local.account_management_policy

  providers = {
    aws = aws.infra_webapp_prod
  }
}

module "allow-accountmanagers-in-org-iam-to-assume-accountmanager-in-webapp-infra-prod" {
  source = "./modules/allow-group-in-sourceaccount-to-assume-role-in-targetaccount"

  group_in_sourceaccount = local.account_manager_group_name
  role_in_targetaccount = local.account_manager_role_name
  targetaccount_info = local.account_info_infra_webapp_prod

  providers = {
    aws = aws.org_iam
  }
}


module "create-accountmanager-role-with-policy-in-company-infra-prod-assumable-from-org-iam" {
  source = "./modules/create-role-with-policy-in-targetaccount-assumable-from-sourceaccount"

  sourceaccount_id = local.account_info_org_iam.id
  rolename = local.account_manager_role_name
  policyname = local.account_management_policy_name
  policy = local.account_management_policy

  providers = {
    aws = aws.infra_company_prod
  }
}

module "allow-accountmanagers-in-org-iam-to-assume-accountmanager-in-company-infra-prod" {
  source = "./modules/allow-group-in-sourceaccount-to-assume-role-in-targetaccount"

  group_in_sourceaccount = local.account_manager_group_name
  role_in_targetaccount = local.account_manager_role_name
  targetaccount_info = local.account_info_infra_company_prod

  providers = {
    aws = aws.org_iam
  }
}
