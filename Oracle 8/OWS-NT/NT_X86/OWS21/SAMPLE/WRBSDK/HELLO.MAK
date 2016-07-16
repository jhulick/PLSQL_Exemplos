# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

!IF "$(CFG)" == ""
CFG=Hello - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Hello - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Hello - Win32 Release" && "$(CFG)" != "Hello - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Hello.mak" CFG="Hello - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Hello - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "Hello - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "Hello - Win32 Debug"
RSC=rc.exe
MTL=mktyplib.exe
CPP=cl.exe

!IF  "$(CFG)" == "Hello - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ".\"
# PROP Intermediate_Dir ".\"
# PROP Target_Dir ""
OUTDIR=.\.
INTDIR=.\.

ALL : "$(OUTDIR)\HelloWorld.dll"

CLEAN : 
	-@erase ".\HelloWorld.dll"
	-@erase ".\WRBDLL.OBJ"
	-@erase ".\HELLOWORLD.OBJ"
	-@erase ".\HelloWorld.lib"
	-@erase ".\HelloWorld.exp"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MD /W3 /GX /O2 /I "..\..\wrbsdk\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "WIN_NT" /YX /c
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\wrbsdk\inc" /D "WIN32" /D "NDEBUG"\
 /D "_WINDOWS" /D "WIN_NT" /Fp"$(INTDIR)/Hello.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\.\ 
CPP_SBRS=
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Hello.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 ..\..\wrbsdk\lib\wrb.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386 /out:"HelloWorld.dll"
LINK32_FLAGS=..\..\wrbsdk\lib\wrb.lib kernel32.lib user32.lib gdi32.lib\
 winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib\
 uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll\
 /incremental:no /pdb:"$(OUTDIR)/HelloWorld.pdb" /machine:I386\
 /out:"$(OUTDIR)/HelloWorld.dll" /implib:"$(OUTDIR)/HelloWorld.lib" 
LINK32_OBJS= \
	"$(INTDIR)/WRBDLL.OBJ" \
	"$(INTDIR)/HELLOWORLD.OBJ"

"$(OUTDIR)\HelloWorld.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Hello - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\HelloWorld.dll"

CLEAN : 
	-@erase ".\Debug\vc40.pdb"
	-@erase ".\Debug\vc40.idb"
	-@erase ".\HelloWorld.dll"
	-@erase ".\Debug\WRBDLL.OBJ"
	-@erase ".\Debug\HELLOWORLD.OBJ"
	-@erase ".\HelloWorld.ilk"
	-@erase ".\Debug\HelloWorld.lib"
	-@erase ".\Debug\HelloWorld.exp"
	-@erase ".\Debug\HelloWorld.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /I "..\..\wrbsdk\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "WIN_NT" /YX /c
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /Zi /Od /I "..\..\wrbsdk\inc" /D "WIN32" /D\
 "_DEBUG" /D "_WINDOWS" /D "WIN_NT" /Fp"$(INTDIR)/Hello.pch" /YX /Fo"$(INTDIR)/"\
 /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Hello.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386
# ADD LINK32 ..\..\wrbsdk\lib\wrb.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /out:"HelloWorld.dll"
LINK32_FLAGS=..\..\wrbsdk\lib\wrb.lib kernel32.lib user32.lib gdi32.lib\
 winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib\
 uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll\
 /incremental:yes /pdb:"$(OUTDIR)/HelloWorld.pdb" /debug /machine:I386\
 /out:"HelloWorld.dll" /implib:"$(OUTDIR)/HelloWorld.lib" 
LINK32_OBJS= \
	"$(INTDIR)/WRBDLL.OBJ" \
	"$(INTDIR)/HELLOWORLD.OBJ"

"$(OUTDIR)\HelloWorld.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "Hello - Win32 Release"
# Name "Hello - Win32 Debug"

!IF  "$(CFG)" == "Hello - Win32 Release"

!ELSEIF  "$(CFG)" == "Hello - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\HELLOWORLD.C

!IF  "$(CFG)" == "Hello - Win32 Release"

DEP_CPP_HELLO=\
	".\oratypes.h"\
	{$(INCLUDE)}"\sys\TYPES.H"\
	".\wrb.h"\
	

"$(INTDIR)\HELLOWORLD.OBJ" : $(SOURCE) $(DEP_CPP_HELLO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Hello - Win32 Debug"

DEP_CPP_HELLO=\
	".\..\..\wrbsdk\inc\oratypes.h"\
	".\..\..\wrbsdk\inc\wrb.h"\
	{$(INCLUDE)}"\sys\TYPES.H"\
	

"$(INTDIR)\HELLOWORLD.OBJ" : $(SOURCE) $(DEP_CPP_HELLO) "$(INTDIR)"


!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\WRBDLL.C

"$(INTDIR)\WRBDLL.OBJ" : $(SOURCE) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
