@echo off
setlocal
set programCaller=%DLC%\bin\prowin.exe
set abltInstallDir=%appdata%\ablt
set testerScript=%abltInstallDir%\tester-cli.p
set testerDiscoverPattern="*TestCase.cls"
set testerLogOutput=ablt-tester-log.log
set openHtmlFile=1
set quiet=0

if not exist %abltInstallDir% (
	echo ERROR: the ablt is not installed yet, please install with the install-ablt script
	goto PROGRAMEND
)

goto GETOPTIONS

:HELP

if exist "%abltInstallDir%\help.txt" (
	cat "%abltInstallDir%\help.txt"
) else (
	cat "%~dp0help.txt"
)
goto PROGRAMEND

:GETOPTIONS
if /I "%1" == "-h" (
	goto HELP
) else if /I "%1" == "--help" (
	goto HELP
) else if /I "%1" == "-q" (
	set quiet=1
	shift
) else if /I "%1" == "-n" (
	set openHtmlFile=0 
	shift
) else if /I "%1" == "--not-open" (
	set openHtmlFile=0 
	shift
) else if /I "%1" == "-t" (
	set testerTestCaseFullPath=%2
	set testerTestCaseRelativePath=%2
	shift
	shift
) else if /I "%1" == "--test-case" (
	set testerTestCaseFullPath=%2
	set testerTestCaseRelativePath=%2
	shift
	shift
) else if /I "%1" == "-d" (
	set testerDiscoverDir=%2
	if /I "%3" == "-f" (
		set testerDiscoverPattern=%4
		shift
		shift
	) else if /I "%3" == "--find" (
		set testerDiscoverPattern=%4
		shift
		shift
	)
	shift
	shift
) else if /I "%1" == "--discover" (
	set testerDiscoverDir=%2
	if /I "%3" == "-f" (
		set testerDiscoverPattern=%4
		shift
		shift
	) else if /I "%3" == "--find" (
		set testerDiscoverPattern=%4
		shift
		shift
	)
	shift
	shift
) else if /I "%1" == "--html" (
	set htmlOutputPath=%2
	shift
	shift
) else if /I "%1" == "--json" (
	set jsonOutputPath=%2
	shift
	shift
) else if /I "%1" == "-ininame" (
	set additionalArgs=%additionalArgs% -basekey "ini" -ininame %2
	shift
	shift
) else if /I "%1" == "-p" (
	set extraProcedures=%2
	shift
	shift
) else if /I "%1" == "-pf" (
	set additionalArgs=%additionalArgs% -pf %2
	shift
	shift
) else if /I "%1" == "-pf1" (
	set additionalArgs=%additionalArgs% -pf %oepf1%
	shift
) else if /I "%1" == "-pf2" (
	set additionalArgs=%additionalArgs% -pf %oepf2%
	shift
) else if /I "%1" == "-log" (
	set testerLogOutput=%2
	shift
	shift
) else (
	if "%1" == "-f" (
		echo "ERROR: the parameter `-f` must always be passed after `-d` or `--discover`
	) else if "%1" == "-f" (
		echo "ERROR: the parameter `--find` must always be passed after `-d` or `--discover`
	) else (
		echo ERROR: unknown parameter `%1`, type `ablt -h` to check the help
	)
	goto PROGRAMEND
)

if /I "%1" == "" (
	goto RUNCOMPILATIONCMD
)

goto GETOPTIONS

:RUNCOMPILATIONCMD
if not exist %testerScript% (
	echo ERROR: tester script was not found in the path %testerScript%
	goto PROGRAMEND
)

if not "%testerTestCaseFullPath%" == "" if not "%testerDiscoverDir%" == "" (
	echo ERROR: you can't specify a test file and a discover dir at the same time
	goto PROGRAMEND
) 

if "%testerTestCaseFullPath%" == "" if "%testerDiscoverDir%" == "" (
	echo ERROR: you must specify `-t` or `-d`
	goto PROGRAMEND
)


if not "%testerTestCaseFullPath%" == "" (
	echo.%testerTestCaseFullPath% | findstr /C:":" 1>nul
	if errorlevel 1 (
		set testerTestCaseFullPath=%cd%\%testerTestCaseFullPath%
	)
)

if not "%testerDiscoverDir%" == "" (
	echo.%testerDiscoverDir% | findstr /C:":" 1>nul
	if errorlevel 1 (
		set testerDiscoverDir=%cd%\%testerDiscoverDir%
	)
)

echo.%additionalArgs% | findstr /C:"-ininame " 1>nul
if errorlevel 1 (
	if not "%oeini%" == "" (
		set additionalArgs=%additionalArgs% -basekey "ini" -ininame %oeini%	
	)
)

echo.%additionalArgs% | findstr /C:"-pf " 1>nul
if errorlevel 1 (
	if not "%oedpf%" == "" (
		set additionalArgs=%additionalArgs% -pf %oedpf%	
	)
)

if "%extraProcedures%" == "" (
	set extraProcedures=%oedcs%
)

%programCaller% -b -p %testerScript% -param %testerTestCaseFullPath%;%testerTestCaseRelativePath%;%testerDiscoverDir%;%testerDiscoverPattern%;%testerLogOutput%;%htmlOutputPath%;%jsonOutputPath%,%extraProcedures% %additionalArgs%
if %quiet% == 0 if exist %testerLogOutput% (
	cat %testerLogOutput%
)
if %openHtmlFile% == 1 if exist "%htmlOutputPath%" "%htmlOutputPath%"
goto PROGRAMEND

:PROGRAMEND
endlocal
@echo on
