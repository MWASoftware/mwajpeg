#
# Borland C++ IDE generated makefile
# Generated 23/04/97 at 15:59:35
#
.AUTODEPEND

#
# Default Paths
#
INCLUDE = c:\BC5\INCLUDE
LIBNAME = c:\BC5\LIB


#
# Borland C++ tools
#
IMPLIB  = Implib
BCC     = Bcc +BccW16.cfg
BCC32   = Bcc32 +BccW32.cfg
BCC32I  = Bcc32i +BccW32.cfg
TLINK   = TLink
TLINK32 = TLink32
TLIB    = TLib
BRC     = Brc
BRC32   = Brc32
TASM    = Tasm
TASM32  = Tasm32
#
# IDE macros
#
#
# External tools
#
Assembler = tasm.exe  # IDE Command Line: $TASM

#
# Options
#
IDE_LinkFLAGS =  -L$(LIBNAME) -C
IDE_LinkFLAGS32 =  -L$(LIBNAME)
IDE_ResFLAGS =
IDE_ResFLAGS32 =
CompLocalOptsAtW16_mwjpegdlib =  -H- -b- -ml -WD
LinkerLocalOptsAtW16_mwjpegdlib =  -f -Twd -c -C -V3.10 -l -k
ResLocalOptsAtW16_mwjpegdlib =
BLocalOptsAtW16_mwjpegdlib =
CompOptsAt_mwjpegdlib = $(CompLocalOptsAtW16_mwjpegdlib)
CompInheritOptsAt_mwjpegdlib = -I$(INCLUDE)
LinkerInheritOptsAt_mwjpegdlib = -x
LinkerOptsAt_mwjpegdlib = $(LinkerLocalOptsAtW16_mwjpegdlib)
ResOptsAt_mwjpegdlib = $(ResLocalOptsAtW16_mwjpegdlib)
BOptsAt_mwjpegdlib = $(BLocalOptsAtW16_mwjpegdlib)
CompLocalOptsAtW32_mwjpeg32dlib =  -WD -K -a- -H- -b-
LinkerLocalOptsAtW32_mwjpeg32dlib =  -Tpd -aa -V4.0 -c
ResLocalOptsAtW32_mwjpeg32dlib =
BLocalOptsAtW32_mwjpeg32dlib =
CompOptsAt_mwjpeg32dlib = $(CompLocalOptsAtW32_mwjpeg32dlib)
CompInheritOptsAt_mwjpeg32dlib = -I$(INCLUDE)
LinkerInheritOptsAt_mwjpeg32dlib = -x
LinkerOptsAt_mwjpeg32dlib = $(LinkerLocalOptsAtW32_mwjpeg32dlib)
ResOptsAt_mwjpeg32dlib = $(ResLocalOptsAtW32_mwjpeg32dlib)
BOptsAt_mwjpeg32dlib = $(BLocalOptsAtW32_mwjpeg32dlib)

#
# Dependency List
#
Dep_mwjpeg = \
   mwjpeg.lib

mwjpeg : BccW16.cfg $(Dep_mwjpeg)
  echo MakeNode

mwjpeg.lib : mwjpeg.dll
  $(IMPLIB) $@ mwjpeg.dll


Dep_mwjpegddll = \
   jmemnobs.obj\
   jquant1.obj\
   jquant2.obj\
   jidctflt.obj\
   jidctint.obj\
   jidctfst.obj\
   jidctred.obj\
   jdapimin.obj\
   jdsample.obj\
   jdpostct.obj\
   jdphuff.obj\
   jdmerge.obj\
   jdmaster.obj\
   jdmarker.obj\
   jdmainct.obj\
   jdinput.obj\
   jdhuff.obj\
   jddctmgr.obj\
   jdcolor.obj\
   jdcoefct.obj\
   jdapistd.obj\
   jdtrans.obj\
   jfdctfst.obj\
   jfdctint.obj\
   jfdctflt.obj\
   jcmainct.obj\
   jcsample.obj\
   jcprepct.obj\
   jcphuff.obj\
   jcparam.obj\
   jcmaster.obj\
   jcmarker.obj\
   jctrans.obj\
   jcinit.obj\
   jccolor.obj\
   jchuff.obj\
   jcdctmgr.obj\
   jccoefct.obj\
   jcapistd.obj\
   jcapimin.obj\
   jmemmgr.obj\
   jerror.obj\
   jutils.obj\
   jcomapi.obj\
   mwjpeg.def\
   mwjpeg.res

mwjpeg.dll : $(Dep_mwjpegddll)
  $(TLINK)   @&&|
  /P /n $(IDE_LinkFLAGS) $(LinkerOptsAt_mwjpegdlib) $(LinkerInheritOptsAt_mwjpegdlib) +
$(LIBNAME)\c0dl.obj+
jmemnobs.obj+
jquant1.obj+
jquant2.obj+
jidctflt.obj+
jidctint.obj+
jidctfst.obj+
jidctred.obj+
jdapimin.obj+
jdsample.obj+
jdpostct.obj+
jdphuff.obj+
jdmerge.obj+
jdmaster.obj+
jdmarker.obj+
jdmainct.obj+
jdinput.obj+
jdhuff.obj+
jddctmgr.obj+
jdcolor.obj+
jdcoefct.obj+
jdapistd.obj+
jdtrans.obj+
jfdctfst.obj+
jfdctint.obj+
jfdctflt.obj+
jcmainct.obj+
jcsample.obj+
jcprepct.obj+
jcphuff.obj+
jcparam.obj+
jcmaster.obj+
jcmarker.obj+
jctrans.obj+
jcinit.obj+
jccolor.obj+
jchuff.obj+
jcdctmgr.obj+
jccoefct.obj+
jcapistd.obj+
jcapimin.obj+
jmemmgr.obj+
jerror.obj+
jutils.obj+
jcomapi.obj
$<,$*
$(LIBNAME)\import.lib+
$(LIBNAME)\mathwl.lib+
$(LIBNAME)\cwl.lib
mwjpeg.def
mwjpeg.res

|
 del *.obj
 del *.res

jmemnobs.obj :  jmemnobs.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jmemnobs.c
|

jquant1.obj :  jquant1.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jquant1.c
|

jquant2.obj :  jquant2.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jquant2.c
|

jidctflt.obj :  jidctflt.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jidctflt.c
|

jidctint.obj :  jidctint.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jidctint.c
|

jidctfst.obj :  jidctfst.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jidctfst.c
|

jidctred.obj :  jidctred.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jidctred.c
|

jdapimin.obj :  jdapimin.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdapimin.c
|

jdsample.obj :  jdsample.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdsample.c
|

jdpostct.obj :  jdpostct.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdpostct.c
|

jdphuff.obj :  jdphuff.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdphuff.c
|

jdmerge.obj :  jdmerge.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdmerge.c
|

jdmaster.obj :  jdmaster.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdmaster.c
|

jdmarker.obj :  jdmarker.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdmarker.c
|

jdmainct.obj :  jdmainct.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdmainct.c
|

jdinput.obj :  jdinput.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdinput.c
|

jdhuff.obj :  jdhuff.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdhuff.c
|

jddctmgr.obj :  jddctmgr.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jddctmgr.c
|

jdcolor.obj :  jdcolor.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdcolor.c
|

jdcoefct.obj :  jdcoefct.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdcoefct.c
|

jdapistd.obj :  jdapistd.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdapistd.c
|

jdtrans.obj :  jdtrans.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jdtrans.c
|

jfdctfst.obj :  jfdctfst.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jfdctfst.c
|

jfdctint.obj :  jfdctint.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jfdctint.c
|

jfdctflt.obj :  jfdctflt.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jfdctflt.c
|

jcmainct.obj :  jcmainct.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcmainct.c
|

jcsample.obj :  jcsample.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcsample.c
|

jcprepct.obj :  jcprepct.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcprepct.c
|

jcphuff.obj :  jcphuff.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcphuff.c
|

jcparam.obj :  jcparam.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcparam.c
|

jcmaster.obj :  jcmaster.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcmaster.c
|

jcmarker.obj :  jcmarker.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcmarker.c
|

jctrans.obj :  jctrans.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jctrans.c
|

jcinit.obj :  jcinit.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcinit.c
|

jccolor.obj :  jccolor.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jccolor.c
|

jchuff.obj :  jchuff.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jchuff.c
|

jcdctmgr.obj :  jcdctmgr.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcdctmgr.c
|

jccoefct.obj :  jccoefct.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jccoefct.c
|

jcapistd.obj :  jcapistd.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcapistd.c
|

jcapimin.obj :  jcapimin.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcapimin.c
|

jmemmgr.obj :  jmemmgr.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jmemmgr.c
|

jerror.obj :  jerror.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jerror.c
|

jutils.obj :  jutils.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jutils.c
|

jcomapi.obj :  jcomapi.c
  $(BCC)   -P- -c @&&|
 $(CompOptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib) -o$@ jcomapi.c
|

mwjpeg.res :  mwjpeg.rc
  $(BRC) -R @&&|
 $(IDE_ResFLAGS) $(ROptsAt_mwjpegdlib) $(CompInheritOptsAt_mwjpegdlib)  -FO$@ mwjpeg.rc
|

# Compiler configuration file
BccW16.cfg : 
   Copy &&|
-w
-R-
-v
-vi
-H
-Og
-a-
-K
-fp
-A-
| $@



