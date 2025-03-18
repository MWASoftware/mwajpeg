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
/*-------------------------------------------------------------------------------------*/
/*                                                                                     */
/*               Unit: MWAQRJPG                                                        */
/*                                                                                     */
/*               Copyright McCallum Whyman Associates Ltd 1998,99                      */
/*                                                                                     */
/*               Version 1.8                                                           */
/*                                                                                     */
/*               Author: Tony Whyman                                                   */
/*                                                                                     */
/*               Description: This unit provides a component to permit a JPEG image    */
/*                            held in a database blob field to be printed using        */
/*                            Quick Reports 2                                          */
/*-------------------------------------------------------------------------------------*/

//14/4/00 Condition defines changed for use with C++Builder 1

// 4/5/99 Use of TBlobStream changed to more generic CreateBlobStream

//---------------------------------------------------------------------------
#include <vcl.h>
#include <vcl/dbtables.hpp>
#pragma hdrstop

#include "mwaQRjpg.h"
#pragma link "qrctrls"
#pragma link "dbctrls"
#pragma link "db"
#if __TCPLUSPLUS__ > 0x0520
#pragma package(smart_init)
#endif
//---------------------------------------------------------------------------
// ValidCtrCheck is used to assure that the components created do not have
// any pure virtual functions.
//

static TJPEGFileDecompressor*  DefaultJPEGDecompressor  = NULL;

#define  sNotBlobField  "%s is not a Blob Field"

static inline void ValidCtrCheck(TQRDBJPEGImage *)
{
    new TQRDBJPEGImage(NULL);
}
//---------------------------------------------------------------------------
__fastcall TQRDBJPEGImage::TQRDBJPEGImage(TComponent* Owner)
    : TQRImage(Owner)
{
}
//---------------------------------------------------------------------------
Mwajpeg::TJPEGFileDecompressor* __fastcall TQRDBJPEGImage::GetJPEGDecompressor(void)
{
     if (JPEGDecompressor != NULL)
        return JPEGDecompressor;
     else
     {
          if (DefaultJPEGDecompressor == NULL)
             DefaultJPEGDecompressor = new TJPEGFileDecompressor(Forms::Application);
          return DefaultJPEGDecompressor;
     }
}
//---------------------------------------------------------------------------
void __fastcall TQRDBJPEGImage::LoadPicture()
{
   if (DataSet->FieldByName(DataField) == NULL)
     Picture->Graphic = NULL;
   else {
#if __TCPLUSPLUS__ > 0x0520
     Db::TBlobField* Field = dynamic_cast<Db::TBlobField*>(DataSet->FieldByName(DataField));
#else
     Dbtables::TBlobField* Field = dynamic_cast<Dbtables::TBlobField*>(DataSet->FieldByName(DataField));
#endif
     if (!(Field))
       throw Exception(sNotBlobField,ARRAYOFCONST((DataField)),1);

     if (Field->IsNull)
       Picture->Graphic = NULL;
     else {
#if __TCPLUSPLUS__ > 0x0520
       TStream* S = Field->DataSet->CreateBlobStream(Field,bmRead);
#else
       TStream* S = new TBlobStream(Field,bmRead);
#endif
        GetJPEGDecompressor()->LoadPictureFromStream(Picture,S);
     }
   }
}
//---------------------------------------------------------------------------
void __fastcall TQRDBJPEGImage::Notification(Classes::TComponent* AComponent, Classes::TOperation Operation)
{
  TQRImage::Notification(AComponent, Operation);
  if (Operation == opRemove && AComponent == DataSet)
    DataSet = NULL;
}
//---------------------------------------------------------------------------
void __fastcall TQRDBJPEGImage::Print(int OfsX, int OfsY)
{
     LoadPicture();
     if (AutoStretch && Parent->Height < Top + Height)
         Parent->Height = Top + Height;
     TQRImage::Print(OfsX, OfsY);
}
//---------------------------------------------------------------------------
void __fastcall TQRDBJPEGImage::SetDataSet(TDataSet* Value)
{
  FDataSet = Value;
  if (Value != NULL)
    Value->FreeNotification(this);
}
//---------------------------------------------------------------------------

