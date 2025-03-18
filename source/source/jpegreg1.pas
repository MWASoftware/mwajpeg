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
