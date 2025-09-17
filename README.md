# 🔍 Key Word Event Viewer Parser

A **PowerShell + WPF GUI application** for parsing Windows **Application logs (Event IDs 1000 & 1002)**.  
It highlights events with suspicious application or module names/paths based on keywords and random filename patterns.  

---

## ✨ Features
- Scans **Event Viewer Application log** for:
  - Event ID **1000** (Application Error / Crash)
  - Event ID **1002** (Application Hang)
- Extracts detailed event info:
  - Application & Module name/path/version
  - Exception code, Fault offset, Process ID
  - Report ID & crash/hang timestamps
- **Cheat/loader detection logic**:
  - Matches suspicious keywords (`launcher`, `external`, `loader`, `mod`, `menu`, etc.)
  - Detects random alphanumeric DLL/EXE filenames
  - Flags suspicious module locations (Temp, AppData, Downloads)
  - Highlights error codes like `0xc0000005` (Access Violation) & `0xc0000409` (Security Check Failure)
- **Modern Dark GUI**:
  - Search box (live filtering)
  - GridView with alternating dark row colors
  - Custom title bar with drag, minimize, maximize, close
  - Context menu (copy App/Module info or full message)
  - Double-click entry → full details popup

---

## 🚀 Usage

### 1. Clone or download the script
```powershell
git clone https://github.com/yourusername/event-keyword-parser.git
cd event-keyword-parser

