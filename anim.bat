@echo off
setLocal enableDelayedExpansion
set output=anim.cfg
if exist !output! ( del !output! /s /q >nul )
set dvar=r_lightTweakSunDirection
	REM dvar goes here
set "wait=2"
	REM ms to wait between vstr switch
set "bindKey=F11"
set /a "valueStart=180"
set /a "valueEnd=240"
set /a "valueSteps=1"
	REM values and steps go here
set "decEnable=1"
	REM enable or disable decimals
set /a "decStart=0"
set /a "decEnd=99"
set /a "decSteps=23"
	REM batch can't process float values, we're using a loop within a loop to make our own decimals


set /a "vstr=1"
set /a "vstrP=2"
echo bind !bindKey! ^"vstr anim1^" >> "!output!"
for /l %%a in (!valueStart!,!valueSteps!,!valueEnd!) do (
	if not %%a == !valueEnd! (
		if !decEnable! == 1 (	
			for /l %%b in (!decStart!,!decSteps!,!decEnd!) do (
				if %%b gtr 9 ( set "b=%%b" ) else ( set "b=0%%b" )
				echo seta anim!vstr! ^"wait !wait!;!dvar! -50 %%a.!b! 0;vstr anim!vstrP!^" >> "!output!"
				set /a "vstr+=1"
				set /a "vstrP+=1"
			)
		)
		if !decEnable! == 0 (
			set "b=00"
			echo seta anim!vstr! ^"wait !wait!;!dvar! -50 %%a.!b! 0;vstr anim!vstrP!^" >> "!output!"
			set /a "vstr+=1"
			set /a "vstrP+=1"
		)
	) else (
		set "b=00"
		echo seta anim!vstr! ^"wait !wait!;!dvar! -50 %%a.!b! 0;cl_avidemo 0^" >> "!output!"
	)	
)
