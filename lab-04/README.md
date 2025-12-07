# Lab 4: Integrate Inventory and Audit (AWS - Configuration and CloudTrail)

## Objectives

- Configure AWS CloudTrail integration with FortiCNAPP
- Set up AWS Config integration
- Enable inventory and audit data collection
- Verify data flow from AWS to FortiCNAPP

## Prerequisites

- Completed Lab 3
- AWS account with administrative access
- FortiCNAPP account with integration permissions
- AWS CLI installed and configured

## Lab Steps

### Step 1: Prepare AWS Environment

1. Ensure CloudTrail is enabled in your AWS account
2. Verify AWS Config is enabled
3. Create an IAM role for FortiCNAPP integration

### Step 2: Create IAM Role for FortiCNAPP

Create an IAM role with the following permissions:
- CloudTrail read access
- Config read access
- EC2 describe permissions
- S3 read access (for CloudTrail logs)

### Step 3: Configure FortiCNAPP Integration

1. Log into FortiCNAPP console
2. Navigate to Integrations > AWS
3. Add new AWS account integration
4. Provide AWS account ID and IAM role ARN
5. Enable CloudTrail and Config integrations

### Step 4: Verify Data Collection

1. Wait for initial data sync (may take 10-15 minutes)
2. Check FortiCNAPP inventory dashboard
3. Review audit logs in FortiCNAPP console
4. Verify CloudTrail events are visible

## Expected Results

- AWS account integrated with FortiCNAPP
- CloudTrail events visible in FortiCNAPP
- AWS Config compliance data available
- Inventory of AWS resources populated

## Troubleshooting

- Verify IAM role permissions are correct
- Check CloudTrail is logging to S3
- Ensure AWS Config is enabled in all regions
- Review FortiCNAPP integration logs for errors

## Next Steps

Proceed to [Lab 5: Integrate Agentless Workload Scanning](../lab-05/README.md)

