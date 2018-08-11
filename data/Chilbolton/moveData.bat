@REM sets the directory to where the bat file is currently located
set myPath=%~dp0
@REM moves recursively all .nc files from zipExtracted/* to the ncReady/ for loading in R
FOR /R "%myPath%/zipExtracted" %%i IN (*.nc) DO MOVE "%%i" "%myPath%/ncReady"