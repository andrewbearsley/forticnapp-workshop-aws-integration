# Lab 2: Integrate AWS Configuration and AWS CloudTrail via CloudFormation

## Objectives

- Integrate AWS Configuration and AWS CloudTrail with FortiCNAPP using CloudFormation

## Lab Steps

### Step 1: Log into AWS Console

1. Navigate to <a href="https://aws.amazon.com/" target="_blank">https://aws.amazon.com/</a>
2. Click **Sign into console**

![AWS IAM sign-in page](images/aws-signin.png)

3. **IMPORTANT:** After logging in, change to your local region (e.g., **Asia Pacific (Singapore)**) using the region selector in the top right of the AWS Console
   - This step is critical - the CloudFormation template will deploy to whatever region is selected
   - If you skip this step, resources will be created in the wrong region

![AWS Console showing region selector set to Asia Pacific (Singapore)](images/aws-console-region-selection.png)

### Step 2: Get CloudFormation Template from FortiCNAPP

1. Log into FortiCNAPP console at <a href="https://partner-demo.lacework.net/" target="_blank">https://partner-demo.lacework.net/</a>
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Integrations** > **Cloud accounts**
4. Click **Add New**
5. Select **Amazon Web Services** as the cloud provider
6. Choose **CloudFormation** as the integration method

![FortiCNAPP console showing Cloud accounts and CloudFormation integration method selected](images/forticnapp-cloudformation-integration.png)

7. In the **Choose integration type** dropdown, select **CloudTrail+Configuration**
8. Click **Run CloudFormation Template**
9. This will open the CloudFormation stack creation page in your chosen AWS session (already logged in from Step 1)

### Step 3: Configure and Deploy CloudFormation Stack

The CloudFormation template should now be open in your AWS Console on Step 1 (Create stack). The template URL should already be populated. Configure the stack:

![AWS CloudFormation Create stack page with template URL pre-populated](images/aws-cloudformation-create-stack.png)

1. Create Stack: Click **Next** to proceed to the next step
2. Specify stack details: Review the parameters and leave them as default
   - The default configuration will create a new CloudTrail trail
   - **Note**: For simplicity, we are creating a new CloudTrail in this lab. Customer environments will almost always have an existing centralised CloudTrail

   ![AWS CloudFormation Specify stack details page showing stack name and parameters](images/aws-cloudformation-stack-details.png)

   - Stack name will be pre-populated (e.g., `AWS-CloudTrail`)
   - API Token and other parameters are pre-configured
   - Click **Next** to proceed to the next step
3. Configure Stack Options: Leave as default (no changes needed)
   - In the **Capabilities** section, check the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox
   - Click **Next** to proceed to the next step
4. Review and Create Stack: 
   - Review the stack details and leave as default
   - Click **Submit** to deploy the stack
   - Monitor the stack creation progress. Refresh via the **Refresh** buttons next to 'Stacks' and 'Events'.
   - Review Resources to see the resources created by the stack.
   - Review Outputs to see the outputs of the stack.
   - Review Events to see the events of the stack.
   - Wait for stack status to show **CREATE_COMPLETE**

![CloudFormation stack events showing CREATE_COMPLETE](images/aws-cloudformation-complete.png)

   - Click **Close** to close the stack creation page

### Step 4: Review CloudFormation Resources

After the stack creation is complete, review the resources that were created:

#### Review CloudFormation Outputs

1. In the CloudFormation stack details page, click on the **Outputs** tab
2. Review the outputs, including the **RoleARN**
   - This is the cross-account access role that FortiCNAPP uses to access your AWS account
   - Note this value for reference

#### Review CloudTrail

1. Navigate to **CloudTrail** service in AWS Console
2. Click on **Trails** in the left navigation
3. Find the trail that was created (it will have a name ending in `-laceworkcws`, e.g., `AWS-CloudTrail-laceworkcws`)

![AWS CloudTrail dashboard showing the created trail](images/aws-cloudtrail-created.png)

4. Click on the trail name to view details
5. Review the **General details** section:
   - Verify **SNS notification delivery** is enabled
     - This is how FortiCNAPP receives notifications when the CloudTrail is updated
   - Note the **Trail log location** (S3 bucket name)
     - This is the S3 bucket where CloudTrail logs are stored
     - If integrating to an existing CloudTrail, you would need these details

![CloudTrail details showing trail log location and SNS notification delivery](images/aws-cloudtrail-details.png)

#### Review IAM Role

1. Navigate to **IAM** service in AWS Console
2. Click on **Roles** in the left navigation
3. Find the IAM role that was created (it will be related to the CloudFormation stack name)

![IAM Roles showing the Lacework cross-account role](images/aws-iam-role.png)

4. Click on the role name to view details
5. Review the role's permissions and trust relationships
   - The trust relationship will show that FortiCNAPP (Lacework) can assume this role

![IAM role trust relationship showing FortiCNAPP cross-account access](images/aws-iam-role-trust.png)

### Step 5: Verify Integration in FortiCNAPP

1. Return to FortiCNAPP console
2. Navigate to **Settings** > **Integrations** > **Cloud accounts**
3. Verify the AWS account appears in the list with Type 'Configuration' and 'CloudTrail'
   - You may need to refresh the browser to see the new integration.

![FortiCNAPP Cloud accounts showing new AWS integration](images/forticnapp-new-integration.png)

## What did we do here?

We connected FortiCNAPP to our AWS account using CloudFormation. One stack deployed everything needed: a CloudTrail trail to capture API activity, an S3 bucket for log storage, SNS notifications to alert FortiCNAPP when new logs arrive, and a cross-account IAM role so FortiCNAPP can read our configuration.

This is the foundation for everything else. Configuration integration gives FortiCNAPP visibility into what resources exist (for compliance and inventory). CloudTrail integration gives it visibility into what's happening (for threat detection and alerts). Without these two, FortiCNAPP is flying blind.
