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
LinkerLocalOptsAtW16_mwjpegdlib =  -f -Twd -c -C
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
   mwjpeg32.lib

mwjpeg : BccW32.cfg $(Dep_mwjpeg)
  echo MakeNode


mwjpeg32.lib : mwjpeg32.dll
  $(IMPLIB) $@ mwjpeg32.dll


Dep_mwjpeg32ddll = \
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
   mwjpeg32.def\
   mwjpeg32.res

mwjpeg32.dll : $(Dep_mwjpeg32ddll)
  $(TLINK32) @&&|
  $(IDE_LinkFLAGS32) $(LinkerOptsAt_mwjpeg32dlib) $(LinkerInheritOptsAt_mwjpeg32dlib) +
$(LIBNAME)\c0d32.obj+
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
$(LIBNAME)\import32.lib+
$(LIBNAME)\cw32.lib
mwjpeg32.def
mwjpeg32.res

|
 del *.obj
 del *.res

jmemnobs.obj :  jmemnobs.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jmemnobs.c
|

jquant1.obj :  jquant1.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jquant1.c
|

jquant2.obj :  jquant2.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jquant2.c
|

jidctflt.obj :  jidctflt.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jidctflt.c
|

jidctint.obj :  jidctint.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jidctint.c
|

jidctfst.obj :  jidctfst.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jidctfst.c
|

jidctred.obj :  jidctred.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jidctred.c
|

jdapimin.obj :  jdapimin.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdapimin.c
|

jdsample.obj :  jdsample.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdsample.c
|

jdpostct.obj :  jdpostct.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdpostct.c
|

jdphuff.obj :  jdphuff.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdphuff.c
|

jdmerge.obj :  jdmerge.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdmerge.c
|

jdmaster.obj :  jdmaster.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdmaster.c
|

jdmarker.obj :  jdmarker.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdmarker.c
|

jdmainct.obj :  jdmainct.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdmainct.c
|

jdinput.obj :  jdinput.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdinput.c
|

jdhuff.obj :  jdhuff.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdhuff.c
|

jddctmgr.obj :  jddctmgr.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jddctmgr.c
|

jdcolor.obj :  jdcolor.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdcolor.c
|

jdcoefct.obj :  jdcoefct.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdcoefct.c
|

jdapistd.obj :  jdapistd.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdapistd.c
|

jdtrans.obj :  jdtrans.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jdtrans.c
|

jfdctfst.obj :  jfdctfst.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jfdctfst.c
|

jfdctint.obj :  jfdctint.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jfdctint.c
|

jfdctflt.obj :  jfdctflt.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jfdctflt.c
|

jcmainct.obj :  jcmainct.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcmainct.c
|

jcsample.obj :  jcsample.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcsample.c
|

jcprepct.obj :  jcprepct.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcprepct.c
|

jcphuff.obj :  jcphuff.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcphuff.c
|

jcparam.obj :  jcparam.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcparam.c
|

jcmaster.obj :  jcmaster.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcmaster.c
|

jcmarker.obj :  jcmarker.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcmarker.c
|

jctrans.obj :  jctrans.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jctrans.c
|

jcinit.obj :  jcinit.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcinit.c
|

jccolor.obj :  jccolor.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jccolor.c
|

jchuff.obj :  jchuff.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jchuff.c
|

jcdctmgr.obj :  jcdctmgr.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcdctmgr.c
|

jccoefct.obj :  jccoefct.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jccoefct.c
|

jcapistd.obj :  jcapistd.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcapistd.c
|

jcapimin.obj :  jcapimin.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcapimin.c
|

jmemmgr.obj :  jmemmgr.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jmemmgr.c
|

jerror.obj :  jerror.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jerror.c
|

jutils.obj :  jutils.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jutils.c
|

jcomapi.obj :  jcomapi.c
  $(BCC32) -P- -c @&&|
 $(CompOptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib) -o$@ jcomapi.c
|

mwjpeg32.res :  mwjpeg32.rc
  $(BRC32) -R @&&|
 $(IDE_ResFLAGS32) $(ROptsAt_mwjpeg32dlib) $(CompInheritOptsAt_mwjpeg32dlib)  -FO$@ mwjpeg32.rc
|

# Compiler configuration file
BccW32.cfg :
   Copy &&|
-w
-R
-v
-vi
-H
-Og
-K
-fp
-A-
| $@

