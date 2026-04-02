@echo off
REM=
REM  NOTE      - regedit.bat
REM  Author    - Aru
REM
REM  Created   - 2026.03.15
REM  Github    - https://github.com/aruyu
REM  Contact   - vine9151@gmail.com
REM



reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
