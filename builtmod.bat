@echo off
set OAT_BASE=E:\COD Modding\t6_oat
set MOD_BASE=%cd%
"%OAT_BASE%\linker.exe" ^
-v ^
--output-folder "%MOD_BASE%\zone_out" ^ mod
pause\