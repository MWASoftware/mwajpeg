unit progress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TProgressBox = class(TForm)
    BitBtn1: TBitBtn;
    ProgressBar1: TProgressBar;
    Title: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FCancelled: boolean;
  public
    { Public declarations }
    function SetProgress(PercentDone: integer): boolean;
  end;

var
  ProgressBox: TProgressBox;

implementation

{$R *.DFM}

procedure TProgressBox.FormShow(Sender: TObject);
begin
  FCancelled := false
end;

procedure TProgressBox.BitBtn1Click(Sender: TObject);
begin
  FCancelled := true
end;

function TProgressBox.SetProgress(PercentDone: integer): boolean;
begin
  ProgressBar1.Position := PercentDone;
  Result := not FCancelled
end;

end.
