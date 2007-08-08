//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "about.h"
#include <sysinit.hpp>
//---------------------------------------------------------------------------
#pragma link "mwajpeg"
#pragma resource "*.dfm"
TAboutBox *AboutBox;
//---------------------------------------------------------------------------
__fastcall TAboutBox::TAboutBox(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TAboutBox::FormCreate(TObject *Sender)
{
  JPEGFileDecompressor1->LoadPictureFromResource(Image1->Picture,(int)Sysinit::HInstance,"TESTImage");
}
//---------------------------------------------------------------------------
