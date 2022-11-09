1. put the aws credential in `.env` file
```
AWS_ACCESS_KEY_ID="xxx"
AWS_SECRET_ACCESS_KEY="xxx"
```

2. `set -a` and `source .env`
3. `terraform init`
4. `terraform plan` or `terraform apply`
