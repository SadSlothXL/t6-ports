@echo off
set GAME_FOLDER=E:\games\SteamLibrary\steamapps\common\Call of Duty Black Ops II
set OAT_BASE=E:\COD Modding\t6_oat
set MOD_BASE=%cd%
set MOD_NAME=common_mp
"%OAT_BASE%\linker.exe" ^
-v ^
--base-folder "%OAT_BASE%" ^
--add-asset-search-path "%MOD_BASE%" ^
--source-search-path "%MOD_BASE%\zone_source" ^
--output-folder "%MOD_BASE%\zone_out" ^ mod
pause\