=================================================  
  
# Chall-Link "VSSDetector" Usage Guide  
## English Version Ver.1.0.0
## Creating 7-Zip Encrypted Archives  
## Using Restore Point VSS Snapshots  
## Full Drive Backup Capability

**Copyright:** Chall-Link  
  
=================================================  

&nbsp;

## ■Software Used in This Usage Guide

&emsp;**1. 7-Zip Enhanced Script Chall-Link "PreFAS Backup"※ (Available from GitHub)**  
&emsp;**2. 7-Zip (LGPL License) (Available from https://www.7-zip.org/)**  

> ※ Scheduled for release around the same time after VSSDetector publication  

&nbsp;

---
## ■Overview: About This Guide
Chall-Link "VSSDetector" unlocks Windows' hidden feature **VSS Snapshots** = drive states saved in an unchangeable form at a specific point in time, making them freely reusable by general users.

This usage guide introduces specific procedures for executing backup software and backup programs using Windows restore points as archive sources, demonstrating the combination of VSSDetector with Chall-Link "PreFAS Backup" or 7-Zip.  

&nbsp;

---
## ■Procedures: Specific Usage Examples

### 1. Objective: Creating 7-Zip Archives Using Folders in VSS Snapshots as Archive Sources  
> Traditional source path specification example: D:\  ※ Work on D: had to be suspended during processing  
>　　　　　　　　　　　↓  
> VSSDetector "VSS Path" specification example: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\*  ※Work can continue during processing

**`VSSDetector enables simultaneous 7-Zip backup processing of large folders (drives) while continuing PC work on large folders (drives)!`**

&nbsp;

### 2. Preparation: Creating Restore Points
> ⚠️ Creating new restore points should be done with administrator/co-administrator consent
> Approximately 20% or more free space is required on the target drive when creating restore points. Insufficient free space may prevent normal processing.

#### 2.1. Step 1: Enabling System Restore Function  
&emsp;**(1) Accessing System Restore Settings**  
&emsp;&emsp;Search for "Create a restore point" in the Windows search box and open it  
&emsp;&emsp;The "System Protection" tab of the "System Properties" window opens  

&emsp;**(2) [Required Setting] System Drive (usually C:) Protection Settings**  
&emsp;&emsp;System Restore cannot enable other drives unless the system drive (C:) is enabled first  
&emsp;&emsp;If "Windows(C:) (System)" protection is disabled, select the system drive (C:)  
&emsp;&emsp;Select "Configure" → "Turn on system protection" to enable system drive (C:) protection  
&emsp;&emsp;<Recommended Setting> Disk Space Usage: 5-10% of disk size

&emsp;**(3) [Important Setting] Data Drive (e.g., D:) Protection Settings**  
&emsp;&emsp;Select the data drive to be backed up and click "Configure"  
&emsp;&emsp;Select "Turn on system protection"  
&emsp;&emsp;<Recommended Setting> Disk Space Usage: 1-3% (1-2% for small capacity drives)  

  > 👉 Simply enabling it does not create restore points yet  

&nbsp;

#### 2.2. Step 2: Creating Restore Points  

> 💡 If you want the latest state backup, we recommend not waiting too long between restore point creation and backup creation

&emsp; **(1) Restore Point Creation:**  
&emsp; &emsp;Click the "Create" button in the "System Protection" tab of the "System Properties" window  

&emsp; **(2) Enter Identification Description**  
&emsp; &emsp;Enter an easily identifiable name in the restore point description field  
&emsp; &emsp;Example: "backup-25-06-06-1200"  

&emsp; **(3) Execute Restore Point Creation Process**  
&emsp; &emsp;Clicking the "Create" button in the "System Protection" window starts creating snapshots of all currently enabled drives  

&emsp; **(4) Confirm Successful Creation**  
Creation is complete when you see "The restore point was created successfully"

&nbsp;

**✔️ `Static state preservation of drives = Windows VSS Snapshot creation is now complete!`**  

&nbsp;

### 3. VSS Path Acquisition Using VSSDetector  

**Use VSSDetector to obtain VSS paths for restore point VSS snapshots**  

#### 3.1. Step 1: Running VSSDetector  

&emsp;**(1) Right-click ChaL-VSSDetector.bat and select "Run as administrator"**  

&emsp;**(2) VSS snapshot analysis processing is executed**  

&emsp;**(3) Execution Complete**  
&emsp;&emsp;After confirming the "Script execution completed" message, you can close the screen.
&emsp;&emsp;**All analysis results have been saved to the output file.**  

&emsp; 

#### 3.2. Step 2: Confirming and Using VSSDetector "VSS Path" Information  

&emsp;**(1) Output Result File**  
&emsp;&emsp;Open "ChaL-RESULT-VSSDetector.txt" created in the execution folder  
&emsp;&emsp;This file is overwritten each time you run the script 

&emsp;**(2) VSSDetector "VSS Path" Information Display Example**:

```
   ────────────────────────────
   [1] HarddiskVolumeShadowCopy1 (Drive D:)
       Creation Time: 2024/06/06 14:30:25
       Type: System Restore Point
       Full Drive Path: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\*
       Folder Path: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\(folder name)
   ────────────────────────────
```

&emsp;**(3) Selecting and Copying VSSDetector "VSS Path"**  
&emsp;&emsp;Copy the optimal VSS path corresponding to your backup target drive/folder

> ⚠️ Difference between VSSDetector "VSS Path" full drive specification and folder specification
> **Full Drive Specification**: Requires "\*" at the end (example: ~Copy1\*)  
> **Specific Folder Specification**: Replace (folder name) with the actual exact folder name

&emsp; 

**✔️ `VSS path extraction for direct access to VSS snapshots is complete!`**  

&emsp; 

**👉`Next, we'll explain how to create 7-Zip archives using VSS snapshots as sources with the 7-Zip enhanced script Chall-Link "PreFAS Backup" or 7-Zip File Manager`**  

&emsp; 

### 4. Archive/Backup Execution

#### 4.1. Configuration Conditions and Precautions

**■ Configuration Examples**  

**[Case1] Small-scale folders that finish processing quickly as archive sources**  
Source Folder: `d:\folder1\sub-folder2\`  
Output Destination: `e:\7-Zip-output\`  
**[Case2] Large-scale sources like entire drives requiring long-term processing as archive sources**  
※ Please note that executing entire drives may take 12+ hours

> **⚠️ Important Verification:**
> In production, always verify that you can open the file with 7-Zip File Manager after backup creation and properly browse the file tree
> The author assumes no responsibility if password mismatch or backup corruption occurs after deleting the source following backup creation

&emsp; 

#### 4.2. [Method 1] Manual Execution with 7-Zip GUI (Recommended for small-scale archives)

***

**[Case1] Small-scale folders that finish processing quickly as archive sources**  
&emsp;**(1) Launch "7-Zip File Manager" with administrator privileges**

&emsp;**(2) Direct Access with VSSDetector "VSS Path"**  
&emsp;&emsp;For 7-Zip File Manager, remove the final * from the full drive path specification  
&emsp;&emsp;Enter the VSSDetector "VSS Path" in the address bar **(excluding the final \*)**  
&emsp;&emsp;Example: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\

&emsp;**(3) Archive Target Selection**  
&emsp;&emsp;Select target folder (example: folder1\sub-folder2\) → Select "Add" to open compression window

&emsp;**(4) [Important] Change Output Destination**  
&emsp;&emsp;By default, the compressed file output destination is set to inside the snapshot  
&emsp;&emsp;\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\  
&emsp;&emsp;This is inside the snapshot and cannot be written to.  
&emsp;&emsp;Change the compression destination to an actual output folder that allows writing (e:\7-Zip-output\).  
&emsp;&emsp;If you set the output filename to file-1.7z, it becomes:
&emsp;&emsp;e:\7-Zip-output\file-1.7z

***

**[Case2] Large-scale sources like entire drives requiring long-term processing as archive sources**  

**～～～ Omitted ～～～**　　  
**👉 For large-scale long-term processing like entire drives, we recommend using the 7-Zip enhanced script Chall-Link "PreFAS Backup" rather than the GUI method**  

***

&emsp; 

#### 4.3. [Method 2] Enhanced 7-Zip Processing with PreFAS Backup (For large-capacity backups)

> **■ About Chall-Link "PreFAS Backup"...**
> 
> Chall-Link "PreFAS Backup" was developed with the concept of protecting valuable files from disasters by converting large-scale drives and folders into portable archives with 7-Zip AES-256 encryption and storing them on cloud storage or M-Disc (100-year durable optical discs).
> 
> **[PreFAS Backup Features]**
> - Secure Archives: Strong data protection with AES-256 encryption
> - Load Reduction and Work Continuation: Controls 7-Zip CPU load, suppressing sustained high load while enabling comfortable editing work in source folders  
> - Large-scale Support: Fully automated backup of terabyte-class folders/drives  
> - Optical Disc Optimization: Efficient split size settings for 25GB, 50GB, 100GB optical discs  
> - Professional-grade Reliability: Error handling system comparable to commercial software

&emsp; 

&emsp;**(1) PreFAS-Sub.bat Configuration**  
&emsp;&emsp;Open ChaL-PreFAS-Backup-SUB-en.bat in a text editor and edit variable values:

***

**[Case1] Small-scale folders that finish processing quickly as archive sources**  

```
set SOURCE_FOLDER="\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\folder1\sub-folder2\"
```

***

**[Case2] Large-scale sources like entire drives requiring long-term processing as archive sources**  

```
set SOURCE_FOLDER="\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\*"
```
> In this case, the final * is required

***

&emsp; 

&emsp;**(2) Other Required/Important Variable Settings**  
&emsp;&emsp;Open ChaL-PreFAS-Backup-SUB-en.bat in a text editor and edit variable values

&emsp;&emsp;**Output Archive Filename Setting**  
&emsp;&emsp;&emsp;`file-1` (no extension required)

&emsp;&emsp;**Archive File Output Folder Setting**  
&emsp;&emsp;&emsp;`e:\7-Zip-output\`

&emsp;&emsp;**Exclude Files and Folders Specification (Example)**  
&emsp;&emsp;&emsp;`set EXCLUDE=-xr!"*.tmp" -xr!"*.temp"`

&emsp;**(3) Reliable Execution of ChaL-PreFAS-Backup-MAIN-en.bat**  
&emsp;&emsp;Right-click → "Run as administrator"

&emsp;**(4) Password Setting**  
&emsp;&emsp;Enter a strong password for AES-256 encryption twice (for high confidentiality, 20-30 characters with alphanumeric characters and symbols recommended)

&emsp;**(5) Automatic Processing Start**  
&emsp;&emsp;● Background color displays in cyan, and advanced automatic processing begins  
&emsp;&emsp;● CPU load is controlled by Chall-Link "PreFAS Backup", enabling normal file editing during archive processing  
&emsp;&emsp;● "Everything is Ok" is displayed upon completion, indicating successful processing

&emsp; 

🎉 **`Backup creation using VSSDetector is complete! Excellent work!`**

&emsp; 

---
## ■Important Matters in This Usage Guide  

### Required Actions
- After archive completion, check password and file list with 7-Zip File Manager  

### Prohibited Actions
- Deleting "System Restore and Shadow Copies" in Disk Cleanup during processing  

### Precautions
- If you notice abnormal PC fan rotation during long-term processing, immediately stop PreFAS Backup

### Recommendations
- Create the latest restore point before PreFAS Backup  
- Store passwords appropriately and safely. Recovery is impossible if lost.

&emsp; 

---
## ■Deleting Restore Point Snapshots

> ⚠️ In shared environments, consult with administrators before implementation

&emsp;(1) Search for "Create a restore point" in the Windows search box and access  
&emsp;(2) Select the target drive for deletion and click "Configure"  
&emsp;(3) Select the "Delete" button to delete snapshots  

&emsp; 

---
## ■[Disclaimer]
- The author assumes no responsibility for any damage or issues arising from executing these procedures.  
- For important data, always create separate backups beforehand.  
- Create this backup as one of multiple backup methods, not as a single backup solution.  

End