# Lab 3: Install Terraform

## Objectives

- Install Terraform on your local machine
- Verify Terraform installation
- Understand Terraform basics for infrastructure as code

## Prerequisites

- Completed Lab 2
- Command-line terminal access
- Administrator/sudo access (for installation)

## Lab Steps

### Step 1: Install Terraform

#### macOS (using Homebrew)

```bash
brew install terraform
```

#### Linux

```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

#### Windows

Download from [Terraform releases](https://www.terraform.io/downloads) and add to PATH.

### Step 2: Verify Installation

```bash
terraform version
```

### Step 3: Configure AWS Provider (Optional)

Create a test configuration file:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

Initialize Terraform:

```bash
terraform init
```

## Expected Results

- Terraform installed and accessible from command line
- Version command returns installed version
- Terraform can initialize AWS provider

## Next Steps

Proceed to [Lab 4: Integrate Inventory and Audit](../lab-04/README.md)

