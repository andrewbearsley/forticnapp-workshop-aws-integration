# Lab 2: Install Lacework CLI and Configure

## Objectives

- Install the Lacework CLI tool
- Configure CLI with FortiCNAPP credentials
- Verify CLI connectivity

## Prerequisites

- Completed Lab 1
- Command-line terminal access
- FortiCNAPP account credentials

## Lab Steps

### Step 1: Install Lacework CLI

#### Linux/macOS

```bash
curl https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | sudo bash -s -- -d /usr/local/bin
```

#### Windows

Download and install from the Lacework CLI releases page.

### Step 2: Configure CLI

```bash
lacework configure
```

Enter your FortiCNAPP account credentials when prompted:
- Account: Your FortiCNAPP account name
- API Key: Your API key
- API Secret: Your API secret

### Step 3: Verify Installation

```bash
lacework version
lacework api get /api/v2/UserProfile
```

## Expected Results

- Lacework CLI installed successfully
- CLI configured with valid credentials
- API connectivity verified

## Troubleshooting

- Verify API credentials are correct
- Check network connectivity
- Ensure CLI version is up to date

## Next Steps

Proceed to [Lab 3: Install Terraform](../lab-03/README.md)

