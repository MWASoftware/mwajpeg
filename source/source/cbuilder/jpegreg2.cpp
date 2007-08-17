//---------------------------------------------------------------------------
//#define DYNAMIC_DLL
//#define STATIC_LIBRARY
#include <vcl\vcl.h>
#pragma hdrstop

#include <vcl\SysUtils.hpp>
#include <vcl\Controls.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Forms.hpp>
#include <vcl\dialogs.hpp>
#include <vcl\sysutils.hpp>
#include <vcl\DsgnIntf.hpp>
#include <vcl\typinfo.hpp>
#pragma resource "jpeg_reg.dcr"
#include "mwaQRjpg.h"
#include "mwajpeg.hpp"
#include "jpeglib.hpp"
#include "mwadbjpg.hpp"
#include "mwajpgpe.h"
#if __TCPLUSPLUS__ == 0x0520
#define PACKAGE
#pragma link "mwajpeg.obj"
#pragma link "jpeglib.obj"
#pragma link "mwadbjpg.obj"
#pragma link "mwaQRjpg.obj"
#pragma link "mwajpgpe.obj"
#else
#pragma package(smart_init)
#endif
//---------------------------------------------------------------------------
namespace Jpegreg2
{
PTypeInfo AnsiStringTypeInfo(void)
{
  PPTypeInfo Temp;

  Temp = GetPropInfo(__typeinfo(TQRDBJPEGImage), "DataField")->PropType;

  return *Temp;
}

        void __fastcall PACKAGE Register()
        {
           try {
#ifdef DYNAMIC_DLL
                LoadJpegLibrary();
#endif
                TComponentClass classes[1] = {__classid(TJPEGFileCompressor)};
                RegisterComponents("MWA JPEG", classes, 0);
                TComponentClass classes1[1] = {__classid(TJPEGFileDecompressor)};
                RegisterComponents("MWA JPEG", classes1, 0);
                TComponentClass classes2[1] = {__classid(TDBJPEGImage)};
                RegisterComponents("MWA JPEG", classes2, 0);
                TComponentClass classes3[1] = {__classid(TQRDBJPEGImage)};
                RegisterComponents("MWA JPEG", classes3, 0);
                RegisterPropertyEditor(AnsiStringTypeInfo(),__classid(TQRDBJPEGImage),
                  "DataField",__classid(TJPEGDataFieldProperty));
                }
           catch (Exception &ExceptObject)
           {
              Application->MessageBox(ExceptObject.Message.c_str(),"Error",MB_OK);
           }
        }
}
//---------------------------------------------------------------------------
