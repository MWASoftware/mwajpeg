unit mwaQRjpg;

{$K+,B-,X+,I-,T-,R-,Q-}
{$IFNDEF VER80}
{$H+,J+}
{$ENDIF}

{$IFDEF VER110}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF VER125}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF CBUILDER5}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF CBBUILDER3OR4OR5}
{$ObjExportAll On}
{$ENDIF}

{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93}
{$DEFINE DELPHI3ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF}

(*-------------------------------------------------------------------------------------*)
(*                                                                                     *)
(*               Unit: MWAQRJPG                                                        *)
(*                                                                                     *)
(*               Copyright McCallum Whyman Associates Ltd 1998,99                      *)
(*                                                                                     *)
(*               Version 1.8                                                           *)
(*                                                                                     *)
(*               Author: Tony Whyman                                                   *)
(*                                                                                     *)
(*               Description: This unit provides a component to permit a JPEG image    *)
(*                            held in a database blob field to be printed using        *)
(*                            Quick Reports 2                                          *)
(*-------------------------------------------------------------------------------------*)

{ 4/5/99 Use of TBlobStream changed to more generic CreateBlobStream
}

interface

uses db, DBCtrls, QRCtrls, classes, mwajpeg;

type
  TQRDBJPEGImage = class(TQRImage)
  private
    FAutoStretch: boolean;
    FJPEGDecompressor: TJPEGFileDecompressor;
    FDataSet: TDataSet;
    FDataField: string;
    FField: TField;
    function GetJPEGDecompressor: TJPEGFileDecompressor;
    procedure SetDataSet(Value : TDataSet);
    procedure SetDataField(Value: string);
  protected
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure UnPrepare; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    procedure LoadPicture;
  published
    property AutoStretch: boolean read FAutoStretch write FAutoStretch;
    property DataField: string read FDataField write SetDataField;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property JPEGDecompressor: TJPEGFileDecompressor read FJPEGDecompressor write FJPEGDecompressor;
  end;

implementation

uses dbtables, Sysutils, clipbrd,Forms;

const
  DefaultJPEGDecompressor: TJPEGFileDecompressor = nil;

  sNotBlobField = '%s is not a Blob Field';

procedure TQRDBJPEGImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove)  and
    (AComponent = Dataset) then Dataset := nil;
end;

function TQRDBJPEGImage.GetJPEGDecompressor: TJPEGFileDecompressor;
begin
     if JPEGDecompressor <> nil then
        Result := JPEGDecompressor
     else
     begin
          if DefaultJPEGDecompressor = nil then
             DefaultJPEGDecompressor := TJPEGFileDecompressor.Create(Application);
          Result := DefaultJPEGDecompressor
     end
end;

procedure TQRDBJPEGImage.LoadPicture;
var S: TStream;
begin
   if (FField = nil) or FField.IsNull then
     Picture.Graphic := nil
   else
   begin
     {$IFDEF DELPHI3ORLATER}
     S := FField.DataSet.CreateBlobStream(FField,bmRead);
     {$ELSE}
     S := TBlobStream.Create(TBlobField(FField),bmRead);
     {$ENDIF}
     try
        GetJPEGDecompressor.LoadPictureFromStream(Picture,S)
     finally
       S.Free
     end
   end;
end;

procedure TQRDBJPEGImage.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    FField := DataSet.FindField(FDataField);
    if FField is TBlobField then
    begin
      Caption := '';
    end;
  end else
    FField := nil;
end;


procedure TQRDBJPEGImage.Print(OfSx, OfsY: integer);
begin
     LoadPicture;
     if AutoStretch and (Parent.Height < Top + Height) then
         Parent.Height := Top + Height;
       inherited Print(OfsX, OfsY)
end;


procedure TQRDBJPEGImage.Unprepare;
begin
  FField := nil;
  inherited Unprepare;
end;

procedure TQRDBJPEGImage.SetDataSet(Value : TDataSet);
begin
  FDataSet := Value;
{$ifdef win32}
  if Value <> nil then
    Value.FreeNotification(self);
{$endif}
end;

procedure TQRDBJPEGImage.SetDataField(Value: string);
begin
     FDataField := Value
end;


end.
