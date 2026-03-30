#!/bin/bash

# ==============================
# Universal Log Sanitizer v2.1
# Author: Nithish Kumar R
# ==============================
# Usage:
#   ./sanitize_logs_v2.sh input.log > output.log
#
# Goal:
#   Preserve forensic structure while removing sensitive identifiers

if [ -z "$1" ]; then
    echo "Usage: $0 input.log"
    exit 1
fi

sed -E '

# -----------------------------
# 0. Remove non-printable chars (binary junk)
# -----------------------------
s/[^[:print:]\t]//g;

# -----------------------------
# 1. Timestamps (normalize)
# -----------------------------
s/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9:.+-]+/TIMESTAMP/g;
s/[A-Z][a-z]{2} [ 0-9]{2} [0-9:]{8}/TIMESTAMP/g;

# -----------------------------
# 2. Hostnames (start of line)
# -----------------------------
s/^[A-Za-z0-9._-]+/host/g;

# -----------------------------
# 2.5 Fix: Secondary hostname/username leakage
# -----------------------------
s/(sudo: )([A-Za-z0-9._-]+)/\1user/g;
s/(by )([A-Za-z0-9._-]+)\(uid=/\1user(uid=/g;
s/(for user )([A-Za-z0-9._-]+)/\1user/g;

# -----------------------------
# 3. IPv4 Addresses
# -----------------------------
s/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/X.X.X.X/g;

# -----------------------------
# 4. IPv6 Addresses
# -----------------------------
s/\b([0-9a-fA-F]{1,4}:){2,7}[0-9a-fA-F]{1,4}\b/XXXX:XXXX:XXXX:XXXX/g;

# -----------------------------
# 5. Emails
# -----------------------------
s/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/email@example.com/g;

# -----------------------------
# 6. MAC Addresses
# -----------------------------
s/\b([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}\b/XX:XX:XX:XX:XX:XX/g;

# -----------------------------
# 7. Hashes (MD5/SHA variants)
# -----------------------------
s/\b[a-fA-F0-9]{32,64}\b/HASH_REDACTED/g;

# -----------------------------
# 8. Ports
# -----------------------------
s/port [0-9]{1,5}/port XXXX/g;

# -----------------------------
# 9. Usernames (robust patterns)
# -----------------------------
s/(user=)[A-Za-z0-9._-]+/\1user/g;
s/\bfor [A-Za-z0-9._-]+/for user/g;
s/\buser [A-Za-z0-9._-]+/user user/g;
s/\b[a-zA-Z0-9._-]+\(uid=[0-9]+\)/user(uid=XXXX)/g;

# -----------------------------
# 10. File Paths (home dirs)
# -----------------------------
s|/home/[A-Za-z0-9._-]+|/home/user|g;

# -----------------------------
# 11. Hostnames in domains
# -----------------------------
s/\b[a-zA-Z0-9._-]+\.(local|lan|home|corp)\b/host.local/g;

# -----------------------------
# 12. Optional: Service fingerprint masking
# -----------------------------
# s/\b(lightdm|xfce4|mongod|polkitd)\b/service/g;

' "$1"