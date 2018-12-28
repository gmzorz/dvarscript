@echo off
setLocal enableDelayedExpansion

REM STILL IN BETA, WILL WORK SOON

	set dvar[0]=cg_fov
	set start[0]=65
	set end[0]=80

	set dvar[1]=r_lightTweakSunDirection
	set start[1]=100 200 50
	set end[1]=240 100 10

set steps=5
set wait=2
set output=out.cfg

:calc
if exist *.start del *.start /s /q >nul
if exist *.end del *.end /s /q >nul
if exist *.clc del *.clc /s /q >nul
if exist *.flt del *.flt /s /q >nul
set /a "count=0" & echo >> "!count!.clc"
for /f "tokens=2 delims==" %%a in ('set dvar[') do (
	for %%b in (*.clc) do (
		for %%c in (!start[%%~nb]!) do ( 
			set /a sn=%%c*100
			echo | set /p=!sn! >> start.txt
		)
		for %%c in (!end[%%~nb]!) do ( 
			set /a en=%%c*100
			echo | set /p=!en! >> end.txt
		)
		if exist start.txt (
			for /f "tokens=*" %%d in (start.txt) do set "start[%%~nb]=%%d" 2>nul
			for /f "tokens=*" %%d in (end.txt) do set "end[%%~nb]=%%d" 2>nul
			del *.txt /s /q >nul
		)
		set /a "floatVal=1"
		for %%c in (!start[%%~nb]!) do ( 
			echo | set /p=%%c >> "!floatVal!.start"
			set /a "floatVal+=1"
		)
		set /a "floatVal=1"
		for %%c in (!end[%%~nb]!) do ( 
			echo | set /p=%%c >> "!floatVal!.end"
			set /a "floatVal+=1"
		)
		set /a "floatVal-=1"
		for /l %%c in (1,1,!floatVal!) do (
			for /f "tokens=*" %%d in (%%c.start) do set /a "s_%%c=%%d"
			for /f "tokens=*" %%d in (%%c.end) do set /a "e_%%c=%%d"
			set /a "addTo_%%a_%%c=((!e_%%c!-!s_%%c!)/!steps!)"
		)
		del *.start
		del *.end
	)
	del *.clc /s /q >nul
	set /a "count+=1" & echo >> !count!.clc"
)


REM			CURRENT				TYPE
REM ----------------------------------
REM %%a   =	step				INT
REM %%b   =	dvar name			STRING
REM %%c   =	dvar count			INT
REM %%d   =	token in var		STRING
REM %%e   =	tokens in txt		STRING
REM %%~nf =	number of tokens	INT
REM ----------------------------------

:l_
set /a "vstr=1"
set /a "vstrP=2"
for /l %%a in (1,1,!steps!) do (
	if exist *.tmp del *.tmp /s /q >nul	
	set /a "count=0" & echo >> "!count!.tmp"
	for /f "tokens=2 delims==" %%b in ('set dvar[') do (
		if exist *.txt del *.txt /s /q >nul
		for %%c in (*.tmp) do (
		set /a "floatVal=1"
		set /a "floatVal=1" & echo >> !floatVal!.flt
			for %%d in (!start[%%~nc]!) do (
				for %%f in (*.flt) do (
					del *.flt /s /q >nul
					set /a "newValue=(%%d+!addTo_%%b_%%~nf!)"
					set valOut=!newValue: =!
					set valOut_=!valOut:~0,-2!.!valOut:~-2!
					echo !valOut_!
					echo | set /p=!valOut! >> d.txt
					rem echo !newValue!
				)
				set /a "floatVal+=1" & echo >> !floatVal!.flt
			)
			for /f "tokens=*" %%e in (d.txt) do set "start[%%~nc]=%%e"
			if exist *.txt del *.txt /s /q >nul
			echo seta anim!vstr! ^"wait !wait!;%%b !start[%%~nc]!;vstr anim!vstrP!^" >> "!output!"
			set /a "vstr+=1"
			set /a "vstrP+=1"
			rem echo !dvar[%%~nc]! !start[%%~nc]!
		)
		if exist *.tmp del *.tmp /s /q >nul	
		set /a "count+=1" & echo >> "!count!.tmp"		
	)
)
pause
