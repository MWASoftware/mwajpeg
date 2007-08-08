unit mwadbjpg;

{$K+,B-,X+,I-,T-,R-,Q-}
{$IFNDEF VER80}
{$H+,J+}
{$ENDIF}
(*-------------------------------------------------------------------------------------*)
(*                                                                                     *)
(*               Unit: MWADBJPG                                                        *)
(*                                                                                     *)
(*               Copyright McCallum Whyman Associates Ltd 1998,99 & 2000,2001          *)
(*                                                                                     *)
(*               Version 1.8                                                           *)
(*                                                                                     *)
(*               Author: Tony Whyman                                                   *)
(*                                                                                     *)
(*               Description: This unit provides a TImage descendant that is a data    *)
(*                            aware control loading and saving the Picture it          *)
(*                            contains using the JPEG compression algorithm            *)
(*-------------------------------------------------------------------------------------*)

{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93}
{$DEFINE DELPHI3ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF}
{$IFDEF VER110}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF VER125}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF CBUILDER5}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}

{$IFDEF CBBUILDER3OR4OR5}
{$ObjExportAll On}
{$ENDIF}

{TDBJPEGImage introduces the following additional properties:

  DataSource: set to the data source for the dataset.
  DataField: set to the required field name (must be a Blob field)
  Field: returns the identified field
  ReadOnly: when set prevents changes to the data field.
  AutoDisplay: If AutoDisplay is True (the default value), the image automatically
               displays new data when the underlying BLOB field changes (such as
               when moving to a new record). If AutoDisplay is False, the image
               clears whenever the underlying BLOB field changes. To display the
               data, the user can double-click on the control or select it and
               press Enter. In addition, calling the LoadPicture method ensures
               that the control is showing data. Change the value of AutoDisplay to
               False if the automatic loading of BLOB fields seems to take too long.
  JPEGCompressor: by default, a JPEG Compressor component is created with default
                  parameters. If non-default parameters are required, then a
                  TJEPGFileCompressor component should be created with the required
                  parameters and assigned to this property.
  JPEGDecompressor: by default, a JPEG Decompressor component is created with default
                  parameters. If non-default parameters are required, then a
                  TJEPGFileDecompressor component should be created with the required
                  parameters and assigned to this property.

  and methods:

  LoadPicture: If the value of the AutoDisplay property is False, the image of a
               database image control is not automatically loaded. If AutoDisplay is
               False, control when the image is loaded at runtime by calling LoadPicture
               when the image should appear in the control.

  PasteFromClipboard: Use PasteFromClipboard to set the field value to an image stored
                      in the Clipboard.

  CutToClipboard: Use the CutToClipboard method to delete the image in the control
                  when copying it to the Clipboard. CutToClipboard gives the
                  associated field a null value.


  CopyToClipboard: Use CopyToClipboard to put a copy of the graphic specified by
                   the Picture property in the Clipboard.

In use, the component is used similarly to a TImage component except that it is
linked to a database field. THe image may be updated from the clipboard or by loading
a new image from a file or stream. If not read only, either of these actions will
automatically place the dataset in edit mode.

A copy of the image may be taken either by copying to the clipboard or by saving
to a disk file.
}

{15/4/99: References to TBlobstream replaced with calls to the more generic
          TDataSet.CreateBlobStream. This should permit operation with 3rd party
          database components

 17/4/99  Notification of removal of JPEG Components added

 25/4/99  Support for TDBCtrlGrid Added

 8/5/01   To support Interbase Express, LoadPicture now also checks the field's
           Blobsize.}

interface

uses db, DBCtrls,  Messages, ExtCtrls, classes, mwajpeg
{$IFNDEF DELPHI3ORLATER} ,DBTables {$ENDIF}
;

type
  TDBJPEGImage = class(TImage)
  private
    FDataLink: TFieldDataLink;
    FOldPictureChanged: TNotifyEvent;
    FAutoDisplay: boolean;
    FLoading: boolean;
    FChanging: boolean;
    FPictureLoaded: boolean;
    FPaintCopy: boolean;
    FChanged: boolean;
    FJPEGCompressor: TJPEGFileCompressor;
    FJPEGDecompressor: TJPEGFileDecompressor;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    function GetJPEGDecompressor: TJPEGFileDecompressor;
    function GetJPEGCompressor: TJPEGFileCompressor;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure ActiveChanged(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure PictureChange(Sender: TObject);
    procedure SetJPEGCompressor(Value: TJPEGFileCompressor);
    procedure SetJPEGDecompressor(Value: TJPEGFileDecompressor);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
   {$IFNDEF VER80}
    procedure Paint; override;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    procedure LoadPicture;
    property Field: TField read GetField;
  published
    property AutoDisplay: boolean read FAutoDisplay write FAutoDisplay default true;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: boolean read GetReadOnly write SetReadOnly;
    property JPEGCompressor: TJPEGFileCompressor read FJPEGCompressor write SetJPEGCompressor;
    property JPEGDecompressor: TJPEGFileDecompressor read FJPEGDecompressor write SetJPEGDecompressor;
  end;


implementation

uses Sysutils, clipbrd,Forms, Controls, Graphics;

const
  DefaultJPEGCompressor: TJPEGFileCompressor = nil;
  DefaultJPEGDecompressor: TJPEGFileDecompressor = nil;

  sNotBlobField = '%s is not a Blob Field';

constructor TDBJPEGImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOldPictureChanged := Picture.OnChange;
  Picture.OnChange := PictureChange;
  FDataLink := TFieldDataLink.Create;
  {$IFNDEF VER80}
  ControlStyle := ControlStyle + [csReplicatable];
  {$ENDIF}
  {$IFDEF DELPHI3ORLATER}
  FDataLink.Control := Self;
  {$ENDIF}
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChanged;
  FAutoDisplay := true

end;

destructor TDBJPEGImage.Destroy;
begin
  if assigned(FDataLink) then FDataLink.Free;
  inherited Destroy;
end;

procedure TDBJPEGImage.PictureChange(Sender: TObject);
begin
  if not FPaintCopy then
  begin
     FOldPictureChanged(Sender);
     if ReadOnly then
     begin
       DataChange(nil);
       Exit
     end
     else
     if FLoading then Exit;

     FChanging := true;
     try
       FDataLink.Edit;
     finally
       FChanging := false
     end;
     FDataLink.Modified
  end
end;

procedure TDBJPEGImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (FDataLink <> nil) and (AComponent = DataSource) then DataSource := nil;
    if AComponent = JPEGCompressor then JPEGCompressor := nil;
    if AComponent = JPEGDecompressor then JPEGDecompressor := nil
  end
end;

function TDBJPEGImage.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBJPEGImage.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  {$IFNDEF VER80}
  if Value <> nil then Value.FreeNotification(Self);
  {$ENDIF}
end;

procedure TDBJPEGImage.ActiveChanged(Sender: TObject);
var Name: string;
begin
  if (Field <> nil) and not (Field is TBlobField) then
  begin
    Name := DataField;
    DataField := '';
    raise Exception.CreateFmt(sNotBlobField,[Name])
  end
end;

function TDBJPEGImage.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDBJPEGImage.SetDataField(const Value: string);
begin
    FDataLink.FieldName := Value
end;

function TDBJPEGImage.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TDBJPEGImage.GetJPEGDecompressor: TJPEGFileDecompressor;
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

procedure TDBJPEGImage.DataChange(Sender: TObject);
begin
     if FChanging then Exit;
     FPictureLoaded := false;
     if FAutoDisplay then
     begin
       if FLoading then FChanged := true
       else LoadPicture
     end
     else
     begin
       FLoading := true;
       try
         Picture.Graphic := nil
       finally
         FLoading := false
       end
     end
end;

procedure TDBJPEGImage.LoadPicture;
var S: TStream;
    M: TMemoryStream;
begin                          
   if FPictureLoaded or FLoading then Exit;
   FLoading := true;
   try
{$IFDEF DELPHI3ORLATER}
     if (Field = nil) or Field.IsNull or ((Field as TBlobField).BlobSize = 0) then
{$ELSE}
     if (Field = nil) or Field.IsNull or ((Field as TBlobField).Size = 0) then
{$ENDIF}
       Picture.Graphic := nil
     else
     repeat
       FChanged := false;
       {$IFNDEF DELPHI3ORLATER}
       S := TBlobStream.Create(TBlobField(Field),bmRead);
       {$ELSE}
       S := Field.DataSet.CreateBlobStream(Field,bmRead);
       {$ENDIF}
       M := TMemoryStream.Create;
       try
          M.CopyFrom(S,0);
          M.Position := 0;
          GetJPEGDecompressor.LoadPictureFromStream(Picture,M);
       finally
         S.Free;
         M.Free
       end;
     until not FChanged;
     FPictureLoaded := true
   finally
     FLoading := false
   end
end;

function TDBJPEGImage.GetJPEGCompressor: TJPEGFileCompressor;
begin
     if JPEGCompressor <> nil then
        Result := JPEGCompressor
     else
     begin
          if DefaultJPEGCompressor = nil then
             DefaultJPEGCompressor := TJPEGFileCompressor.Create(Application);
          Result := DefaultJPEGCompressor
     end
end;

procedure TDBJPEGImage.UpdateData(Sender: TObject);
var S: TStream;
begin
     if Picture.Graphic <> nil then
     begin
       {$IFNDEF DELPHI3ORLATER}
       S := TBlobStream.Create(TBlobField(Field),bmWrite);
       {$ELSE}
       S := Field.DataSet.CreateBlobStream(Field,bmWrite);
       {$ENDIF}
       try
          GetJPEGCompressor.SavePictureToStream(Picture,S)
       finally
         S.Free
       end
     end
     else
       Field.Clear;
end;

function TDBJPEGImage.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBJPEGImage.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TDBJPEGImage.CopyToClipboard;
begin
     Clipboard.Assign(Picture)
end;

procedure TDBJPEGImage.CutToClipboard;
begin
     CopyToClipboard;
     Picture.Graphic := nil
end;

procedure TDBJPEGImage.PasteFromClipboard;
begin
     Picture.Assign(Clipboard)
end;

procedure TDBJPEGImage.SetJPEGCompressor(Value: TJPEGFileCompressor);
begin
  FJPEGCompressor := Value;
  {$IFNDEF VER80}
  if Value <> nil then Value.FreeNotification(Self)
  {$ENDIF}
end;

procedure TDBJPEGImage.SetJPEGDecompressor(Value: TJPEGFileDecompressor);
begin
  FJPEGDecompressor := Value;
  {$IFNDEF VER80}
  if Value <> nil then Value.FreeNotification(Self)
  {$ENDIF}
end;

procedure TDBJPEGImage.WMCut(var Message: TMessage);
begin
  CutToClipboard;
end;

procedure TDBJPEGImage.WMCopy(var Message: TMessage);
begin
  CopyToClipboard;
end;

procedure TDBJPEGImage.WMPaste(var Message: TMessage);
begin
  PasteFromClipboard;
end;

{$IFNDEF VER80}
procedure TDBJPEGImage.Paint;
var SaveImage: TPicture;
    OnProgress: TNotifyEvent;
begin
    if (csPaintCopy in ControlState)  then
    begin
      if FLoading or FPaintCopy or not AutoDisplay then Exit;
      SaveImage := TPicture.Create;
      FPaintCopy := true;
      try
        SaveImage.Assign(Picture);
        try
          FPictureLoaded := false;
          if JpegDecompressor <> nil then
          begin
            OnProgress := JpegDecompressor.OnProgressReport;
            JpegDecompressor.OnProgressReport := nil
          end;
          try
            LoadPicture;
            if Picture.Graphic = nil then
              Canvas.FillRect(Rect(0,0,Width,Height));
            inherited Paint
          finally
            if JpegDecompressor <> nil then
              JpegDecompressor.OnProgressReport := OnProgress
          end
        finally
          Picture.Graphic := SaveImage.Graphic;
          FPictureLoaded := true;
        end
      finally
        FPaintCopy := false;
        SaveImage.Free
      end
    end
    else
      inherited Paint
end;
{$ENDIF}

end.
