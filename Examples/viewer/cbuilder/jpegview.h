//---------------------------------------------------------------------------
#ifndef jpegviewH
#define jpegviewH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ComCtrls.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\Buttons.hpp>
#include <vcl\Menus.hpp>
#include <vcl\Dialogs.hpp>
#include "mwajpeg.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TStatusBar *StatusBar1;
        TPanel *SpeedPanel;
        TSpeedButton *OpenBtn;
        TMainMenu *MainMenu1;
        TSpeedButton *SaveBtn;
        TMenuItem *File1;
        TMenuItem *open1;
        TMenuItem *Save1;
        TMenuItem *N1;
        TMenuItem *Exit1;
        TMenuItem *Edit1;
        TMenuItem *Copy1;
        TMenuItem *Paste1;
        TMenuItem *Help1;
        TMenuItem *About1;
        TJPEGFileCompressor *JPEGFileCompressor1;
        TJPEGFileDecompressor *JPEGFileDecompressor1;
        TOpenDialog *OpenDialog1;
        TSaveDialog *SaveDialog1;
        TImage *Image1;
    TMenuItem *Print1;
    TMenuItem *PrintSetup1;
    TMenuItem *N2;
    TPrinterSetupDialog *PrinterSetupDialog1;
    TPrintDialog *PrintDialog1;
    TSpeedButton *PrintBtn;
        void __fastcall OpenBtnClick(TObject *Sender);
        void __fastcall Exit1Click(TObject *Sender);
        void __fastcall Save1Click(TObject *Sender);
        void __fastcall Copy1Click(TObject *Sender);
        void __fastcall Paste1Click(TObject *Sender);
        void __fastcall JPEGFileDecompressor1JPEGComment(TJPEGBase *sender,
        PChar comment);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall JPEGFileCompressor1ProgessReport(TObject *Sender);
        void __fastcall About1Click(TObject *Sender);
    void __fastcall PrintSetup1Click(TObject *Sender);
    void __fastcall Print1Click(TObject *Sender);
private:	// User declarations
        bool __fastcall IsFileExtension(const AnsiString& FileName, char *extension);
        void __fastcall ReSizeForm(const AnsiString& Title);
        void __fastcall ShowHint(TObject *Sender);
        void __fastcall HandleOnIdle(TObject *Sender, bool& done);
public:		// User declarations
        void __fastcall SaveJPEG(AnsiString FileName);
        void __fastcall SaveBitmap(AnsiString FileName);
        void __fastcall SaveMetaFile(AnsiString FileName);
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
