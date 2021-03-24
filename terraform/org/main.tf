provider "aws" {
  alias  = "root"
  region = local.default_region
}

locals {
  default_region = "us-west-1"

  account_info_org_iam = {
    name  = "herodot-org-iam"
    email = "kiessling.manuel+aws-herodot-org-iam@gmail.com"
  }

  account_info_infra_company_prod = {
    name  = "herodot-infra-company-prod"
    email = "kiessling.manuel+aws-herodot-infra-company-prod@gmail.com"
  }

  account_info_infra_webapp_prod = {
    name  = "herodot-infra-webapp-prod"
    email = "kiessling.manuel+aws-herodot-infra-webapp-prod@gmail.com"
  }
}
