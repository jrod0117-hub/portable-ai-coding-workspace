cd F:\ISO
New-Item -ItemType Directory -Force -Name seediso | Out-Null
Copy-Item seed\user-data seediso\
Copy-Item seed\meta-data seediso\
Write-Host 'Files copied to seediso'
