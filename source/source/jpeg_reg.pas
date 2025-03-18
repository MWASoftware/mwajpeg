{
    This file is part of the MWA JPEG COMPONENT LIBRARY.

    The MWA JPEG COMPONENT LIBRARY is free software: you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The MWA JPEG COMPONENT LIBRARY is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with the MWA JPEG COMPONENT LIBRARY.  If not, see <https://www.gnu.org/licenses/>.
}
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
