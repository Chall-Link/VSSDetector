::
:: *** IMPORTANT ***
:: This English version script should work with UTF-8 encoding and CRLF line endings.
:: When downloading as Raw from GitHub, line endings become LF and may not work properly.
:: Please download the Zip file from GitHub Release for proper operation.
::
::
:: ~ VolumeShadowCopy Snapshot Path Detection Script ~
:: ----------------------------------------------------------------
::   VSSDetector English Version Ver.1.0.0
:: ----------------------------------------------------------------
::   Detects accurate paths of shadow copies created by system restore points.
::   By specifying these paths as compression sources in 7-Zip, you can
::   specify source folders and drives where file changes do not occur.
::
::   Copyright by Chall-Link
::   Developed in Japan
::
:: * Please run this script with administrator privileges.
::
:: ▼▼▼
:: For the purpose, effects, and features of this script, please check Readme-VSSDetector_Guide.txt
::


@echo off
pushd %~dp0
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ===============================================
echo VSSDetector English Version Ver.1.0.0
echo ===============================================
echo Processing snapshots... Please wait.
echo.

:: Administrator privilege check
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Error] Administrator privileges required.
    echo Please right-click and select "Run as administrator"
    pause >nul
    popd
    exit /b 1
)

:: Get vssadmin output to temporary file
set TEMP_FILE=%TEMP%\vssadmin_output.txt
vssadmin list shadows > "%TEMP_FILE%" 2>&1

if %errorLevel% neq 0 (
    echo [Error] Failed to retrieve snapshot information.
    echo Restore points may not have been created.
    del "%TEMP_FILE%" >nul 2>&1
    pause >nul
    popd
    exit /b 1
)

:: Create PowerShell script to parse vssadmin output
echo $ErrorActionPreference = 'Stop' > "%TEMP%\parse_shadows.ps1"
echo $outputFile = ".\ChaL-RESULT-VSSDetector.txt" >> "%TEMP%\parse_shadows.ps1"
echo try { >> "%TEMP%\parse_shadows.ps1"
echo     # Initialize output file with header >> "%TEMP%\parse_shadows.ps1"
echo     "===============================================" ^| Out-File -FilePath $outputFile -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "Snapshot Detection Tool (Enhanced Version)" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "===============================================" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "Display list of snapshots saved in the system" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "(No changes will be made to the system)" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "Generated: $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     "" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     $content = Get-Content '%TEMP_FILE%' -Encoding OEM >> "%TEMP%\parse_shadows.ps1"
echo     $shadows = @() >> "%TEMP%\parse_shadows.ps1"
echo     $currentShadow = @{} >> "%TEMP%\parse_shadows.ps1"
echo     $globalCreationTime = $null >> "%TEMP%\parse_shadows.ps1"
echo     foreach ($line in $content) { >> "%TEMP%\parse_shadows.ps1"
echo         $line = $line.Trim() >> "%TEMP%\parse_shadows.ps1"
echo         if ($line -match 'Creation time: (.+)' -or $line -match '作成時刻: (\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2})') { >> "%TEMP%\parse_shadows.ps1"
echo             $globalCreationTime = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             if ($globalCreationTime -match '(\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}:\d{2} (AM^|PM))') { >> "%TEMP%\parse_shadows.ps1"
echo                 try { >> "%TEMP%\parse_shadows.ps1"
echo                     $globalCreationTime = [DateTime]::Parse($globalCreationTime).ToString('yyyy/MM/dd HH:mm:ss') >> "%TEMP%\parse_shadows.ps1"
echo                 } catch { >> "%TEMP%\parse_shadows.ps1"
echo                     $globalCreationTime = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo                 } >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'Shadow Copy ID:.*\{(.+)\}' -or $line -match 'シャドウ コピー ID:.*\{(.+)\}') { >> "%TEMP%\parse_shadows.ps1"
echo             if ($currentShadow.Count -gt 0) { >> "%TEMP%\parse_shadows.ps1"
echo                 $shadows += $currentShadow >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow = @{} >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.ID = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.CreationTime = $globalCreationTime >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'Original Volume:.*\(([A-Z]):\).*Volume\{(.+)\}' -or $line -match '元のボリューム:.*\(([A-Z]):\).*Volume\{(.+)\}') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.DriveLetter = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.VolumeGUID = $matches[2] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'Shadow Copy Volume:.*HarddiskVolumeShadowCopy(\d+)' -or $line -match 'シャドウ コピー ボリューム:.*HarddiskVolumeShadowCopy(\d+)') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.CopyNumber = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'Provider:.*''(.+)''' -or $line -match 'プロバイダー:.*''(.+)''') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.Provider = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'Type:\s*(.+)' -or $line -match '種類:\s*(.+)') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.Type = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo     if ($currentShadow.Count -gt 0) { >> "%TEMP%\parse_shadows.ps1"
echo         $shadows += $currentShadow >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo     $shadows = $shadows ^| Sort-Object { >> "%TEMP%\parse_shadows.ps1"
echo         if ($_.CreationTime) { >> "%TEMP%\parse_shadows.ps1"
echo             try { [DateTime]::Parse($_.CreationTime) } catch { [DateTime]::MinValue } >> "%TEMP%\parse_shadows.ps1"
echo         } else { [DateTime]::MinValue } >> "%TEMP%\parse_shadows.ps1"
echo     } -Descending >> "%TEMP%\parse_shadows.ps1"
echo     $count = 0 >> "%TEMP%\parse_shadows.ps1"
echo     foreach ($shadow in $shadows) { >> "%TEMP%\parse_shadows.ps1"
echo         $count++ >> "%TEMP%\parse_shadows.ps1"
echo         $copyNum = if ($shadow.CopyNumber) { $shadow.CopyNumber } else { 'Unknown' } >> "%TEMP%\parse_shadows.ps1"
echo         $drive = if ($shadow.DriveLetter) { $shadow.DriveLetter } else { 'Unknown' } >> "%TEMP%\parse_shadows.ps1"
echo         $creationTime = if ($shadow.CreationTime) { >> "%TEMP%\parse_shadows.ps1"
echo             try { >> "%TEMP%\parse_shadows.ps1"
echo                 $dt = [DateTime]::Parse($_.CreationTime) >> "%TEMP%\parse_shadows.ps1"
echo                 $dt.ToString('yyyy/MM/dd HH:mm:ss') >> "%TEMP%\parse_shadows.ps1"
echo             } catch { >> "%TEMP%\parse_shadows.ps1"
echo                 $shadow.CreationTime >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo         } else { 'Unknown' } >> "%TEMP%\parse_shadows.ps1"
echo         $type = if ($shadow.Type) { $shadow.Type } else { 'Unknown' } >> "%TEMP%\parse_shadows.ps1"
echo         $creatorType = 'Unknown' >> "%TEMP%\parse_shadows.ps1"
echo         if ($type -eq 'ClientAccessibleWriters') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'System Restore Point' >> "%TEMP%\parse_shadows.ps1"
echo         } elseif ($shadow.Provider -like '*System*') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'System Backup' >> "%TEMP%\parse_shadows.ps1"
echo         } elseif ($shadow.Provider -like '*Microsoft*') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'Microsoft Service' >> "%TEMP%\parse_shadows.ps1"
echo         } else { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'Third-party Backup' >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         "[$count] HarddiskVolumeShadowCopy$copyNum (Drive $drive`:)" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "    Creation Time: $creationTime" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "    Type: $creatorType" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "    Full Drive Path: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\*" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "    Folder Path: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\(FolderName)" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo     if ($count -eq 0) { >> "%TEMP%\parse_shadows.ps1"
echo         '[Info] No available snapshots found' ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         'System restore may be disabled or no snapshots exist' ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     } else { >> "%TEMP%\parse_shadows.ps1"
echo         '===============================================' ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "Total $count snapshots found" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "[Usage with PreFAS]" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "Copy the above path format and use it in PreFAS settings." ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "Use 'Full Drive Path' for entire drive backup" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "Use 'Folder Path' for specific folders, replacing (FolderName) with actual folder name" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "[CRITICAL WARNING]" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "Do not create new restore points while 7-Zip is running!" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "Snapshots may become invalid and archives may be corrupted." ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "[IMPORTANT NOTES]" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "- For full drive: Must include '\*' at the end" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "- For folders: Replace (FolderName) with actual folder name (no wildcards needed)" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "- Do not run disk cleanup or system maintenance during backup" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "- Old snapshots may be automatically deleted" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "- Do not shutdown PC during compression" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo         "- Latest snapshots are displayed first" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo } catch { >> "%TEMP%\parse_shadows.ps1"
echo     "Error occurred during processing" ^| Out-File -FilePath $outputFile -Append -Encoding UTF8 >> "%TEMP%\parse_shadows.ps1"
echo } >> "%TEMP%\parse_shadows.ps1"

:: Execute PowerShell script silently
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\parse_shadows.ps1" >nul 2>&1
set PS_EXIT_CODE=%errorLevel%

:: Clean up temporary files
del "%TEMP_FILE%" >nul 2>&1
del "%TEMP%\parse_shadows.ps1" >nul 2>&1

:: Display results
if %PS_EXIT_CODE% equ 0 (
    echo Processing completed successfully.
    echo.
    echo ===============================================
    echo Results have been saved to:
    echo ChaL-RESULT-VSSDetector.txt
    echo.
    echo Please check the output file for VSS paths.
    echo ===============================================
) else (
    echo Processing failed. Please run as administrator.
)

echo.
echo Press any key to exit...
pause >nul
popd