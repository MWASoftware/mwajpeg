//---------------------------------------------------------------------------
#include <vcl\vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
USEFORM("dblistvr.cpp", Form1);
USERES("dbGrDemo.res");
USEFORM("progress.cpp", ProgressBox);
USEFORM("about.cpp", AboutBox);
USEFORM("Report.cpp", ReportForm);
USEDATAMODULE("jpegdata.cpp", DataModule1);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                Application->Initialize();
                Application->CreateForm(__classid(TForm1), &Form1);
        Application->CreateForm(__classid(TAboutBox), &AboutBox);
        Application->CreateForm(__classid(TProgressBox), &ProgressBox);
        Application->CreateForm(__classid(TReportForm), &ReportForm);
        Application->CreateForm(__classid(TDataModule1), &DataModule1);
        Application->Run();
        }
        catch (Exception &exception)
        {
                Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
