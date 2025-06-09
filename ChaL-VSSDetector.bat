::
::�@�` VolumeShadowCopy �X�i�b�v�V���b�g �p�X�擾�X�N���v�g �`
:: �|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
::�@�@VSSDetector ���{��� Ver.1.0.0
:: �|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
::�@�@�V�X�e���̕����|�C���g�Ȃǂō쐬�����V���h�[�R�s�[�̐��m�ȃp�X���擾����B
::�@�@�擾�����p�X�� 7-Zip �Ȃǂň��k���\�[�X�Ɏw�肷�鎖�ŁA�t�@�C���̕ύX���N��Ȃ�
::�@�@�\�[�X�t�H���_�A�\�[�X�h���C�u���w��\�ɂȂ�B
::
::   Copyright by Chall-Link�i�V���������N�j
::
:: ���{�X�N���v�g�͊Ǘ��Ҍ����Ŏ��s���Ă��������B
::
:: ������
:: �{�X�N���v�g�̖ړI�E���ʁE�����Ȃǂ́AReadme-VSSDetector_Guide.txt �����m�F��������
::


@echo off
pushd %~dp0
chcp 932 >nul 2>&1
setlocal enabledelayedexpansion

echo ===============================================
echo �X�i�b�v�V���b�g�m�F�c�[���i�g���Łj
echo ===============================================
echo �V�X�e���ɕۑ����ꂽ�X�i�b�v�V���b�g�ꗗ��\��
echo �i�V�X�e���ɕύX�͉����܂���j
echo.

:: �Ǘ��Ҍ����`�F�b�N
echo �Ǘ��Ҍ������m�F��...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [�G���[] ���̃c�[���͊Ǘ��Ҍ������K�v�ł�
    echo �E�N���b�N���āu�Ǘ��҂Ƃ��Ď��s�v��I�����Ă�������
    echo.
    echo �C�ӂ̃L�[�������ďI��...
    pause >nul
    popd
    exit /b 1
)
echo �Ǘ��Ҍ������m�F���܂����B

echo.
echo �X�i�b�v�V���b�g�����擾��...
echo �i���b������ꍇ������܂��j
echo.

:: vssadmin�o�͂��ꎞ�t�@�C���Ɏ擾
set TEMP_FILE=%TEMP%\vssadmin_output.txt
vssadmin list shadows > "%TEMP_FILE%" 2>&1

if %errorLevel% neq 0 (
    echo [�G���[] �X�i�b�v�V���b�g���̎擾�Ɏ��s���܂���
    echo VSS�T�[�r�X�����s����Ă��Ȃ��\��������܂�
    del "%TEMP_FILE%" >nul 2>&1
    echo �C�ӂ̃L�[�������ďI��...
    pause >nul
    popd
    exit /b 1
)

:: PowerShell�X�N���v�g���쐬����vssadmin�o�͂����
echo $ErrorActionPreference = 'Stop' > "%TEMP%\parse_shadows.ps1"
echo $outputFile = ".\ChaL-RESULT-VSSDetector.txt" >> "%TEMP%\parse_shadows.ps1"
echo try { >> "%TEMP%\parse_shadows.ps1"
echo     # �o�̓t�@�C���Ƀw�b�_�[�������� >> "%TEMP%\parse_shadows.ps1"
echo     "===============================================" ^| Out-File -FilePath $outputFile -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "�X�i�b�v�V���b�g�m�F�c�[���i�g���Łj" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "===============================================" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "�V�X�e���ɕۑ����ꂽ�X�i�b�v�V���b�g�ꗗ��\��" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "�i�V�X�e���ɕύX�͉����܂���j" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "��������: $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     $content = Get-Content '%TEMP_FILE%' -Encoding OEM >> "%TEMP%\parse_shadows.ps1"
echo     $shadows = @() >> "%TEMP%\parse_shadows.ps1"
echo     $currentShadow = @{} >> "%TEMP%\parse_shadows.ps1"
echo     $globalCreationTime = $null >> "%TEMP%\parse_shadows.ps1"
echo     foreach ($line in $content) { >> "%TEMP%\parse_shadows.ps1"
echo         $line = $line.Trim() >> "%TEMP%\parse_shadows.ps1"
echo         if ($line -match '�쐬����: (\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2})') { >> "%TEMP%\parse_shadows.ps1"
echo             $globalCreationTime = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '�V���h�E �R�s�[ ID:.*\{(.+)\}') { >> "%TEMP%\parse_shadows.ps1"
echo             if ($currentShadow.Count -gt 0) { >> "%TEMP%\parse_shadows.ps1"
echo                 $shadows += $currentShadow >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow = @{} >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.ID = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.CreationTime = $globalCreationTime >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '���̃{�����[��:.*\(([A-Z]):\).*Volume\{(.+)\}') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.DriveLetter = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.VolumeGUID = $matches[2] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '�V���h�E �R�s�[ �{�����[��:.*HarddiskVolumeShadowCopy(\d+)') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.CopyNumber = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '�v���o�C�_�[:.*''(.+)''') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.Provider = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '���:\s*(.+)') { >> "%TEMP%\parse_shadows.ps1"
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
echo         $copyNum = if ($shadow.CopyNumber) { $shadow.CopyNumber } else { '�s��' } >> "%TEMP%\parse_shadows.ps1"
echo         $drive = if ($shadow.DriveLetter) { $shadow.DriveLetter } else { '�s��' } >> "%TEMP%\parse_shadows.ps1"
echo         $creationTime = if ($shadow.CreationTime) { >> "%TEMP%\parse_shadows.ps1"
echo             try { >> "%TEMP%\parse_shadows.ps1"
echo                 $dt = [DateTime]::Parse($_.CreationTime) >> "%TEMP%\parse_shadows.ps1"
echo                 $dt.ToString('yyyy/MM/dd HH:mm:ss') >> "%TEMP%\parse_shadows.ps1"
echo             } catch { >> "%TEMP%\parse_shadows.ps1"
echo                 $shadow.CreationTime >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo         } else { '�s��' } >> "%TEMP%\parse_shadows.ps1"
echo         $type = if ($shadow.Type) { $shadow.Type } else { '�s��' } >> "%TEMP%\parse_shadows.ps1"
echo         $creatorType = '�s��' >> "%TEMP%\parse_shadows.ps1"
echo         if ($type -eq 'ClientAccessibleWriters') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = '�V�X�e�������|�C���g' >> "%TEMP%\parse_shadows.ps1"
echo         } elseif ($shadow.Provider -like '*System*') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = '�V�X�e���o�b�N�A�b�v' >> "%TEMP%\parse_shadows.ps1"
echo         } elseif ($shadow.Provider -like '*Microsoft*') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'Microsoft�T�[�r�X' >> "%TEMP%\parse_shadows.ps1"
echo         } else { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = '�T�[�h�p�[�e�B�o�b�N�A�b�v' >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "[$count] HarddiskVolumeShadowCopy$copyNum (�h���C�u $drive`:)" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    �쐬����: $creationTime" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    ���: $creatorType" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    �h���C�u�S�̎w�莞�p�X�\�L: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\*" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    �t�H���_�w�莞�p�X�\�L: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\(�t�H���_��)" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '' >> "%TEMP%\parse_shadows.ps1"
echo         "[$count] HarddiskVolumeShadowCopy$copyNum (�h���C�u $drive`:)" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    �쐬����: $creationTime" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    ���: $creatorType" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    �h���C�u�S�̎w�莞�p�X�\�L: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\*" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    �t�H���_�w�莞�p�X�\�L: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\(�t�H���_��)" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo     if ($count -eq 0) { >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '[���] ���p�\�ȃX�i�b�v�V���b�g��������܂���ł���' >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '�V�X�e���̕������������A�X�i�b�v�V���b�g�����݂��܂���' >> "%TEMP%\parse_shadows.ps1"
echo         '[���] ���p�\�ȃX�i�b�v�V���b�g��������܂���ł���' ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         '�V�X�e���̕������������A�X�i�b�v�V���b�g�����݂��܂���' ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     } else { >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '===============================================' >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "���v $count �̃X�i�b�v�V���b�g��������܂���" >> "%TEMP%\parse_shadows.ps1"
echo         '===============================================' ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "���v $count �̃X�i�b�v�V���b�g��������܂���" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "[PreFAS�ł̎g�p���@]" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "��L�̃p�X�`�����R�s�[���āAPreFAS�ݒ�Ɏg�p���Ă��������B" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "�h���C�u�S�̂̃o�b�N�A�b�v�ɂ́u�h���C�u�S�̎w�莞�p�X�\�L�v���g�p" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "����t�H���_�ɂ́u�t�H���_�w�莞�p�X�\�L�v���g�p���A(�t�H���_��)�����ۂ̃t�H���_���ɒu������" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "[�d��Ȍx��]" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "7-Zip���s���ɐV���������|�C���g���쐬���Ȃ��ł��������I" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "�X�i�b�v�V���b�g�������ɂȂ�A�A�[�J�C�u���j������\��������܂��B" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "[�d�v�Ȓ��ӎ���]" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- �h���C�u�S�̂̏ꍇ: �����Ɂu\*\�v��K���t����" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- �t�H���_�̏ꍇ: (�t�H���_��)�����ۂ̃t�H���_���ɒu�������i���C���h�J�[�h�s�v�j" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- �o�b�N�A�b�v���Ƀf�B�X�N�N���[���A�b�v��V�X�e�������e�i���X�����s���Ȃ�" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- �Â��X�i�b�v�V���b�g�͎����I�ɍ폜�����ꍇ������" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- ���k����PC���V���b�g�_�E�����Ȃ�" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- �ŐV�̃X�i�b�v�V���b�g���ŏ��ɕ\������܂�" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo } catch { >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host '[�G���[] �X�i�b�v�V���b�g���̉�͂Ɏ��s���܂���' -ForegroundColor Red >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host "�G���[�ڍ�: $($_.Exception.Message)" -ForegroundColor Red >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host 'vssadmin�̐��o�͂�\��:' -ForegroundColor Yellow >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host '' >> "%TEMP%\parse_shadows.ps1"
echo     Get-Content '%TEMP_FILE%' -Encoding OEM >> "%TEMP%\parse_shadows.ps1"
echo } >> "%TEMP%\parse_shadows.ps1"

:: �o�̓t�@�C���p�X��ݒ�
set OUTPUT_FILE=%~dp0ChaL-RESULT-VSSDetector.txt

:: �t�@�C���o�͂̂��߃X�N���v�g�f�B���N�g���Ɉړ�
pushd "%~dp0"

:: PowerShell�X�N���v�g�����s
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\parse_shadows.ps1"
set PS_EXIT_CODE=%errorLevel%

:: ���̃f�B���N�g���ɖ߂�
popd

:: �ꎞ�t�@�C�����N���[���A�b�v
del "%TEMP_FILE%" >nul 2>&1
del "%TEMP%\parse_shadows.ps1" >nul 2>&1

if %PS_EXIT_CODE% neq 0 (
    echo.
    echo [�G���[] PowerShell�X�N���v�g�̎��s�Ɏ��s���܂����i�I���R�[�h: %PS_EXIT_CODE%�j
    echo.
    echo �t�H�[���o�b�N���������݂܂�...
    echo.
    vssadmin list shadows
)

echo.
echo ===============================================
echo.
echo [PreFAS�ł̎g�p���@]
echo ��L�̃p�X�`�����R�s�[���āAPreFAS�ݒ�Ɏg�p���Ă��������B
echo �h���C�u�S�̂̃o�b�N�A�b�v�ɂ́u�h���C�u�S�̎w�莞�p�X�\�L�v���g�p
echo ����t�H���_�ɂ́u�t�H���_�w�莞�p�X�\�L�v���g�p���A(�t�H���_��)�����ۂ̃t�H���_���ɒu������
echo.
echo [�d��Ȍx��]
echo 7-Zip���s���ɐV���������|�C���g���쐬���Ȃ��ł��������I
echo �X�i�b�v�V���b�g�������ɂȂ�A�A�[�J�C�u���j������\��������܂��B
echo.
echo [�d�v�Ȓ��ӎ���]
echo - �h���C�u�S�̂̏ꍇ: �����Ɂu\*\�v��K���t����
echo - �t�H���_�̏ꍇ: (�t�H���_��)�����ۂ̃t�H���_���ɒu�������i���C���h�J�[�h�s�v�j
echo - �o�b�N�A�b�v���Ƀf�B�X�N�N���[���A�b�v��V�X�e�������e�i���X�����s���Ȃ�
echo - �Â��X�i�b�v�V���b�g�͎����I�ɍ폜�����ꍇ������
echo - ���k����PC���V���b�g�_�E�����Ȃ�
echo - �ŐV�̃X�i�b�v�V���b�g���ŏ��ɕ\������܂�
echo.
echo [���] �X�i�b�v�V���b�g���͈ȉ��ɕۑ�����܂���: ChaL-RESULT-VSSDetector.txt
echo.
echo ===============================================
echo �X�N���v�g�̎��s���������܂����B
echo �C�ӂ̃L�[�������ďI��...
echo.
echo    If Moji-Bake: Check If bat file is S-JIS.
echo.
pause >nul
popd