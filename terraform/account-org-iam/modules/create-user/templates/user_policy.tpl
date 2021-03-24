{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:ListAccessKeys",
                "iam:CreateAccessKey",
                "iam:UpdateAccessKey",
                "iam:DeleteAccessKey",
                "iam:GetSSHPublicKey",
                "iam:GetAccessKeyLastUsed",
                "iam:GetUser",
                "iam:ListUsers",
                "iam:ListGroups",
                "iam:ListRoles",
                "iam:ListSSHPublicKeys",
                "iam:GetUserPolicy"
            ],
            "Resource": "arn:aws:iam::${account_id}:user/${user_name}"
        }
    ]
}
