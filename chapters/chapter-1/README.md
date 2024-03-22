# chapter-1

```sh
terraform apply
```

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

> **Result**
>
> ```
> 1. Checks for Amazon VPC Systems Manager VPC Endpoint 'com.amazonaws.ap-northeast-1.ssm':
> - [INFO] No VPC endpoint for Systems Manager found on the EC2 instance VPC: vpc-0955e3b787949d12d.
>
> 2. Checks for the VPC route table entries of the instance's subnet 'subnet-0cc60ff02a51f5ee0:'
> - [INFO] VPC route table found: rtb-06f3955cea1cda451.
> - [INFO] VPC local route (default route) available for 10.0.0.0/16.
> - [WARNING] A local route is required to communicate with the VPC endpoint interface.
> - [WARNING] No route found for 0.0.0.0/0. Internet access is required to connect to the public Systems Manager endpoint.
> - For more information about routing options see https://docs.aws.amazon.com/vpc/latest/userguide/route-table-options.html#route-tables-vpc-peering
> - For more information about route tables see https://docs.aws.amazon.com/vpc/latest/userguide/route-table-options.html#route-tables-vpc-peering
>
> 3. Checks for NACL rules of the instance subnet 'subnet-0cc60ff02a51f5ee0':
> - Check network ACLs requirements instance 'i-078f9468a15e81c8d' for instance subnet 'subnet-0cc60ff02a51f5ee0':
> - Check network ACLs requirements on network ACL 'acl-0e7c2e0e63fcd3aa6':
> - [OK] 'ALL' outbound traffic allowed to '10.0.1.231' from '[1024, 65535]'
>
> 4. Checks EC2 instance 'i-078f9468a15e81c8d' security groups outbound traffic:
> - Check outbound traffic to the public Systems Manager endpoint:
> - [OK] VPC endpoint security group 'sg-0842a8a51bab89580' allows outbound traffic on port '443' to '0.0.0.0/0'.
>
> 5. Checks EC2 instance IAM profile and required permissions:
> - Check Default Host Management Configuration:
> - [INFO] Default Host Management Configuration is Default.
> - [ERROR] No EC2 instance IAM profile attached to the instance: 'i-078f9468a15e81c8d'.
>
> 6. Additional Troubleshooting:
> - Starting with the SSM Agent version 3.1.501.0, you can use the 'ssm-cli' tool to diagnose issues at the operating system level.
> - Troubleshooting managed node availability using ssm-cli:
> - https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-cli.html
> - Troubleshooting reference:
> - https://repost.aws/knowledge-center/systems-manager-ec2-instance-not-appear
> - https://docs.aws.amazon.com/systems-manager/latest/userguide/troubleshooting-ssm-agent.html
> ```

```
terraform destroy
```
