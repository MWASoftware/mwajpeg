program jpegdemo;

uses
  Forms,
  Sdimain in 'SDIMAIN.PAS' {SDIAppForm},
  About in 'ABOUT.PAS' {AboutBox},
  progress in 'progress.pas' {ProgressBox};

{$R *.RES}

begin
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TProgressBox, ProgressBox);
  Application.Run;
end.
 