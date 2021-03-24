module "create-readonlyaccountmanager-role-without-policy-in-webapp-infra-prod-assumable-from-org-iam" {
  source = "../accounts/modules/create-role-without-policy-in-targetaccount-assumable-from-sourceaccount"

  sourceaccount_id = local.account_info_org_iam.id
  rolename = "ReadonlyAccountManager"
  policy_arn = data.aws_iam_policy.read_only_access.arn

  providers = {
    aws = aws.infra_webapp_prod
  }
}
