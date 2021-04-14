locals {
  default_region = "us-west-1"

  account_info_org_iam = {
    id    = "507397081639"
    name  = "herodot-org-iam"
  }

  account_info_infra_webapp_preprod = {
    id    = "619527075300"
    name  = "herodot-infra-webapp-prod"
  }

  account_info_infra_webapp_prod = {
    id    = "230024871185"
    name  = "herodot-infra-webapp-prod"
  }

  account_info_infra_company_prod = {
    id    = "829748688443"
    name  = "herodot-infra-company-prod"
  }

  account_manager_group_name = "AccountManagers"
  account_manager_role_name = "AccountManager"
}


provider "aws" {
  region     = local.default_region
}

provider "aws" {
  region     = local.default_region
  alias      = "org_iam"
}

provider "aws" {
  alias = "infra_webapp_prod"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_info_infra_webapp_prod.id}:role/${local.account_manager_role_name}"
  }
  region = local.default_region
}

provider "aws" {
  alias = "infra_webapp_preprod"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_info_infra_webapp_preprod.id}:role/${local.account_manager_role_name}"
  }
  region = local.default_region
}

provider "aws" {
  alias = "infra_company_prod"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_info_infra_company_prod.id}:role/${local.account_manager_role_name}"
  }
  region = local.default_region
}


data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  provider = aws.org_iam
}
