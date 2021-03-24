resource "aws_organizations_organization" "main" {
  provider = aws.root

  feature_set = "ALL"
  aws_service_access_principals = ["access-analyzer.amazonaws.com"]
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}


resource "aws_organizations_organizational_unit" "org" {
  provider = aws.root

  name      = "org"
  parent_id = aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "infra" {
  provider = aws.root

  name      = "infra"
  parent_id = aws_organizations_organization.main.roots[0].id
}


resource "aws_organizations_account" "org_iam" {
  provider = aws.root

  name  = local.account_info_org_iam.name
  email = local.account_info_org_iam.email
  parent_id = aws_organizations_organizational_unit.org.id
}

resource "aws_organizations_account" "infra_company_prod" {
  provider = aws.root

  name  = local.account_info_infra_company_prod.name
  email = local.account_info_infra_company_prod.email
  parent_id = aws_organizations_organizational_unit.infra.id
}

resource "aws_organizations_account" "infra_webapp_prod" {
  provider = aws.root

  name  = local.account_info_infra_webapp_prod.name
  email = local.account_info_infra_webapp_prod.email
  parent_id = aws_organizations_organizational_unit.infra.id
}
