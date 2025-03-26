@echo off
setlocal
set abltInstallDir=%appdata%\ablt

net session >nul 2>&1
if errorlevel 2 (
	echo you must run this script as admin.
	goto PROGRAMEND
)


goto GETOPTS

:HELP
powershell -c $(get-content "%~dp0help-install.txt")
goto PROGRAMEND

:INSTALL
mkdir "%~dp0tmp" >nul 2>&1
cd tmp >nul 2>&1
where /q ablt.bat

if errorlevel 1 (
	mkdir %abltInstallDir% >nul 2>&1
	echo. "%path%" | findstr /C:"%abltInstallDir%\;" >nul
	if errorlevel 1 (
		setx /M path "%abltInstallDir%\;%path%" >nul 2>&1
	)
	cd ..
	rmdir tmp >nul 2>&1
	copy * "%abltInstallDir%\" >nul 2>&1
	echo installed with success.
	goto PROGRAMEND
) 

echo already installed.
cd ..
rmdir tmp

goto PROGRAMEND

:GETOPTS

if /I "%1" == "-u" (
	mkdir %~dp0^tmp >nul 2>&1
	cd tmp >nul 2>&1
	where /q ablt.bat

	if errorlevel 1 (
		goto INSTALL
	) else (
		cd ..
		rmdir tmp >nul 2>&1
		copy * "%abltInstallDir%\" >nul 2>&1
		echo updated with success.
	)
	goto PROGRAMEND
)

if /I "%1" == "-i" (
	goto INSTALL
)

if /I "%1" == "-h" (
	goto HELP
)

if /I "%1" == "" (
	goto HELP
)

:PROGRAMEND
endlocal
@echo on
