@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

echo {
echo "data":[

SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`"C:\Windows\System32\nvidia-smi.exe" -L`) DO (
    if !count! GTR 1 echo ,

    SET line=%%F
    SET var!count!=%%F
    SET /a count=!count!+1
    for /f "tokens=1 delims=:" %%A in ('echo %%F') do (
        for /f "tokens=2 delims= " %%B in ('echo %%A') do (
            echo|set /p={"{#GPUINDEX}":"
            echo|set /p=%%B", "
        )
    )
    for /f "tokens=1 delims=(" %%A in ('echo %%F') do (
        for /f "tokens=2 delims=:" %%B in ('echo %%A') do (
            set model=%%B
            set model=!model:~0,-1!
            echo|set /p="{#GPUMODEL}":""
            echo|set /p=!model!", "
        )
    )
    for /f "tokens=3 delims=:" %%A in ('echo %%F') do (
        echo|set /p={#GPUUUID}":"
        for /f "tokens=1 delims= " %%B in ('echo %%A') do (
            for /f "tokens=1 delims=)" %%C in ('echo %%B') do (
                echo|set /p=%%C"}
            )
        )
        rem echo|set /p=
    )
)
echo.
echo ]
echo }

ENDLOCAL

