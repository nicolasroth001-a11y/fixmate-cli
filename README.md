# FixMate CLI

**FixMate** is a modular PowerShell CLI that diagnoses AWS errors using an AI-powered Lambda backend. It prints clean, multiline output, supports clipboard copy, logs every run, and offers JSON output for deeper diagnostics.

## 🔧 Features

- ✅ Clean multiline output
- ✅ Clipboard copy with `-Copy` flag
- ✅ JSON view with `-Json` flag
- ✅ Logging to timestamped `.log` files in `logs/`
- ✅ Version stamping (`FixMate v1.1`)

## 🚀 Usage

```powershell
powershell -ExecutionPolicy Bypass -File "fixmate.ps1" -ErrorMessage "Your AWS error here" -Copy
