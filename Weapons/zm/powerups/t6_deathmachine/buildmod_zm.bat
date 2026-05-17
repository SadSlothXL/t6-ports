@echo off
set GAME_FOLDER=E:\games\SteamLibrary\steamapps\common\Call of Duty Black Ops II
set OAT_BASE=%cd%
set MOD_BASE=%cd%
"%OAT_BASE%\linker.exe" ^
-v ^
--load "%GAME_FOLDER%\zone\all\zm_prison.ff" ^
--base-folder "%OAT_BASE%" ^
--source-search-path "%MOD_BASE%\zone_source" ^
--output-folder "%MOD_BASE%\zone_out" ^ mod
pause\