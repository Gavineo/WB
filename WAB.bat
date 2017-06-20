::Gavineo is cool bruh


@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

SET "CHARSET=!+0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghikjlmnopqrstuvwxyz"



:: ----------------------------------------------------------------------------
:: Lets Start this

CALL :CONFIGURE_CHARSET "%CHARSET%"
REM ECHO MAX_INDEX: !MAX_INDEX!
REM SET

SET ITER_FILE=%TEMP%\ITERATOR_%RANDOM%.txt
ECHO.0>"%ITER_FILE%"

:INFINITE_LOOP
CALL :READ_ITER "%ITER_FILE%" _ITER_CONTENTS
ECHO '!_ITER_CONTENTS!'
CALL :NEXT_ITER "%ITER_FILE%"

GOTO :INFINITE_LOOP

EXIT /B

:NEXT_ITER
SETLOCAL
SET "FILE=%~1"
SET "NEXT_FILE=%TEMP%\ITERATOR_NEXT_%RANDOM%.txt"
SET CARRY=1
FOR /F %%n IN (%FILE%) DO (
    IF !CARRY! EQU 1 (
        SET /A I_VALUE=%%n+1
        IF !I_VALUE! GTR %MAX_INDEX% (
            SET I_VALUE=0
            SET CARRY=1
        ) ELSE (
            SET CARRY=0
        )
    ) ELSE (
        SET I_VALUE=%%n
    )
    ECHO !I_VALUE!>>"!NEXT_FILE!"
)
REM    
IF !CARRY! EQU 1 (ECHO.0>>"!NEXT_FILE!")
MOVE /Y "%NEXT_FILE%" "%FILE%" >NUL
ENDLOCAL
EXIT /B

:READ_ITER
SETLOCAL
SET "FILE=%~1"
SET "VAR=%~2"
SET VALUE=
SET _V=
FOR /F %%n IN (%FILE%) DO (
    SET "VALUE=!VALUE_%%n!!VALUE!"
)
ENDLOCAL && SET %VAR%=%VALUE%
EXIT /B

:TRANS_INDEX
SETLOCAL
SET "VAR=%~1"
SET "C=%~2"
SET IDX=
FOR /L %%i IN (0,1,%MAX_INDEX%) DO (
    IF "!VALUE_%%i!"=="!C!" SET IDX=%%i
)
SET "TRANS=!VALUE_%%i!"
ENDLOCAL && SET "%VAR%=%TRANS%"
EXIT /B

:CONFIGURE_CHARSET
SET CONFIG_TEMP=%TEMP%\CONFIG_%RANDOM%.cmd
IF EXIST "%CONFIG_TEMP%" DEL /Q "%CONFIG_TEMP%"
CALL :WRITE_CONFIG "%CONFIG_TEMP%" "%~1"
REM   Import all the definitions.
CALL "%CONFIG_TEMP%"
EXIT /B

REM
:WRITE_CONFIG
SETLOCAL
SET "FILE=%~1"
SET "STR=%~2"

REM This is the "index" of the symbol.
SET "INDEX=%~3"
IF "!INDEX!"=="" SET INDEX=0

IF NOT "%STR%"=="" (
   SET "C=!STR:~0,1!"
   IF NOT "%~4"=="" (
       SET "FIRST=%~4"
   ) ELSE (
       SET "FIRST=!C!"
   )
   SET "D=!STR:~1,1!"
    IF "!D!"=="" (
        SET CARRY=1
        SET "D=!FIRST!"
    ) ELSE (
        SET CARRY=0
    )
    ECHO SET VALUE_!INDEX!=!C!>>"!FILE!"

    SET /A NEXT_INDEX=INDEX+1

    REM 
    SET MAX_INDEX=!INDEX!
    CALL :WRITE_CONFIG "!FILE!" "!STR:~1!" "!NEXT_INDEX!" "!FIRST!"
    IF !INDEX! GTR !MAX_INDEX! SET MAX_INDEX=!INDEX!
)
ENDLOCAL && SET MAX_INDEX=%MAX_INDEX%
EXIT /B
