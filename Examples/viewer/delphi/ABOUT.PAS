unit About;

interface

uses winprocs, wintypes, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, mwajpeg;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Image1: TImage;
    JPEGFileDecompressor1: TJPEGFileDecompressor;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

{$R Test.res}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
     JPEGFileDecompressor1.LoadPictureFromResource(Image1.Picture,HInstance,'TESTImage')
end;

end.
 
