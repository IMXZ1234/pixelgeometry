cd  C:\Users\xz683\Desktop\myproject
REM if exist myproject.obj del myproject.obj
REM if exist myproject.exe del myproject.exe
REM if exist rsrc.res del rsrc.res
REM if exist pixelgraph.obj del pixelgraph.obj
REM if exist pixelgraph.lib del pixelgraph.lib
if exist pixelgraph.dll del pixelgraph.dll
ml /coff /c pixelgraph.asm
if exist pixelgraph.obj link /DLL /DEF:pixelgraph.def pixelgraph.obj
pause
rc rsrc.rc
ml /coff /c pixelgeometry.asm
if exist pixelgeometry.obj link pixelgeometry.obj rsrc.RES
pause
if exist pixelgeometry.exe start pixelgeometry.exe
