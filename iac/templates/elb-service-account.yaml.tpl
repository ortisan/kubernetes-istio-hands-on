apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-loadbalancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${service_role_arn}