@echo off
:: Made by Rihards Mantejs
:: Works on Fujitsu E420d
:: Other MoBo's etc could need a different WMIC call.
:: PLEASE SET MAX TEMP
set maxtemp=25

:: Please set Recipients
set to=rmantejs@therange.co.uk

:: Please set From
set from=RFCFS@HIGH-TEMP-ALERT

:: Please set subject
set subject=RFCFS OVERHEAT WARNING

:: Set SMTP server now outlook.therange.local
set smtp=172.15.10.224


for /f "delims== tokens=2" %%a in (
    'wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature /value'
) do (
    set /a degrees_celsius=%%a / 10 - 273
)

:: This is here because the TEMP is set to VAR only after the above lines.
:: Please set body
set body=RFCFS - Heat %degrees_celsius% C

if %degrees_celsius% geq %threshold% goto sendmail

:sendmail
powershell.exe -command " & {Send-MailMessage -SMTPServer %smtp% -To '%to%' -From '%from%' -Subject '%subject%' -Body '%body%'}
goto END

:END
exit;