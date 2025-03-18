/*
    This file is part of the MWA JPEG COMPONENT LIBRARY.

    The MWA JPEG COMPONENT LIBRARY is free software: you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The MWA JPEG COMPONENT LIBRARY is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with the MWA JPEG COMPONENT LIBRARY.  If not, see <https://www.gnu.org/licenses/>.
*/
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
