//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#if __TCPLUSPLUS__ < 0x0570
#define QREPORT2
#endif
#include <vcl\SysUtils.hpp>
#include <vcl\Controls.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Forms.hpp>
#include <vcl\dialogs.hpp>
#include <vcl\sysutils.hpp>
#if __TCPLUSPLUS__ >= 0x0560
#include <vcl\DesignEditors.HPP>
#include <vcl\DesignIntf.hpp>
#else
#include <vcl\DsgnIntf.hpp>
#endif
#ifdef QREPORT2
#if __TCPLUSPLUS__ == 0x0520
#include "mwaQRjpg.hpp"
#else
#include "mwaQRjpg.h"
#endif
#include "mwajpgpe.h"
#endif
#include "mwajpeg.hpp"
#include "jpeglib.hpp"
#include "mwadbjpg.hpp"
#include <vcl\typinfo.hpp>
#pragma resource "common\\jpeg_reg.dcr"
#if __TCPLUSPLUS__ == 0x0520
#define PACKAGE
#pragma link "mwajpeg.obj"
#pragma link "jpeglib.obj"
#pragma link "mwadbjpg.obj"
#pragma link "mwajpgpe.obj"
#ifdef QREPORT2
#pragma link "mwaQRjpg.obj"
#endif
#else
#pragma package(smart_init)
#endif
//---------------------------------------------------------------------------
namespace Jpeg_reg
{
#ifdef QREPORT2
PTypeInfo AnsiStringTypeInfo(void)
{
  PPTypeInfo Temp;

  Temp = GetPropInfo(__typeinfo(TQRDBJPEGImage), "DataField")->PropType;

  return *Temp;
}
#endif
//---------------------------------------------------------------------------
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
#ifdef QREPORT2
                TComponentClass classes3[1] = {__classid(TQRDBJPEGImage)};
                RegisterPropertyEditor(AnsiStringTypeInfo(),__classid(TQRDBJPEGImage),
                  "DataField",__classid(TJPEGDataFieldProperty));
                RegisterComponents("MWA JPEG", classes3, 0);
#endif
                }
           catch (Exception &ExceptObject)
           {
              Application->MessageBox(ExceptObject.Message.c_str(),"Error",MB_OK);
           }
        }
}
//---------------------------------------------------------------------------
