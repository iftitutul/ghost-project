- Add secretmanagerpolicy.json to EKS_OIDC_ROLE

- Create Sample Secret using AWS CLI

`aws secretsmanager create-secret --name hello-service/password --secret-string "1234"`

`aws secretsmanager update-secret --name hello-service/password --secret-string "123456"`


