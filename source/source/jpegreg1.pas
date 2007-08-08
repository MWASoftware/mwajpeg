unit Jpegreg1;

{ $DEFINE DYNAMIC_DLL}
{ $DEFINE STATIC_LIBRARY}


{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93}
{$DEFINE DELPHI3ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF}
{$IFNDEF VER100} {$IFNDEF VER110} {$IFNDEF VER120} {$IFNDEF VER125}
{$DEFINE DELPHI5ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF} {$ENDIF}


{Determine default DLL settings if not explicitly specified}

{$IFNDEF DYNAMIC_DLL} {$IFNDEF STATIC_LIBRARY} {$IFNDEF NODLL}
{$IFDEF DELPHI3ORLATER}
{$DEFINE NODLL}
{$ELSE}
{$IFDEF VER93} 
{$DEFINE NODLL}
{$ELSE}
{$DEFINE DYNAMIC_DLL}
{$ENDIF}{$ENDIF}
{$ENDIF}{$ENDIF}{$ENDIF}

{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}


interface

procedure Register;

implementation

uses Classes, mwadbjpg, mwajpeg, jpeglib, dialogs, sysutils
{$IFDEF DELPHI5ORLATER},dsgnwnds{$ENDIF}
{$IFDEF DESIGNTIME},Graphics, jpeg {$ENDIF};

{$R jpeg_reg.dcr}

procedure Register;
begin
  try
{$IFDEF DYNAMIC_DLL}
    LoadJpegLibrary;
{$ENDIF}
    RegisterComponents('MWA JPEG', [TJPEGFileCompressor]);
    RegisterComponents('MWA JPEG', [TJPEGFileDecompressor]);
    RegisterComponents('MWA JPEG',[TDBJPEGImage]);
{$IFDEF DESIGNTIME}
    TPicture.UnregisterGraphicClass(TJPEGImage);
    TPicture.RegisterFileFormat('jpg','JPEG Image',TJPEGBitmap);
    TPicture.RegisterFileFormat('jpeg','JPEG Image',TJPEGBitmap);
{$ENDIF}
  except
    MessageDlg(Exception(ExceptObject).message,mtError,[mbOK],0)
  end
end;



end.
