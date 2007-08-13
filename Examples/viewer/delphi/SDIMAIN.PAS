unit Sdimain;

interface

uses wintypes, winprocs, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls,  mwajpeg;

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
    Image1: TImage;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    JPEGFileCompressor1: TJPEGFileCompressor;
    JPEGFileDecompressor1: TJPEGFileDecompressor;
    StatusBar: TPanel;
    Clear1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    N3: TMenuItem;
    PrintSetup1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
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
    procedure JPEGFileDecompressor1JPEGComment(sender: TJPEGBase;
    {$IFDEF DELPHI7ORLATER}
      comment: PAnsiChar);
    {$ELSE}
      comment: PChar);
    {$ENDIF}
    procedure Clear1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SaveJPEG(FileName: string);
    procedure SaveBitmap(FileName: string);
    procedure SaveMetaFile(FileName: string);
    procedure HandleOnIdle(Sender: TObject; var done: boolean);
    procedure ShowProgressBox(const Title: string);
    procedure ReSize;
  public
    { Public declarations }
  end;

var
  SDIAppForm: TSDIAppForm;

implementation

uses SysUtils, About, clipbrd, progress, Printers;

{$R *.DFM}

const
  sCaption = 'Image Viewer';

procedure TSDIAppForm.ShowHint(Sender: TObject);
begin
  StatusBar.Caption := Application.Hint;
end;

procedure TSDIAppForm.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TSDIAppForm.OpenItemClick(Sender: TObject);
begin
  with OpenDialog do
  if Execute then
  begin
    StatusBar.Caption := '';
    if CompareText(ExtractFileExt(FileName),'.jpg') = 0 then
       ShowProgressBox('Opening ' + FileName);
    try
      Image1.Stretch := false;
      Image1.Align := alNone;
      Image1.Picture.LoadFromFile(FileName);
      ReSize;
      Image1.Stretch  := true;
      Image1.Align := alClient;
      Caption := sCaption + ' - ' + OpenDialog.FileName
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

procedure TSDIAppForm.ReSize;
begin
  ClientHeight := Image1.Picture.Height + StatusBar.Height + SpeedPanel.Height;
  ClientWidth := Image1.Picture.Width;
  Image1.Height := ClientHeight;
  Image1.Width := ClientWidth;
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
     PrintBtn.Enabled := Copy1.Enabled;
     Print1.Enabled := Copy1.Enabled;
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
     Clipboard.Assign(Image1.Picture)
end;

procedure TSDIAppForm.Paste1Click(Sender: TObject);
begin
     Image1.Picture.Assign(Clipboard);
     ReSize;
     Caption := sCaption
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

procedure TSDIAppForm.PrintSetup1Click(Sender: TObject);
begin
     PrinterSetupDialog1.Execute
end;

procedure TSDIAppForm.Print1Click(Sender: TObject);
var screen: hDC;
    SrcLogPixelSX,
    SrcLogPixelSY,
    DestLogPixelSX,
    DestLogPixelSY,
    DestWidth,
    DestHeight: integer;
begin
   if PrintDialog1.Execute then
   begin
      Printer.BeginDoc;
      screen := GetDC(0);
      try
        SrcLogPixelSX := GetDeviceCaps(screen,LOGPIXELSX);
        SrcLogPixelSY := GetDeviceCaps(screen,LOGPIXELSY)
      finally
        ReleaseDC(0,screen);
      end;
      DestLogPixelSX := GetDeviceCaps(Printer.Canvas.Handle,LOGPIXELSX);
      DestLogPixelSY := GetDeviceCaps(Printer.Canvas.Handle,LOGPIXELSY);
      DestWidth := Round(Image1.Picture.Bitmap.Width * DestLogPixelSX / SrcLogPixelSX);
      DestHeight := Round(Image1.Picture.Bitmap.Height * DestLogPixelSY / SrcLogPixelSY);
      Printer.Canvas.StretchDraw(Rect(0,0,DestWidth,
               DestHeight),Image1.Picture.Graphic);
      Printer.EndDoc;
    end
end;

end.

