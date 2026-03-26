#!/bin/bash
# CloudShell Cleanup Script
# This script cleans up CloudShell artifacts created during labs 4, 8, 10, and 11
#
# To use: Copy and paste this entire script into AWS CloudShell, or save as a file and run:
#   bash cloudshell_cleanup.sh

set -e

# Disable AWS CLI pager to prevent interactive prompts
export AWS_PAGER=""

echo "=== FortiCNAPP Workshop CloudShell Cleanup ==="
echo ""

# Step 1: Destroy Terraform resources first (Lab 9)
# This removes Terraform-managed AWS integrations
echo "Checking for Terraform deployments..."
if [ -d "$HOME/lacework/aws" ]; then
    echo "  Found Terraform working directory: ~/lacework/aws"

    # Navigate to the Terraform directory
    cd "$HOME/lacework/aws" || {
        echo "  Warning: Failed to navigate to ~/lacework/aws directory"
        cd "$HOME"
    }

    # Check if terraform command is available
    if command -v terraform &>/dev/null || [ -f "$HOME/bin/terraform" ]; then
        TERRAFORM_CMD="terraform"
        if [ -f "$HOME/bin/terraform" ]; then
            TERRAFORM_CMD="$HOME/bin/terraform"
        fi

        # Check if terraform is initialized
        if [ ! -d ".terraform" ] && [ ! -f "terraform.tfstate" ] && [ ! -f ".terraform/terraform.tfstate" ]; then
            echo "  Terraform not initialized - initializing first..."
            if $TERRAFORM_CMD init -upgrade 2>/dev/null; then
                echo "  Done: Terraform initialized"
            else
                echo "  Warning: Terraform init failed - may not have resources to destroy"
            fi
        fi

        # Run terraform destroy with auto-approve
        echo "  Running terraform destroy..."
        if $TERRAFORM_CMD destroy -auto-approve 2>/dev/null; then
            echo "  Done: Terraform resources destroyed successfully"
        else
            echo "  Warning: Terraform destroy encountered errors (check output above)"
            echo "  This may be normal if no resources exist or were already destroyed"
        fi
    else
        echo "  Warning: Terraform command not found - skipping destroy"
        echo "  You may need to manually destroy Terraform resources"
    fi

    # Return to home directory
    cd "$HOME"
else
    echo "  - No Terraform working directory found (~/lacework/aws does not exist)"
    echo "  Skipping Terraform init and destroy"
fi

# Step 2: Terminate all EC2 instances
echo "Terminating EC2 instances..."
if command -v aws &>/dev/null; then
    # Get all running and stopped EC2 instances
    INSTANCES=$(aws ec2 describe-instances --no-cli-pager --query 'Reservations[].Instances[].InstanceId' --output text --filters "Name=instance-state-name,Values=running,stopped" 2>/dev/null || echo "")

    if [ -n "$INSTANCES" ]; then
        echo "  Found EC2 instances to terminate:"
        for instance in $INSTANCES; do
            echo "    - $instance"
        done
        echo "  Terminating instances..."
        if aws ec2 terminate-instances --instance-ids $INSTANCES --no-cli-pager 2>/dev/null; then
            echo "  Done: Termination request sent for all instances"
        else
            echo "  Warning: Failed to terminate some instances"
        fi
    else
        echo "  - No EC2 instances found"
    fi
else
    echo "  - AWS CLI not found (skipping EC2 termination)"
fi

# Step 3: Remove Terraform binary
echo "Removing Terraform..."
if [ -f "$HOME/bin/terraform" ]; then
    rm -f "$HOME/bin/terraform"
    echo "  Terraform removed from bin/"
fi
if [ -f "$HOME/terraform" ]; then
    rm -f "$HOME/terraform"
    echo "  Terraform removed from home directory"
fi

# Step 4: Remove Lacework CLI binary
echo "Removing Lacework CLI..."
if [ -f "$HOME/bin/lacework" ]; then
    rm -f "$HOME/bin/lacework"
    echo "  Lacework CLI removed"
else
    echo "  Lacework CLI not found"
fi

# Step 5: Remove cloned repositories
echo "Removing cloned repositories..."
if [ -d "$HOME/lacework-iac-scan-example" ]; then
    rm -rf "$HOME/lacework-iac-scan-example"
    echo "  Removed lacework-iac-scan-example repository"
fi

if [ -d "$HOME/lacework-sca-scan-example" ]; then
    rm -rf "$HOME/lacework-sca-scan-example"
    echo "  Removed lacework-sca-scan-example repository"
fi

# Step 5a: Remove LICENSE files and other workshop artifacts
echo "Removing LICENSE files and workshop artifacts..."
for f in LICENSE.txt LICENSES.txt sbom.json terraform.zip; do
    if [ -f "$HOME/$f" ]; then
        rm -f "$HOME/$f"
        echo "  Removed $f"
    fi
done
# Remove terraform binary if it's in home directory (not in bin/)
if [ -f "$HOME/terraform" ] && [ ! -f "$HOME/bin/terraform" ]; then
    rm -f "$HOME/terraform"
    echo "  Removed terraform binary from home directory"
fi
# Remove any malformed export/command files or directories (often created by copy-paste errors)
find "$HOME" -maxdepth 1 \( -type f -o -type d \) \( -name "*export*" -o -name "*TF_PLUGIN*" -o -name "*Configure*" -o -name "*Terraform*" \) 2>/dev/null | while read -r item; do
    if [ -e "$item" ]; then
        if [ -f "$item" ]; then
            if head -1 "$item" 2>/dev/null | grep -qE "(export|TF_PLUGIN|Configure)" 2>/dev/null; then
                rm -f "$item"
                echo "  Removed malformed file: $(basename "$item")"
            fi
        elif [ -d "$item" ]; then
            dirname=$(basename "$item")
            if echo "$dirname" | grep -qiE "(export|TF_PLUGIN|Configure|Terraform)" 2>/dev/null; then
                rm -rf "$item"
                echo "  Removed malformed directory: $dirname"
            fi
        fi
    fi
done

# Step 6: Remove Terraform working directory
echo "Removing Terraform working directory..."
if [ -d "$HOME/lacework" ]; then
    rm -rf "$HOME/lacework"
    echo "  Removed ~/lacework directory"
fi

# Step 6a: Remove Terraform plugin cache directory
echo "Removing Terraform plugin cache..."
if [ -d "$HOME/.terraform.d" ]; then
    rm -rf "$HOME/.terraform.d"
    echo "  Removed ~/.terraform.d directory"
else
    echo "  ~/.terraform.d directory not found"
fi

# Step 7: Remove Lacework CLI configuration
echo "Removing Lacework CLI configuration..."
if [ -d "$HOME/.lacework" ]; then
    rm -rf "$HOME/.lacework"
    echo "  Removed Lacework CLI configuration directory"
else
    echo "  Lacework CLI configuration directory not found"
fi

if [ -f "$HOME/.lacework.toml" ]; then
    rm -f "$HOME/.lacework.toml"
    echo "  Removed Lacework CLI config file (.lacework.toml)"
else
    echo "  Lacework CLI config file not found"
fi

# Step 8: Remove component installations
echo "Removing Lacework components..."
if [ -d "$HOME/.lacework/components" ]; then
    rm -rf "$HOME/.lacework/components"
    echo "  Removed Lacework components"
fi

# Step 9: Clean up bin directory if empty
if [ -d "$HOME/bin" ] && [ -z "$(ls -A $HOME/bin)" ]; then
    rmdir "$HOME/bin"
    echo "  Removed empty bin directory"
fi

# Step 10: Remove PATH modifications from .bashrc if they exist (SAFE - only removes specific lines)
echo "Cleaning up .bashrc..."
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "  Created backup of .bashrc"

    sed -i '/^export PATH=\$HOME\/bin:\$PATH$/d' "$HOME/.bashrc" 2>/dev/null || \
    sed -i '' '/^export PATH=\$HOME\/bin:\$PATH$/d' "$HOME/.bashrc" 2>/dev/null

    sed -i '/^export PATH=HOME\/bin:/d' "$HOME/.bashrc" 2>/dev/null || \
    sed -i '' '/^export PATH=HOME\/bin:/d' "$HOME/.bashrc" 2>/dev/null

    sed -i '/^export TF_PLUGIN_CACHE_DIR=/d' "$HOME/.bashrc" 2>/dev/null || \
    sed -i '' '/^export TF_PLUGIN_CACHE_DIR=/d' "$HOME/.bashrc" 2>/dev/null

    if bash -n "$HOME/.bashrc" 2>/dev/null; then
        echo "  Cleaned up .bashrc (syntax verified)"
    else
        echo "  Warning: Syntax error detected after cleanup - restoring backup"
        cp "$HOME/.bashrc.backup."* "$HOME/.bashrc" 2>/dev/null
        echo "  Restored .bashrc from backup"
    fi
else
    echo "  .bashrc not found"
fi

# Step 11: Delete CloudFormation stacks first (stops infrastructure that writes to S3)
echo "Deleting CloudFormation stacks..."
if command -v aws &>/dev/null; then
    # Helper: find the parent stack from a list (shortest name = parent, nested stacks have suffixes)
    find_parent_stack() {
        local prefix=$1
        local all_stacks
        all_stacks=$(aws cloudformation describe-stacks --no-cli-pager --query "Stacks[?starts_with(StackName, \`$prefix\`)].StackName" --output text 2>/dev/null || echo "")
        if [ -z "$all_stacks" ]; then
            echo ""
            return
        fi
        local parent=""
        for stack in $all_stacks; do
            if [ -z "$parent" ] || [ ${#stack} -lt ${#parent} ]; then
                parent="$stack"
            fi
        done
        echo "$parent"
    }

    # Helper: delete a CloudFormation stack with retry logic
    delete_cfn_stack() {
        local stack_name=$1
        echo "  Deleting $stack_name stack (this may take a few minutes)..."
        aws cloudformation delete-stack --stack-name "$stack_name" --no-cli-pager 2>/dev/null || true
        echo "    Waiting for deletion..."
        if aws cloudformation wait stack-delete-complete --stack-name "$stack_name" --no-cli-pager 2>/dev/null; then
            echo "    Done: $stack_name deleted"
            return 0
        fi
        # Stack deletion failed - retry with retained resources
        echo "    Retrying with retained resources..."
        FAILED_RESOURCES=$(aws cloudformation describe-stack-resources --stack-name "$stack_name" --no-cli-pager \
            --query 'StackResources[?ResourceStatus==`DELETE_FAILED`].LogicalResourceId' --output text 2>/dev/null || echo "")
        if [ -n "$FAILED_RESOURCES" ]; then
            aws cloudformation delete-stack --stack-name "$stack_name" --retain-resources $FAILED_RESOURCES --no-cli-pager 2>/dev/null || true
            aws cloudformation wait stack-delete-complete --stack-name "$stack_name" --no-cli-pager 2>/dev/null || true
            echo "    Done: $stack_name deleted (some resources retained for manual cleanup)"
        else
            echo "    Warning: Could not determine failed resources for $stack_name"
        fi
    }

    # Delete AWS-AgentlessScanning stack (parent only, not nested stacks)
    AGENTLESS_STACK=$(find_parent_stack "AWS-AgentlessScanning")
    if [ -n "$AGENTLESS_STACK" ]; then
        delete_cfn_stack "$AGENTLESS_STACK"
    else
        echo "  - AWS-AgentlessScanning stack not found"
    fi

    # Delete AWS-Cloudtrail stack (parent only)
    CLOUDTRAIL_STACK=$(find_parent_stack "AWS-Cloudtrail")
    if [ -n "$CLOUDTRAIL_STACK" ]; then
        delete_cfn_stack "$CLOUDTRAIL_STACK"
    else
        echo "  - AWS-Cloudtrail stack not found"
    fi
else
    echo "  - AWS CLI not found (skipping CloudFormation stack cleanup)"
fi

# Step 12: Delete CloudTrail trails created by workshop
echo "Deleting CloudTrail trails created by workshop..."
if command -v aws &>/dev/null; then
    ALL_TRAILS=$(aws cloudtrail list-trails --no-cli-pager --query 'Trails[].Name' --output text 2>/dev/null || echo "")

    WORKSHOP_TRAILS=""
    if [ -n "$ALL_TRAILS" ]; then
        for trail in $ALL_TRAILS; do
            if echo "$trail" | grep -qi "lacework" 2>/dev/null; then
                WORKSHOP_TRAILS="$WORKSHOP_TRAILS $trail"
            fi
        done
    fi

    if [ -n "$WORKSHOP_TRAILS" ]; then
        for trail in $WORKSHOP_TRAILS; do
            echo "  Deleting CloudTrail trail: $trail"
            aws cloudtrail stop-logging --name "$trail" --no-cli-pager 2>/dev/null || true
            sleep 2
            if aws cloudtrail delete-trail --name "$trail" --no-cli-pager 2>/dev/null; then
                echo "    Done: Deleted CloudTrail trail: $trail"
            else
                echo "    Warning: Failed to delete CloudTrail trail: $trail"
            fi
        done
    else
        echo "  - No workshop CloudTrail trails found"
    fi
else
    echo "  - AWS CLI not found (skipping CloudTrail cleanup)"
fi

# Step 13: Delete EC2 key pairs
echo "Deleting EC2 key pairs..."
if command -v aws &>/dev/null; then
    ALL_KEY_PAIRS=$(aws ec2 describe-key-pairs --no-cli-pager --query 'KeyPairs[].KeyName' --output text 2>/dev/null || echo "")

    if [ -n "$ALL_KEY_PAIRS" ]; then
        for key_pair in $ALL_KEY_PAIRS; do
            echo "  Deleting EC2 key pair: $key_pair"
            if aws ec2 delete-key-pair --key-name "$key_pair" --no-cli-pager 2>/dev/null; then
                echo "    Done: Deleted EC2 key pair: $key_pair"
            else
                echo "    Warning: Failed to delete EC2 key pair: $key_pair"
            fi
        done
    else
        echo "  - No EC2 key pairs found"
    fi
else
    echo "  - AWS CLI not found (skipping EC2 key pair cleanup)"
fi

# Step 14: Delete security groups (except 'default')
echo "Deleting security groups (except 'default')..."
if command -v aws &>/dev/null; then
    SECURITY_GROUPS=$(aws ec2 describe-security-groups --no-cli-pager --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text 2>/dev/null || echo "")

    if [ -n "$SECURITY_GROUPS" ]; then
        for sg_id in $SECURITY_GROUPS; do
            echo "  Deleting security group: $sg_id"
            if aws ec2 delete-security-group --group-id "$sg_id" --no-cli-pager 2>/dev/null; then
                echo "    Done: Deleted security group: $sg_id"
            else
                echo "    Warning: Failed to delete security group: $sg_id (may be in use)"
            fi
        done
    else
        echo "  - No security groups found (other than 'default')"
    fi
else
    echo "  - AWS CLI not found (skipping security group cleanup)"
fi

# Step 15: Empty and delete S3 buckets (after stacks deleted so nothing writes new objects)
echo "Emptying and deleting Lacework-related S3 buckets..."
if command -v aws &>/dev/null; then
    ALL_BUCKETS=$(aws s3api list-buckets --query 'Buckets[].Name' --output text --no-cli-pager 2>/dev/null || echo "")

    LACEWORK_BUCKETS=""
    if [ -n "$ALL_BUCKETS" ]; then
        for bucket in $ALL_BUCKETS; do
            if echo "$bucket" | grep -qiE "(lacework|lw-)" 2>/dev/null; then
                LACEWORK_BUCKETS="$LACEWORK_BUCKETS $bucket"
            fi
        done
    fi

    if [ -n "$LACEWORK_BUCKETS" ]; then
        TMPFILE=$(mktemp)
        for bucket in $LACEWORK_BUCKETS; do
            echo "  Processing bucket: $bucket"

            if ! aws s3api head-bucket --bucket "$bucket" --no-cli-pager 2>/dev/null; then
                echo "    - Bucket does not exist or is already deleted"
                continue
            fi

            # Remove all current objects
            echo "    Removing objects..."
            aws s3 rm "s3://$bucket" --recursive --no-cli-pager 2>/dev/null || true

            # Remove all object versions and delete markers
            # Uses --no-paginate to get one page at a time (max 1000 items)
            # Uses a temp file to avoid pipe/echo issues with large JSON
            echo "    Removing versions and delete markers..."
            BATCH_COUNT=0
            while true; do
                # Get one page of versions and markers
                aws s3api list-object-versions --bucket "$bucket" --no-paginate \
                    --output json --no-cli-pager 2>/dev/null > "$TMPFILE" || break

                # Use python3 (available on CloudShell) to extract items and build delete request
                DELETE_JSON=$(python3 -c "
import json, sys
with open('$TMPFILE') as f:
    data = json.load(f)
items = []
for v in data.get('Versions', []) or []:
    items.append({'Key': v['Key'], 'VersionId': v['VersionId']})
for m in data.get('DeleteMarkers', []) or []:
    items.append({'Key': m['Key'], 'VersionId': m['VersionId']})
if items:
    print(json.dumps({'Objects': items, 'Quiet': True}))
" 2>/dev/null || echo "")

                if [ -z "$DELETE_JSON" ]; then
                    break
                fi

                echo "$DELETE_JSON" > "$TMPFILE.del"
                aws s3api delete-objects --bucket "$bucket" --delete "file://$TMPFILE.del" \
                    --no-cli-pager 2>/dev/null || break
                BATCH_COUNT=$((BATCH_COUNT + 1))
                echo "      Deleted batch $BATCH_COUNT..."
            done

            if [ "$BATCH_COUNT" -gt 0 ]; then
                echo "    Emptied bucket ($BATCH_COUNT batches)"
            fi

            # Delete the bucket
            echo "    Deleting bucket..."
            if aws s3api delete-bucket --bucket "$bucket" --no-cli-pager 2>/dev/null; then
                echo "    Done: Deleted bucket: $bucket"
            else
                echo "    Warning: Failed to delete bucket: $bucket"
                echo "    Try manually: aws s3 rb s3://$bucket --force"
            fi
        done
        rm -f "$TMPFILE" "$TMPFILE.del"
    else
        echo "  - No Lacework-related buckets found"
    fi
else
    echo "  - AWS CLI not found (skipping S3 bucket cleanup)"
fi

echo ""
echo "=== CloudShell cleanup complete ==="
