unit Jpeg_reg;

{ $DEFINE QREPORT2}
{$DEFINE DYNAMIC_DLL}


{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93}
{$DEFINE DELPHI3ORLATER}
{$DEFINE QREPORT2}
{$ENDIF}{$ENDIF}{$ENDIF}

{Allow command line defines to override default settings}
{$IFDEF NODLL}
{$UNDEF DYNAMIC_DLL}
{$ENDIF}
{$IFDEF STATIC_LIBRARY}
{$UNDEF DYNAMIC_DLL}
{$ENDIF}

{$IFDEF VER110}
{$ObjExportAll On}
{$ENDIF}


interface

procedure Register;

implementation

uses Classes, 
  {$IFDEF QREPORT2} mwaQRjpg,{$ENDIF}
  mwadbjpg, mwajpeg, jpeglib, dialogs, sysutils;

{$IFDEF VER80}
{$R jpgreg16.dcr}
{$ELSE}
{$R jpeg_reg.dcr}
{$ENDIF}

procedure Register;
begin
  try
{$IFDEF DYNAMIC_DLL}
    LoadJpegLibrary;
{$ENDIF}
    RegisterComponents('MWA JPEG', [TJPEGFileCompressor]);
    RegisterComponents('MWA JPEG', [TJPEGFileDecompressor]);
    RegisterComponents('MWA JPEG',[TDBJPEGImage]);
{$IFDEF QREPORT2}
    RegisterComponents('MWA JPEG',[TQRDBJPEGImage])
{$ENDIF}
  except
    MessageDlg(Exception(ExceptObject).message,mtError,[mbOK],0)
  end
end;



end.
