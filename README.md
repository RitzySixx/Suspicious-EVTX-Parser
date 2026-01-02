# 🔍 Suspicious Event Parser - Enhanced

A **PowerShell + WPF GUI application** for parsing Windows **Application & Windows Defender logs**.  
It detects suspicious applications, crashes, malware detections, and potential security threats with intelligent risk assessment.

---

## ✨ **Enhanced Features**

### **🔍 Dual Log Support**
- **Application Log** (Event IDs 1000 & 1002)
  - Application crashes, hangs, and errors
  - Detailed fault information with risk scoring
- **Windows Defender Log** (Event IDs 1116 & 1117)
  - Malware/threat detections
  - Defender actions and status updates
  - Real-time protection events

### **🎯 Intelligent Risk Detection**
- **Multi-tiered Risk Assessment** (Danger/High/Medium/Low/Info)
- **Keyword-based detection**:
  ```
  launcher, external, cheat, mod, menu, loader, fivem, citizenfx, 
  redengine, eulen, luna, hx, 9z, tz, crown, skript, nexus, phaze,
  inject, executor, aimbot, esp, godmode, teleport
  ```
- **Pattern recognition**:
  - Random alphanumeric filenames (`[a-zA-Z0-9]{8,}`)
  - Suspicious paths (Temp, AppData, Downloads)
  - Common cheat/mod indicators

### **🛡️ Windows Defender Integration**
- **Event ID 1116**: Threat detections with details
  ```
  Detection ID, Threat Name, Threat ID, Path, Process Name, Origin
  ```
- **Event ID 1117**: Action taken reports
  ```
  Action, Action Status, Error Code, Error Description
  ```

### **📊 Comprehensive Event Analysis**
- **Application/Module Details**:
  - Name, path, version, timestamps
  - Exception codes & fault offsets
  - Process IDs & report IDs
- **Risk Scoring Factors**:
  - Exception code analysis (0xc0000005, 0xc0000409)
  - Module location assessment
  - File naming patterns
  - Application behavior flags

---

## 🛠️ **Keyboard Shortcuts**
- **F5** - Refresh events
- **Ctrl+R** - Refresh events
- **Ctrl+E** - Export results
- **Double-click** - View event details
- **Enter** in search - Apply filter

---

## 📁 **Export Options**
The parser can export results in:
- **CSV format** - Compatible with Excel, Power BI, etc.
- **Includes**: Timestamps, Event IDs, applications, paths, modules, risk levels, and full messages

---

## 🔍 **Detection Examples**

### **High Risk Indicators**
```
1. Random-named executables: "x7gH9jK2.exe", "loader_d3f4.dll"
2. Suspicious paths: "C:\Users\*\AppData\Local\Temp\*.exe"
3. Known cheat keywords: "eulen", "citizenfx", "aimbot"
4. Access violations: Exception code 0xc0000005
5. Security failures: Exception code 0xc0000409
```

### **Windows Defender Alerts**
```
- Threat Name: Trojan:Win32/Agent.ABC
- Action Taken: Quarantine
- Detection Source: Unknown origin
```

---

## 📊 **Output Columns**
| Column | Description | Example |
|--------|-------------|---------|
| **Time** | Event timestamp | 2024-01-15 14:30:22 |
| **Event ID** | Windows Event ID | 1000 / 1116 |
| **Application** | App name with icon | FiveM.exe 🎮 |
| **Path** | Full application path | C:\FiveM\FiveM.exe |
| **Module** | Faulting module | unknown.dll |
| **Module Path** | Module location | C:\Windows\System32\ |
| **Risk** | Risk assessment | Danger 🔴 |
| **Count** | Occurrences | 5 |

---

## ⚠️ **Disclaimer**

This tool is for **educational and legitimate security auditing purposes only**.  
- Use only on systems you own or have permission to test
- Not responsible for misuse or false positives
- Always verify findings before taking action
- May trigger antivirus due to PowerShell scripting

---

## 📞 **Support**

**Issues**: [GitHub Issues](https://github.com/RitzySixx/Suspicious-EVTX-Parser/issues)  
**Questions**: Open a discussion or check existing issues

---

## 📜 **License**

MIT License - See LICENSE file for details

---

## 🔄 **Changelog**

### **v3.0.5 - Enhanced Edition**
- ✅ Added Windows Defender log support
- ✅ Improved risk scoring algorithm
- ✅ Modern WPF dark theme UI
- ✅ Real-time search filtering
- ✅ Export to CSV functionality
- ✅ Application icon mapping
- ✅ Event deduplication with counts
- ✅ Detailed event viewer
- ✅ Keyboard shortcuts
- ✅ Performance optimizations
