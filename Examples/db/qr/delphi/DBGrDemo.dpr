program DBGrDemo;

uses
  Forms,
  DBListvr in 'DBListvr.pas' {ListVr},
  about in 'about.pas' {AboutBox},
  progress in 'progress.pas' {ProgressBox},
  Report in 'Report.pas' {ReportForm: TReportForm},
  JpegData in 'JpegData.pas' {DataModule1: TDataModule};

{$R *.RES}

begin
  Application.CreateForm(TListVr, ListVr);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TProgressBox, ProgressBox);
  Application.CreateForm(TReportForm, ReportForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
 