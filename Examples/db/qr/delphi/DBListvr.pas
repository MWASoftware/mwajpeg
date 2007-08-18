unit DBListvr;

interface

uses wintypes, winprocs, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls,  mwajpeg, Mask, DBCtrls, Db,
  DBTables, mwadbjpg, DBCGrids;

{$IFNDEF VER80}{$IFNDEF VER90}{$IFNDEF VER93}{$IFNDEF VER100} {$IFNDEF VER110} {$IFNDEF VER120} 
{$IFNDEF VER125} {$IFNDEF VER130} {$IFNDEF VER140}
{$DEFINE DELPHI7ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF} {$ENDIF} {$ENDIF}{$ENDIF} {$ENDIF}{$ENDIF}{$ENDIF}

type
  TListVr = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    OpenItem: TMenuItem;
    SaveItem: TMenuItem;
    ExitItem: TMenuItem;
    N1: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Help1: TMenuItem;
    About1: TMenuItem;
    SpeedPanel: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    JPEGFileCompressor1: TJPEGFileCompressor;
    JPEGFileDecompressor1: TJPEGFileDecompressor;
    Clear1: TMenuItem;
    N2: TMenuItem;
    DataSource1: TDataSource;
    Cut1: TMenuItem;
    Print1: TMenuItem;
    PrintBtn: TSpeedButton;
    DBCtrlGrid1: TDBCtrlGrid;
    StatusBar: TPanel;
    Panel1: TPanel;
    Image1: TDBJPEGImage;
    Panel2: TPanel;
    DBEdit1: TDBEdit;
    procedure ShowHint(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure OpenItemClick(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnProgress(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    {$IFDEF DELPHI7ORLATER}
    procedure JPEGFileDecompressor1JPEGComment(sender: TJPEGBase;
      comment: PAnsiChar);
    {$ELSE}
    procedure JPEGFileDecompressor1JPEGComment(sender: TJPEGBase;
      comment: PChar);
    {$ENDIF}
    procedure Clear1Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure Cut1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure SaveJPEG(FileName: string);
    procedure SaveBitmap(FileName: string);
    procedure SaveMetaFile(FileName: string);
    procedure HandleOnIdle(Sender: TObject; var done: boolean);
    procedure ShowProgressBox(const Title: string);
  public
    { Public declarations }
  end;

var
  ListVr: TListVr;

implementation

uses SysUtils, About,  Clipbrd, progress, Report, JpegData;

{$R *.DFM}

const
  sCaption = 'Image Viewer';

procedure TListVr.ShowHint(Sender: TObject);
begin
  StatusBar.Caption := Application.Hint;
  if StatusBar.Caption = '' then
  with DataModule1 do
   if Table1.RecordCount > 0 then
     StatusBar.Caption := Format('Record %d of %d',[Table1.RecNo,Table1.RecordCount])
   else
   if Table1.RecNo = -1 then
     StatusBar.Caption := 'Inserting new record'
   else
     StatusBar.Caption := 'Empty Database'
end;

procedure TListVr.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TListVr.OpenItemClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  with OpenDialog do
  if Execute then
  begin
    if CompareText(ExtractFileExt(FileName),'.jpg') = 0 then
       ShowProgressBox('Opening ' + FileName);
    try
      Image1.Picture.LoadFromFile(FileName);
      Caption := sCaption + ' - ' + OpenDialog.FileName;
      DataModule1.Table1Subject.AsString := 'Picture From ' + OpenDialog.FileName;
      ShowHint(Sender);
    finally
      ProgressBox.Visible := false
    end
  end
end;

procedure TListVr.ShowProgressBox(const Title: string);
begin
     ProgressBox.Title.Caption := Title;
     ProgressBox.Visible := true
end;

procedure TListVr.SaveItemClick(Sender: TObject);
begin
  with SaveDialog do
    if Execute then
    case FilterIndex of
    1: SaveJPEG(FileName);
    2: SaveBitmap(FileName);
    3: SaveMetaFile(FileName);
    end
end;

procedure TListVr.HandleOnIdle(Sender: TObject; var done: boolean);
begin
     Paste1.Enabled := Clipboard.HasFormat(CF_BITMAP) or Clipboard.HasFormat(CF_METAFILEPICT);
     Copy1.Enabled := Image1.Picture.Graphic <> nil;
     done := true
end;

procedure TListVr.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TListVr.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowHint;
  Application.OnIdle := HandleOnIdle;
end;

procedure TListVr.SaveJPEG(FileName: string);
begin
     if ExtractFileExt(FileName) = '' then
        FileName := FileName + '.jpg';

     ShowProgressBox('Saving ' + FileName);
     try
       JPEGFileCompressor1.SaveStretchedPictureToFile(Image1.Picture,Image1.Width,
                                                            Image1.Height,FileName)
     finally
       ProgressBox.Visible := false
     end
end;

procedure TListVr.SaveBitmap(FileName: string);
var meta2bitmap: TBitmap;
    NewBitmap: TBitmap;
begin
     if ExtractFileExt(FileName) = '' then
        FileName := FileName + '.bmp';

     with Image1.Picture do
          if Graphic is TBitmap  then
          begin
            if (Image1.width = Image1.Picture.Width)
                            and (Image1.Height = Image1.Picture.Height) then
               Bitmap.SaveToFile(FileName)
            else
            begin
                 NewBitmap := ResizeBitmap(Bitmap,Image1.Width,Image1.Height);
                 try
                    NewBitmap.SaveToFile(FileName)
                 finally
                    NewBitmap.Free
                 end
            end
          end
          else
          if Graphic is TMetafile  then
          begin
            meta2bitmap := MetaToBitmap(Metafile,Image1.Picture.width,Image1.Picture.Height);
            try
              meta2bitmap.SaveToFile(Filename)
            finally
              meta2bitmap.Free
            end
          end
          else
            raise Exception.create('Cannot save image')
end;

procedure TListVr.SaveMetaFile(FileName: string);
begin
     if ExtractFileExt(FileName) = '' then
        FileName := FileName + '.wmf';

     with Image1.Picture do
          if Graphic is TMetaFile then
             Metafile.SaveToFile(FileName)
          else
            raise Exception.create('Cannot save image')
end;

procedure TListVr.OnProgress(Sender: TObject);
begin
     Application.ProcessMessages;
     with Sender as TJPEGBase do
       if not ProgressBox.SetProgress(PercentDone) then
       begin
          StatusBar.Caption := '';
          Abort
       end

end;

procedure TListVr.Copy1Click(Sender: TObject);
begin
     Image1.CopyToClipboard
end;

procedure TListVr.Paste1Click(Sender: TObject);
begin
     Image1.PasteFromClipboard;
     Caption := sCaption;
     DataModule1.Table1Subject.AsString := 'Picture from Clipboard'
end;

procedure TListVr.JPEGFileDecompressor1JPEGComment(sender: TJPEGBase;
    {$IFDEF DELPHI7ORLATER}
      comment: PAnsiChar);
    {$ELSE}
      comment: PChar);
    {$ENDIF}
begin
     StatusBar.Caption := StrPas(comment)
end;

procedure TListVr.Clear1Click(Sender: TObject);
begin
    Image1.Picture.Graphic := nil;
    Caption := sCaption
end;

procedure TListVr.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
   ShowHint(nil)
end;

procedure TListVr.Cut1Click(Sender: TObject);
begin
     Image1.CutToClipboard;
end;

procedure TListVr.Print1Click(Sender: TObject);
var Current: TBookmark;
begin
   DataSource1.Enabled := false;
   with DataModule1 do
   try
     Current := Table1.GetBookmark;
     try
       ReportForm.Report.Preview;
       Table1.GotoBookmark(Current)
     finally
       Table1.FreeBookmark(Current)
     end
   finally
     DataSource1.Enabled := true
   end
end;

procedure TListVr.FormResize(Sender: TObject);
begin
     DBCtrlGrid1.Height := ClientHeight - StatusBar.Height - SpeedPanel.Height;
     DBCtrlGrid1.Width := ClientWidth;
     DBEdit1.Width := DBCtrlGrid1.PanelWidth - 20
end;

end.

