variable "targetaccount_info" {
  type = object({id = string, name = string})
}

variable "group_in_sourceaccount" {
  type = string
}

variable "role_in_targetaccount" {
  type = string
}

resource "aws_iam_policy" "allow_to_assume_role_in_targetaccount" {
  name = "allow-assume-role-${var.role_in_targetaccount}-in-${var.targetaccount_info.name}"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${var.targetaccount_info.id}:role/${var.role_in_targetaccount}"
        }
    ]
}
EOT
}

resource "aws_iam_group_policy_attachment" "allow_to_assume_role_in_targetaccount" {
  policy_arn = aws_iam_policy.allow_to_assume_role_in_targetaccount.arn
  group = var.group_in_sourceaccount
}
