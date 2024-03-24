# ec2-instance-managed-by-ssm-with-terraform

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

## バリデーション

Amazon EC2 インスタンスが AWS Systems Manager の管理対象になっているか確認する

```sh
# terraform output -raw instance_id
INSTANCE_ID=$(terraform output -raw instance_id | tee /dev/tty)

# aws ssm start-automation-execution \
#   --document-name AWSSupport-TroubleshootManagedInstance \
#   --parameters InstanceId=${INSTANCE_ID}
AUTOMATION_EXECUTION_ID=$(aws ssm start-automation-execution \
  --document-name AWSSupport-TroubleshootManagedInstance \
  --parameters InstanceId=${INSTANCE_ID} \
  --query 'AutomationExecutionId' \
  --output text | tee /dev/tty)

aws ssm get-automation-execution \
  --automation-execution-id ${AUTOMATION_EXECUTION_ID} \
  --query 'AutomationExecution.StepExecutions[?StepName==`FinalOutput` && StepStatus==`Success`].Outputs.Message' \
  --output text
```
