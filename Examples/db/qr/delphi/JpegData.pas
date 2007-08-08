unit JpegData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDataModule1 = class(TDataModule)
    Table1: TTable;
    Table1Subject: TStringField;
    Table1Picture: TBlobField;
    procedure DataModule1Create(Sender: TObject);
    procedure DataModule1Destroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.DFM}

procedure TDataModule1.DataModule1Create(Sender: TObject);
begin
  Table1.TableName := ExtractFilePath(Application.Exename)+Table1.TableName;
  if not FileExists(Table1.TableName) then
    Table1.CreateTable;
  Table1.Open

end;

procedure TDataModule1.DataModule1Destroy(Sender: TObject);
begin
     if Table1.State in [dsEdit, dsInsert] then Table1.Post
end;

end.
