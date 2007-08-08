//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "progress.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TProgressBox *ProgressBox;
//---------------------------------------------------------------------------
__fastcall TProgressBox::TProgressBox(TComponent* Owner)
        : TForm(Owner)
{
  Cancelled = false;
}
//---------------------------------------------------------------------------
void __fastcall TProgressBox::BitBtn1Click(TObject *Sender)
{
  Cancelled = true;
}
//---------------------------------------------------------------------------
bool __fastcall TProgressBox::SetProgress(int PercentDone)
{
  ProgressBar1->Position = PercentDone;
  return !Cancelled;
}
//---------------------------------------------------------------------------

void __fastcall TProgressBox::FormDestroy(TObject *Sender)
{
  ProgressBox = NULL;        
}
//---------------------------------------------------------------------------