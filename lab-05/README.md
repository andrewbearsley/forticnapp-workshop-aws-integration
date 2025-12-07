# Lab 5: Integrate Agentless Workload Scanning

## Objectives

- Understand agentless scanning capabilities
- Configure agentless workload scanning for AWS EC2 instances
- Perform initial vulnerability scans
- Review scan results in FortiCNAPP

## Prerequisites

- Completed Lab 4
- AWS EC2 instances running (Linux or Windows)
- Security groups configured to allow scanning
- FortiCNAPP integration active

## Lab Steps

### Step 1: Enable Agentless Scanning

1. Navigate to FortiCNAPP console
2. Go to Integrations > AWS > Agentless Scanning
3. Enable agentless scanning for your AWS account
4. Configure scanning schedule and scope

### Step 2: Configure Scanning Parameters

1. Select regions to scan
2. Choose instance types to include
3. Set scan frequency (daily, weekly, etc.)
4. Configure scan depth and scope

### Step 3: Perform Initial Scan

1. Trigger manual scan from FortiCNAPP console
2. Monitor scan progress
3. Wait for scan completion (typically 15-30 minutes)

### Step 4: Review Scan Results

1. Navigate to Vulnerabilities dashboard
2. Review discovered vulnerabilities
3. Examine affected resources
4. Review severity classifications

## Expected Results

- Agentless scanning enabled and configured
- Initial scan completed successfully
- Vulnerability data visible in FortiCNAPP
- Resources identified with security issues

## Troubleshooting

- Verify EC2 instances are accessible
- Check security group rules allow scanning
- Ensure IAM permissions include EC2 describe access
- Review scan logs for connection issues

## Next Steps

Proceed to [Lab 6: Install Linux Agent](../lab-06/README.md)

