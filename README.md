# logbuddy

## Infrastructure Bootstrap Project

### AWS Accounts

668123239304 - herodot-root                 - kiessling.manuel+aws-herodot-root@gmail.com
507397081639 - herodot-org-iam              - kiessling.manuel+aws-herodot-org-iam@gmail.com
829748688443 - herodot-infra-company-prod   - kiessling.manuel+aws-herodot-infra-company-prod@gmail.com
619527075300 - herodot-infra-webapp-preprod - kiessling.manuel+aws-herodot-infra-webapp-preprod@gmail.com
230024871185 - herodot-infra-webapp-prod    - kiessling.manuel+aws-herodot-infra-webapp-prod@gmail.com

071157021432 - Personal main account of Manuel Kießling
878092365830 - Proof-of-concept account, part of Org owned by 071157021432


### Getting started

When creating the infrastructure for the very first time, there are some steps that need to be taken manually:

- Create a new AWS Account "herodot-root" which serves as the account owning the AWS Organization
- Set up MFA auth for this account
- Create AWS API credentials and use them to configure your local AWS CLI setup

You can now terraform the AWS Organization with its Organizational Units (OU) and all AWS Accounts within these OUs, by running `terraform init` and then `terraform apply` within folder `terraform/org`.

Once this is done, you need to manually set passwords for the Root users of the new AWS Accounts that have been created, using the "Forgot password?" process of AWS.

For each account's Root user, please enable MFA.

Then, create API credentials for each AWS Account root user and put these into file `terraform/accounts/terraform.tfvars`, using `terraform/accounts/terraform.tfvars.dist` as a template.

Next, switch to `terraform/accounts` and run `terraform init` and then `terraform apply` there.

This creates IAM user "AccountManager" in account "herodot-org-iam" - use its API credentials to fully set up the herodot-org-iam account via `terraform/account-org-iam`.

This in turn will set up all personal IAM users in herodot-org-iam, which are then able to assume the AccountManager role in all other accounts (use bin/assume-role.sh for this when working on the command line), and are therefore best suited for any further AWS work from then on.

Once bootstrapping is done, make sure to remove all Access Key ID / Secret Access Key pairs for all Root Users of all AWS accounts!

For every IAM user newly created in account herodot-org-iam, you need to manually enable and set a AWS Console Access password and provide this to the user.


### What this project does

This project is used to terraform the very fundamentals of our whole AWS setup. To do so, it:

- Sets up an AWS Organization
- Creates all AWS Accounts we need within this organization
- Sets Service Control Policies and other limits to make the AWS Accounts safer to use
- Create a role "AccountManager" in each AWS account, so that Terraform runs for all the other setups can assume this role and do their work in the respective AWS accounts

While doing the bootstrapping, we need full access to each of our AWS accounts.

To achieve this, we need a set of fully privileged AWS API credentials for each of our AWS account.

For the root account herodot-root, this is straight-forward: simply get an Access Key ID and its Secret Access Key of the Root User kiessling.manuel+aws-herodot-root@gmail.com from the AWS Web Console, and configure these locally using `aws configure`.

For the other accounts, like herodot-org-iam and herodot-infra-webapp-prod, you also need to retrieve an Access Key ID and its Secret Access Key of each Root User kiessling.manuel+aws-herodot-org-iam@gmail.com and kiessling.manuel+aws-herodot-infra-webapp-prod@gmail.com respectively, and put these into a file named terraform.tfvars - a file that intentionally is not part of git.

Use file terraform.tfvars.dist as the template for the files' structure.
