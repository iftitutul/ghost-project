### Important Notes
- Add secretmanagerpolicy.json to EKS_OIDC_ROLE
- Add secretmanagerpolicy.json to Node IAM Role [not needed as per docs]

### Create Sample Secret using AWS CLI

`aws secretsmanager create-secret --name hello-service/password --secret-string "1234"`

`aws secretsmanager update-secret --name hello-service/password --secret-string "123456"`

### Hints

- https://gist.github.com/lukaszbudnik/f1f42bd5a57430e3c25034200ba44c2e


