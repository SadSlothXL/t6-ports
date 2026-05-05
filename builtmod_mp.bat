@echo off
set OAT_BASE=%cd%
"%OAT_BASE%\linker.exe" ^
-v ^
--output-folder "%OAT_BASE%\zone_out" ^ mod
pause\