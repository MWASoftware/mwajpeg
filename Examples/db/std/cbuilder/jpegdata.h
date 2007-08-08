//---------------------------------------------------------------------------
#ifndef jpegdataH
#define jpegdataH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\DBTables.hpp>
#include <vcl\DB.hpp>
#include <Db.hpp>
//---------------------------------------------------------------------------
class TDataModule1 : public TDataModule
{
__published:	// IDE-managed Components
	TTable *Table1;
	TStringField *Table1Subject;
	TBlobField *Table1Picture;
	void __fastcall DataModule1Create(TObject *Sender);
	void __fastcall DataModule1Destroy(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TDataModule1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TDataModule1 *DataModule1;
//---------------------------------------------------------------------------
#endif
