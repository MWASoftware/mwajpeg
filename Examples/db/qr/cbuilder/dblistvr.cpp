//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#include <vcl/clipbrd.hpp>
#include <dir.h>
#include <string.h>
#pragma hdrstop

#include "dblistvr.h"
#include "progress.h"
#include "about.h"
#include "Report.h"
#include "jpegdata.h"
//---------------------------------------------------------------------------
#pragma link "mwajpeg"
#pragma link "mwadbjpg"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
//
// TProgressReport encapsulates the VCL Class TProgressBox
// so that it can be made visible on request
// and then automatically made invisible when this class goes out of scope.
//
class TProgressReport{
public:
  TProgressReport(const AnsiString& Title, bool Show);
  ~TProgressReport();
};

TProgressReport::TProgressReport(const AnsiString& Title, bool Show)
{
  ProgressBox->Visible = Show;
  ProgressBox->Title->Caption = Title;
}

TProgressReport::~TProgressReport()
{
  ProgressBox->Visible = false;
}
//---------------------------------------------------------------------------
//
// The Class TDisableUpdates is sued to disable updates to the Image form
// while the report is running
//
class TDisableUpdates{
private:
  TBookmark Current;
  TDataSource *DataSource;
public:
  TDisableUpdates(TDataSource *ADataSource);
  ~TDisableUpdates();
};

TDisableUpdates::TDisableUpdates(TDataSource *ADataSource)
{
    DataSource = ADataSource;
	Current = DataSource->DataSet->GetBookmark();
    DataSource->Enabled = false;
}

TDisableUpdates::~TDisableUpdates()
{
	DataSource->DataSet->GotoBookmark(Current);
    DataSource->Enabled = true;
	DataSource->DataSet->FreeBookmark(Current);
}

//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::OpenBtnClick(TObject *Sender)
{
  if (OpenDialog1->Execute()) {
    StatusBar1->SimpleText = "";

    //Show Progress Box is file extension is .jpg
    TProgressReport ProgressReport = TProgressReport("Opening " + OpenDialog1->FileName,
             IsFileExtension(OpenDialog1->FileName,".jpg"));

    Image1->Picture->LoadFromFile(OpenDialog1->FileName);
	DataModule1->Table1Subject->AsString = "Picture From " + OpenDialog1->FileName;
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Exit1Click(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Save1Click(TObject *Sender)
{
  if (SaveDialog1->Execute()) {
    switch (SaveDialog1->FilterIndex) {
    case 1: SaveJPEG(SaveDialog1->FileName);
            break;
    case 2: SaveBitmap(SaveDialog1->FileName);
            break;
    case 3: SaveMetaFile(SaveDialog1->FileName);
    }
  }
}

//---------------------------------------------------------------------------
bool __fastcall TForm1::IsFileExtension(const AnsiString& FileName, char *extension)
{
    char drive[MAXDRIVE];
    char dir[MAXDIR];
    char file[MAXFILE];
    char ext[MAXEXT];

    fnsplit(FileName.c_str(),drive,dir,file,ext);
    return strcmpi(ext,extension) == 0;
 }

//---------------------------------------------------------------------------
 void  __fastcall TForm1::SaveJPEG(AnsiString FileName)
 {
    if (!IsFileExtension(FileName,".jpg"))
        FileName = FileName + ".jpg";

     TProgressReport ProgressReport = TProgressReport("Saving "+FileName,true);
     JPEGFileCompressor1->SaveStretchedPictureToFile(Image1->Picture,Image1->Width,Image1->Height,FileName);
 }
//---------------------------------------------------------------------------
void  __fastcall TForm1::SaveBitmap(AnsiString FileName)
{
    if (!IsFileExtension(FileName,".bmp"))
        FileName = FileName + ".bmp";

    if (dynamic_cast<Graphics::TBitmap*>(Image1->Picture->Graphic) != 0)
      if (Image1->Width == Image1->Picture->Width && Image1->Height == Image1->Picture->Height)
             Image1->Picture->Bitmap->SaveToFile(FileName);
      else 
        ReSizeBitmap(Image1->Picture->Bitmap,Image1->Width,Image1->Height)->SaveToFile(FileName);
    else
    if (dynamic_cast<TMetafile*>(Image1->Picture->Graphic) != 0) {
      Graphics::TBitmap* meta2bitmap = MetaToBitmap(Image1->Picture->Metafile,
                                  Image1->Picture->Width,Image1->Picture->Height);
      meta2bitmap->SaveToFile(FileName);
    }
    else
      throw Exception("Cannot save image");
}
//---------------------------------------------------------------------------
void  __fastcall TForm1::SaveMetaFile(AnsiString FileName)
{
    if (!IsFileExtension(FileName,".wmf"))
        FileName = FileName + ".wmf";

    if (dynamic_cast<TMetafile*>(Image1->Picture->Graphic) != 0)
      Image1->Picture->Metafile->SaveToFile(FileName);
    else
      throw Exception("Cannot save image");
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Copy1Click(TObject *Sender)
{
  Image1->CopyToClipboard();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Paste1Click(TObject *Sender)
{
  Image1->PasteFromClipboard();
  DataModule1->Table1Subject->AsString = "Picture from Clipboard";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::JPEGFileDecompressor1JPEGComment(TJPEGBase *sender,
        PChar comment)
{
 StatusBar1->SimpleText =  comment;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  Application->OnHint = ShowHint;
  Application->OnIdle = HandleOnIdle;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ShowHint(TObject *Sender)
{
  StatusBar1->SimpleText = Application->Hint;
  if (StatusBar1->SimpleText == "") {
   if (DataModule1->Table1->State == dsInsert)
     StatusBar1->SimpleText = "Inserting new record";
   else
   if (DataModule1->Table1->RecordCount > 0)
        StatusBar1->SimpleText = AnsiString::Format("Record %d of %d",ARRAYOFCONST(((int)DataModule1->Table1->RecNo,(int)DataModule1->Table1->RecordCount)));
   else
     StatusBar1->SimpleText = "Empty Database";
  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::HandleOnIdle(TObject *Sender, bool& done)
{
     Paste1->Enabled = Clipboard()->HasFormat(CF_BITMAP)
                             || Clipboard()->HasFormat(CF_METAFILEPICT);
     Save1->Enabled = Image1->Picture->Graphic != NULL;
     Copy1->Enabled = Image1->Picture->Graphic != NULL;
     done = true;
}
void __fastcall TForm1::JPEGFileCompressor1ProgessReport(TObject *Sender)
{
  Application->ProcessMessages();
  if (ProgressBox != NULL && !ProgressBox->SetProgress(dynamic_cast<TJPEGBase*>(Sender)->PercentDone))
      dynamic_cast<TJPEGBase*>(Sender)->Abort();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::About1Click(TObject *Sender)
{
  AboutBox->ShowModal();        
}
//---------------------------------------------------------------------------
void __fastcall TForm1::DataSource1DataChange(TObject *Sender, TField *Field)
{
    ShowHint(NULL);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Cut1Click(TObject *Sender)
{
    Image1->CutToClipboard();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Clear1Click(TObject *Sender)
{
	Image1->Picture->Graphic = NULL;	
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Print1Click(TObject *Sender)
{
  TDisableUpdates DU = TDisableUpdates(DataSource1);
  ReportForm->QuickReport1->Preview();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormResize(TObject *Sender)
{
     DBCtrlGrid1->Height = ClientHeight - StatusBar1->Height - SpeedPanel->Height;
     DBCtrlGrid1->Width = ClientWidth;
     DBEdit1->Width = DBCtrlGrid1->PanelWidth - 20;
}
//---------------------------------------------------------------------------
