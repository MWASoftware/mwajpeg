//---------------------------------------------------------------------------
#ifndef progressH
#define progressH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ComCtrls.hpp>
#include <vcl\Buttons.hpp>
//---------------------------------------------------------------------------
class TProgressBox : public TForm
{
__published:	// IDE-managed Components
        TProgressBar *ProgressBar1;
        TBitBtn *BitBtn1;
        TLabel *Title;
        void __fastcall BitBtn1Click(TObject *Sender);
        void __fastcall FormDestroy(TObject *Sender);
private:	// User declarations
        bool Cancelled;
public:		// User declarations
        __fastcall TProgressBox(TComponent* Owner);
        bool __fastcall SetProgress(int PercentDone);
};
//---------------------------------------------------------------------------
extern TProgressBox *ProgressBox;
//---------------------------------------------------------------------------
#endif
