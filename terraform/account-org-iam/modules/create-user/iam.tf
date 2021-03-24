variable "user_name" {
  type = string
}

variable "groups" {
  type = list(string)
}

variable "iam_account_id" {
  type = string
}

resource "aws_iam_user" "default" {
  name = var.user_name
}

resource "aws_iam_user_group_membership" "default" {
  groups = var.groups
  user = aws_iam_user.default.name
}

data "template_file" "user_policy_default" {
  template = file("./modules/create-user/templates/user_policy.tpl")
  vars = {
    user_name = aws_iam_user.default.name
    account_id = var.iam_account_id
  }
}

resource "aws_iam_user_policy" "default" {
  policy = data.template_file.user_policy_default.rendered
  user = aws_iam_user.default.name
}
