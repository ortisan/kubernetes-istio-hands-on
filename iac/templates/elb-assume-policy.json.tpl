{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${oidc_arn}"
      },
      "Condition": {
        "StringEquals": {
          "${oidc_url}:aud": "sts.amazonaws.com",
          "${oidc_url}:sub": "system:serviceaccount:kube-system:aws-loadbalancer-controller"
        }
      },
      "Action": "sts:AssumeRoleWithWebIdentity"
    }
  ]
}