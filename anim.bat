@echo off
setLocal enableDelayedExpansion

REM improved script generator
REM unfortunately does not support decimals on input... but does smoothe out the path as much as possible

set bindKey=F11
set vString=anim
set output=out.cfg

	set dvar[0]=r_lightTweakSunDirection
	set start[0]=30 240 0
	set end[0]=-89 240 0
	
	set dvar[1]=r_lightTweakSunLight
	set start[1]=0
	set end[1]=2

set steps=500
	REM no more than 9999 steps
set wait=1


set /a "numDvars=-1" & for /f "tokens=2 delims==" %%a in ('set dvar[') do ( set /a "numDvars+=1" )
for /l %%a in (0,1,!numDvars!) do (
	set endLine=!endLine!!dvar[%%a]! !start[%%a]!;
)
set endLine=!endLine!^"
set /a "prcnt=!steps!/50"
set bar=^|
set /a "l=0"
set /a "numv=0"
if exist !output! del !output! /s /q >nul
echo bind !bindKey! ^"vstr !vString!1^" >> "!output!"
if exist *.start del *.start /s /q >nul
if exist *.end del *.end /s /q >nul
if exist *.clc del *.clc /s /q >nul
if exist *.flt del *.flt /s /q >nul
if exist *.tmp del *.tmp /s /q >nul
set /a "count=0" & echo >> "!count!.clc"
for /f "tokens=2 delims==" %%a in ('set dvar[') do (
	for %%b in (*.clc) do (
		for %%c in (!start[%%~nb]!) do ( 
			if not %%c == 0 ( set /a sn=%%c*10000 ) else ( set /a "sn=1" )
			echo | set /p=!sn! >> start.txt
		)
		for %%c in (!end[%%~nb]!) do ( 
			if not %%c == 0 ( set /a en=%%c*10000 ) else ( set /a "en=1" )
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
del *.clc /s /q >nul

REM			CURRENT				TYPE
REM ----------------------------------
REM %%a   =	step				INT
REM %%b   =	dvar name			STRING
REM %%c   =	dvar count			INT
REM %%d   =	token in var		STRING
REM %%e   =	tokens in txt		STRING
REM %%~nf =	number of tokens	INT
REM ----------------------------------
set /a "vstr=1"
set /a "vstrP=2"
for /l %%a in (1,1,!steps!) do (
	if exist *.tmp del *.tmp /s /q >nul	
	set /a "count=0" & echo >> "!count!.tmp"
	set curStr=seta !vString!!vstr! ^"wait !wait!;
	for /f "tokens=2 delims==" %%b in ('set dvar[') do (
		if exist *.txt del *.txt /s /q >nul
		for %%c in (*.tmp) do (
		set /a "floatVal=1"
		set /a "floatVal=1" & echo >> !floatVal!.flt
			for %%d in (!start[%%~nc]!) do (
				for %%f in (*.flt) do (
					del *.flt /s /q >nul
					set /a "newValue=(%%d+!addTo_%%b_%%~nf!)" 2>nul
					set valOut=!newValue: =!
					set valOut_=!valOut:~0,-4!.!valOut:~-4!
					if !newValue! lss 10000 ( 
						if !newValue! gtr 999 ( set "valOut_=0.!valOut:~-5!" )
					)
					if !newValue! lss 1000 ( 
						if !newValue! gtr 99 ( set "valOut_=0.0!valOut:~-4!" )
					)
					if !newValue! lss 100 ( 
						if !newValue! gtr 9 ( set "valOut_=0.00!valOut:~-3!" )
					)
					if !newValue! lss 10 (
						if !newValue! gtr 0 ( set "valOut_=0.000!valOut:~-2!" )
						if !newValue! gtr -10000 ( set "valOut_=!valOut:~0,-4!0.!valOut:~-4!" )
						if !newValue! gtr -1000 ( set "valOut_=!valOut:~0,-3!0.0!valOut:~-3!" )
						if !newValue! gtr -100 ( set "valOut_=!valOut:~0,-2!0.00!valOut:~-2!" )
						if !newValue! gtr -10 ( set "valOut_=!valOut:~0,-1!0.00!valOut:~-1!" )
					)
					echo | set /p=!valOut_! >> d.txt 
					echo | set /p=!valOut! >> d2.txt 
				)
				set /a "floatVal+=1" & echo >> !floatVal!.flt
			)
			for /f "tokens=*" %%e in (d.txt) do set "start_[%%~nc]=%%e"
			
			for /f "tokens=*" %%e in (d2.txt) do set "start[%%~nc]=%%e"
			if exist d.txt del d.txt /s /q >nul
			if exist d2.txt del d2.txt /s /q >nul
			set start_[%%~nc]=!start_[%%~nc]:  = !
			set start_[%%~nc]=!start_[%%~nc]:~0,-1!
			set curStr=!curStr!%%b !start_[%%~nc]!;
		)
		del *.flt /s /s >nul
		if exist *.tmp del *.tmp /s /q >nul	
		set /a "count+=1" & echo >> "!count!.tmp"
	)
	set curStr=!curStr!vstr !vString!!vstrP!^"
	echo !curStr! >> "!output!"
	set /a "vstr+=1"
	set /a "vstrP+=1"
	
	if !l! LEQ !prcnt! (
		set /a l+=1
	) 
	if !l! GTR !prcnt! (
		set "bar=!bar!-"
		set /a "numv+=2"
		set /a l=1
		cls
		echo.
		echo.
		echo                              .RrRrR.     .M_Mm mM_M. 
		echo                             .Rr*R*rR.   .Mm~M*m*M~mM. 
		echo                             R*R   R*R   M*m  M*M  M*M 
		echo                             R*R   R*R   M*M  M*M  M*M 
		echo                             R*R   R*R   M*M  M*M  M*M 
		echo                             R*R   R*R   M*M  M*M  M*M 
		echo                             R*R         M*M       M*M 
		echo                             R*R         M*M       M*M 
		echo                             R*R         M*M       M*M 
		echo                             R*R         M*M       M*M 
		echo                             R*R         M*M       M*M 
		echo                             R*R         M*M       M*M 
		echo. 
		echo. 
		echo                !bar!
		echo                !numv!%%
		echo. 
	)	
)
cls
echo.
echo.
echo                              .RrRrR.     .M_Mm mM_M. 
echo                             .Rr*R*rR.   .Mm~M*m*M~mM. 
echo                             R*R   R*R   M*m  M*M  M*M 
echo                             R*R   R*R   M*M  M*M  M*M 
echo                             R*R   R*R   M*M  M*M  M*M 
echo                             R*R   R*R   M*M  M*M  M*M 
echo                             R*R         M*M       M*M 
echo                             R*R         M*M       M*M 
echo                             R*R         M*M       M*M 
echo                             R*R         M*M       M*M 
echo                             R*R         M*M       M*M 
echo                             R*R         M*M       M*M 
echo. 
echo. 
echo                !bar!^|
echo                100%%
echo. 
set endLine=seta !vString!!vstr! ^"wait !wait!;!endLine!
echo !endLine! >> "!output!"
echo	Finished writing to !output!
pause >nul
