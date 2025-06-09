::
::　～ VolumeShadowCopy スナップショット パス取得スクリプト ～
:: －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
::　　VSSDetector 日本語版 Ver.1.0.0
:: －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
::　　システムの復元ポイントなどで作成されるシャドーコピーの正確なパスを取得する。
::　　取得したパスを 7-Zip などで圧縮元ソースに指定する事で、ファイルの変更が起らない
::　　ソースフォルダ、ソースドライブを指定可能になる。
::
::   Copyright by Chall-Link（シャルリンク）
::
:: ※本スクリプトは管理者権限で実行してください。
::
:: ▼▼▼
:: 本スクリプトの目的・効果・特徴などは、Readme-VSSDetector_Guide.txt をご確認ください
::


@echo off
pushd %~dp0
chcp 932 >nul 2>&1
setlocal enabledelayedexpansion

echo ===============================================
echo スナップショット確認ツール（拡張版）
echo ===============================================
echo システムに保存されたスナップショット一覧を表示
echo （システムに変更は加えません）
echo.

:: 管理者権限チェック
echo 管理者権限を確認中...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [エラー] このツールは管理者権限が必要です
    echo 右クリックして「管理者として実行」を選択してください
    echo.
    echo 任意のキーを押して終了...
    pause >nul
    popd
    exit /b 1
)
echo 管理者権限を確認しました。

echo.
echo スナップショット情報を取得中...
echo （数秒かかる場合があります）
echo.

:: vssadmin出力を一時ファイルに取得
set TEMP_FILE=%TEMP%\vssadmin_output.txt
vssadmin list shadows > "%TEMP_FILE%" 2>&1

if %errorLevel% neq 0 (
    echo [エラー] スナップショット情報の取得に失敗しました
    echo VSSサービスが実行されていない可能性があります
    del "%TEMP_FILE%" >nul 2>&1
    echo 任意のキーを押して終了...
    pause >nul
    popd
    exit /b 1
)

:: PowerShellスクリプトを作成してvssadmin出力を解析
echo $ErrorActionPreference = 'Stop' > "%TEMP%\parse_shadows.ps1"
echo $outputFile = ".\ChaL-RESULT-VSSDetector.txt" >> "%TEMP%\parse_shadows.ps1"
echo try { >> "%TEMP%\parse_shadows.ps1"
echo     # 出力ファイルにヘッダーを初期化 >> "%TEMP%\parse_shadows.ps1"
echo     "===============================================" ^| Out-File -FilePath $outputFile -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "スナップショット確認ツール（拡張版）" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "===============================================" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "システムに保存されたスナップショット一覧を表示" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "（システムに変更は加えません）" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "生成日時: $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     $content = Get-Content '%TEMP_FILE%' -Encoding OEM >> "%TEMP%\parse_shadows.ps1"
echo     $shadows = @() >> "%TEMP%\parse_shadows.ps1"
echo     $currentShadow = @{} >> "%TEMP%\parse_shadows.ps1"
echo     $globalCreationTime = $null >> "%TEMP%\parse_shadows.ps1"
echo     foreach ($line in $content) { >> "%TEMP%\parse_shadows.ps1"
echo         $line = $line.Trim() >> "%TEMP%\parse_shadows.ps1"
echo         if ($line -match '作成時刻: (\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2})') { >> "%TEMP%\parse_shadows.ps1"
echo             $globalCreationTime = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'シャドウ コピー ID:.*\{(.+)\}') { >> "%TEMP%\parse_shadows.ps1"
echo             if ($currentShadow.Count -gt 0) { >> "%TEMP%\parse_shadows.ps1"
echo                 $shadows += $currentShadow >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow = @{} >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.ID = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.CreationTime = $globalCreationTime >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '元のボリューム:.*\(([A-Z]):\).*Volume\{(.+)\}') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.DriveLetter = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.VolumeGUID = $matches[2] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'シャドウ コピー ボリューム:.*HarddiskVolumeShadowCopy(\d+)') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.CopyNumber = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match 'プロバイダー:.*''(.+)''') { >> "%TEMP%\parse_shadows.ps1"
echo             $currentShadow.Provider = $matches[1] >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         elseif ($line -match '種類:\s*(.+)') { >> "%TEMP%\parse_shadows.ps1"
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
echo         $copyNum = if ($shadow.CopyNumber) { $shadow.CopyNumber } else { '不明' } >> "%TEMP%\parse_shadows.ps1"
echo         $drive = if ($shadow.DriveLetter) { $shadow.DriveLetter } else { '不明' } >> "%TEMP%\parse_shadows.ps1"
echo         $creationTime = if ($shadow.CreationTime) { >> "%TEMP%\parse_shadows.ps1"
echo             try { >> "%TEMP%\parse_shadows.ps1"
echo                 $dt = [DateTime]::Parse($_.CreationTime) >> "%TEMP%\parse_shadows.ps1"
echo                 $dt.ToString('yyyy/MM/dd HH:mm:ss') >> "%TEMP%\parse_shadows.ps1"
echo             } catch { >> "%TEMP%\parse_shadows.ps1"
echo                 $shadow.CreationTime >> "%TEMP%\parse_shadows.ps1"
echo             } >> "%TEMP%\parse_shadows.ps1"
echo         } else { '不明' } >> "%TEMP%\parse_shadows.ps1"
echo         $type = if ($shadow.Type) { $shadow.Type } else { '不明' } >> "%TEMP%\parse_shadows.ps1"
echo         $creatorType = '不明' >> "%TEMP%\parse_shadows.ps1"
echo         if ($type -eq 'ClientAccessibleWriters') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'システム復元ポイント' >> "%TEMP%\parse_shadows.ps1"
echo         } elseif ($shadow.Provider -like '*System*') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'システムバックアップ' >> "%TEMP%\parse_shadows.ps1"
echo         } elseif ($shadow.Provider -like '*Microsoft*') { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'Microsoftサービス' >> "%TEMP%\parse_shadows.ps1"
echo         } else { >> "%TEMP%\parse_shadows.ps1"
echo             $creatorType = 'サードパーティバックアップ' >> "%TEMP%\parse_shadows.ps1"
echo         } >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "[$count] HarddiskVolumeShadowCopy$copyNum (ドライブ $drive`:)" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    作成日時: $creationTime" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    種類: $creatorType" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    ドライブ全体指定時パス表記: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\*" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "    フォルダ指定時パス表記: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\(フォルダ名)" >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '' >> "%TEMP%\parse_shadows.ps1"
echo         "[$count] HarddiskVolumeShadowCopy$copyNum (ドライブ $drive`:)" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    作成日時: $creationTime" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    種類: $creatorType" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    ドライブ全体指定時パス表記: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\*" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "    フォルダ指定時パス表記: \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy$copyNum\(フォルダ名)" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo     if ($count -eq 0) { >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '[情報] 利用可能なスナップショットが見つかりませんでした' >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host 'システムの復元が無効か、スナップショットが存在しません' >> "%TEMP%\parse_shadows.ps1"
echo         '[情報] 利用可能なスナップショットが見つかりませんでした' ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         'システムの復元が無効か、スナップショットが存在しません' ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     } else { >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host '===============================================' >> "%TEMP%\parse_shadows.ps1"
echo         Write-Host "合計 $count 個のスナップショットが見つかりました" >> "%TEMP%\parse_shadows.ps1"
echo         '===============================================' ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "合計 $count 個のスナップショットが見つかりました" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "[PreFASでの使用方法]" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "上記のパス形式をコピーして、PreFAS設定に使用してください。" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "ドライブ全体のバックアップには「ドライブ全体指定時パス表記」を使用" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "特定フォルダには「フォルダ指定時パス表記」を使用し、(フォルダ名)を実際のフォルダ名に置き換え" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "[重大な警告]" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "7-Zip実行中に新しい復元ポイントを作成しないでください！" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "スナップショットが無効になり、アーカイブが破損する可能性があります。" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "[重要な注意事項]" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- ドライブ全体の場合: 末尾に「\*\」を必ず付ける" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- フォルダの場合: (フォルダ名)を実際のフォルダ名に置き換え（ワイルドカード不要）" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- バックアップ中にディスククリーンアップやシステムメンテナンスを実行しない" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- 古いスナップショットは自動的に削除される場合がある" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- 圧縮中にPCをシャットダウンしない" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo         "- 最新のスナップショットが最初に表示されます" ^| Out-File -FilePath $outputFile -Append -Encoding Default >> "%TEMP%\parse_shadows.ps1"
echo     } >> "%TEMP%\parse_shadows.ps1"
echo } catch { >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host '[エラー] スナップショット情報の解析に失敗しました' -ForegroundColor Red >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host "エラー詳細: $($_.Exception.Message)" -ForegroundColor Red >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host 'vssadminの生出力を表示:' -ForegroundColor Yellow >> "%TEMP%\parse_shadows.ps1"
echo     Write-Host '' >> "%TEMP%\parse_shadows.ps1"
echo     Get-Content '%TEMP_FILE%' -Encoding OEM >> "%TEMP%\parse_shadows.ps1"
echo } >> "%TEMP%\parse_shadows.ps1"

:: 出力ファイルパスを設定
set OUTPUT_FILE=%~dp0ChaL-RESULT-VSSDetector.txt

:: ファイル出力のためスクリプトディレクトリに移動
pushd "%~dp0"

:: PowerShellスクリプトを実行
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\parse_shadows.ps1"
set PS_EXIT_CODE=%errorLevel%

:: 元のディレクトリに戻る
popd

:: 一時ファイルをクリーンアップ
del "%TEMP_FILE%" >nul 2>&1
del "%TEMP%\parse_shadows.ps1" >nul 2>&1

if %PS_EXIT_CODE% neq 0 (
    echo.
    echo [エラー] PowerShellスクリプトの実行に失敗しました（終了コード: %PS_EXIT_CODE%）
    echo.
    echo フォールバック方式を試みます...
    echo.
    vssadmin list shadows
)

echo.
echo ===============================================
echo.
echo [PreFASでの使用方法]
echo 上記のパス形式をコピーして、PreFAS設定に使用してください。
echo ドライブ全体のバックアップには「ドライブ全体指定時パス表記」を使用
echo 特定フォルダには「フォルダ指定時パス表記」を使用し、(フォルダ名)を実際のフォルダ名に置き換え
echo.
echo [重大な警告]
echo 7-Zip実行中に新しい復元ポイントを作成しないでください！
echo スナップショットが無効になり、アーカイブが破損する可能性があります。
echo.
echo [重要な注意事項]
echo - ドライブ全体の場合: 末尾に「\*\」を必ず付ける
echo - フォルダの場合: (フォルダ名)を実際のフォルダ名に置き換え（ワイルドカード不要）
echo - バックアップ中にディスククリーンアップやシステムメンテナンスを実行しない
echo - 古いスナップショットは自動的に削除される場合がある
echo - 圧縮中にPCをシャットダウンしない
echo - 最新のスナップショットが最初に表示されます
echo.
echo [情報] スナップショット情報は以下に保存されました: ChaL-RESULT-VSSDetector.txt
echo.
echo ===============================================
echo スクリプトの実行が完了しました。
echo 任意のキーを押して終了...
echo.
echo    If Moji-Bake: Check If bat file is S-JIS.
echo.
pause >nul
popd