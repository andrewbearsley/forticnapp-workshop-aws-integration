# Lab 7: Install Windows Agent

## Objectives

- Install FortiCNAPP agent on Windows EC2 instance
- Configure agent for Windows-specific monitoring
- Verify agent connectivity and data flow
- Review Windows security monitoring capabilities

## Prerequisites

- Completed Lab 6
- Windows EC2 instance running (Windows Server 2016 or later)
- RDP access to Windows instance
- Administrator access on the instance

## Lab Steps

### Step 1: Prepare Windows Instance

1. RDP into your Windows EC2 instance
2. Verify system requirements:
   - Windows Server 2016 or later
   - Minimum 2GB RAM
   - Network connectivity
   - Administrator access

### Step 2: Download Agent Installer

1. Log into FortiCNAPP console
2. Navigate to Settings > Agents
3. Download Windows agent installer (MSI file)
4. Transfer MSI to Windows instance

### Step 3: Install Agent

#### Method 1: GUI Installation

1. Double-click the MSI installer
2. Follow installation wizard
3. Enter account URL and agent token when prompted
4. Complete installation

#### Method 2: Command Line Installation

Open PowerShell as Administrator:

```powershell
msiexec /i lacework-agent.msi /quiet ACCOUNT=<account> TOKEN=<token>
```

Replace `<account>` with your FortiCNAPP account name and `<token>` with your agent token.

### Step 4: Verify Agent Installation

Check agent service status:

```powershell
Get-Service -Name LaceworkAgent
```

Verify agent is running:

```powershell
Get-Process -Name lacework
```

### Step 5: Configure Agent (if needed)

Agent configuration file location:
```
C:\ProgramData\Lacework\config\config.json
```

Restart agent service:

```powershell
Restart-Service -Name LaceworkAgent
```

### Step 6: Verify Data Collection

1. Wait 5-10 minutes for initial data collection
2. Check FortiCNAPP console for agent status
3. Review Windows-specific security data:
   - Process monitoring
   - Network connections
   - Registry changes
   - Windows Event Log integration

## Expected Results

- Agent installed and running on Windows instance
- Agent status shows "Connected" in FortiCNAPP console
- Windows process and network data visible
- Registry and event log monitoring active

## Troubleshooting

- Verify agent token is correct
- Check Windows Firewall allows outbound connections
- Review agent logs: `C:\ProgramData\Lacework\log\`
- Ensure Windows Event Log service is running
- Verify administrator privileges

## Workshop Completion

All labs in the FortiCNAPP AWS Integration workshop are complete.

### Summary

Completed tasks:
- FortiCNAPP console navigation and capabilities review
- CLI tools installation and configuration
- AWS CloudTrail and Config integration
- Agentless workload scanning enabled
- Agents deployed on Linux and Windows instances

### Additional Resources

- FortiCNAPP advanced features documentation
- Custom compliance policy configuration
- Alerting and notification setup
- Security best practices documentation

