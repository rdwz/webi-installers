#!/usr/bin/env pwsh

# If a command returns an error, halt the script.
$ErrorActionPreference = 'Stop'

# Ignore progress events from cmdlets so Invoke-WebRequest is not painfully slow
$ProgressPreference = 'SilentlyContinue'

# Switch to userprofile
pushd $Env:USERPROFILE

# Make paths if needed
if (!(Test-Path -Path .local\bin))
{
    New-Item -Path .local\bin -ItemType Directory
}

# {{ baseurl }}
# {{ version }}

# Enter path
pushd .local\bin

# TODO SetStrictMode
# TODO Test-Path variable:global:Env:WEBI_HOST ???
IF($Env:WEBI_HOST -eq $null -or $Env:WEBI_HOST -eq "")
{
    $Env:WEBI_HOST = "https://webinstall.dev"
}

# Fetch webi.bat
echo "$Env:WEBI_HOST/packages/_webi/webi.ps1"
curl.exe -s -A "windows" "$Env:WEBI_HOST/packages/_webi/webi.ps1.bat" -o webi.bat
curl.exe -s -A "windows" "$Env:WEBI_HOST/packages/_webi/webi.ps1" -o webi.ps1

popd

# Run webi.ps1
#TODO Set-ExecutionPolicy -ExecutionPolicy Bypass
Invoke-Expression "powershell -ExecutionPolicy Bypass .\.local\bin\webi.ps1 {{ exename }}"

# Run pathman to set up the folder
#& "$Env:USERPROFILE\.local\bin\pathman.exe" add "$Env:USERPROFILE\.local\.bin"
& "$Env:USERPROFILE\.local\bin\pathman.exe" add .local\.bin

# Done
popd
