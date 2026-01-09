# Log & User Data Filtering with grep

## Scenario
I investigated system logs and user reports to identify errors, access files, and user account changes using Linux CLI tools.

## Objectives
- Identify error entries in log files
- Filter filenames using string patterns
- Search file contents for specific users and departments

## Tools
grep, ls, wc, Bash

## Environment
/home/analyst/logs  
/home/analyst/reports/users

## Task 1 – Error Log Analysis
```bash
cd /home/analyst/logs
grep "error" server_logs.txt
grep "error" server_logs.txt | wc -l
```
Result: 6 error entries found.

## Task 2 – Filename Filtering
```bash
cd /home/analyst/reports/users
ls | grep Q1
ls | grep access
```
Results:
- 3 Q1-related files
- 4 access-related files

## Task 3 – File Content Search
```bash
grep jhill Q2_deleted_users.txt
grep "Human Resources" Q4_added_users.txt
```
Results:
- User jhill confirmed deleted
- 2 users added to Human Resources in Q4

## Conclusion
This lab demonstrates practical SOC skills including log triage, access auditing, and user lifecycle verification using grep and shell pipelines.

