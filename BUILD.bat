@ECHO OFF
SET "params=%*"
CD /d "%~dp0" && ( IF EXIST "%temp%\getadmin.vbs" DEL "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>NUL 2>NUL || ( ECHO Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && EXIT /B )
TITLE BUILD SPAWNBIOME
SETLOCAL ENABLEEXTENSIONS

REM   EDIT FOLDERS BELOW TO WHERE POM.XML IS LOCATED.. WHERE bin\JAVA.EXE IS LOCATED.. WHERE mvn\bin\MVN.CMD IS LOCATED

SET "POMXML_DIR=C:\BUILD"
SET "JAVA_HOME=C:\BUILD\JAVA"
SET "MAVEN_HOME=C:\BUILD\MAVEN"
SET "JAVA_EXE=C:\BUILD\JAVA\bin\java.exe"
SET "JAVAP_EXE=C:\BUILD\JAVA\bin\javap.exe"
SET "MAVEN_CMD=C:\BUILD\MAVEN\mvn\bin\mvn.cmd"

SET "PATH=%JAVA_HOME%\bin;%MAVEN_HOME%\mvn\bin;%PATH%"

ECHO.
ECHO ====================
ECHO   BUILD SPAWNBIOME
ECHO ====================
ECHO.
IF NOT EXIST "%POMXML_DIR%\pom.xml" (
    ECHO ERROR: pom.xml not found:
    ECHO        "%POMXML_DIR%\pom.xml"
    ECHO.
    PAUSE
    EXIT /B 1
)
IF NOT EXIST "%JAVA_EXE%" (
    ECHO ERROR: Java 17 was not found at:
    ECHO        "%JAVA_EXE%"
    ECHO.
    PAUSE
    EXIT /B 1
)
IF NOT EXIST "%MAVEN_CMD%" (
    ECHO ERROR: Maven was not found at:
    ECHO        "%MAVEN_CMD%"
    ECHO.
    PAUSE
    EXIT /B 1
)
CD /D "%POMXML_DIR%"
IF ERRORLEVEL 1 (
    ECHO ERROR: Could not enter POM folder:
    ECHO        "%POMXML_DIR%"
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO POM:
ECHO   %CD%
ECHO.
ECHO Java being used:
"%JAVA_EXE%" -version
IF ERRORLEVEL 1 (
    ECHO.
    ECHO ERROR: Java failed to run.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.
ECHO Maven being used:
CALL "%MAVEN_CMD%" --version
IF ERRORLEVEL 1 (
    ECHO.
    ECHO ERROR: Maven failed to run.
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.
ECHO Building SpawnBiome.jar...
CALL "%MAVEN_CMD%" -U clean package
IF ERRORLEVEL 1 (
    ECHO.
    ECHO BUILD FAILED!
    ECHO.
    PAUSE
    EXIT /B 1
)
IF NOT EXIST "%POMXML_DIR%\TARGET\SpawnBiome.jar" (
    ECHO.
    ECHO BUILD FINISHED, BUT JAR WAS NOT FOUND:
    ECHO   "%POMXML_DIR%\TARGET\SpawnBiome.jar"
    ECHO.
    PAUSE
    EXIT /B 1
)
ECHO.
ECHO Verifying class major version. Java 17 should be major version 61.
IF EXIST "%JAVAP_EXE%" (
    "%JAVAP_EXE%" -verbose -classpath "%POMXML_DIR%\TARGET\SpawnBiome.jar" com.creeperusa.spawnbiome.SpawnBiomePlugin | findstr /C:"major version"
) ELSE (
    ECHO WARNING: javap.exe not found, skipping bytecode check.
)
ECHO.
ECHO ==================
ECHO   BUILD COMPLETE
ECHO ==================
ECHO.
ECHO   JAR:
ECHO   %POMXML_DIR%\TARGET\SpawnBiome.jar
ECHO.
ECHO.
PAUSE
EXIT
