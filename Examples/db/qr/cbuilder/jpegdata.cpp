//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "jpegdata.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TDataModule1 *DataModule1;
//---------------------------------------------------------------------------
__fastcall TDataModule1::TDataModule1(TComponent* Owner)
	: TDataModule(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::DataModule1Create(TObject *Sender)
{
  Table1->TableName = ExtractShortPathName(ExtractFilePath(Application->ExeName)+Table1->TableName);
  if (!FileExists(Table1->TableName))
    Table1->CreateTable();
  Table1->Open();
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::DataModule1Destroy(TObject *Sender)
{
     if (Table1->State == dsEdit || Table1->State == dsInsert)
       Table1->Post();
}
//---------------------------------------------------------------------------