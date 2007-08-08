//---------------------------------------------------------------------------
#ifndef mwaQRjpgH
#define mwaQRjpgH
//---------------------------------------------------------------------------
#include <SysUtils.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Forms.hpp>
#include <Qrctrls.hpp>
#include <quickrpt.hpp>
#include <db.hpp>
#include <dbctrls.hpp>
#include "mwajpeg.hpp"

#if __TCPLUSPLUS__ == 0x0520
#define PACKAGE
#pragma link "mwajpeg.obj"
#pragma link "jpeglib.obj"
#endif
//---------------------------------------------------------------------------
class PACKAGE TQRDBJPEGImage : public TQRImage
{
private:
    bool FAutoStretch;
    Mwajpeg::TJPEGFileDecompressor *FJPEGDecompressor;
    System::AnsiString FDataField;
    Db::TDataSet *FDataSet;
    Mwajpeg::TJPEGFileDecompressor* __fastcall GetJPEGDecompressor(void);
    void __fastcall SetDataSet(TDataSet* Value);
protected:
    virtual void __fastcall Print(int OfsX, int OfsY);
public:
    __fastcall TQRDBJPEGImage(TComponent* Owner);
    void __fastcall LoadPicture(void);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation);

__published:
	__property Db::TDataSet* DataSet = {read=FDataSet, write=SetDataSet};
	__property System::AnsiString DataField = {read=FDataField, write=FDataField};
  	__property bool AutoStretch = {read=FAutoStretch, write=FAutoStretch, nodefault};
    __property Mwajpeg::TJPEGFileDecompressor*  JPEGDecompressor = {read=FJPEGDecompressor, write=FJPEGDecompressor};

};
//---------------------------------------------------------------------------
#endif
