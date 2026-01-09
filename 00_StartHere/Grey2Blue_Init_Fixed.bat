@echo off
setlocal EnableExtensions

REM ============================================================
REM Grey2Blue SOC Portfolio Bootstrap (Fixed + beginner-proof)
REM - Run location: ...\Grey2Blue\00_StartHere (or anywhere)
REM - Creates folder structure + starter files + starter content
REM - Default: DOES NOT overwrite existing files
REM - To overwrite: set OVERWRITE=1 before running
REM ============================================================

REM --- Resolve repo root: script_dir -> .. (expects script in 00_StartHere) ---
cd /d "%~dp0"
cd ..

set "REPO=%CD%"
if not exist "%REPO%\.git" (
  echo [ERROR] This does not look like the repo root: %REPO%
  echo         I expected to find a .git folder here.
  echo         Put this .bat in Grey2Blue\00_StartHere and run it again.
  pause
  exit /b 1
)

if "%OVERWRITE%"=="" set "OVERWRITE=0"

echo.
echo [Grey2Blue] Repo root: %REPO%
echo [Grey2Blue] Overwrite mode: %OVERWRITE%
echo.

REM -----------------------
REM Create folder structure
REM -----------------------
echo [1/4] Creating folders...

for %%D in (
  "00_StartHere"
  "01_Incident-Response"
  "02_Detection-Engineering"
  "03_Log-Analysis"
  "04_Network-Analysis"
  "06_Threat-Intel"
  "07_Linux-SQL"
  "08_HomeLab"
  "09_Resume-And-Links"
  "Templates"
  "01_Incident-Response\_template"
  "02_Detection-Engineering\_template"
  "03_Log-Analysis\_template"
  "04_Network-Analysis\_template"
  "06_Threat-Intel\_template"
  "07_Linux-SQL\_template"
  "08_HomeLab\_template"
  "01_Incident-Response\phishing-triage"
  "02_Detection-Engineering\bruteforce-detection"
  "04_Network-Analysis\dns-beaconing"
) do (
  if not exist "%REPO%\%%~D" mkdir "%REPO%\%%~D" 2>nul
)

REM ----------------------------------------
REM Create + populate files via PowerShell
REM (Much less fragile than batch string hacks)
REM ----------------------------------------
echo [2/4] Creating files + writing starter content...

powershell -NoProfile -ExecutionPolicy Bypass ^
  -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$repo = (Get-Location).Path;" ^
  "$overwrite = [int]$env:OVERWRITE;" ^
  "function Ensure-File { param([string]$Path,[string]$Content)" ^
  "  $full = Join-Path $repo $Path;" ^
  "  $dir = Split-Path -Parent $full;" ^
  "  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }" ^
  "  if ((Test-Path $full) -and ($overwrite -ne 1)) { Write-Host ('[SKIP] ' + $Path); return }" ^
  "  Set-Content -Path $full -Value $Content -Encoding UTF8;" ^
  "  Write-Host ('[WRITE] ' + $Path)" ^
  "}" ^
  ^
  "Ensure-File '00_StartHere/README.md' @'
# 00 Start Here

Welcome to **Grey2Blue**.

**Grey → Blue** is my progression from exploring security concepts to practicing defensive analysis like an entry-level SOC analyst.

## How to navigate
- Start with **portfolio-map.md** (quick links to my strongest work).
- Then browse sections by domain: Incident Response, Detection Engineering, Log Analysis, Network Analysis, Threat Intel, Linux/SQL, Automation, and Home Lab.

## What you’ll find
- Evidence-first investigations (what I saw, why it mattered, what I concluded)
- Detection logic and tuning notes (including false positive considerations)
- PCAP investigations and key filters used
- Small scripts that automate repetitive triage steps

## Data safety / sanitization
Everything here is lab-generated or sanitized. No real client/company data, no credentials, no malware binaries.
'@;" ^
  ^
  "Ensure-File '00_StartHere/portfolio-map.md' @'
# Portfolio Map (Recruiter Quick Links)

## Featured Projects (Top 3)
- **Phishing Triage + IOC Extraction** → ../01_Incident-Response/phishing-triage/
- **Brute Force Detection Rule + Validation** → ../02_Detection-Engineering/bruteforce-detection/
- **PCAP Investigation: DNS Beaconing** → ../04_Network-Analysis/dns-beaconing/

## Sections
- Incident Response: `01_Incident-Response/`
- Detection Engineering: `02_Detection-Engineering/`
- Log Analysis: `03_Log-Analysis/`
- Network Analysis (PCAP): `04_Network-Analysis/`
- Threat Intel: `06_Threat-Intel/`
- Linux + SQL: `07_Linux-SQL/`
- Home Lab: `08_HomeLab/`
- Resume + Links: `09_Resume-And-Links/`

This map stays short on purpose. Recruiters skim. The strongest work stays at the top.
'@;" ^
  ^
  "Ensure-File '00_StartHere/how-i-work.md' @'
# How I Work (SOC Mindset)

## 1) Triage
- What triggered the investigation (alert, report, anomaly)?
- Define scope: host/user/subnet and time window.

## 2) Gather evidence
- Logs: auth, endpoint, DNS, proxy, firewall (as available)
- Network: PCAP / flow summaries / DNS patterns
- Context: expected behavior vs anomaly

## 3) Analyze
- Identify likely technique (credential abuse, beaconing, persistence, etc.)
- Separate signal from noise (note likely false positives)

## 4) Conclude
- Most likely explanation and why
- Next actions (containment, scoping, prevention)

## 5) Document
- Write for handoff: clear timeline, evidence links, and next steps.
'@;" ^
  ^
  "Ensure-File '00_StartHere/tools-i-use.md' @'
# Tools I Use (Entry-Level SOC)

## Network
- Wireshark (PCAP inspection, display filters)
- tcpdump (capture basics)

## Endpoint / Windows
- Event Viewer (and Sysmon when available)
- Basic process + persistence triage mindset

## Logs / Detection
- Query thinking (KQL/Splunk-style logic even without paid tools)
- Correlation mindset (thresholds, time windows)

## Linux + Data
- grep/awk basics, permissions, process triage
- SQL filtering/aggregation for investigations

## Automation
- Python for parsing logs, extracting IOCs, quick enrichment
'@;" ^
  ^
  "Ensure-File '01_Incident-Response/README.md' @'
# 01 Incident Response

Investigation writeups in incident-response format:
- Incident report (summary, impact, scope, conclusion)
- Timeline (events in order)
- Evidence (sanitized logs/screenshots)
- IOCs (what to block/search for)

Use the template in `01_Incident-Response/_template/`.
'@;" ^
  ^
  "Ensure-File '02_Detection-Engineering/README.md' @'
# 02 Detection Engineering

Detection logic and validation work:
- Rules/queries
- Tuning notes (false positives/false negatives)
- Clear “why” behind thresholds and time windows

Use the template in `02_Detection-Engineering/_template/`.
'@;" ^
  ^
  "Ensure-File '03_Log-Analysis/README.md' @'
# 03 Log Analysis

Hands-on log investigations: Windows/Linux auth, DNS, web/proxy patterns, and correlation thinking.

Use the template in `03_Log-Analysis/_template/`.
'@;" ^
  ^
  "Ensure-File '04_Network-Analysis/README.md' @'
# 04 Network Analysis (PCAP)

PCAP investigations using a SOC-focused approach:
- What “normal” looks like
- What stood out
- Filters used
- Conclusion + next actions

Use the template in `04_Network-Analysis/_template/`.
'@;" ^
  ^
  "Ensure-File '06_Threat-Intel/README.md' @'
# 06 Threat Intel

Short, practical threat intel writeups:
- What happened (brief)
- Techniques used
- How a SOC would detect it (logs + signals)
- Mitigations

Keep these operational and concise.
'@;" ^
  ^
  "Ensure-File '07_Linux-SQL/README.md' @'
# 07 Linux + SQL

Linux and SQL work that supports investigations:
- Log filtering and process triage
- Security-focused SQL queries
- Clear explanation of why each command/query matters
'@;" ^
  ^
  "Ensure-File '08_HomeLab/README.md' @'
# 08 Home Lab

Lab environment documentation:
- Architecture (simple diagram is fine)
- Tools used (SIEM/IDS/log sources)
- Test scenarios and what telemetry they generated

Goal: prove you can generate and analyze evidence, not just read about it.
'@;" ^
  ^
  "Ensure-File '09_Resume-And-Links/README.md' @'
# 09 Resume and Links

- Resume (PDF) and optionally a plain-text version
- LinkedIn
- Certifications
- Contact method (professional email)

Tip: keep personal info minimal on public repos.
'@;" ^
  ^
  "Ensure-File 'Templates/incident-report.md' @'
# Incident Report Template

## Summary
- What happened (1–3 sentences)

## Detection
- How it was detected (alert, user report, monitoring)

## Scope
- Affected hosts/users
- Time window

## Evidence Reviewed
- Logs:
- Network:
- Endpoint:

## Findings
- Key indicators and interpretation

## Actions Taken (if any)
- Containment:
- Eradication:
- Recovery:

## Recommendations
- Preventive controls
- Detection improvements

## Notes / Assumptions
- What I’m confident about vs unsure about
'@;" ^
  ^
  "Ensure-File 'Templates/timeline.md' @'
# Timeline Template

| Time (UTC/local) | Source | Event | Why it matters |
|---|---|---|---|
| | | | |
'@;" ^
  ^
  "Ensure-File 'Templates/detection-logic.md' @'
# Detection Logic Template

## Goal
- What behavior are we detecting?

## Data Sources
- Which logs are required?

## Logic
- Explain the rule in plain language
- Provide query/pseudocode

## Validation
- Test cases used
- Expected matches

## Tuning
- Known false positives
- Threshold adjustments

## Mapping (optional)
- MITRE ATT&CK technique (if applicable)
'@;" ^
  ^
  "Ensure-File 'Templates/pcap-analysis.md' @'
# PCAP Analysis Template

## Objective
- What are we trying to confirm or rule out?

## Files
- PCAP name (and source)

## Filters Used
- Display filters and why

## Findings
- Key conversations (src/dst, ports, protocol)
- Timing patterns (beaconing?)

## Conclusion
- Most likely explanation

## Next Actions
- What would you block, hunt, or collect next?
'@;" ^
  ^
  "Ensure-File 'Templates/readme-project.md' @'
# Project README Template

## What this is
- 2–3 sentence overview

## What I did
- Steps taken (bullets)

## Evidence
- Links to logs/screenshots (sanitized)

## Outcome
- What I concluded or built

## Skills Demonstrated
- SOC-relevant skills demonstrated
'@;" ^
  ^
  "Ensure-File '01_Incident-Response/phishing-triage/README.md' @'
# Phishing Triage + IOC Extraction (Coming Soon)

Planned artifacts:
- incident-report.md
- timeline.md
- iocs.md
- evidence/ (sanitized screenshots)

Goal: demonstrate end-to-end SOC triage and communication.
'@;" ^
  ^
  "Ensure-File '02_Detection-Engineering/bruteforce-detection/README.md' @'
# Brute Force Detection Rule + Validation (Coming Soon)

Planned artifacts:
- detection-logic.md (rule + thresholds)
- validation-notes.md

Goal: show detection thinking, tuning, and false positive awareness.
'@;" ^
  ^
  "Ensure-File '04_Network-Analysis/dns-beaconing/README.md' @'
# PCAP Investigation: DNS Beaconing (Coming Soon)

Planned artifacts:
- pcap-analysis.md
- filters-used.md
- findings.md

Goal: show PCAP workflow, filters, and conclusions.
'@;"

if errorlevel 1 (
  echo.
  echo [ERROR] PowerShell step failed.
  echo If you see an ExecutionPolicy error, run this from CMD:
  echo   set OVERWRITE=0
  echo   Grey2Blue_Init_Fixed.bat
  pause
  exit /b 1
)

echo.
echo [3/4] Done writing files.
echo [4/4] Next steps:
echo   1) Open GitHub Desktop
echo   2) Commit: "Add SOC portfolio structure and starter docs"
echo   3) Push origin
echo.
pause
endlocal
