# Lab 8: Install integrations via Terraform

## Objectives

- Use Lacework CLI to generate Terraform configuration for AWS integration
- Deploy FortiCNAPP integrations using Terraform from AWS CloudShell
- Understand infrastructure as code approach for integrations
- Verify integration deployment

## Prerequisites

- Completed Lab 7 (Lacework CLI and Terraform installed in CloudShell)
- AWS account with appropriate permissions
- FortiCNAPP account access with API key configured

## Lab Steps

### Step 1: Open AWS CloudShell

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. After logging in, change to your local region (e.g., **Asia Pacific (Singapore)**) using the region selector in the top right of the AWS Console
4. Click the **CloudShell** icon in the top navigation bar (cloud icon with `>_` symbol)
5. Wait for CloudShell to initialize

### Step 2: Verify Lacework CLI Configuration

Verify that the Lacework CLI is configured and working:

```bash
lacework version
lacework api get /api/v2/UserProfile
```

If the CLI is not in your PATH, add it:

```bash
export PATH="$HOME/bin:$PATH"
```

### Step 3: Generate Terraform Configuration for AWS Integration

Use the Lacework CLI to generate Terraform code for AWS integration. This will create Terraform files for CloudTrail and Configuration assessment:

```bash
lacework generate cloud-account aws \
  --config --cloudtrail --noninteractive \
  --aws_region ap-southeast-1
```

**Parameters explained:**
- `--config`: Enable AWS Configuration integration
- `--cloudtrail`: Enable AWS CloudTrail integration
- `--noninteractive`: Run without prompts (uses defaults)
- `--aws_region ap-southeast-1`: Specify the AWS region (Asia Pacific - Singapore)

This command generates Terraform files in the `~/lacework/aws` directory.

### Step 4: Review Generated Terraform Files

Navigate to the generated Terraform directory and review the files:

```bash
cd ~/lacework/aws
ls -la
```

**Note**: The Lacework CLI generates only a `main.tf` file. It does not generate `variables.tf`, `terraform.tfvars`, or `outputs.tf` files. This is expected behavior - the generated configuration uses Lacework Terraform modules that have sensible defaults built in, so additional variable files are not required.

The Lacework CLI generates a minimal Terraform configuration that uses pre-built modules from the Lacework Terraform registry. This is a best practice approach that simplifies deployment and maintenance.

Review the generated configuration:

```bash
cat main.tf
```

The `main.tf` file contains:
- **Terraform provider configuration**: Defines the required AWS and Lacework providers
- **AWS Config module**: Uses the `lacework/config/aws` module to set up Configuration assessment integration
- **CloudTrail module**: Uses the `lacework/cloudtrail/aws` module to set up CloudTrail integration
- **Module integration**: The CloudTrail module references the IAM role created by the Config module

This modular approach means:
- The complex IAM policies, S3 bucket configurations, and CloudTrail setup are handled by the modules
- You get a clean, maintainable Terraform configuration
- Updates to the modules automatically provide improvements and security fixes
- Less code to maintain while still having full control over the deployment
- **No need for tfvars files**: The modules use default values, so you can deploy directly without additional configuration files

**Optional: Creating Custom Variables**

If you need to customize the configuration (e.g., different region, custom naming, etc.), you can create your own `variables.tf` and `terraform.tfvars` files, but this is not required for this lab. The generated `main.tf` is ready to use as-is.

### Step 5: Initialize Terraform

Initialize Terraform to download the required providers:

```bash
terraform init
```

This will download the AWS and Lacework Terraform providers.

### Step 6: Review Terraform Plan

Review what Terraform will create before applying:

```bash
terraform plan
```

This shows you:
- Resources that will be created (IAM roles, CloudTrail, S3 buckets, etc.)
- Any changes that will be made
- Output values that will be generated

The plan output will display in your terminal. Review it carefully to understand what will be deployed.

**Optional: Save the plan to a file:**

If you want to save the plan output for later review or documentation:

```bash
terraform plan -out=tfplan
```

This saves the plan to a binary file `tfplan` that can be used later with `terraform apply tfplan`.

**Or save as text:**

To save the plan as readable text:

```bash
terraform plan > plan-output.txt
```

Then view it with:

```bash
cat plan-output.txt
```

### Step 7: Apply Terraform Configuration

If the plan looks correct, apply the Terraform configuration to deploy the integration:

```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

**Note**: This process may take several minutes as it creates:
- IAM roles and policies
- CloudTrail (if not already exists)
- S3 buckets for CloudTrail logs
- SNS topics for notifications
- Configuration assessment integration

### Step 8: Verify Integration Deployment

After the Terraform apply completes successfully, verify the integration:

1. **Using Lacework CLI:**
```bash
lacework cloud-account list
```

You should see entries for:
- `AwsCfg` (Configuration integration)
- `AwsCtSqs` (CloudTrail integration)

2. **In FortiCNAPP Console:**
   - Log into FortiCNAPP console at https://partner-demo.lacework.net/
   - Ensure tenant is set to **FORTINETAPACDEMO**
   - Navigate to **Settings** > **Integrations** > **Cloud accounts**
   - Verify that your AWS account appears with both Configuration and CloudTrail integrations active

### Step 9: Review Terraform Outputs

View the Terraform outputs to see important information:

```bash
terraform output
```

This will show values like:
- IAM role ARNs
- CloudTrail ARN
- S3 bucket names
- Integration status

### Step 10: Clean Up Resources

After completing the lab, clean up the resources created by Terraform:

1. **Review what will be destroyed:**
```bash
terraform plan -destroy
```

This shows you what resources will be removed.

2. **Destroy the resources:**
```bash
terraform destroy
```

When prompted, type `yes` to confirm the destruction.

**Note**: This will:
- Remove the FortiCNAPP integrations from your AWS account
- Delete IAM roles and policies created by Terraform
- Remove S3 buckets created for CloudTrail (if created by Terraform)
- Remove SNS topics created for notifications (if created by Terraform)
- **Note**: If you're using an existing CloudTrail, it will not be deleted, only the integration will be removed

3. **Verify cleanup:**
```bash
lacework cloud-account list
```

The AWS integrations should no longer appear in the list.

4. **Optional: Clean up Terraform files:**
If you want to remove the generated Terraform files:
```bash
cd ~
rm -rf ~/lacework/aws
```

## Expected Results

- Terraform configuration generated successfully using Lacework CLI
- AWS Configuration integration deployed and active
- AWS CloudTrail integration deployed and active
- Integration visible in FortiCNAPP console
- IAM roles and AWS resources created as expected
- Resources successfully destroyed and cleaned up after lab completion


## Additional Resources

- [FortiCNAPP Documentation: AWS Integration Terraform from AWS CloudShell](https://docs.fortinet.com/document/forticnapp/latest/administration-guide/283460/aws-integration-terraform-from-aws-cloudshell)


