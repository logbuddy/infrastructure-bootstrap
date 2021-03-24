# This creates a role in the target AWS account that can generally be assumed from the source AWS account, together with a policy that defines what users assuming the role are allowed to do in the target account.
# Note that this is not sufficient to enable IAM users from the source AWS account to actually assume this role - it also needs a specific sts:AssumeRole policy within the source account for the IAM user (or its group), which can be defined through module `allow-group-in-sourceaccount-to-assume-role-in-targetaccount`.

variable "sourceaccount_id" {
  type = string
}

variable "rolename" {
  type = string
}

variable "policy_arn" {
  type = string
}


output "rolename" {
  value = aws_iam_role.default.name
}


resource "aws_iam_role" "default" {
  name = var.rolename
  max_session_duration = "28800"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::${var.sourceaccount_id}:root"
    },
    "Action": "sts:AssumeRole"
  }
}
EOT
}

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = var.policy_arn
  role = aws_iam_role.default.name
}
