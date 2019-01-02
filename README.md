# anim.bat
Batch script goes in the ```C:\Program Files\Activision\Call of Duty: Modern Warfare\main``` folder. right click -> edit to customize.

**Usage**: Right click, run as admin and wait for progress bar to be at 100%. launch cod4, open the console and type: `/exec out.cfg`. This has to be done inside an actual private match or while running a demo, once set, you can start the animation using the preferred keybind

`set bindKey=F11`
Sets the keybind to start the animation

`set vString=anim`
Sets the name of the ingame variable string to set (not important, unless you have your own variable strings)

`set output=out.cfg`
Config to write to

`set steps=250`
Amount of steps (step "rate", depending on wait ..; parameter) 

`set wait=2`
Time in ms (relative to game performance) between each step/frame

`set looping=0`
Call first variabe string at the end of the final vstr (making the sequence loop), not recommended as it will not allow you to perform any other in-game actions while looping. ending this loop can only be done using a forced shut down. 
```
set dvar[0]=r_lightTweakSunDirection
set start[0]=-45 0 0
set end[0]=-45 360 0

set dvar[1]=cg_fov
set start[1]=80
set end[1]=65
 ```The dvars above
