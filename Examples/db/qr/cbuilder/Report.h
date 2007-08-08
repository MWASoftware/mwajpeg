//---------------------------------------------------------------------------
#ifndef ReportH
#define ReportH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include <vcl\DB.hpp>
#include "mwadbjpg.hpp"
#include "quickrpt.hpp"
#include "Qrctrls.hpp"
#include "mwaQRjpg.h"
#include <QRCtrls.hpp>
#include <QuickRpt.hpp>
//---------------------------------------------------------------------------
class TReportForm : public TForm
{
__published:	// IDE-managed Components
	TQuickRep *QuickReport1;
	TQRBand *QRBand1;
	TQRLabel *QRLabel1;
	TQRBand *QRBand2;
	TQRDBText *QRDBText1;
	TQRDBJPEGImage *QRDBJPEGImage1;
private:	// User declarations
public:		// User declarations
	__fastcall TReportForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TReportForm *ReportForm;
//---------------------------------------------------------------------------
#endif
