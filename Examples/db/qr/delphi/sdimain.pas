unit Sdimain;

interface

uses wintypes, winprocs, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls,  mwajpeg, Mask, DBCtrls, Db,
  DBTables, mwadbjpg, ComCtrls;

{$IFNDEF VER80}{$IFNDEF VER90}{$IFNDEF VER93}{$IFNDEF VER100} {$IFNDEF VER110} {$IFNDEF VER120} 
{$IFNDEF VER125} {$IFNDEF VER130} {$IFNDEF VER140}
{$DEFINE DELPHI7ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF} {$ENDIF} {$ENDIF}{$ENDIF} {$ENDIF}{$ENDIF}{$ENDIF}

type
  TSDIAppForm = class(TForm)
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
    StatusBar: TPanel;
    Clear1: TMenuItem;
    N2: TMenuItem;
    DataSource1: TDataSource;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    Panel2: TPanel;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Cut1: TMenuItem;
    Image1: TDBJPEGImage;
    ProgressBar1: TProgressBar;
    Print1: TMenuItem;
    PrintBtn: TSpeedButton;
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
    procedure Image1Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
      const Msg: String);
    procedure Print1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SaveJPEG(FileName: string);
    procedure SaveBitmap(FileName: string);
    procedure SaveMetaFile(FileName: string);
    procedure HandleOnIdle(Sender: TObject; var done: boolean);
    procedure ShowProgressBox(const Title: string);
    procedure ReSizeViewer;
  public
    { Public declarations }
  end;

var
  SDIAppForm: TSDIAppForm;

implementation

uses SysUtils, About,  Clipbrd, progress, Report, JpegData;

{$R *.DFM}

const
  sCaption = 'Image Viewer';

procedure TSDIAppForm.ShowHint(Sender: TObject);
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

procedure TSDIAppForm.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TSDIAppForm.OpenItemClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  with OpenDialog do
  if Execute then
  begin
    if CompareText(ExtractFileExt(FileName),'.jpg') = 0 then
       ShowProgressBox('Opening ' + FileName);
    try
      JPEGFileDecompressor1.LoadPictureFromFile(Image1.Picture,FileName);
      ReSizeViewer;
      Caption := sCaption + ' - ' + OpenDialog.FileName;
      with DataModule1 do
        Table1Subject.AsString := 'Picture From ' + OpenDialog.FileName;
      ShowHint(Sender);
    finally
      ProgressBox.Visible := false
    end
  end
end;

procedure TSDIAppForm.ShowProgressBox(const Title: string);
begin
     ProgressBox.Title.Caption := Title;
     ProgressBox.Visible := true
end;

procedure TSDIAppForm.ReSizeViewer;
begin
  if Image1.Picture.Graphic = nil then
  begin
       ClientHeight := 350;
       ClientWidth := 300
  end
  else
  begin
    ClientHeight := Image1.Picture.Height + StatusBar.Height + SpeedPanel.Height
                   + Panel1.Height + Panel2.Height;
    ClientWidth := Image1.Picture.Width;
    if ClientWidth < DBNavigator1.Width + 2*DBNavigator1.Left then
    begin
      ClientWidth := DBNavigator1.Width + 2*DBNavigator1.Left;
      ClientHeight := ClientHeight + 2*DBNavigator1.Left
    end
  end
end;

procedure TSDIAppForm.SaveItemClick(Sender: TObject);
begin
  with SaveDialog do
    if Execute then
    case FilterIndex of
    1: SaveJPEG(FileName);
    2: SaveBitmap(FileName);
    3: SaveMetaFile(FileName);
    end
end;

procedure TSDIAppForm.HandleOnIdle(Sender: TObject; var done: boolean);
begin
     Paste1.Enabled := Clipboard.HasFormat(CF_BITMAP) or Clipboard.HasFormat(CF_METAFILEPICT);
     Copy1.Enabled := Image1.Picture.Graphic <> nil;
     done := true
end;

procedure TSDIAppForm.About1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TSDIAppForm.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowHint;
  Application.OnIdle := HandleOnIdle;
end;

procedure TSDIAppForm.SaveJPEG(FileName: string);
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

procedure TSDIAppForm.SaveBitmap(FileName: string);
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

procedure TSDIAppForm.SaveMetaFile(FileName: string);
begin
     if ExtractFileExt(FileName) = '' then
        FileName := FileName + '.wmf';

     with Image1.Picture do
          if Graphic is TMetaFile then
             Metafile.SaveToFile(FileName)
          else
            raise Exception.create('Cannot save image')
end;

procedure TSDIAppForm.OnProgress(Sender: TObject);
begin
     Application.ProcessMessages;
     with Sender as TJPEGBase do
       if not ProgressBox.SetProgress(PercentDone) then
       begin
          StatusBar.Caption := '';
          Abort
       end

end;

procedure TSDIAppForm.Copy1Click(Sender: TObject);
begin
     Image1.CopyToClipboard
end;

procedure TSDIAppForm.Paste1Click(Sender: TObject);
begin
     Image1.PasteFromClipboard;
     ReSizeViewer;
     Caption := sCaption;
     with DataModule1 do
       Table1Subject.AsString := 'Picture from Clipboard'
end;

procedure TSDIAppForm.JPEGFileDecompressor1JPEGComment(sender: TJPEGBase;
    {$IFDEF DELPHI7ORLATER}
      comment: PAnsiChar);
    {$ELSE}
      comment: PChar);
    {$ENDIF}
begin
     StatusBar.Caption := StrPas(comment)
end;

procedure TSDIAppForm.Clear1Click(Sender: TObject);
begin
    Image1.Picture.Graphic := nil;
    Caption := sCaption
end;

procedure TSDIAppForm.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
   ResizeViewer;
   ShowHint(nil)
end;

procedure TSDIAppForm.Cut1Click(Sender: TObject);
begin
     Image1.CutToClipboard;
     ResizeViewer
end;

procedure TSDIAppForm.Image1Progress(Sender: TObject;
  Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
  const R: TRect; const Msg: String);
begin
     StatusBar.Caption := Msg;
     case Stage of
     psStarting:
            ProgressBar1.Show;
     psRunning:
            ProgressBar1.Position := PercentDone;
     psEnding:
            ProgressBar1.Hide;
     end;
end;

procedure TSDIAppForm.Print1Click(Sender: TObject);
begin
   ReportForm.Report.Preview
end;

end.

