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
#include "mwadbjpg.hpp"
#include <vcl\DBTables.hpp>
#include <vcl\DB.hpp>
#include <vcl\DBCtrls.hpp>
#include <vcl\Mask.hpp>
#include <Db.hpp>
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
	TDBJPEGImage *Image1;
	TPanel *Panel2;
	TLabel *Label1;
	TDBEdit *DBEdit1;
	TDataSource *DataSource1;
	TPanel *Panel1;
	TDBNavigator *DBNavigator1;
	TMenuItem *Cut1;
	TMenuItem *Print1;
	TMenuItem *N2;
	TMenuItem *Clear1;
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
	void __fastcall DataSource1DataChange(TObject *Sender, TField *Field);
	void __fastcall Cut1Click(TObject *Sender);
	
	
	void __fastcall Clear1Click(TObject *Sender);
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
