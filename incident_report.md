# Executive Summary

A simulated Linux system compromise was analyzed involving unauthorized privilege escalation to root access. Suspicious activity including cron-based persistence, access to sensitive credential files, and authentication log tampering was identified. The observed behavior indicates post-compromise actions aimed at maintaining persistence and evading detection. The system is considered compromised with potential credential exposure.

---

## Timeline of Events

- **09:15** — Privilege escalation to root via sudo observed
- **09:22** — Access to sensitive file (/etc/shadow) detected
- **09:24** — Authentication logs modified, indicating tampering
- **09:25** — Suspicious cron job executing script from /tmp identified

---

## Key Findings

- Unauthorized privilege escalation to root access
- Access to sensitive credential file (/etc/shadow)
- Suspicious cron job indicating persistence mechanism
- Evidence of authentication log tampering
- No confirmed malicious external network activity at time of capture

---

## Indicators of Compromise (IOCs)

- Unauthorized root-level sudo session
- Cron job executing script from /tmp directory
- Modification of authentication logs
- Access to /etc/shadow file
- Presence of copied sensitive file (shadow_copy.txt)

---

## Remediation Recommendations

- Restrict and audit sudo access to prevent unauthorized privilege escalation
- Monitor and validate cron jobs, especially those executing from temporary directories
- Implement log integrity monitoring to detect tampering attempts
- Enforce least privilege access controls on sensitive files
- Enable centralized logging and continuous monitoring through a SIEM solution

---

## Severity Assessment

### Severity Level: Critical

### Justification:

- Unauthorized root access combined with access to credential storage (/etc/shadow) indicates a high likelihood of credential compromise
- The presence of persistence mechanisms and log tampering further increases the risk, justifying a critical severity classification

---

## Analyst Notes

- Cron execution from /tmp is atypical and suggests persistence behavior
- Limited visibility into historical logs may indicate partial log tampering
- No external command-and-control traffic confirmed at time of analysis
- Further investigation required using full system logs (e.g., journalctl) for timeline validation