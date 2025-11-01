# FixMate

**FixMate** is a modular PowerShell CLI that diagnoses AWS errors using an AI-powered Lambda backend. It prints clean output, supports clipboard copy, logs every run, and offers JSON output for deeper diagnostics.

## Features

- ✅ Clean multiline output
- ✅ Clipboard copy (`-Copy`)
- ✅ JSON view (`-Json`)
- ✅ Logging to timestamped `.log` files
- ✅ Version stamping (`FixMate v1.1`)

## Usage

```powershell
powershell -ExecutionPolicy Bypass -File "fixmate.ps1" -ErrorMessage "Your AWS error here" -Copy
