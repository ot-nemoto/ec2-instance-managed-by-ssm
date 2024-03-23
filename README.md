# ec2-instance-managed-by-ssm

-   SSM で管理するプライベートネットワークのインスタンスを作成する

### 事前準備

```sh
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

```sh
terraform init
```

### インフラストラクチャの作成

```sh
terraform apply
```

### インフラストラクチャの削除

```sh
terraform destroy
```

## SSM Automation で SSM でインスタンスが管理されているかを検証する

-   [chapter-1](./chapters/chapter-1/)
-   [chapter-2](./chapters/chapter-2/)
