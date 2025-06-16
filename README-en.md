=================================================

# Chall-Link "VSSDetector" - VSS Snapshot Universal Path Acquisition Tool  
## English Version Ver.1.0.0  
## Unlocking Windows Hidden Features for Everyone  
## Advanced VSS Utilization Utility  

**Copyright:** Chall-Link  
**Development:** Developed in Japan  
**License:** MIT License  
**Type:** Free Software (Open Source)  

=================================================
💡 This document uses "archive," "backup," and "compression" with similar meanings  
💡 "Snapshot" is also referred to as "shadow copy"

&emsp; 

---
## ■File Structure
VSSDetector/  
├── ChaL-VSSDetector.bat          # Main script (Japanese)  
├── ChaL-VSSDetector-en.bat       # Main script (English)  
├── README.md                     # Documentation (Japanese)  
├── README-en.md                  # Documentation (English)  
└── docs/  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── advanced-backup-guide.md  # Usage guide (Japanese)  

&nbsp;

---
## ■Overview: Revolutionary Breakthrough - The Secret Location Hidden in Your Windows

With Chall-Link "VSSDetector," anyone can easily access Windows snapshots directly with software like 7-zip. These snapshots represent "static (unchanging) drives/folders/files at any point in the past." Previously, this functionality was mainly accessible only through Windows itself and commercial software.

&nbsp;

---
## ■System Requirements
- **Download Link**: Please download "Source code (zip)" from [VSSDetector-GitHub Release](https://github.com/Chall-Link/VSSDetector/releases). Please note that downloading via GitHub Raw will result in LF line endings and the script will not work properly.
- **Character Encoding & Line Endings**: When using the Japanese version (ChaL-VSSDetector.bat), this script requires Shift-JIS encoding and CRLF line endings to function properly on Japanese Windows systems.
- Windows 10 Pro 64bit (tested), theoretically compatible with Windows 7 SP1 or later (untested, use at your own risk)
- **Requirements**: PowerShell 2.0 or later (included with Windows), Administrator privileges, VSS service enabled
- **Recommended Software**: Chall-Link "PreFAS Backup" (available from [PreFAS Backup-GitHub Release](https://github.com/Chall-Link/PreFAS-Backup/releases) "Source code (zip)"), 7-Zip (LGPL License) (available from https://www.7-zip.org/)

&nbsp;

---
## ■If "Windows protected your PC" appears when using the script
Windows Defender SmartScreen may display a warning when first using the software. This is a standard warning for unsigned new software.

**Safety Information:**
- ESET virus scan verified (locally confirmed)
- Completely open source (content verifiable)

**How to run:** Click "More info" → "Run anyway" on the warning screen

&nbsp;

**👉 `**This script makes VSS functionality accessible to everyone!**`**

&nbsp;

---
## ■Experience: Basic Usage - Let's Experience It First. The Amazing Moment! 

### ■ 3-Minute Amazing Experience 
> ⚠️ This section only explains how to use VSSDetector. As a prerequisite, restore points must be created beforehand. However, this script only provides information retrieval functionality, so running it without restore points will simply display "Restore points may not have been created" without affecting your system.  
> If you're unsure, feel free to run it anyway. For detailed procedures including restore point creation, please refer to the separate usage guide ([advanced-backup-guide.md](https://github.com/Chall-Link/VSSDetector/blob/main/docs/advanced-backup-guide.md)).  
> Please consult with your PC administrator and obtain permission before creating new restore points.

1. Right-click ChaL-VSSDetector.bat and run as administrator

2. Snapshot information in your system will be automatically analyzed and saved to output file:
Analysis result file: ChaL-RESULT-VSSDetector.txt
```
   ────────────────────────────
[1] HarddiskVolumeShadowCopy3 (Drive D:)
    Creation Time: 2025/06/15 18:28:17
    Type: System Restore Point
    Full Drive Path: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy3\*
    Folder Path: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy3\(FolderName) 
   ────────────────────────────
```
> Please only use snapshots with "Type: System Restore Point" as others are created by various software

&nbsp; 

**👉 `You've now obtained VSSDetector VSS paths!`**

&nbsp;

> ⚠️ The following experience requires 7-Zip (https://www.7-zip.org/).  
> Please install it if needed.

&nbsp;

3. Copy the required VSSDetector VSS path and use it with other tools

&emsp; &emsp; 👉 **`Let's use 7-Zip File Manager to peek inside VSS snapshots!`**

4. Copy the "Full Drive Path" from step 2, **excluding the final \***

5. Launch 7-Zip File Manager
6. Paste the VSS path into the address bar and press Enter

&nbsp;

**👉 `A snapshot of files and folders from a past point in time has appeared!`**

&nbsp;

> ⚠️ To avoid trouble, please only browse and do not perform other operations.

&nbsp;

---
## ■Features: Excellent Characteristics of VSSDetector  
### ● Complete Visibility of Hidden Snapshots
- Automatically detects all snapshots stored in the system
- Properly identifies creation time, target drive, and source automatically

### ● Automatic Generation of Practical VSS Paths
- Automatically provides VSS path formats directly usable with 7-zip
- Complete support for both full drive and folder specification patterns
- Ready for immediate use with other tools via copy & paste

### ● Always Accessible Result File Output
- Saves to text file (ChaL-RESULT-VSSDetector.txt) simultaneously with screen display
- Includes important notes
- Rich error handling

&nbsp;

---
## ■Backup: Application to Backup Processing
### Benefits of Using VSS for Backup

Using VSS as a backup source means you can use static, unchanging drive/folder images as sources.  
For example, when using actual folders as sources, file editing work in the original folder was impossible during backup processing, requiring work to be suspended until completion. Simultaneous work could cause backup failures.
VSSDetector unlocks VSS functionality and solves this challenge.

For large-scale processing like backing up entire drives with 7-Zip, it's impossible to continue both backup and editing work simultaneously.  
Running 7-Zip continuously for days requires different operational comfort considerations than processing that takes minutes.  

This led to the development of the separate script Chall-Link "PreFAS Backup."
Using VSSDetector and PreFAS Backup together, scripts are optimized to enable continued editing work while performing multi-day backup processing using VSS.

Additionally, PreFAS Backup is designed with the concept of long-term safe storage of valuable files, aiming to protect precious files from disasters by storing created encrypted backup files on cloud storage or M-Disc (100-year durable optical discs).

&nbsp;

---
## ■Applications: PreFAS Backup Usage Scenarios
- **Photo & Video Management** / Complete protection of precious recorded photos and private memories
- **Creators & Designers** / Reliable long-term storage of completed works
- **Software Developers** / Strategic backup of stable program versions
- **Document Creation & Office Work** / Reliable protection of important documents and literary works
- **System Administration & IT Personnel** / Deep understanding of VSS and application to system maintenance

&nbsp;

---
## ■Important Notes

### ■ Critical Considerations
- Deletion of "System Restore and Shadow Copies" during disk cleanup while using VSS paths  
- For full drive specification, "\*" at the end is required; for folder specification, replace (folder name) with actual name
- When using 7-Zip File Manager, remove the final * from the full drive path when entering it in the path field

### ■ Troubleshooting
- "Restore points may not have been created" → Restore points not created, or VSS service may be stopped
- "Administrator privileges required" → Launch with "Run as administrator" from right-click menu

**👉 `With Chall-Link "VSSDetector," you can achieve results previously only obtainable with expensive commercial backup software using free software`**

&emsp; 

---
## ■Expanding Application Possibilities

Chall-Link "VSSDetector" can be applied to various fields:
- **Security & Auditing** (File & Backup)  
- **System Administration & Operations** (Troubleshooting system failures)  
- **Disk Analysis & Optimization Tools** (Comparing old and new folder states)  

### ● Backup Applications
- Use snapshots as backup sources, enabling continued work with actual files during archive processing
    - Achieve previously impossible VSS copying with Chall-Link "PreFAS" (large-scale), 7-Zip (small-scale), robocopy, xcopy, etc.

### ● File Comparison & Recovery
- Compare content between past (snapshot) and present (actual files)
- Compare content between past (snapshot) and present (actual folders)

### ● Past File Extraction
- Restore lost files from snapshots
- Extract past versions of files from snapshots

### ● Applications with Other Tools
- Integration into automated batch file processing
- Collaboration with PowerShell scripts

### ● Enterprise & Professional Use
- Automation of regular backup processing
- Application in system administration tasks
- Powerful tool for data recovery operations

&emsp; 

---
##  ■License & Disclaimer
This software is free software (MIT License). Copyright belongs to Chall-Link.
The author assumes no responsibility for any damage or issues arising from the use of this software.  
Redistribution is free, but please cite "Chall-Link 'VSSDetector'" as the source.

Please submit feedback and comments to the GitHub repository [Issues](https://github.com/Chall-Link/VSSDetector/issues).  
Code reviews and improvement suggestions are also welcome.  
However, we do not provide individual support or responses.  

&nbsp;

---
## ■Tags
VSS, snapshot, restore-point, 7zip, PowerShell, vssadmin, system-administration, windows-tools, large-data, backup  

[Tags: VSS, snapshot, restore-point, 7zip, PowerShell, vssadmin, system-administration, windows-tools, large-data, backup]

&nbsp;

End