@REM ���ڳЫؤ@��C:\Windows\System32\cmd.exe�����|�åB�R�W�� Telegram_�Ʀr

@REM �åB�i�H��J�_�l�Ʀr�M�����Ʀr
@REM �Ҧp: 1-10

@REM �o�˴N�|�Ы�10�ӱ��|


@echo off

set /p start=�п�J�_�l�Ʀr:
set /p end=�п�J�����Ʀr:

cd D:\Desktop\startup

@REM �󥿽ƻs ��e���|���U�� cmd.lnk �ק令 Telegram_�Ʀr.lnk
for /l %%i in (%start%, 1, %end%) do (
    copy D:\Desktop\Startup\cmd.lnk Telegram_%%i.lnk
)