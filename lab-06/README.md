# Lab 6: Install Linux Agent

## Objectives

- Install FortiCNAPP agent on Linux EC2 instance
- Configure agent for data collection
- Verify agent connectivity and data flow
- Review agent-based security monitoring

## Prerequisites

- Completed Lab 5
- Linux EC2 instance running (Ubuntu, RHEL, or Amazon Linux)
- SSH access to EC2 instance
- Sudo/root access on the instance

## Lab Steps

### Step 1: Prepare EC2 Instance

1. SSH into your Linux EC2 instance
2. Verify system requirements:
   - Minimum 2GB RAM
   - Network connectivity
   - Sudo/root access

### Step 2: Download and Install Agent

#### Ubuntu/Debian

```bash
curl -sSL https://lacework.net/install.sh | sudo bash -s -- -U https://<account>.lacework.net -T <token>
```

#### RHEL/CentOS/Amazon Linux

```bash
curl -sSL https://lacework.net/install.sh | sudo bash -s -- -U https://<account>.lacework.net -T <token>
```

Replace `<account>` with your FortiCNAPP account name and `<token>` with your agent token from FortiCNAPP console.

### Step 3: Verify Agent Installation

```bash
sudo systemctl status lacework
sudo lacework agent status
```

### Step 4: Configure Agent (if needed)

Edit agent configuration:

```bash
sudo vi /var/lib/lacework/config/config.json
```

Restart agent:

```bash
sudo systemctl restart lacework
```

### Step 5: Verify Data Collection

1. Wait 5-10 minutes for initial data collection
2. Check FortiCNAPP console for agent status
3. Review process and network activity data
4. Verify file integrity monitoring is active

## Expected Results

- Agent installed and running on Linux instance
- Agent status shows "Connected" in FortiCNAPP console
- Process and network data visible
- File integrity monitoring active

## Troubleshooting

- Verify agent token is correct
- Check network connectivity to FortiCNAPP
- Review agent logs: `sudo journalctl -u lacework -f`
- Ensure firewall allows outbound connections

## Next Steps

Proceed to [Lab 7: Install Windows Agent](../lab-07/README.md)

