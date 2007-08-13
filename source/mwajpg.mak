# ---------------------------------------------------------------------------
!if !$d(BCB)
BCB = $(MAKEDIR)\..
!endif

# ---------------------------------------------------------------------------
# IDE SECTION
# ---------------------------------------------------------------------------
# The following section of the project makefile is managed by the BCB IDE.
# It is recommended to use the IDE to change any of the values in this
# section.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
PROJECT = .\mwajpg.bpl
!if $d(RUNTIME)
OBJFILES = mwajpeg.obj  mwadbjpg.obj mwajpg.obj jpeglib.obj
!else
OBJFILES = mwajpeg.obj  mwadbjpg.obj mwajpg.obj jpeg_reg.obj\
    jpeglib.obj mwajpgpe.obj mwaQRjpg.obj 
!endif
RESFILES = mwajpg.res
MAINSOURCE = mwajpg.cpp
RESDEPEN = $(RESFILES)
LIBFILES = 
IDLFILES = 
IDLGENFILES = 
!if $d(B6)
VERSION = BCB.06.00
LIBRARIES = dclocx.lib nmfast.lib tee.lib teedb.lib teeui.lib vcldbx.lib ibsmp.lib 
PACKAGES = rtl.bpi vcl.bpi qrpt.bpi vclx.bpi bcbsmp.bpi dbrtl.bpi vcldb.bpi \
    bdertl.bpi designide.bpi
SPARELIBS = rtl.lib vcl.lib vclx.lib vcljpg.lib bcbsmp.lib qrpt.lib dbrtl.lib \
    vcldb.lib bdertl.lib ibsmp.lib vcldbx.lib teeui.lib teedb.lib tee.lib \
    nmfast.lib dclocx.lib
!elif $d(B5)
VERSION = BCB.05.03
LIBRARIES = dclocx50.lib nmfast50.lib tee50.lib teedb50.lib teeui50.lib vcldbx50.lib \
    ibsmp50.lib vcljpg50.lib
PACKAGES = vcl50.bpi qrpt50.bpi vclx50.bpi bcbsmp50.bpi vcldb50.bpi vclbde50.bpi \
    dsnide50.bpi
SPARELIBS = vcl50.lib vclx50.lib vcljpg50.lib bcbsmp50.lib qrpt50.lib vcldb50.lib \
    vclbde50.lib ibsmp50.lib vcldbx50.lib teeui50.lib teedb50.lib tee50.lib \
    nmfast50.lib dclocx50.lib
!elif $d(B4)
VERSION = BCB.04.04
LIBRARIES = dclocx40.lib nmfast40.lib tee40.lib teedb40.lib teeui40.lib vcldbx40.lib \
  ibsmp40.lib vcljpg40.lib
SPARELIBS =  Vcl40.lib vclx40.lib vcljpg40.lib bcbsmp40.lib qrpt40.lib vcldb40.lib \
  ibsmp40.lib vcldbx40.lib teeui40.lib teedb40.lib tee40.lib nmfast40.lib \
  dclocx40.lib
PACKAGES = vcl40.bpi dbx40.bpi qrpt40.bpi Vclx40.bpi bcbsmp40.bpi Vcldb40.bpi
!elif $d(B3)
VERSION = BCB.03
LIBRARIES =
SPARELIBS = VCL35.lib vcldb35.lib Qrpt35.lib vclx35.lib
PACKAGES = vcl35.bpi vcldb35.bpi qrpt35.bpi vclx35.bpi
!endif
DEFFILE = 
OTHERFILES = 
# ---------------------------------------------------------------------------
DEBUGLIBPATH = $(BCB)\lib\debug
RELEASELIBPATH = $(BCB)\lib\release
USERDEFINES = 
SYSDEFINES = _RTLDLL;NO_STRICT;USEPACKAGES
INCLUDEPATH = $(UNITDIR);source;source\cbuilder;.;$(BCB)\include;$(BCB)\include\vcl
LIBPATH = $(UNITDIR);$(BCB)\Lib;$(BCB)\lib\obj;$(RESPATH);$(BCB)\lib\release;source
WARNINGS= -w-par -w-8027 -w-8026
PATHCPP = .;source\cbuilder
PATHASM = .;
PATHPAS = .;source
PATHRC = .;
PATHOBJ = .;$(LIBPATH)
# ---------------------------------------------------------------------------
!if $d(B6)
CFLAG1 = -Od -H=$(BCB)\lib\vcl60.csm -Hc -Vx -Ve -X- -r- -a8 -b- -k -y -v -vi- \
    -c -tWM -n$(UNITDIR)
PFLAGS = -$YD -$W -$O- -$A8 -v -JPHNE -M -D$(PDEFS);$(DLLSTATE);CBUILDER5 -OObj -U$(UNITDIR) -N0$(UNITDIR) -NO. -NH$(UNITDIR)
!elif $d(B5)
CFLAG1 = -Od -H=$(BCB)\lib\vcl50.csm -Hc -Vx -Ve -X- -r- -a8 -b- -k -y -v -vi- \
    -c -tWM -n$(UNITDIR)
PFLAGS = -$YD -$W -$O- -$A8 -v -JPHNE -M -D$(PDEFS);$(DLLSTATE);CBUILDER5 -OObj -U$(UNITDIR) -N0$(UNITDIR) -NO. -NH$(UNITDIR)
!elif $d(B4)
CFLAG1 = -I.;$(BCB)\include;$(BCB)\include\vcl -Od -Hc -H=$(BCB)\lib\vcl40.csm \
  -w -Ve -r- -a8 -k -y -v -vi- -c -b- -w-par -w-inl -Vx -tWM \
  -D$(SYSDEFINES);$(USERDEFINES)
PFLAGS = -U$(BCB)\Lib;$(BCB)\lib\obj;$(RESPATH);$(RELEASELIBPATH) \
  -D$(PDEFS);$(DLLSTATE) -I$(BCB)\include;$(BCB)\include\vcl -$YD -$W -$O- -OObj -v -JPHNE -M -U$(UNITDIR) -N$(UNITDIR)
!elif $d(B3)
CFLAG1 = -Od -Hc -w -Ve -r- -k -y -v -vi- -c -b- -w-par -w-inl -Vx \
  -D_RTLDLL;USEPACKAGES -I.;$(BCB)\include;$(BCB)\include\vcl \
  -H=$(BCB)\lib\vcl35.csm -Tkh30000
PFLAGS = -D_RTLDLL;USEPACKAGES;$(PDEFS);$(DLLSTATE) -U$(BCB)\lib\obj;$(BCB)\lib;$(RELEASELIBPATH) \
  -I.;$(BCB)\include;$(BCB)\include\vcl -$Y -$W -v -JPHN -M -R$(RESPATH) -OObj -U$(UNITDIR) -N$(UNITDIR)
!endif
IDLCFLAGS = 
RFLAGS = 
AFLAGS = /mx /w2 /zd
!if $d(B3) || $d(B4)
!if $d(RUNTIME)
LFLAGS = -L$(BCB)\lib\obj;$(BCB)\lib;$(RELEASELIBPATH);$(RESPATH) -D"MWA JPEG Component Library" \
  -aa -Tpp -Gpr -x -Gn -Gl -Gi -v
!else
LFLAGS = -L$(BCB)\lib\obj;$(BCB)\lib;$(RELEASELIBPATH);$(RESPATH) -D"MWA JPEG Component Library" \
  -aa -Tpp -Gpd -x -Gn -Gl -Gi -v
!endif
!else
!if $d(RUNTIME)
LFLAGS = -l. -D"MWA JPEG Component Library" -aa -Tpp -Gpr -x -Gn -Gl -Gi -v
!else
LFLAGS = -l. -D"MWA JPEG Component Library" -aa -Tpp -Gpd -x -Gn -Gl -Gi -v
!endif
!endif
# ---------------------------------------------------------------------------
ALLOBJ = c0pkg32.obj $(PACKAGES) Memmgr.Lib sysinit.obj $(OBJFILES)
ALLRES = $(RESFILES)
ALLLIB = $(LIBFILES) $(LIBRARIES) import32.lib cp32mti.lib
# ---------------------------------------------------------------------------
!ifdef IDEOPTIONS

[Version Info]
IncludeVerInfo=0
AutoIncBuild=0
MajorVer=1
MinorVer=10
Release=0
Build=0
Debug=0
PreRelease=0
Special=0
Private=0
DLL=0

[Version Info Keys]
CompanyName=
FileDescription=
FileVersion=1.10.0.0
InternalName=
LegalCopyright=
LegalTrademarks=
OriginalFilename=
ProductName=
ProductVersion=1.10.0.0
Comments=

[Debugging]
DebugSourceDirs=$(BCB)\source\vcl

!endif





# ---------------------------------------------------------------------------
# MAKE SECTION
# ---------------------------------------------------------------------------
# This section of the project file is not used by the BCB IDE.  It is for
# the benefit of building from the command-line using the MAKE utility.
# ---------------------------------------------------------------------------

.autodepend
# ---------------------------------------------------------------------------
!if "$(USERDEFINES)" != ""
AUSERDEFINES = -d$(USERDEFINES:;= -d)
!else
AUSERDEFINES =
!endif

!if !$d(BCC32)
BCC32 = bcc32
!endif

!if !$d(CPP32)
CPP32 = cpp32
!endif

!if !$d(DCC32)
DCC32 = dcc32
!endif

!if !$d(TASM32)
TASM32 = tasm32
!endif

!if !$d(LINKER)
LINKER = ilink32
!endif

!if !$d(BRCC32)
BRCC32 = brcc32
!endif


# ---------------------------------------------------------------------------
!if $d(PATHCPP)
.PATH.CPP = $(PATHCPP)
.PATH.C   = $(PATHCPP)
!endif

!if $d(PATHPAS)
.PATH.PAS = $(PATHPAS)
!endif

!if $d(PATHASM)
.PATH.ASM = $(PATHASM)
!endif

!if $d(PATHRC)
.PATH.RC  = $(PATHRC)
!endif

!if $d(PATHOBJ)
.PATH.OBJ  = $(PATHOBJ)
!endif
# ---------------------------------------------------------------------------
$(PROJECT): $(OTHERFILES) $(IDLGENFILES) $(OBJFILES) $(RESDEPEN) $(DEFFILE)
    $(BCB)\BIN\$(LINKER) @&&!
    $(LFLAGS) -L$(LIBPATH) +
    $(ALLOBJ), +
    $(PROJECT),, +
    $(ALLLIB), +
    $(DEFFILE), +
    $(ALLRES)
!
# ---------------------------------------------------------------------------
.pas.hpp:
    $(BCB)\BIN\$(DCC32) $(PFLAGS) -U$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -O$(INCLUDEPATH) --BCB {$< }

.pas.obj:
    $(BCB)\BIN\$(DCC32) $(PFLAGS) -U$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -O$(INCLUDEPATH) --BCB {$< }

.cpp.obj:
    $(BCB)\BIN\$(BCC32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n$(@D) {$< }

.c.obj:
    $(BCB)\BIN\$(BCC32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n$(@D) {$< }

.c.i:
    $(BCB)\BIN\$(CPP32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n. {$< }

.cpp.i:
    $(BCB)\BIN\$(CPP32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n. {$< }

.asm.obj:
    $(BCB)\BIN\$(TASM32) $(AFLAGS) -i$(INCLUDEPATH:;= -i) $(AUSERDEFINES) -d$(SYSDEFINES:;= -d) $<, $@

.rc.res:
    $(BCB)\BIN\$(BRCC32) $(RFLAGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -fo$@ $<



# ---------------------------------------------------------------------------




