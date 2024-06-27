@REM 幫我創建一個C:\Windows\System32\cmd.exe的捷徑並且命名成 Telegram_數字

@REM 並且可以輸入起始數字和結束數字
@REM 例如: 1-10

@REM 這樣就會創建10個捷徑


@echo off

set /p start=請輸入起始數字:
set /p end=請輸入結束數字:

cd D:\Desktop\startup

@REM 更正複製 當前路徑底下的 cmd.lnk 修改成 Telegram_數字.lnk
for /l %%i in (%start%, 1, %end%) do (
    copy D:\Desktop\Startup\cmd.lnk Telegram_%%i.lnk
)