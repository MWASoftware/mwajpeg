//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop

#include "Report.h"
#include "jpegdata.h"
//---------------------------------------------------------------------------
#pragma link "mwadbjpg"
#pragma link "quickrpt"
#pragma link "Qrctrls"
#pragma link "mwaQRjpg"
#pragma resource "*.dfm"
TReportForm *ReportForm;
//---------------------------------------------------------------------------
__fastcall TReportForm::TReportForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
