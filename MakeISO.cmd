@echo off
color 1F
mode con lines=30 cols=90
rem ��ʼ������
set "Oscdimg=%~sdp0Bin\%PROCESSOR_ARCHITECTURE%\oscdimg.exe"
set "DVD=%~1"
set "ISOLabel=%~2"
set "ISOFileName=%~3"
rem ѡ����̾���Ŀ¼
if "%DVD%" equ "" call :SelectFolder
set "BIOSBoot=%DVD%\boot\etfsboot.com"
set "UEFIBoot=%DVD%\efi\microsoft\boot\efisys.bin"
rem �ж�BIOS����
if not exist "%BIOSBoot%" echo %BIOSBoot% ������ && goto :Exit
if not exist "%DVD%\sources\boot.wim" echo boot.wim ������ && goto :Exit
if not exist "%DVD%\sources\install.wim" ( if not exist "%DVD%\sources\install.esd" echo ��װ���񲻴��� && goto :Exit )
rem �Զ����ɾ���
call :MakeLabel %DVD%
if "%ISOFileName%" equ "" ( set "ISOFileName=%~dp0%ISOLabel%.iso" )
rem ����ei.cfg
if exist "%DVD%\sources\ei.cfg" del /f /q "%DVD%\sources\ei.cfg"
(
    echo.[EditionID]
    echo.
    echo.[Channel]
    echo.OEM
    echo.[VL]
    echo.1
)>"%DVD%\sources\ei.cfg"
rem �ж�UEFI����
if exist "%UEFIBoot%" (
   "%Oscdimg%" -bootdata:2#p0,e,b"%BIOSBoot%"#pEF,e,b"%UEFIBoot%" -o -h -m -u2 -udfver102 "%DVD%" "%ISOFileName%"
) else (
   "%Oscdimg%" -bootdata:1#p0,e,b"%BIOSBoot%" -o -h -m -u2 -udfver102 "%DVD%" "%ISOFileName%"
)
goto :Exit

:SelectFolder
set folder=mshta "javascript:var folder=new ActiveXObject('Shell.Application').BrowseForFolder(0,'ѡ��װ��������Ŀ¼', 513, '');if(folder) new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(folder.Self.Path);window.close();"
for /f "tokens=* delims=" %%f in ('%folder%') do set "DVD=%%f"
if "%DVD%" equ "" goto :Exit
goto :eof

:MakeLabel
if "%ISOLabel%" equ "" ( set "ISOLabel=%~n1" )
goto :eof

:Exit
if "%~1" equ "" pause