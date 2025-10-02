# HelloKitty Ransomware IoCs:

This repository contains Indicators of Compromise (IoCs) and security resources for threat detection and analysis. It includes hash lists, summaries of notable malware, and references for incident response.

---

## Table of Contents

- [Summary of IOC File](#summary-of-ioc-file)
- [HelloKitty Ransomware](#hellokitty-ransomware)
- [Fileless Malware Overview](#fileless-malware-overview)
- [References](#references)

---

## Summary of IOC File

The `IoC/IOC.txt` file lists multiple MD5 hashes categorized as Indicators of Compromise (IoCs). These hashes are likely associated with known malicious files, especially ransomware, trojans, and other forms of malware. Security analysts can use these for:

- Automated scanning and detection
- Incident response investigations
- Sharing with threat intelligence networks

_Note: MD5 is a weak hash and may be susceptible to collisions, but is still often used in malware detection for its speed and compatibility._

---

<img width="1536" height="1024" alt="41264A1A-3D57-4343-B7D4-33CEC99C7B3C" src="https://github.com/user-attachments/assets/3e608c0b-da0a-4b69-a791-bcefc9c82b24" />



## HelloKitty Ransomware

**HelloKitty** is a ransomware strain first observed in 2020, known for targeting organizations worldwide. It encrypts files on compromised systems and demands payment for decryption keys. Notable aspects include:

- **Targeted Attacks:** Focused on large enterprises, including high-profile companies and critical infrastructure.
- **Double Extortion:** Exfiltrates sensitive data before encryption and threatens to leak it unless the ransom is paid.
- **Techniques:** Spreads via compromised credentials, software vulnerabilities, or phishing campaigns.
- **Technical Details:** Encrypts files using AES and RSA algorithms; appends a custom extension to encrypted files.
- **Notable Victims:** CD Projekt Red (developer of Cyberpunk 2077), among others.

**Indicators of Compromise:**  
- Unique file extensions on encrypted files (e.g., `.hellokitty`)
- Ransom notes named `readme.txt` or similar
- MD5 hashes of known HelloKitty binaries (see `IoC/IOC.txt`)

---

## Fileless Malware Overview

**Fileless malware** is a form of malicious attack that does not rely on traditional files written to disk. Instead, it operates in memory, abusing legitimate system tools and processes. Key characteristics include:

- **No Disk Footprint:** Operates mainly in RAM, making detection by antivirus solutions more difficult.
- **Living off the Land:** Leverages built-in Windows tools like PowerShell, WMI, and macros.
- **Persistence:** May use registry keys or scheduled tasks instead of files to maintain persistence.
- **Execution Techniques:** Common methods include malicious scripts, exploits, and in-memory payloads delivered via phishing or drive-by downloads.

**Detection and Response:**
- Monitor for unusual process behavior and command-line activity.
- Utilize endpoint detection and response (EDR) solutions capable of behavioral analysis.
- Regularly update operating systems and applications to patch vulnerabilities.

---

## References

- [HelloKitty IOC Analysis (Kaspersky)](https://securelist.com/the-hellokitty-ransomware-family/104491/)
- [Fileless Malware Explained (CrowdStrike)](https://www.crowdstrike.com/cybersecurity-101/malware/fileless-malware/)
- [MD5 Hashes as IoC (SANS)](https://www.sans.org/blog/using-md5-hashes-for-detection/)
