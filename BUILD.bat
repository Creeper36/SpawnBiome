@ECHO OFF
TITLE BUILD_SPAWNBIOME
CD /D "%~dp0"

WHERE mvn >NUL 2>&1
IF ERRORLEVEL 1 (
    ECHO Maven was not found in PATH.
    ECHO Install Maven or build this project in an IDE.
    PAUSE
    EXIT /B 1
)

mvn clean package
IF ERRORLEVEL 1 (
    ECHO.
    ECHO Build failed.
    PAUSE
    EXIT /B 1
)

ECHO.
ECHO Build complete.
ECHO JAR:
ECHO %CD%\target\SpawnBiome.jar
PAUSE
