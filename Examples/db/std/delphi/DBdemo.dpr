program DBdemo;

uses
  Forms,
  sdimain in 'sdimain.pas' {SDIAppForm},
  about in 'about.pas' {AboutBox},
  progress in 'progress.pas' {ProgressBox},
  JpegData in 'JpegData.pas' {DataModule1: TDataModule};

{$R *.RES}

begin
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TProgressBox, ProgressBox);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
 