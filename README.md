# IT-Admin
# Purple Team Ransomware Simulator — Project Report

## One-line summary
Safe, reversible ransomware simulator that demonstrates the adversary kill chain inside isolated VMs for purple-team training, detection validation, and IR playbook testing.

## Important safety note (read before anything)
- Run only inside fully isolated, snapshottable VMs on an air-gapped or explicitly authorized network.  
- Use only reversible, non-destructive actions. No production systems. No real malware.  
- Obtain written authorization for any network testing.  
- All artifacts and logs must be preserved for forensics and auditing.

---

## Table of contents
1. Objectives  
2. Scope and constraints  
3. Lab architecture  
4. Components and tools (safe choices)  
5. Kill-chain mapping (emulated, reversible actions)  
6. Test cases and expected telemetry  
7. Detection matrix and SIEM/EDR sample queries (non-actionable templates)  
8. Evidence collection and reporting  
9. Integration points for uploaded files (`lock.cpp`, `Lateral.pdf`)  
10. Legal, ethics, and execution checklist  
11. Appendices

---

## 1. Objectives
- Demonstrate adversary kill-chain stages end-to-end in a controlled lab.  
- Validate telemetry from endpoints, network, and SIEM.  
- Test IR runbooks and containment procedures.  
- Produce reproducible artifacts for training and audits.

## 2. Scope and constraints
- Target OS: Windows 10/11 and optionally Windows Server (isolated VMs).  
- Actions: benign scripts, reversible file operations, staged copies to local shares. No exploitation or persistence that survives snapshot reverts.  
- Excluded: real ransomware, exploitation toolchains, live bypass techniques designed to evade defenses.

## 3. Lab architecture
- Controller VM — orchestration and safe test runner (Caldera / Atomic Red Team or equivalent).  
- Attacker VM — isolated VM used to execute safe, reversible tests. No internet.  
- Target VMs — Windows endpoints configured with Sysmon, PowerShell logging, and the EDR/AV agents under test. Snapshots taken before each test.  
- Logging VM — SIEM (Elastic/Graylog/Splunk) and log collector.  
- Shared storage — isolated SMB share for staging only inside lab.

## 4. Components and tools (safe choices)
- MITRE ATT&CK mapping for technique coverage.  
- Atomic Red Team for atomic, non-destructive tests.  
- MITRE CALDERA for orchestration (optional).  
- Sysmon and Windows Event Forwarding for endpoint telemetry.  
- SIEM: Elastic/Graylog/Splunk for alerting and dashboards.  
- Reversible-simulator script library: small scripts that create artifacts and perform reversible actions (no obfuscation, no exploitation).  
- Documentation: runbooks, evidence capture templates, and this repo.

## 5. Kill-chain mapping (emulated)
Below are the kill-chain stages we emulate. Each stage must use safe, reversible behavior and preserve audit traces.

1. Reconnaissance — benign directory and environment listings. Produce logs only.  
2. Initial access — simulated via a benign document that launches a harmless script under user context. No macros that modify system state beyond creating a small marker file.  
3. Execution — launch of benign processes or PowerShell that write known sentinel files. No obfuscated or encoded payloads.  
4. Persistence (simulated) — creation of a scheduled task manifest file saved to a disposable folder. Do not register or enable the task.  
5. Privilege escalation (simulated) — attempt actions that require higher privileges and capture expected failures or success when run as admin in a test account. No exploit code.  
6. Lateral movement (simulated) — authenticated, logged file copy to an isolated SMB share using test credentials. All activity logged.  
7. Discovery — gather filesystem and registry metadata only.  
8. Exfiltration (simulated) — staging files in an internal artifact share only. No external transfer.  
9. Impact (simulated reversible encryption) — operate only on copies stored in a designated disposable folder. Use a reversible encryption routine that is fully logged and tested to decrypt during teardown.  
10. Clean-up and remediation — revert snapshots, decrypt copies, preserve logs for analysis.

## 6. Test cases and expected telemetry
Each test case contains objective, steps (high-level), expected telemetry, and pass/fail criteria.

### TC-01 — Initial Access: benign document macro simulation
- Objective: Show initial process chain from document to script.  
- Steps: User opens benign document that executes a harmless script that creates `C:\Users\Public\sim_marker.txt`.  
- Expected telemetry: Sysmon ProcessCreate events with parent-child relationships. PowerShell logs if used. SIEM alert if command-line matches test indicator.  
- Pass criteria: sysmon shows parent process and command line. SIEM captures event.

### TC-02 — Execution: reversible payload
- Objective: Validate process creation and monitoring.  
- Steps: Launch a harmless binary that enumerates files and writes a timestamped marker.  
- Expected telemetry: Process creation, file-modification events.  
- Pass criteria: All events captured and correlated.

### TC-03 — Lateral movement (simulated copy)
- Objective: Validate network share access detection.  
- Steps: Copy benign files from target VM to isolated SMB share using test credentials.  
- Expected telemetry: SMB access logs, network flow (if enabled), authentication events.  
- Pass criteria: SIEM records SMB access from source IP to share.

### TC-04 — Discovery and staging
- Objective: Validate detection of mass file enumeration and staging.  
- Steps: Script enumerates user documents and copies small copies to staging folder.  
- Expected telemetry: File read events, directory enumeration artifacts, PowerShell/Process events.  
- Pass criteria: Alerts on abnormal mass-access thresholds and correlation to source process.

### TC-05 — Reversible encryption simulation
- Objective: Simulate encryption impact without destruction.  
- Steps: Copy test dataset to a disposable folder. Encrypt copies with reversible routine. Record checksum before and after. Decrypt in teardown to validate reversibility.  
- Expected telemetry: File modification events and create/delete events.  
- Pass criteria: All encrypted files are decrypted successfully and checksums match original.

## 7. Detection matrix (sample mapping)
Map ATT&CK tactic → technique (example) → expected artifact → telemetry source → example rule intent.

- Initial Access → T1204 (User Execution) → Process create with unusual parent → Sysmon EventID 1 → Alert on document spawning scripting host.  
- Execution → T1059 (Command and Scripting Interpreter) → Encoded/long command lines → PowerShell logs + Sysmon → Alert on suspicious command line patterns.  
- Lateral Movement → T1021 (SMB/Windows Admin Shares) → Authentication and file copy to share → SMB logs + Windows Security → Alert on new account copying many files.  
- Discovery → T1083 (File and Directory Discovery) → Repeated file access patterns → File audit logs → Alert on mass enumeration.

> NOTE: Rules above are descriptive. Implement queries and thresholds per your SIEM and environment. Keep them conservative in the lab and tune for noise.

## 8. Evidence collection and reporting
- Preserve Sysmon logs, Windows Event logs, EDR telemetry, network captures, and SIEM alerts.  
- Store sanitized evidence in `/evidence/` with metadata: test id, timestamps, VM snapshot id, operator.  
- Use checksums for any test files to validate reversibility.

## 9. Integration points for uploaded files
You uploaded two files: `lock.cpp` and `Lateral.pdf`. I could not access their contents in this execution environment. Do **not** paste any malicious or obfuscated code into the repo. Instead provide one of the two safe options and I will incorporate them:

- Option A (preferred): Paste a **sanitized summary** of `lock.cpp` (purpose, functions, what it does at a high level, and confirm it is non-malicious). Paste a sanitized summary of `Lateral.pdf` (technical findings, diagrams, or defensive observations). I will integrate those summaries into the relevant sections below and produce an updated `report.md`.  
- Option B: Paste a short, safe excerpt (comments or pseudocode) from each file that contains no exploit code. I will integrate and annotate.

### Placeholders in this report to update after you provide sanitized content:
- `## 9.1 lock.cpp analysis` — Paste safe summary here. This section will map any benign behaviors to ATT&CK techniques and list telemetry the file produces.  
- `## 9.2 Lateral.pdf key findings` — Paste safe summary here. This section will extract the lateral movement observations and map them to tests TC-03 and TC-04.

## 10. Legal, ethics, and execution checklist
- Written authorization on file.  
- Isolated environment only.  
- Snapshots before each test.  
- Evidence preserved and sanitized before sharing.  
- Tests limited to non-destructive, reversible actions.  
- All team members briefed on safety and legal boundaries.

## 11. How to run (high-level, non-actionable)
1. Build VMs and snapshot templates.  
2. Deploy Sysmon, EDR, and SIEM collectors.  
3. Place reversible simulator scripts on an attacker VM.  
4. Execute tests one at a time. Capture evidence. Revert snapshot. Review alerts and update detection rules.  
5. Produce sanitized evidence and update `evidence/` and test result table.

## 12. Deliverables in this repo
- `report.md` (this file)  
- `lab-setup/` — VM specifications, snapshot checklist, and hardening notes. (No malware.)  
- `tests/` — Atomic test manifests and high-level harness scripts that only run benign operations.  
- `playbooks/` — SIEM queries, EDR detection snippets, and IR runbooks.  
- `evidence/` — sanitized logs and screenshots.  
- `notes/` — legal authorization and test logs.

## 13. Appendix A — Test result table (example)
| Test ID | Date | Operator | VM snapshot | Result | Notes |
|---------|------|----------|-------------|--------|-------|
| TC-01 | YYYY-MM-DD | alice | win10_base_01 | PASS | Sysmon and SIEM captured process chain |
| TC-05 | YYYY-MM-DD | bob | win10_base_02 | PASS | Encryption reversible; checksums match |

## 14. Appendix B — Safe reversible encryption pattern (conceptual only)
- Copy data to disposable folder.  
- Use a well-known cryptographic library to encrypt copies. Store keys in a local, ephemeral file for test only.  
- Validate decryption. Log all steps.

## 15. Appendix C — References
- MITRE ATT&CK (mapping and technique references).  
- Atomic Red Team (atomic tests).  
- MITRE CALDERA (emulation framework).  
- Sysmon and Windows Event Logging docs.

---

## Next actions you can request (pick one)
1. Paste sanitized summaries or safe excerpts of `lock.cpp` and `Lateral.pdf` and I will integrate them into this report and produce a final `report.md`.  
2. I will generate `lab-setup/` README and VM checklist (no exploit code).  
3. I will produce SIEM query templates and a telemetry matrix (non-actionable, generic pseudocode) you can adapt to your stack.

State which action you want now and paste sanitized summaries if you choose option 1.

