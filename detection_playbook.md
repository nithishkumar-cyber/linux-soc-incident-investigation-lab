# Detection Playbook

## Objective

This playbook is designed to detect post-compromise activity on Linux systems, including privilege escalation, persistence mechanisms, log tampering, and potential data exfiltration. It is based on analysis of a simulated compromise and aims to improve detection and response capabilities.

---

## Detection Use Cases

---

### 1. Detect Privilege Escalation

**Description:**
Detect unauthorized elevation of privileges to root using sudo.

**Data Sources:**

* /var/log/auth.log

**Detection Logic:**

* Alert on successful sudo sessions opening for root accounts
* Identify sudo activity from users without prior administrative history
* Detect execution of high-risk commands (e.g., shell spawning, file access to sensitive paths)

**Indicators:**

* Sudo session opened for root by non-administrative user
* Execution of commands accessing sensitive files (e.g., /etc/shadow)

**False Positives:**

* Legitimate administrative tasks performed by authorized users
* Scheduled maintenance requiring elevated privileges

---

### 2. Detect Persistence (Cron Jobs)

**Description:**
Identify unauthorized scheduled tasks used to maintain persistence.

**Data Sources:**

* /etc/crontab
* /var/spool/cron/
* /etc/cron.d/

**Detection Logic:**

* Alert on newly created or modified cron entries
* Flag scripts executing from user-writable directories (e.g., /tmp, /home)
* Detect cron jobs initiating outbound network connections

**Indicators:**

* Cron job executing script from /tmp directory
* Unexpected cron entries created by non-administrative users

**False Positives:**

* Legitimate automation scripts
* System update or maintenance jobs

---

### 3. Detect Log Tampering

**Description:**
Detect attempts to alter or delete system logs to evade detection.

**Data Sources:**

* /var/log/auth.log

**Detection Logic:**

* Identify sudden reduction in log file size
* Detect missing or inconsistent timestamps
* Monitor for unexpected modifications to log files

**Indicators:**

* Gaps in log timeline
* Log truncation or deletion events
* Presence of irregular or injected log entries

**False Positives:**

* Log rotation processes
* System reboots or maintenance activities

---

### 4. Detect Data Exfiltration / Suspicious Network Activity

**Description:**
Identify abnormal outbound network activity that may indicate data exfiltration or command-and-control communication.

**Data Sources:**

* Network connection data (ss, netstat)
* Firewall and router logs

**Detection Logic:**

* Detect outbound connections to unknown or untrusted external IP addresses
* Identify unusual ports or protocols used for communication
* Monitor for abnormal data transfer volumes

**Indicators:**

* Connections to unknown external IPs
* Use of tools such as netcat for outbound communication
* Large or sustained data transfers

**False Positives:**

* Software updates and package downloads
* Normal user browsing or application traffic

---

## Response Actions

* Validate alert by reviewing associated logs and affected systems
* Determine severity based on impact and scope
* Escalate confirmed suspicious activity according to SOC procedures
* Initiate containment actions for high or critical severity incidents
* Document findings, evidence, and response actions in incident ticket

---

## Notes

* Detection effectiveness depends on log availability and integrity
* Limited visibility may occur in cases of log tampering
* Detection rules should be continuously tuned based on environment behavior
* Further validation using centralized logging (SIEM) is recommended
