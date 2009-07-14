unit mwajpeg;
{$K+,B-,X+,I-,T-,R-,Q-}
{$IFNDEF VER80}
{$H+,J+}
{$ENDIF}
{ $DEFINE DYNAMIC_DLL}
{ $DEFINE STATIC_LIBRARY}
(*-------------------------------------------------------------------------------------*)
(*                                                                                     *)
(*               Unit: MWAJPEG                                                         *)
(*                                                                                     *)
(*               Copyright McCallum Whyman Associates Ltd 1997-99 & 2000,2001          *)
(*                                                                                     *)
(*               Version 1.8                                                           *)
(*                                                                                     *)
(*               Author: Tony Whyman                                                   *)
(*                                                                                     *)
(*               Description: This unit encapsulates the interface to the IJG JPEG     *)
(*                            library as a set of Delphi classes.                      *)
(*                            It provides a common code base for Delphi                *)
(*                            and C++Builder with conditional compilation              *)
(*                            where differences exist.                                 *)
(*-------------------------------------------------------------------------------------*)

{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93}
{$DEFINE DELPHI3ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF}
{$IFDEF VER110}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF VER125}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
{$IFDEF CBUILDER5}{$DEFINE CBBUILDER3OR4OR5} {$ENDIF}
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

{$IFDEF CBBUILDER3OR4OR5}
{$ObjExportAll On}
{$ENDIF}

{$IFDEF VER90} {$DEFINE BeforeDelphi3} {$ENDIF}
{$IFDEF VER93} {$DEFINE BeforeDelphi3} {$ENDIF}
{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER93} {$IFNDEF VER100} {$IFNDEF VER110}
{$IFNDEF VER120}{$IFNDEF VER130}
{$DEFINE DELPHI6ORLATER}
{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}{$ENDIF}

{Changes from 1.6a

1. With Delphi 3 or later, TJpegDecompressor.ReadBitmap now returns a DIB bitmap
   rather than a Device Dependent Bitmap. This is for improved and more reliable
   printing. Earlier verions of Delpbi and C++Builder 1 do not support DIB bitmaps.

Changes from 1.6

1. New properties added: DefaultCompressor and DefaultDecompressor. This is to
   avoid a race condition with DBGrids. The problem is that it is unpredictable
   as to when the DBGrid will call its decompressor to display an image. If this
   same object is used as the Default JPEG decompressor i.e. used on a call to
   TPicture.LoadPictureFromFile then a JPEG library error may result. The new
   property is used to ensure that the JPEG decompressor used for a DBgrid will
   not be the default decompressor as well.

Changes from 1.5

1. If an error occurs during the decompression of a jpeg image from TImage.Picture.LoadFromFile,
   the next call to the JPEG Decompressor should no longer risk an Access Violation.

2. If an exception occurs during the processing of a progress report, Abort is now called
   to reset the JPEG decompressor/compressor. This will avoid the "JPEG decompressor/compressor
   not in correct state error messages on subsequent calls to the jpeg code.

3. Cured memory leak in LoadPictureFromStream

4. type size_t changed to localSize_t to avoid conflicts with C++Builder

Changes from 1.4

1. Added LoadPictureFromResource and LoadPictureFromResID methods .

2. Changed registration mechanism to unregister the Borland Imposter first.

 Changes from version 1.3

1. Parameters to TStream.Seek in TJPEGCompressor.SkipInputBytes now the correct way round :(
   Why didn't Borland make the "ORigin" parameter an enumerated type then this typo
   would have been a compile time error!

2. The error code returned from PlayEnhMetaFile is now returned in the error messsage

3. The decompressor now has a property (ColoursIn8bitMode) that allows the user to
   specify the actual numbers of discrete colours in the image when decoding to a
   256 colour image. This used to be 256. However, a lower number can avoid a
   colour cast especially with Blank and White images encoded as full colour images.
   The default is now 64.

4. Now calls "LoadJPEGLibrary" to load the dll dynamically and thus permit more meaningful
   error messages to be generated when dll cannot be located.

5. When the buffer size is changed the buffer will now be freed and reallocated.

6. An event handler for warning messages has been added.

7. You should now be able to correctly save JPEG images when working in the IDE
   and want to save an image as a JPEG at design time (but only when the image
   was loaded from a JPEG source - the IDE cannot be used to convert JPEG's to
   bitmaps, but it can be used to convert from JPEGs to bitmaps.

8. OnProgressReport now spelt correctly!

9. Delphi and all versions of C++Builder no longer require the jpeg dll. This is now a
   compile time option.

Changes from Version 1.2

1. Unit name changed to MWAJPEG in order to avoid confusion with Delphi 3's
   jpeg.dcu

2. ResyncToRestart now sets the return value

3. Added support for ".jpeg" extension in Win32 versions.

4. Now incorporates own methods for creating a DIB from a TBitmap, rather than using
   those supplied by Borland. This is because Delphi 3 now creates a 32 bit DIB when
   in True Colour mode rather than a 24-bit bitmap as required for JPEG Compression.

5. In 16-bit version the conversion of a metafile to a bitmap should now reliably
   produce a non-empty bitmap.

6. Consistently use the Screen Window when getting a Device Context to manipulate
   bitmaps.

7. Added support for saving bitmaps at a different size to the original bitmap.

}
{Changes from 1.1:

1. Zero length comments now handled correctly i.e. no GPF :)

}

{Changes from version 1.0:

1. Included Compiler directives in source code in order to ensure consistency in different
   user environments.

2. Abort method made safe to call from OnProgress event handler i.e. now gives a
   meaningful exception message.

3. SkipInputData method now works correctly.

4. App15 handler now installed for user OnMarker handler.

5. Fixed problem with grayscale mapping in 16-bit i.e. huge pointer arithmetic
   now used.

6. Use a Memory DC to realise Bitmaps in order to avoid palette switching giving
   a messy display in 256 colour mode.

}

{This unit provides two additional non-visual components for use
under either Delphi or C++Builder. These are TJPEGFileCompressor and
TJPEGFileDecompressor. These support compression of images to JPEG Format and
decompression respectively.

Simply installing these components JPEG enables the Delphi or C++Builder IDE.
The components register themselves as supporting .jpg files and the JPEG
compression format and, when you come to load an image into a TImage Picture,
the JPEG format will be found amongst the list of supported file formats.
An image loaded from a JPEG source can also be saved back to JPEG.

These two components also support TImage at run-time too. As at design time, if
TJPEGFileDecompressor is included in your project, then calling
TImage.Picture.LoadFromFile when the file extension is .jpg will automatically
invoke the JPEG decompressor. You can also explicitly call TJPEGFileDecompressor
to load a JPEG image from any file.

TJPEGFileCompressor can be used to save a TImage.Picture in JPEG format, and can
handle pictures that are either bitmaps or metafiles. It can also compress a
device independent bitmap.

This software uses original software for JPEG developed by the Independent JPEG
Group (see ftp://ftp.uu.net/graphics/jpeg). The IJG have made available a library
of generic 'C' code supporting JPEG compression and decompression and have
permitted its free use provided the source is acknowledged. The IJG code has been
modified for use with Delphi and MS Windows and is provided as a separate .dll
(mwjpeg.dll for the 16-bit version and mwjpeg32.dll for the 32-bit version). This
dll may be freely distributed.

An interface to this .dll is provided by the unit jpeglib.pas. This is
encapsulated as a set of Delphi components in the unit jpeg.pas, which also
supports the mapping of the environment independent image format expected by the
IJG code into MS Windows bitmap and metafile formats.}

interface

uses classes, winprocs,  wintypes, jpeglib, Graphics, ExtCtrls;

const DefaultBufSize = 4096;
      DefaultQuality = 75;

      sJPEGResourceType = 'JPEG'; {Used for user defined resource name}

{TJPEGBase
 ---------

 This is the base class for all JPEG compression and decompression classes. It comprises
 the code to handle error reports and progress reports. Note that descendant objects
 create the IJG library JPEG Compression/Decompression object in the CreateJPEGObject
 method and not directly in the constructor.}

type
  TWarningEvent = procedure(const warning_message: string) of object;

  TJPEGBase = class(TComponent)
  private
    JPEGObject: j_common_ptr;
    FInAbort: boolean;   {used to suppress error message when aborting}
    FInProgress: boolean; {used to control process abort from OnProgress Handler}
    FAbortRequested: boolean; {used to defer an abort to the main loop}
    FOnProgressReport: TNotifyEvent;
    FOnWarning: TWarningEvent;
    function GetWarnings: long;
    function GetTraceLevel: int;
    function GetPercentDone: integer;
    procedure SetTraceLevel(value: int);
    procedure CreateJPEGObject(err: jpeg_error_mgr_ptr); virtual; abstract;
  protected
    procedure Error; virtual;
    procedure Warning(msg_level : int); virtual;
    procedure DoProgress; virtual;
    function Round4(i: longint): longint;
  public
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Abort; virtual;
    property Warnings: long read GetWarnings;
    property Trace_Level: int read GetTraceLevel write SetTraceLevel;
    property PercentDone: integer read GetPercentDone;
    property OnProgressReport: TNotifyEvent read FOnProgressReport write FOnProgressReport;
    property OnWarning: TWarningEvent read FOnWarning write FOnWarning;
  end;

  {TJPEGCompressor
   ---------------

   This is the base class for all JPEG Compression objects. It creates the IDG Library
   compression object and performs all compression of bitmaps and metafiles. However,
   the access to the JPEG output device is abstract and must be provided by a
   descendant class}

   TBitmapResolution = (bmDefault,   {que cera cera}
                        bm16Colour,  {16 Colour VGA Resolution}
                        bm256Colour, {256 Colour Resolution}
                        bm24bit);    {Full Colour}
  {$IFDEF VER80}
  TImageSize = longint;
  {$ELSE}
  TImageSize = DWORD;
  {$ENDIF}

  TJPEGCompressor = class(TJPEGBase)
  private
    FComment: string;
    FProgressiveJPEG: boolean;
    FWriteAllTables: boolean;
    FQuality: int;
    FGrayscaleOutput: boolean;
    FOnWriteMarkers: TNotifyEvent;
    function GetNextOut: JOCTET_PTR;
    function GetFreeIn: localsize_t;
    procedure SetNextOut(value: JOCTET_PTR);
    procedure SetFreeIn(value: localsize_t);
    procedure SetQuality(Value: int);
    procedure CreateJPEGObject(err: jpeg_error_mgr_ptr);  override;
{$IFDEF CBBUILDER3OR4OR5}
  function Getcinfoinput_components: int;
  function Getcinfoimage_width: JDIMENSION;
  function Getcinfoinput_gamma: double;
  function Getcinfodata_precision: int;
  function Getcinfojpeg_color_space: J_COLOR_SPACE;
  function Getcinfodct_method: J_DCT_METHOD;
  function Getcinfooptimize_coding: boolean;
  function Getcinforestart_interval: cardinal;
  function Getcinforestart_in_rows: int;
  function Getcinfosmoothing_factor: int;
  function Getcinfowrite_JFIF_header: boolean;
  function Getcinfodensity_unit: UINT8;
  function GetcinfoX_density: UINT16;
  function GetcinfoY_Density: UINT16;
  function Getcinfowrite_Adobe_marker: boolean;
  function Getcinfoimage_height: JDIMENSION;
  procedure Setcinfoinput_components(Value: int);
  procedure Setcinfoimage_width(Value: JDIMENSION);
  procedure Setcinfoinput_gamma(Value: double);
  procedure Setcinfodata_precision(Value: int);
  procedure Setcinfojpeg_color_space(Value: J_COLOR_SPACE);
  procedure Setcinfodct_method(Value: J_DCT_METHOD);
  procedure Setcinfooptimize_coding(Value: boolean);
  procedure Setcinforestart_interval(Value: cardinal);
  procedure Setcinforestart_in_rows(Value: int);
  procedure Setcinfosmoothing_factor(Value: int);
  procedure Setcinfowrite_JFIF_header(Value: boolean);
  procedure Setcinfodensity_unit(Value: UINT8);
  procedure SetcinfoX_density(Value: UINT16);
  procedure SetcinfoY_Density(Value: UINT16);
  procedure Setcinfowrite_Adobe_marker(Value: boolean);
  procedure Setcinfoimage_height(Value: JDIMENSION);
  {$ENDIF}
   protected
    cinfo: jpeg_compress_struct;
    procedure InitDestination; virtual; abstract;
    function EmptyOutputBuffer: boolean; virtual; abstract;
    procedure TermDestination; virtual; abstract;
    procedure SetColorSpace(value: J_COLOR_SPACE);
    procedure Bitmap2DIB(Bitmap: TBitmap; Resolution: TBitmapResolution;
                                                                var BitMapInfo, bits);
    procedure GetBitmapInfoHeader(Bitmap: HBitmap; Resolution: TBitmapResolution;
                                                      var BitmapInfoHeader: TBitmapInfoHeader);
    procedure GetDIBSizes(Bitmap: HBITMAP; Resolution: TBitmapResolution; var InfoHeaderSize: Integer;
                         var ImageSize: TImageSize);
    procedure WriteDIBitmap(const BitmapInfo: TBitmapInfo; bits: PChar);
    procedure WriteBitmap(bitmap: TBitMap);
    procedure WriteStretchedBitmap(bitmap: TBitmap; width, height: integer);
    procedure WriteMetaFile(metafile: TMetaFile; width, height: longint);
    property next_out: JOCTET_PTR read GetNextOut write SetNextOut;
    property free_in: localsize_t read GetFreeIn write SetFreeIn;
  {$IFDEF CBBUILDER3OR4OR5}
    property InputComponents: int read Getcinfoinput_components write Setcinfoinput_components;
    property ImageWidth: JDIMENSION read Getcinfoimage_width write Setcinfoimage_width;
    property ImageHeight: JDIMENSION read Getcinfoimage_height write Setcinfoimage_height;
  {$ELSE}
    property InputComponents: int read cinfo.input_components;
    property ImageWidth: JDIMENSION read cinfo.image_width write cinfo.image_width;
    property ImageHeight: JDIMENSION  read cinfo.image_height write cinfo.image_height;
  {$ENDIF}
  public
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddQuantTable(which_tbl: int;
				       const basic_table: uint_ptr;
				       scale_factor: int;
				       force_baseline: boolean);
    procedure WriteMarker(Marker: int; const buf; Count: uint);
    property GrayscaleOutput: boolean read FGrayscaleOutput write FGrayscaleOutput;
    property Comment: string read FComment write FComment;
    property Quality: int read FQuality write SetQuality default DefaultQuality;
    property ProgressiveJPEG: boolean read FProgressiveJPEG write FProgressiveJPEG;
    {$IFDEF CBBUILDER3OR4OR5}
    property InputGamma: double read Getcinfoinput_gamma write Setcinfoinput_gamma;
    property DataPrecision: int read Getcinfodata_precision write Setcinfodata_precision;
    property OutputColorSpace: J_COLOR_SPACE read Getcinfojpeg_color_space write Setcinfojpeg_color_space;
    property DCTMethod: J_DCT_METHOD read Getcinfodct_method write Setcinfodct_method;
    property OptimizeCoding: boolean read Getcinfooptimize_coding write Setcinfooptimize_coding;
    property RestartInterval: cardinal read Getcinforestart_interval write Setcinforestart_interval;
    property RestartInRows: int read Getcinforestart_in_rows write Setcinforestart_in_rows;
    property SmoothingFactor: int read Getcinfosmoothing_factor write Setcinfosmoothing_factor;
    property WriteJFIFHeader: boolean read Getcinfowrite_JFIF_header write Setcinfowrite_JFIF_header;
    property DensityUnit: UINT8 read Getcinfodensity_unit write Setcinfodensity_unit;
    property X_Density: UINT16 read GetcinfoX_density write SetcinfoX_density;
    property Y_Density: UINT16 read GetcinfoY_Density write SetcinfoY_Density;
    property WriteAdobeMarker: boolean read Getcinfowrite_Adobe_marker write Setcinfowrite_Adobe_marker;
    {$ELSE}
    property InputGamma: double read cinfo.input_gamma write cinfo.input_gamma;
    property DataPrecision: int read cinfo.data_precision write  cinfo.data_precision;
    property OutputColorSpace: J_COLOR_SPACE read cinfo.jpeg_color_space;
    property DCTMethod: J_DCT_METHOD read cinfo.dct_method write cinfo.dct_method;
    property OptimizeCoding: boolean read cinfo.optimize_coding write cinfo.optimize_coding;
    property RestartInterval: cardinal read cinfo.restart_interval write cinfo.restart_interval;
    property RestartInRows: int read cinfo.restart_in_rows write cinfo.restart_in_rows;
    property SmoothingFactor: int read cinfo.smoothing_factor write cinfo.smoothing_factor;
    property WriteJFIFHeader: boolean read cinfo.write_JFIF_header
                                      write cinfo.write_JFIF_header;
    property DensityUnit: UINT8 read cinfo.density_unit write cinfo.density_unit;
    property X_Density: UINT16 read cinfo.X_density write cinfo.X_density;
    property Y_Density: UINT16 read cinfo.Y_density write cinfo.Y_density;
    property WriteAdobeMarker: boolean read cinfo.write_Adobe_marker
                                       write cinfo.write_Adobe_marker;
    {$ENDIF}
    property WriteAllTables: boolean read FWriteAllTables write FWriteAllTables
                                                          default true;
    property OnWriteMarkers: TNotifyEvent read FOnWriteMarkers write FOnWriteMarkers;
  end;

  {TJPEGDecompressor
   ---------------

   This is the base class for all JPEG Decompression objects. It creates the IDG Library
   decompression object and performs all decompression of JPEG images to windows
   bitmaps . However, the access to the JPEG input device is abstract and must be
   provided by a  descendant class}

  const
    DefaultColoursIn8bitMode = 64;

  type
  TJPEGCommentEvent = procedure(sender: TJPEGBase; comment: PChar) of object;
  TJPEGMarkerEvent = procedure(sender: TJPEGBase; Marker: int; var done: boolean) of object;

  TJPEGOutputType = (jp24bit,jp8bit,jp4bit,jpGrayscale);

  TJPEGDecompressor = class(TJPEGBase)
  private
    FOnJPEGComment: TJPEGCommentEvent;
    FDCT_METHOD: J_DCT_METHOD;
    FDoFancyUpSampling: boolean;
    FDoBlockSmoothing: boolean;
    FGrayScaleOutput: boolean;
    FTwoPassQuantize: boolean;
    FDitherMode: J_DITHER_MODE;
    FColoursIn8bitMode: integer;
    FOnJPEGMarker: TJPEGMarkerEvent;
    FCMYKInvert: boolean;
    procedure CreateJPEGObject(err: jpeg_error_mgr_ptr); override;
    function GetNextInputByte: JOCTET_PTR;
    function GetBytesInBuffer: localsize_t;
    procedure SetNextInputByte(value: JOCTET_PTR);
    procedure SetBytesInBuffer(value: localsize_t);
    function HandleJPEGComment: boolean;
    function HandleAPPMarker: boolean;
  {$IFDEF CBBUILDER3OR4OR5}
  function Getcinfoout_color_space: J_COLOR_SPACE;
  function Getcinfoscale_num: cardinal;
  function Getcinfoscale_denom: cardinal;
  function Getcinfooutput_gamma: double;
  function Getcinfoquantize_colors: boolean;
  function Getcinfodesired_number_of_colors: int;
  function Getcinfocolormap: JSAMPARRAY;
  function Getcinfoactual_number_of_colors: int;
  function Getcinfoimage_width: JDIMENSION;
  function Getcinfoimage_height: JDIMENSION;
  function Getcinfojpeg_color_space: J_COLOR_SPACE;
  function Getcinfosaw_JFIF_marker: boolean;
  function Getcinfodensity_unit: UINT8;
  function GetcinfoX_density: UINT16;
  function GetcinfoY_density: UINT16;
  function GetcinfoAdobe_transform: UINT8;
  function Getcinfoenable_1pass_quant: boolean;
  function Getcinfoenable_external_quant: boolean;
  function Getcinfoenable_2pass_quant: boolean;
  function Getcinfooutput_height: JDIMENSION;
  function Getcinfooutput_width: JDIMENSION;
  procedure Setcinfoout_color_space(Value: J_COLOR_SPACE);
  procedure Setcinfoscale_num(Value: cardinal);
  procedure Setcinfoscale_denom(Value: cardinal);
  procedure Setcinfooutput_gamma(Value: double);
  procedure Setcinfoquantize_colors(Value: boolean);
  procedure Setcinfodesired_number_of_colors(Value: int);
  procedure Setcinfocolormap(Value: JSAMPARRAY);
  procedure Setcinfoactual_number_of_colors(Value: int);
  procedure Setcinfoimage_width(Value: JDIMENSION);
  procedure Setcinfoimage_height(Value: JDIMENSION);
  procedure Setcinfojpeg_color_space(Value: J_COLOR_SPACE);
  procedure Setcinfosaw_JFIF_marker(Value: boolean);
  procedure Setcinfodensity_unit(Value: UINT8);
  procedure SetcinfoX_density(Value: UINT16);
  procedure SetcinfoY_density(Value: UINT16);
  procedure SetcinfoAdobe_transform(Value: UINT8);
  procedure Setcinfoenable_1pass_quant(Value: boolean);
  procedure Setcinfoenable_external_quant(Value: boolean);
  procedure Setcinfoenable_2pass_quant(Value: boolean);
  procedure Setcinfooutput_height(Value: JDIMENSION);
  procedure Setcinfooutput_width(Value: JDIMENSION);
  {$ENDIF}
  protected
    cinfo: jpeg_decompress_struct;
    procedure InitSource; virtual; abstract;
    function FillInputBuffer: boolean; virtual; abstract;
    procedure SkipInputBytes(num_bytes : long); virtual; abstract;
    function ResyncToRestart(desired: int): boolean; virtual; abstract;
    procedure TermSource; virtual; abstract;
    function DoJPEGComment(comment: PChar): boolean; virtual;
    procedure ReadDIBitmap(var BitMapInfo: TBitMapInfo; OutputType: TJPEGOutputType;
                                       bits: pointer);
    function ReadBitmap: TBitmap;
    procedure ReadWinBitmap(var Bitmap: HBITMAP; var Palette: HPALETTE);
    procedure ReadHeader; virtual;
    procedure ReadDIBtoStream(Destination: TStream;
                                                   OutputType: TJPEGOutputType);


    {The following are for use by input manager functions}

    property NextInputByte: JOCTET_PTR read GetNextInputByte write SetNextInputByte;
    property BytesInBuffer: localsize_t read GetBytesInBuffer write SetBytesInBuffer;

    {The following are set to defaults by jpeg_Read_Header and set by ReadHeader}

    {$IFDEF CBBUILDER3OR4OR5}
    property OutputColorSpace: J_COLOR_SPACE read Getcinfoout_color_space write Setcinfoout_color_space;
    property ScaleNum: cardinal read Getcinfoscale_num write Setcinfoscale_num;
    property ScaleDenom: cardinal read Getcinfoscale_denom write Setcinfoscale_denom;
    property OutputGamma: double read Getcinfooutput_gamma write Setcinfooutput_gamma;
    property QuantizeColors: boolean read Getcinfoquantize_colors write Setcinfoquantize_colors;
    property NumColorsDesired: int read Getcinfodesired_number_of_colors write Setcinfodesired_number_of_colors;
    property ColorMap: JSAMPARRAY read Getcinfocolormap write Setcinfocolormap;
    property ActualColorsInMap: int read Getcinfoactual_number_of_colors write Setcinfoactual_number_of_colors;
    {$ELSE}
    property OutputColorSpace: J_COLOR_SPACE read cinfo.out_color_space;
    property ScaleNum: cardinal read cinfo.scale_num write cinfo.scale_num;
    property ScaleDenom: cardinal read cinfo.scale_denom write cinfo.scale_denom;
    property OutputGamma: double read cinfo.output_gamma write cinfo.output_gamma;
    property QuantizeColors: boolean read cinfo.quantize_colors write cinfo.quantize_colors;
    property NumColorsDesired: int read cinfo.desired_number_of_colors
                                   write cinfo.desired_number_of_colors;
    property ColorMap: JSAMPARRAY read cinfo.colormap write cinfo.colormap;
    property ActualColorsInMap: int read cinfo.actual_number_of_colors
                                    write cinfo.actual_number_of_colors;
    {$ENDIF}
  public
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBitmapInfoSize(OutputType: TJPEGOutputType): longint;
    function GetDIBitsSize(OutputType: TJPEGOutputType): longint;
    function GetByte: JOCTET;
    property OnJPEGComment: TJPEGCommentEvent read FOnJPEGComment write FOnJPEGComment;
    property OnJPEGMarker: TJPEGMarkerEvent read FOnJPEGMarker write FOnJPEGMarker;
    property GrayScaleOutput: boolean read FGrayScaleOutput write FGrayScaleOutput;

    {The following are valid after a call to ReadHeader}
    {$IFDEF CBBUILDER3OR4OR5}
    property Width: JDIMENSION read Getcinfoimage_width write Setcinfoimage_width;
    property Height: JDIMENSION read Getcinfoimage_height write Setcinfoimage_height;
    property ColorSpace: J_COLOR_SPACE read Getcinfojpeg_color_space write Setcinfojpeg_color_space;
    property JFIFMarkerPresent: boolean read Getcinfosaw_JFIF_marker write Setcinfosaw_JFIF_marker;
    property DensityUnit: UINT8 read Getcinfodensity_unit write Setcinfodensity_unit;
    property X_Density: UINT16 read GetcinfoX_density write SetcinfoX_density;
    property Y_Density: UINT16 read GetcinfoY_density write SetcinfoY_density;
    property AdobeTransform: UINT8 read GetcinfoAdobe_transform write SetcinfoAdobe_transform;
   {$ELSE}
    property Width: JDIMENSION read cinfo.image_width;
    property Height: JDIMENSION  read cinfo.image_height;
    property NumComponents: int read cinfo.num_components;
    property ColorSpace: J_COLOR_SPACE read cinfo.jpeg_color_space;
    property JFIFMarkerPresent: boolean read cinfo.saw_JFIF_marker;
    property DensityUnit: UINT8 read cinfo.density_unit;           {from JFIF Marker}
    property X_Density: UINT16 read cinfo.X_density;               {from JFIF Marker}
    property Y_Density: UINT16 read cinfo.Y_density;               {from JFIF Marker}
    property AdobeMarkerPresent: boolean read cinfo.saw_Adobe_marker;
    property AdobeTransform: UINT8 read cinfo.Adobe_transform;
   {$ENDIF}

    property TwoPassQuantize: boolean read FTwoPassQuantize
                                      write FTwoPassQuantize default true;
    property ColoursIn8bitMode: integer read FColoursIn8bitMode write FColoursIn8bitMode
                                            default DefaultColoursIn8bitMode;
    property DitherMode: J_DITHER_MODE read FDitherMode write FDitherMode
                                                              default JDITHER_FS;
    property DCTMethod: J_DCT_METHOD read FDCT_METHOD write FDCT_METHOD default JDCT_DEFAULT;
    property DoFancyUpSampling: boolean read FDoFancyUpSampling
                                        write FDoFancyUpSampling default true;
    property DoBlockSmoothing: boolean read FDoBlockSmoothing
                                        write FDoBlockSmoothing default true;

    {The following are used only in buffered image mode}
    {$IFDEF CBBUILDER3OR4OR5}
    property Enable1PassQuant: boolean read Getcinfoenable_1pass_quant write Setcinfoenable_1pass_quant;
    property EnableExternalQuant: boolean read Getcinfoenable_external_quant write Setcinfoenable_external_quant;
    property Enable2PassQuant: boolean read Getcinfoenable_2pass_quant write Setcinfoenable_2pass_quant;
    {$ELSE}
    property Enable1PassQuant: boolean read cinfo.enable_1pass_quant
                                       write cinfo.enable_1pass_quant;
    property EnableExternalQuant: boolean read cinfo.enable_external_quant
                                          write cinfo.enable_external_quant;
    property Enable2PassQuant: boolean read cinfo.enable_2pass_quant
                                       write cinfo.enable_2pass_quant;
    {$ENDIF}

    {The following are valid after ReadHeader has been called}

    {$IFDEF CBBUILDER3OR4OR5}
    property OutputHeight: JDIMENSION read Getcinfooutput_height write Setcinfooutput_height;
    property OutputWidth: JDIMENSION read Getcinfooutput_width write Setcinfooutput_width;
    {$ELSE}
    property OutputHeight: JDIMENSION read cinfo.output_height;
    property OutputWidth: JDIMENSION read cinfo.output_width;
    {$ENDIF}
    property CMYKInvert: boolean read FCMYKInvert write FCMYKInvert;
  end;

  {TJPEGStreamCompressor
   ---------------------

   This is a TJPEGCompressor where the output JPEG device is a Delphi TStream}

  TJPEGStreamCompressor = class(TJPEGCompressor)
  private
    FStream: TStream;
    FBuffer: pointer;
    FBufSize: integer;
    FDefaultCompressor: boolean;
    procedure SetBufSize(Value: integer);
  protected
    procedure InitDestination; override;
    function EmptyOutputBuffer: boolean; override;
    procedure TermDestination; override;
    procedure OpenStream(Stream: TStream);
    procedure CloseStream;
  public
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SavePictureToStream(Picture: TPicture; Stream: TStream);
    procedure SaveStretchedPictureToStream(Picture: TPicture; width,height: integer;
                          Stream: TStream);
    procedure SaveBitMapToStream(bitmap: TBitmap; Stream: TStream);
    procedure SaveStretchedBitMapToStream(bitmap: TBitmap; width,height: integer;
                     Stream: TStream);
    procedure SaveDIBitmapToStream(Stream: TStream; const BitmapInfo: TBitmapInfo;
                                    bits: PChar);
    procedure SaveMetaFileToStream(metafile: TMetafile; Stream: TStream; width, height: integer);
    property BufSize: integer read FBufSize write SetBufSize default DefaultBufSize;
    property DefaultCompressor: boolean read FDefaultCompressor write FDefaultCompressor;
  end;

  {TJPEGStreamDecompressor
   -----------------------
   This is a TJPEGDecompressor where the input JPEG device is a Delphi TStream.}

  TJPEGStreamDecompressor = class(TJPEGDecompressor)
  private
    FStream: TStream;
    FBuffer: PChar;
    FBufSize: integer;
    FDefaultDecompressor: boolean;
  protected
    procedure InitSource; override;
    function FillInputBuffer: boolean; override;
    procedure SkipInputBytes(num_bytes : long); override;
    function ResyncToRestart(desired: int): boolean; override;
    procedure SetBufSize(Value: integer);
    procedure TermSource; override;
  public
    procedure OpenStream(Stream: TStream);
    procedure CloseStream;
    constructor create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConvertToDIB(Source, Destination: TStream; OutputType: TJPEGOutputType);
    procedure LoadPictureFromStream(Picture: TPicture; Stream: TStream);
    procedure LoadPictureFromResource(Picture: TPicture; Instance: THandle; const ResName: string);
    procedure LoadPictureFromResID(Picture: TPicture; Instance: THandle; ResID: Integer);
    function ReadBitMapFromStream(Stream: TStream): TBitmap;
    procedure ReadDIBitmapFromStream(Stream: TStream;
                                       var BitMapInfo: TBitMapInfo;
                                       OutputType: TJPEGOutputType;
                                       var bits: THandle);
    property BufSize: integer read FBufSize write SetBufSize default DefaultBufSize;
    property DefaultDecompressor: boolean read FDefaultDecompressor write FDefaultDecompressor;
  end;

{TJPEGFileDecompressor
---------------------

Properties:

ColoursIn8bitMode: integer;

Although the compressor can create a 256 colour image for display on 256 colour
adapters, this does not always give the best results. It may cause a colour cast
on black and white images and does not give any room in the adapter's colour
palette for colours in background images. The default is 64 but may be adjusted
to generate more or less colours.

DCTMethod: J_DCT_METHOD;

Selects the algorithm used for the DCT quantisation step.  Choices are as for
compression.

DitherMode: J_DITHER_MODE

Selects color dithering method.  Supported values are:

	JDITHER_NONE	no dithering: fast, very low quality
	JDITHER_ORDERED	ordered dither: moderate speed and quality
	JDITHER_FS	Floyd-Steinberg dither: slow, high quality

Default is JDITHER_FS.  (At present, ordered dither is implemented only in the
single-pass, standard-colormap case.  If you ask for ordered dither when
two_pass_quantize is TRUE or when you supply an external color map, you'll get F-S
dithering.)

DoBlockSmoothing: boolean

If TRUE, interblock smoothing is applied in early stages of decoding progressive
JPEG files; if FALSE, not.  Default is TRUE.  Early progression stages look
"fuzzy" with smoothing, "blocky" without.

DoFancyUpSampling: boolean

If TRUE, do careful upsampling of chroma components.  If FALSE, a faster but
sloppier method is used.  Default is TRUE.  The visual impact of the sloppier
method is often very small.

GrayScaleOutput: boolean

If true then the image is converted to a 64 level grayscale image on decoding.

TwoPassQuantize: boolean

If TRUE, an extra pass over the image is made to select a custom colour map for
the image.  This usually looks a lot better than the one-size-fits-all colourmap
that is used otherwise.  Default is TRUE.  Ignored when the application supplies
its own colour map.

Trace_Level: int;

Controls the level of trace information reported. (set >= 3 to see more than the
first warning message).

CMYKInvert: boolean;

Adobe CMYK images used inverted CMYK values and this approach is assumed by default.
To process a "positive" CMYK encoded JPEG, set CMYKInvert to false;

Methods:

procedure LoadPictureFromFile(Picture: TPicture; const FileName: string);

Opens the file identified by FileName which is assumed to contain a JPEG image in
the JFIF format. This is decoded into a windows bitmap and loaded into the
supplied Picture object.


procedure ConvertToDIB(Source, Destination: TStream; OutputType: TJPEGOutputType);

Converts a JPEG compressed image Windows Device Independent bitmap contained in
the Source stream to a Windows Device Independent bitmap written to the
destination stream.

The format of the DIB is determined by the setting of OutputType. This may be
either:

  TJPEGOutputType = (jp24bit, (24 bit bitmap)
		     jp8bit,  (256 colour bitmap)
		     jp4bit,  (16 colour bitmap)
		     jpGrayscale); (grayscale)


procedure LoadPictureFromStream(Picture: TPicture; Stream: TStream);

The source stream is assumed to contain a JPEG image in the JFIF format. This is
decoded into a windows bitmap and loaded into the supplied Picture object.

function ReadBitMapFromStream(Stream: TStream): TBitmap;

The source stream is assumed to contain a JPEG image in the JFIF format. This is
decoded into a windows bitmap and returned as a TBitmap object.


procedure ReadDIBitmapFromStream(Stream: TStream;
                                       var BitMapInfo: TBitMapInfo;
                                       OutputType: TJPEGOutputType;
                                       var bits: THandle);

The source stream is assumed to contain a JPEG image in the JFIF format. This is
decoded into a windows device independent bitmap and returned in the memory block
given by bits. The output type is determined as above and the information 
describing the bitmap size, resolution and colour map is returned in the Windows
APS BitMapInfo structure. 

Events:

OnJPEGComment: TJPEGCommentEvent

  TJPEGCommentEvent = procedure(sender: TJPEGBase; comment: PChar) of object;

This event occurs when a comment is found in the JPEG compressed image. The
comment is extracted and provided as a parameter to the event handler.

OnJPEGMarker: TJPEGMarkerEvent

  TJPEGMarkerEvent = procedure(sender: TJPEGBase; Marker: int; var Done: boolean)
of object;

This event occurs when any other JPEG marker is found in the JPEG image (except
for APP1 the JFIF marker). The marker is identified by the Marker parameter (range
1..13), and the response method may read successive bytes from the stream after
the marker by calling the GetByte method (this is a parameterless function that 
returns a single byte value). Note that marker processing is application specific.

If the marker is not processed, then the response method should return with Done 
set to false. The marker text will then be skipped, otherwise, Done should be set
to true to indicate that the response method has handled the marker itself.

OnProgessReport: TNotifyEvent

Called regularly during compression to enable a progress report to be maintained. 
The PercentDone integer property (read only) may be consulted to find out the
percentage so far compressed.}

  TJPEGFileDecompressor = class(TJPEGStreamDecompressor)
  public
    procedure LoadPictureFromFile(Picture: TPicture; const FileName: string);
  published
    property Warnings;
    property Trace_Level;
    property PercentDone;
    property ColoursIn8bitMode;
    property GrayScaleOutput;
    property OnJPEGComment;
    property OnJPEGMarker;
    property TwoPassQuantize;
    property DitherMode;
    property DefaultDecompressor;
    property DCTMethod;
    property DoFancyUpSampling;
    property DoBlockSmoothing;
    property OnProgressReport;
    property OnWarning;
    property CMYKInvert;
  end;

{TJPEGFileCompressor
------------------

Properties:

Comment: string

This comment is included in the compressed JPEG image. A typical use is to include 
a copyright message.

DCTMethod: J_DCT_METHOD;

Selects the algorithm used for the DCT quantisation step.  Choices are:
	JDCT_ISLOW: slow but accurate integer algorithm
	JDCT_IFAST: faster, less accurate integer method
	JDCT_FLOAT: floating-point method
The FLOAT method is very slightly more accurate than the ISLOW method, but may
give different results on different machines due to varying roundoff behaviour.  
The integer methods should give the same results on all machines.  On machines
with sufficiently fast FP hardware, the floating-point method may also be the 
fastest.  The IFAST method is considerably less accurate than the other two; its
use is not recommended if high quality is a concern.

DensityUnit: UINT8;
X_Density: UNIT16;
Y_Density: UNIT16;

The resolution information to be written into the JFIF marker; not used otherwise.  
density_unit may be 0 for unknown, 1 for dots/inch, or 2 for dots/cm.  The default 
values are 0,1,1 indicating square pixels of unknown size.

GrayscaleOutput: boolean;

If true then the image is converted to a grayscale image when written out to the 
JPEG file.

OptimizeCoding: boolean;

TRUE causes the compressor to compute optimal Huffman coding tables for the image.  
This requires an extra pass over the data and therefore costs a good deal of space
and time.  The default is FALSE, which tells the compressor to use the supplied or 
default Huffman tables.  In most cases optimal tables save only a few percent of 
file size compared to the default tables.

ProgressiveJPEG: boolean;

Progressive JPEG rearranges the stored data into a series of scans of increasing 
quality.  In situations where a JPEG file is transmitted across a slow
communications link, a decoder can generate a low-quality image very quickly from 
the first scan, then gradually improve the displayed quality as more scans are 
received.  The final image after all scans are complete is identical to that of a 
regular (sequential) JPEG file of the same quality setting.  Progressive JPEG
files are often slightly smaller than equivalent sequential JPEG files, but the
possibility of incremental display is the main reason for using progressive JPEG.

When this property is set to true a progressive JPEG file is generated using a 
default scan script generated by the JPEG library.

Quality: int;

JPEG quantisation tables appropriate for the indicated quality setting are
generated.  The quality value is expressed on a 0..100 scale. 

RestartInterval: Cardinal;
RestartInRows: int;

To emit restart markers in the JPEG file, set one of these nonzero. Set
RestartInterval to specify the exact interval in MCU blocks. Set RestartInRows to 
specify the interval in MCU rows.  (If RestartInRows is not 0, then
RestartInterval is set after the image width in MCUs is computed.)  Defaults are 
zero (no restarts).


Smoothing Factor: int;

If non-zero, the input image is smoothed; the value should be 1 for minimal 
smoothing to 100 for maximum smoothing.  The default is zero.

Trace_Level: int;

Controls the level of trace information reported. (set >= 3 to see more than the 
first warning message).

WriteAllTables: boolean;

Set to True (default) to ensure that a proper JPEG Interchange stream is written.
If false, then the quantisation and Huffman tables are not written to the JPEG 
file. This makes for a smaller file but creates difficulties for the decompressor 
unless some other way is found to transfer these tables.

WriteJFIFHeader: boolean;

If true (default) then a JFIF APP0 marker is emitted. The decompressor will then
recognise it as a JFIF compatible stream.


Methods:

procedure SavePictureToFile(Picture: TPicture; const FileName: string);

Provided that the Picture holds a Bitmap or a Metafile image, it will be
compressed to a JPEG and written out to the file "FileName".

procedure SaveStretchedPictureToFile(Picture: TPicture; width, height: integer;
                           const FileName: string);

Provided that the Picture holds a Bitmap or a Metafile image, it will be stretched
to the specified width and height, and then compressed to a JPEG and written out
to the file "FileName".

procedure SaveBitmapToFile(bitmap: TBitmap; const FileName: string);

The provided Bitmap is compressed to a JPEG and written out to the file "FileName".

procedure SaveStretchedBitmapToFile(bitmap: TBitmap; width, height: integer;
                     const FileName: string);

The provided Bitmap is stretched to the specified width and height, and then
compressed to a JPEG and written out to the file "FileName".

procedure SaveMetafileToFile(metafile: TMetafile; width, height: integer;
                           const FileName: string);

The metafile is compressed to a JPEG and written out to the file "FileName". Note
that the height and width of the required image (in pixels) must also be provided.

procedure SavePictureToStream(Picture: TPicture; Stream: TStream);

Provided that the Picture holds a Bitmap or a Metafile image, it will be
compressed to a JPEG and written out to the provided stream.

procedure SaveBitMapToStream(bitmap: TBitmap; Stream: TStream);

The bitmap is compressed to a JPEG and written out to the provided stream.

procedure SaveDIBitmapToStream(Stream: TStream; const BitmapInfo: TBitmapInfo;
                                bits: PChar);

The device independent bitmap held in the memory block given by "bits", is
compressed to a JPEG and written out to the provided stream. Note that the
BitmapInfo structure is defined by the Windows API and defines the size and
resolution of the bitmap and may also contain a colour map.

procedure SaveMetaFileToStream(metafile: TMetafile; Stream: TStream; width,
height: longint);

The metafile is compressed to a JPEG and written out to the provided stream. Note
that the height and width of the required image (in pixels) must also be provided.

procedure WriteMarker(Marker: int; const buf; Count: uint);

This method may be called from the event "OnWriteMarkers" to write out data with a
JPEG APPn marker. The actual marker is identified by the Marker parameter (e.g. to
write out an APP1 marker, set Marker to one). The value data written out is
contained in buf and contains Count bytes.

Events:

OnProgessReport: TNotifyEvent

Called regularly during compression to enable a progress report to be maintained.
The PercentDone integer property (read only) may be consulted to find out the
percentage so far compressed.

OnWriteMarkers: TNotifyEvent

See above discussion of WriteMarker Method.
}

TJPEGFileCompressor = class(TJPEGStreamCompressor)
  public
    procedure SavePictureToFile(Picture: TPicture; const FileName: string);
    procedure SaveStretchedPictureToFile(Picture: TPicture; width, height: integer;
                           const FileName: string);
    procedure SaveBitmapToFile(bitmap: TBitmap; const FileName: string);
    procedure SaveStretchedBitmapToFile(bitmap: TBitmap; width, height: integer;
                     const FileName: string);
    procedure SaveMetafileToFile(metafile: TMetafile; width, height: integer;
                           const FileName: string);
  published
    property Warnings;
    property Trace_Level;
    property PercentDone;
    property GrayscaleOutput;
    property Comment;
    property Quality;
    property InputGamma;
    property ProgressiveJPEG;
    property DCTMethod;
    property OptimizeCoding;
    property RestartInterval;
    property RestartInRows;
    property SmoothingFactor;
    property WriteJFIFHeader;
    property DensityUnit;
    property X_Density;
    property Y_Density;
    property WriteAllTables;
    property DefaultCompressor;
    property OnProgressReport;
    property OnWriteMarkers;
    property OnWarning;
  end;

{TJPEGBitmap
 -----------

 This class exists purely to support registration of the JPEG compression/decompression
 classes with the Delphi Graphics unit. At initialisation time, RegisterFileFormat is
 called to register the .jpg extension and the TJPEGBitmap object as the TGraphic
 descendant that supports this extension and the implied file format.}

TJPEGBitmap = class(TBitmap)
private
  FSaveAsBitmap: boolean;
  FDecompressor: TJPEGStreamDecompressor;
  FCompressor: TJPEGStreamCompressor;
{$IFDEF DELPHI3ORLATER}
  FProgressEvent: TNotifyEvent;
  procedure HandleDecompressOnProgress(Sender: TObject);
  procedure HandleCompressOnProgress(Sender: TObject);
{$ENDIF}
public
  procedure LoadFromStream(Stream: TStream); override;
  procedure SaveToStream(Stream: TStream); override;
  procedure SaveToFile(const FileName: string); override;
end;

{ReSizeBitmap is a utility function to resize a bitmap. The bitmap is copied
 to a new TBitmap object and resized to the specified width and height using the
 Windows StretchBlt API function, and returned as the function result. }

function ReSizeBitmap(bitmap: TBitmap; width, height: integer): TBitmap;

{CropBitmap is a utility function that is used to copy a portion of an existing
 bitmap (given by the rectangle "Clip" to a new bitmap returned as the result of the
 function. The newly created bitmap can also be resized. "width and "height" specify
 the width and height of the new bitmap. If the bitmap is to be the same size as the
 Clip, then with should be set to Clip.Right-Clip.Left and height to Clip.Bottom-Clip.Top.}


function CropBitmap(bitmap: TBitmap; width, height: integer; Clip: TRect): TBitmap;

{MetaFileToBitmap is a utility function that renders a metafile using the current
 display device and returns the result as a bitmap}

function MetaToBitmap(metafile: TMetaFile; Width, Height: longint): TBitmap;

{DSTART}
{$IFDEF DELPHI_REQUIRED}

const UseIsIllegal: boolean = false;
{$ENDIF}
{DEND}

implementation

uses SysUtils, Dialogs, Forms, 
     {$IFDEF DELPHI6ORLATER}
     math;
     {$ELSE}
     macros;
     {$ENDIF}

const
     sNoImage        = 'The Image Property is empty!';
     sNoJPEGImage    = 'cannot save a picture that is neither a bitmap nor metafile';
     sReadOverFlow   = 'Read beyond end of JPEG source';
     sBadBitCount    = 'Unable to compress at %d bit resolution';
     sNoDIB          = 'Cannot obtain a Device Independent Bitmap';
     sOutputMustBeGrayscale = 'Image is Grayscale but colour output requested';
     sUserAbort      = 'User Interrupt';
     sPlayMetaFailed = 'Unable to render metafile as a bitmap - PlayEnhMetaFile returned %d';
     sCantSetBufSize = 'Cannot change buffer size while buffer is in use';
     sDecompressing  = 'Decompressing Image';
     sCompressing    = 'Compressing Image';
     sOpening        = 'Opening JPEG Image';
     sClosing        = 'Decompression completed';

     DefaultJPEGDecompressor: TJPEGStreamDecompressor = nil;
     DefaultJPEGCompressor: TJPEGStreamCompressor = nil;

     GrayscaleResolution = 64;   {levels of grey}

{IncPointer
==============

Utility function used to increment a pointer by a longint}

{$IFNDEF WIN32}
{Windows magic number __AHSHIFT}

procedure __AHSHIFT; far; external 'KERNEL' index 113;

procedure IncPointer(var P: PChar; Ofs: Longint); assembler;
asm
        Mov     AX,Ofs.Word[0]
        Mov     DX,Ofs.Word[2]     {DX,AX is offset to add to P}
        Les     DI,P
        Add     AX,ES:[DI].Word[0] {Add segment offset}
        Adc     DX,0               {Add carry to segment selector}
        Mov     CX,OFFSET __AHSHIFT
        Shl     DX,CL              {Shift selector by magic number}
        Add     DX,ES:[DI].Word[2] {Inc selector value}
        Mov     ES:[DI].Word[0],AX
        Mov     ES:[DI].Word[2],DX
end;

{$ENDIF}

{DSTART}
{$IFDEF DELPHI_REQUIRED}

{IsDelphiRunning
 ===============

 Provides a check on whether or not Delphi is running for the Shareware version
 of this module.}

{$IFDEF VER170}
var Proof1, Proof2: boolean;

function EnumWindowsProc(Handle: HWND; Param: LParam): boolean; stdcall;
var ClassNameBuffer: array [0..256] of char;
    WTextBuffer: array [0..1024] of char;
    ClassName: string;
begin
  if (GetClassName(Handle,@ClassNameBuffer,sizeof(ClassNameBuffer)) > 0) and
     (GetWindowText(Handle,@WTextBuffer,sizeof(WTextBuffer)) > 0) then
  begin
     ClassName := StrPas(ClassNameBuffer);
     if (ClassName = 'TAppBuilder')  and
        (Pos('Delphi 2005',StrPas(WTextBuffer)) > 0) then Proof1 := true
     else
     if (ClassName = 'TApplication')  and
        (Pos('Delphi 2005',StrPas(WTextBuffer)) > 0) then Proof2 := true
  end;
  Result := not (Proof1 and Proof2)
end;

function IsDelphiRunning: boolean;
begin
  Proof1 := false;
  Proof2 := false;
  EnumWindows (@EnumWindowsProc,0);
  Result := Proof1 and Proof2;
  UseIsIllegal := not Result
end;

{$ELSE}
{$IFDEF VER185}
var Proof1: boolean;

function EnumWindowsProc(Handle: HWND; Param: LParam): boolean; stdcall;
var ClassNameBuffer: array [0..256] of char;
    WTextBuffer: array [0..1024] of char;
    ClassName: string;
begin
  if (GetClassName(Handle,@ClassNameBuffer,sizeof(ClassNameBuffer)) > 0) and
     (GetWindowText(Handle,@WTextBuffer,sizeof(WTextBuffer)) > 0) then
  begin
     ClassName := StrPas(ClassNameBuffer);
     if (ClassName = 'TAppBuilder')  and (
        (Pos('CodeGear Delphi',StrPas(WTextBuffer)) > 0) or
        (Pos('CodeGear C++Builder',StrPas(WTextBuffer)) > 0) 
     ) then Proof1 := true
  end;
  Result := not Proof1
end;

function IsDelphiRunning: boolean;
begin
  Proof1 := false;
  EnumWindows (@EnumWindowsProc,0);
  Result := Proof1;
  UseIsIllegal := not Result
end;

{$ELSE}
{$IFDEF VER180}
var Proof1, Proof2: boolean;

function EnumWindowsProc(Handle: HWND; Param: LParam): boolean; stdcall;
var ClassNameBuffer: array [0..256] of char;
    WTextBuffer: array [0..1024] of char;
    ClassName: string;
begin
  if (GetClassName(Handle,@ClassNameBuffer,sizeof(ClassNameBuffer)) > 0) and
     (GetWindowText(Handle,@WTextBuffer,sizeof(WTextBuffer)) > 0) then
  begin
     ClassName := StrPas(ClassNameBuffer);
     if (ClassName = 'TAppBuilder')  and
        (Pos('Developer Studio 2006',StrPas(WTextBuffer)) > 0) then Proof1 := true
     else
     if (ClassName = 'TApplication')  and
        (Pos('Developer Studio 2006',StrPas(WTextBuffer)) > 0) then Proof2 := true
  end;
  Result := not (Proof1 and Proof2)
end;

function IsDelphiRunning: boolean;
begin
  Proof1 := false;
  Proof2 := false;
  EnumWindows (@EnumWindowsProc,0);
  Result := Proof1 and Proof2;
  UseIsIllegal := not Result
end;


{$ELSE}

function IsDelphiRunning: boolean;

var
  H1, H2, H3, H4 : Hwnd;

const
  A1 : array[0..12] of char = 'TApplication'#0;
  A2 : array[0..15] of char = 'TAlignPalette'#0;
  A3 : array[0..18] of char = 'TPropertyInspector'#0;
  A4 : array[0..11] of char = 'TAppBuilder'#0;
  {$IFDEF VER90}
  T1 : array[0..10] of char = 'Delphi 2.0'#0;
  {$ELSE}
    {$IFDEF VER100}
      T1 : array[0..9] of char = 'Delphi 3'#0;
    {$ELSE}
     {$IFDEF VER93}
     T1 : array[0..10] of char = 'C++Builder'#0;
     {$ELSE}
      {$IFDEF VER110}
      T1 : array[0..10] of char = 'C++Builder'#0;
      {$ELSE}
       {$IFDEF VER120}
       T1 : array[0..9] of char = 'Delphi 4'#0;
       {$ELSE}
         {$IFDEF VER125}
           T1 : array[0..12] of char = 'C++Builder 4'#0;
         {$ELSE}
       	  {$IFDEF VER130}
            {$IFDEF CBUILDER5}
       	       T1 : array[0..13] of char = 'C++Builder 5'#0;
            {$ELSE}
               T1 : array[0..9] of char = 'Delphi 5'#0;
            {$ENDIF}
          {$ELSE}
            {$IFDEF VER140}
              {$IFDEF CBUILDER5}
        	 T1 : array[0..13] of char = 'C++Builder 6'#0;
              {$ELSE}
                 T1 : array[0..9] of char = 'Delphi 6'#0;
              {$ENDIF}
            {$ELSE}
              {$IFDEF VER150}
                 T1 : array[0..9] of char = 'Delphi 7'#0;
              {$ELSE}
                T1 : array[0..6] of char = 'Delphi'#0;
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
         {$ENDIF}
       {$ENDIF}
      {$ENDIF}
     {$ENDIF}
    {$ENDIF}
  {$ENDIF}

Begin
     H1 := FindWindow(A1, T1);
     H2 := FindWindow(A2, nil);
     H3 := FindWindow(A3, nil);
     H4 := FindWindow(A4, nil);
     Result := (H1 <> 0) and (H2 <> 0) and (H3 <> 0) and (H4 <> 0);
     UseIsIllegal := not Result
End;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{DEND}

{$IFDEF VER80}
{TResourceStream is not part of the Delphi 1 VCL, so an implementation has to be
 provided here}
type
  TResourceStream = class(TStream)
  private
    HResInfo: THandle;
    HGlobal: THandle;
    FSize: longint;
    FPointer: pointer;
    FPosition: longint;
    procedure Initialize(Instance: THandle; Name, ResType: PChar);
  public
    constructor Create(Instance: THandle; const ResName: string; ResType: PChar);
    constructor CreateFromID(Instance: THandle; ResID: Integer; ResType: PChar);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

constructor TResourceStream.Create(Instance: THandle; const ResName: string;
  ResType: PChar);
var S: array [0..256] of char;
begin
  inherited Create;
  Initialize(Instance, StrPCopy(S,ResName), ResType);
end;

constructor TResourceStream.CreateFromID(Instance: THandle; ResID: Integer;
  ResType: PChar);
begin
  inherited Create;
  Initialize(Instance, PChar(ResID), ResType);
end;

procedure TResourceStream.Initialize(Instance: THandle; Name, ResType: PChar);

  procedure Error;
  begin
    raise EResNotFound.Create(Format('Resource %s not found', [Name]));
  end;

begin
  HResInfo := FindResource(Instance, Name, ResType);
  if HResInfo = 0 then Error;
  HGlobal := LoadResource(Instance, HResInfo);
  if HGlobal = 0 then Error;
  FSize := SizeOfResource(Instance, HResInfo);
  FPointer := LockResource(HGlobal);
end;

destructor TResourceStream.Destroy;
begin
  UnlockResource(HGlobal);
  FreeResource(HGlobal);
  inherited Destroy;
end;

function TResourceStream.Read(var Buffer; Count: Longint): Longint;
var P: PChar;
begin
  if Count > FSize - FPosition then
    Result := FSize - FPosition
  else
    Result := Count;
  P := PChar(FPointer);
  IncPointer(P,FPosition);
  Move(P^,Buffer,Result);
  Inc(FPosition,Result)
end;

function TResourceStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := 0;
    soFromCurrent: Inc(FPosition,Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition
end;

function TResourceStream.Write(const Buffer; Count: Longint): Longint;
begin
  raise EStreamError.Create('Illegal write to TResourceStream');
end;

{$ENDIF}


{TJPEGBase's Methods----------------------------------------------------------}

procedure ErrorExit(cinfo: j_common_ptr);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.UserRef as TJPEGBase).Error
end;

procedure EmitMessage(cinfo : j_common_ptr; msg_level : int);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.UserRef as TJPEGBase).Warning(msg_level)
end;

procedure ProgressMonitor(cinfo: j_common_ptr);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.UserRef as TJPEGBase).DoProgress
end;

constructor TJPEGBase.create(AOwner: TComponent);
var err: jpeg_error_mgr_ptr;
begin
{DSTART}
{$IFDEF DELPHI_REQUIRED}
     if not IsDelphiRunning Then
     begin
          MessageDlg('You are using an unregistered copy of the JPEG Component Library. '+
                     'This can only be used while Delphi or C++Builder is also running. ' +
                     'As neither is running, your application will now be terminated.',
                     mtInformation,[mbOK],0);
          Application.Terminate
     end;
{$ENDIF}
{DEND}
     inherited create(AOwner);
{$IFDEF DYNAMIC_DLL}
     LoadJpegLibrary;
{$ENDIF}
     new(err);
     if err = nil then OutOfMemoryError;
     err := jpeg_std_error(err);
     err^.error_exit := ErrorExit;
     err^.emit_message := EmitMessage;
     CreateJPEGObject(err);
     new(JPEGObject^.progress);
     if JPEGObject^.progress = nil then OutOfMemoryError;
     with JPEGObject^.progress^ do
     begin
          progress_monitor := ProgressMonitor;
          pass_counter := 0;
          pass_limit := 0;
          completed_passes := 0;
          total_passes := 0
     end
end;

destructor TJPEGBase.Destroy;
begin
   if assigned(JPEGObject) then
   begin
{$IFDEF DYNAMIC_DLL}
     if assigned (jpeg_destroy) then
{$ENDIF}
        jpeg_destroy(JPEGObject);
       with JPEGObject^ do
       begin
          if assigned(err) then dispose(err);
          if assigned(progress) then dispose(progress)
       end
   end;
   inherited Destroy
end;

procedure TJPEGBase.Abort;
begin
  if FInProgress then
    FAbortRequested := true
  else
  begin
    FInAbort := true;
    try
       jpeg_abort(JPEGObject)
    finally
      FInAbort := false
    end
  end
end;

procedure TJPEGBase.Error;
var buffer: array [0..JMSG_LENGTH_MAX] of char;
begin
  if not FInAbort then
  begin
     JPEGObject^.err^.format_message(JPEGObject,@buffer);   {Get Error Message}
     Abort;
     raise Exception.create(StrPas(buffer))                 {Display as exception}
  end
end;

procedure TJPEGBase.Warning(msg_level : int);
var buffer: array [0..JMSG_LENGTH_MAX] of char;
begin
  with JPEGObject^ do
  if (msg_level < 0) then
    { It's a warning message.  Since corrupt files may generate many warnings,
     * the policy implemented here is to show only the first warning,
     * unless trace_level >= 3.
     *}
  begin
    if (err^.num_warnings = 0) or (err^.trace_level >= 3) then
    begin
         err^.format_message(JPEGObject,@buffer);
         if assigned(FOnWarning) then
            OnWarning(strpas(buffer))
         else
           MessageDlg(strpas(buffer),mtWarning,[mbOK],0);;
    end;
    { Always count warnings in num_warnings. }
    Inc(err^.num_warnings)
  end
  else
  { It's a trace message.  Show it if trace_level >= msg_level. }
  if (err^.trace_level >= msg_level) then
  begin
       err^.format_message(JPEGObject,@buffer);
         if assigned(FOnWarning) then
            OnWarning(strpas(buffer))
         else
            MessageDlg(strpas(buffer),mtWarning,[mbOK],0)
  end
end;

procedure TJPEGBase.DoProgress;
begin
     if assigned(FOnProgressReport) then
     try
          FInProgress := true;
          try
            FOnProgressReport(Self)
          finally
            FInProgress := false
          end
     except
       Abort;
       raise
     end
end;

function TJPEGBase.GetPercentDone: integer;
begin
  with JPEGObject^.progress^ do
     Result := Round(((completed_passes + (pass_counter/pass_limit))/total_passes)*100)
end;

function TJPEGBase.GetWarnings: long;
begin
     Result := JPEGObject^.err^.num_warnings
end;

function TJPEGBase.GetTraceLevel: int;
begin
     Result := JPEGObject^.err^.trace_level
end;

procedure TJPEGBase.SetTraceLevel(value: int);
begin
     JPEGObject^.err^.trace_level := value
end;

function TJPEGBase.Round4(i: longint): longint;
begin
     Result := ((i+3) shr 2) shl  2
end;


{TJPEGCompressor-----------------------------------------------------}

procedure InitDestination(cinfo : j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.common_fields.UserRef as TJPEGCompressor).InitDestination
end;

function EmptyOutputBuffer(cinfo : j_compress_ptr): boolean;
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     Result := (cinfo^.common_fields.UserRef as TJPEGCompressor).EmptyOutputBuffer
end;

procedure TermDestination(cinfo : j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.common_fields.UserRef as TJPEGCompressor).TermDestination
end;

constructor TJPEGCompressor.Create(AOwner: TComponent);
begin
   inherited create(AOwner);
   with cinfo do
   begin
     FWriteAllTables := true;
     input_components := 3;
     in_color_space := JCS_RGB;
     jpeg_set_defaults(@cinfo);
     new(dest);
     if dest = nil then OutOfMemoryError;
     with dest^ do
     begin
          init_destination := mwajpeg.InitDestination;
          empty_output_buffer := mwajpeg.EmptyOutputBuffer;
          term_destination := mwajpeg.TermDestination
     end
   end;
   Quality := DefaultQuality
end;

destructor TJPEGCompressor.Destroy;
begin
  with cinfo do
     if assigned(dest) then Dispose(dest);
     inherited Destroy
end;

procedure TJPEGCompressor.CreateJPEGObject(err: jpeg_error_mgr_ptr);
begin
     cinfo.common_fields.err := err;
     cinfo.common_fields.UserRef := Self;
     JPEGObject := j_common_ptr(@cinfo);
     jpeg_Create_Compress(@cinfo);
end;

procedure TJPEGCompressor.AddQuantTable(which_tbl: int;
				       const basic_table: uint_ptr;
				       scale_factor: int;
				       force_baseline: boolean);
begin
     jpeg_add_quant_table(@cinfo,which_tbl,basic_table,scale_factor,force_baseline)
end;


{$IFDEF CBBUILDER3OR4OR5}
function TJPEGCompressor.Getcinfoinput_components: int;
begin
  Result := cinfo.input_components
end;

procedure TJPEGCompressor.Setcinfoinput_components(Value: int);
begin
 cinfo.input_components := Value;
end;

function TJPEGCompressor.Getcinfoimage_width: JDIMENSION;
begin
  Result := cinfo.image_width
end;

procedure TJPEGCompressor.Setcinfoimage_width(Value: JDIMENSION);
begin
 cinfo.image_width := Value;
end;

function TJPEGCompressor.Getcinfoinput_gamma: double;
begin
  Result := cinfo.input_gamma
end;

procedure TJPEGCompressor.Setcinfoinput_gamma(Value: double);
begin
 cinfo.input_gamma := Value;
end;

function TJPEGCompressor.Getcinfodata_precision: int;
begin
  Result := cinfo.data_precision
end;

procedure TJPEGCompressor.Setcinfodata_precision(Value: int);
begin
 cinfo.data_precision := Value;
end;

function TJPEGCompressor.Getcinfojpeg_color_space: J_COLOR_SPACE;
begin
  Result := cinfo.jpeg_color_space
end;

procedure TJPEGCompressor.Setcinfojpeg_color_space(Value: J_COLOR_SPACE);
begin
 cinfo.jpeg_color_space := Value;
end;

function TJPEGCompressor.Getcinfodct_method: J_DCT_METHOD;
begin
  Result := cinfo.dct_method
end;

procedure TJPEGCompressor.Setcinfodct_method(Value: J_DCT_METHOD);
begin
 cinfo.dct_method := Value;
end;

function TJPEGCompressor.Getcinfooptimize_coding: boolean;
begin
  Result := cinfo.optimize_coding
end;

procedure TJPEGCompressor.Setcinfooptimize_coding(Value: boolean);
begin
 cinfo.optimize_coding := Value;
end;

function TJPEGCompressor.Getcinforestart_interval: cardinal;
begin
  Result := cinfo.restart_interval
end;

procedure TJPEGCompressor.Setcinforestart_interval(Value: cardinal);
begin
 cinfo.restart_interval := Value;
end;

function TJPEGCompressor.Getcinforestart_in_rows: int;
begin
  Result := cinfo.restart_in_rows
end;

procedure TJPEGCompressor.Setcinforestart_in_rows(Value: int);
begin
 cinfo.restart_in_rows := Value;
end;

function TJPEGCompressor.Getcinfosmoothing_factor: int;
begin
  Result := cinfo.smoothing_factor
end;

procedure TJPEGCompressor.Setcinfosmoothing_factor(Value: int);
begin
 cinfo.smoothing_factor := Value;
end;

function TJPEGCompressor.Getcinfowrite_JFIF_header: boolean;
begin
  Result := cinfo.write_JFIF_header
end;

procedure TJPEGCompressor.Setcinfowrite_JFIF_header(Value: boolean);
begin
 cinfo.write_JFIF_header := Value;
end;

function TJPEGCompressor.Getcinfodensity_unit: UINT8;
begin
  Result := cinfo.density_unit
end;

procedure TJPEGCompressor.Setcinfodensity_unit(Value: UINT8);
begin
 cinfo.density_unit := Value;
end;

function TJPEGCompressor.GetcinfoX_density: UINT16;
begin
  Result := cinfo.X_density
end;

procedure TJPEGCompressor.SetcinfoX_density(Value: UINT16);
begin
 cinfo.X_density := Value;
end;

function TJPEGCompressor.GetcinfoY_Density: UINT16;
begin
  Result := cinfo.Y_Density
end;

procedure TJPEGCompressor.SetcinfoY_Density(Value: UINT16);
begin
 cinfo.Y_Density := Value;
end;

function TJPEGCompressor.Getcinfowrite_Adobe_marker: boolean;
begin
  Result := cinfo.write_Adobe_marker
end;

procedure TJPEGCompressor.Setcinfowrite_Adobe_marker(Value: boolean);
begin
 cinfo.write_Adobe_marker := Value;
end;

function TJPEGCompressor.Getcinfoimage_height: JDIMENSION;
begin
  Result := cinfo.image_height
end;

procedure TJPEGCompressor.Setcinfoimage_height(Value: JDIMENSION);
begin
 cinfo.image_height := Value;
end;

{$ENDIF}
procedure TJPEGCompressor.SetColorSpace(value: J_COLOR_SPACE);
begin
     jpeg_set_colorspace(@cinfo,value)
end;

procedure TJPEGCompressor.SetQuality(Value: int);
begin
     FQuality := Value;
     jpeg_set_quality(@cinfo,Value,true)
end;

function TJPEGCompressor.GetNextOut: JOCTET_PTR;
begin
     Result := cinfo.dest^.next_output_byte
end;

function TJPEGCompressor.GetFreeIn: localsize_t;
begin
     Result := cinfo.dest^.free_in_buffer
end;

procedure TJPEGCompressor.SetNextOut(value: JOCTET_PTR);
begin
     cinfo.dest^.next_output_byte := value
end;

procedure TJPEGCompressor.SetFreeIn(value: localsize_t);
begin
     cinfo.dest^.free_in_buffer := value
end;

procedure TJPEGCompressor.WriteDIBitmap(const BitmapInfo: TBitmapInfo; bits: PChar);
type
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array [0..255] of TRGBQuad;
var RowSize: longint;
    NextRow: PChar;
    LineBuffer: PChar;
    ColourMap: PRGBQuadArray;

  function Mapped16Colour(MappedBuffer: PChar; var LineBuffer: PChar): JSAMPARRAY;
  var I: integer;
      bufPtr: PChar;
  begin
       Result := JSAMPARRAY(@LineBuffer);
       bufPtr:= LineBuffer;
       for I := 1 to (ImageWidth + 1) div 2 do
       begin
            Move(ColourMap^[(ord(MappedBuffer^) and $F0) shr 4],bufPtr^,3);
            Inc(bufPtr,3);
            Move(ColourMap^[ord(MappedBuffer^) and $0F],bufPtr^,3);
            Inc(bufPtr,3);
            {$IFDEF WIN32}
            Inc(MappedBuffer)
            {$ELSE}
            IncPointer(MappedBuffer,1)
            {$ENDIF}
       end
  end;

  function Mapped256Colour(MappedBuffer: PChar; var LineBuffer: PChar): JSAMPARRAY;
  var I: integer;
      bufPtr: PChar;
  begin
       Result := JSAMPARRAY(@LineBuffer);
       bufPtr:= LineBuffer;
       for I := 1 to ImageWidth  do
       begin
            Move(ColourMap^[ord(MappedBuffer^)],bufPtr^,3);
            Inc(bufPtr,3);
            {$IFDEF WIN32}
            Inc(MappedBuffer)
            {$ELSE}
            IncPointer(MappedBuffer,1)
            {$ENDIF}
       end
  end;

begin
     LineBuffer := nil;
     ColourMap := PRGBQuadArray(@(BitmapInfo.bmiColors));
     With BitmapInfo.bmiHeader do
     begin
          ImageWidth := biWidth;
          ImageHeight := biHeight;
          if GrayscaleOutput then
             SetColorSpace(JCS_GRAYSCALE)
          else
             SetColorSpace(JCS_YCbCr);

          case biBitCount of
          24:     {nothing to do};
          4,8: {allocate a buffer for colour mapped output}
               begin
                  GetMem(LineBuffer,Round4(biWidth)*3);
                  if LineBuffer = nil then OutOfMemoryError
               end
          else   raise Exception.createFmt(sBadBitCount,[biBitCount]);
          end;

          try
            if ProgressiveJPEG then
               jpeg_simple_progression(@cinfo);

            if not WriteAllTables then
               jpeg_suppress_tables(@cinfo, true);

            jpeg_start_compress(@cinfo,FWriteAllTables);
            if length(FComment) > 0 then
               jpeg_write_marker(@cinfo,JPEG_COM,@(FComment[1]),length(FComment));

            if assigned(FOnWriteMarkers) then OnWriteMarkers(Self);

            case biBitCount of
            4:           RowSize := Round4((ImageWidth + 1) div 2);
            8:           RowSize := Round4(ImageWidth);
            else {24:}   RowSize := Round4(ImageWidth*InputComponents);
            end;

            {$IFDEF WIN32}
            NextRow := PChar(bits) + RowSize * (ImageHeight - 1);
            {$ELSE}
            NextRow := PChar(bits);
            IncPointer(NExtRow,RowSize * (ImageHeight - 1));
            {$ENDIF}
            FAbortRequested := false;
            while cinfo.next_scanline < ImageHeight do
            begin
               case biBitCount of
               24:     jpeg_write_scanlines(@cinfo,JSAMPARRAY(@NextRow),1);
               4:      jpeg_write_scanlines(@cinfo,Mapped16Colour(NextRow,LineBuffer),1);
               8:      jpeg_write_scanlines(@cinfo,Mapped256Colour(NextRow, LineBuffer),1);
               end;
               {$IFDEF WIN32}
               Dec(NextRow,RowSize);
               {$ELSE}
               IncPointer(NextRow,-RowSize);
               {$ENDIF}
               if FAbortRequested then
               begin
                 Abort;
                 raise Exception.Create(sUserAbort)
                 end
            end;
            with JPEGObject^.Progress^ do
            begin
               pass_counter := 0;
               completed_passes := total_passes; {force 100%}
            end;
            DoProgress;
            jpeg_finish_compress(@cinfo)
          finally
            if assigned(LineBuffer) then
                          FreeMem(LineBuffer,Round4(biWidth)*3)
          end
     end
end;

{Derive the BitmapInfoHeader for the specified bitmap and override for the requested
 resolution}

procedure TJPEGCompressor.GetBitmapInfoHeader(Bitmap: HBitmap; Resolution: TBitmapResolution;
                                                      var BitmapInfoHeader: TBitmapInfoHeader);
var
  Dummy: integer;
  BM: Wintypes.TBitmap;
begin
  GetObject(Bitmap, SizeOf(BM), @BM);
  with BitmapInfoHeader do
  begin
    biSize := SizeOf(BitmapInfoHeader);
    biWidth := BM.bmWidth;
    biHeight := BM.bmHeight;
    biBitCount := BM.bmBitsPixel * BM.bmPlanes;
    case Resolution of
    bmDefault : if biBitCount > 8 then biBitCount := 24;
    bm16Colour: biBitCount := 4;
    bm256Colour: biBitCount := 8;
    bm24bit: biBitCount := 24
    end;
    biPlanes := 1;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biClrUsed := 0;
    biClrImportant := 0;
    biCompression := BI_RGB;
    biSizeImage := Round4(biWidth * biBitCount) * biHeight;
  end;
end;

{Determine the size of the BitmapInfo and the iamge}

procedure TJPEGCompressor.GetDIBSizes(Bitmap: HBITMAP; Resolution: TBitmapResolution; var InfoHeaderSize: Integer;
  var ImageSize: TImageSize);
var
  BI: TBitmapInfoHeader;
begin
  GetBitmapInfoHeader(Bitmap, Resolution, BI);
  with BI do
  begin
    case biBitCount of
      24: InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    else
      InfoHeaderSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) *
       (1 shl biBitCount);
    end;
  end;
  ImageSize := BI.biSizeImage;
end;

procedure TJPEGCompressor.Bitmap2DIB(Bitmap: TBitmap; Resolution: TBitmapResolution;
                                                                var BitMapInfo, bits);
var
  OldPal: HPALETTE;
  ScreenDC,
  dc: HDC;
  OldImage,
  ScreenImage: HBitmap;
begin
  GetBitmapInfoHeader(Bitmap.Handle, Resolution, TBitmapInfoHeader(BitmapInfo));
  ScreenDC := GetDC(0); {use the current focused window's device context to realise bitmap}
  try
    dc := CreateCompatibleDC(ScreenDC); {use a memory DC for actual realisation}
    try
      ScreenImage := CreateCompatibleBitMap(ScreenDC,1,1);
      try
       OldImage := SelectObject(dc,ScreenImage);
       try
          if Bitmap.Palette <> 0 then
          begin
               OldPal := SelectPalette(dc, Bitmap.Palette, False);
               RealizePalette(dc);
          end
          else
              OldPal := 0;
          try
            if GetDIBits(DC, Bitmap.Handle, 0, TBitmapInfoHeader(BitmapInfo).biHeight, @Bits,
                              TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) = 0 then
                                raise Exception.Create(sNoDIB);
          finally
            if OldPal <> 0 then SelectPalette(dc, OldPal, False)
          end
       finally
        SelectObject(dc,OldImage);
       end
      finally
        DeleteObject(ScreenImage)
      end
    finally
      DeleteDC(dc)
    end
  finally
    ReleaseDC(0,ScreenDC)
  end
end;

function ReSizeBitmap(bitmap: TBitmap; width, height: integer): TBitmap;
begin
     Result := CropBitmap(bitmap,width,height,Rect(0,0,bitmap.width,bitmap.height))
end;

function CropBitmap(bitmap: TBitmap; width, height: integer; Clip: TRect): TBitmap;
var ScreenDC: HDC;
    SourceDC,
    DestDC: HDC;
    StretchedBitmap: HBitmap;
    OldSourceImage,
    OldDestImage: HBitmap;
    SourceOldPal,
    DestOldPal: HPalette;
    Origin: TPoint;

begin
     Result := nil;
     ScreenDC := GetDC(0);
     try
        SourceDC := CreateCompatibleDC(ScreenDC);
        DestDC := CreateCompatibleDC(ScreenDC);
        try
           OldSourceImage := SelectObject(SourceDC,bitmap.Handle);
           StretchedBitmap := CreateCompatibleBitmap(ScreenDC,width,height);
           OldDestImage := SelectObject(DestDC,StretchedBitmap);
           try
              SourceOldPal := 0;
              DestOldPal := 0;
              if bitmap.Palette <> 0 then
              begin
                   SourceOldPal := SelectPalette(SourceDC,bitmap.Palette,false);
                   RealizePalette(SourceDC);
                   DestOldPal := SelectPalette(DestDC,bitmap.Palette,false);
                   RealizePalette(DestDC)
              end;
              try
                 {$IFDEF WIN32}
                 SetStretchBltMode(DestDC,HALFTONE);
                   {$IFDEF DELPHI3ORLATER}
                   SetBrushOrgEx(DestDC,0,0,@Origin);
                   {$ELSE}
                   SetBrushOrgEx(DestDC,0,0,Origin);
                   {$ENDIF}
                 {$ELSE}
                 SetStretchBltMode(DestDC,STRETCH_DELETESCANS);
                 {$ENDIF}
                 StretchBlt(DestDC,0,0,width,height,SourceDC,Clip.Left,Clip.Top,
                                  Clip.Right-CLip.Left,Clip.Bottom-Clip.Top,srcCopy);
                 Result := TBitmap.Create;
                 Result.Palette := bitmap.Palette;
                 Result.Handle := StretchedBitmap;
              finally
                if SourceOldPal <> 0 then
                begin
                     SelectPalette(SourceDC,SourceOldPal,false);
                     RealizePalette(SourceDC);
                     SelectPalette(DestDC,DestOldPal,false);
                     RealizePalette(DestDC)
                end
              end
           except
             SelectObject(SourceDC,OldSourceImage);
             SelectObject(DestDC,OldDestImage);
             DeleteObject(StretchedBitmap);
             raise
           end
        finally
          DeleteDC(SourceDC);
          DeleteDC(DestDC)
        end
     finally
       ReleaseDC(0,ScreenDC)
     end
end;

procedure TJPEGCompressor.WriteStretchedBitmap(bitmap: TBitmap; width, height: integer);
var NewBitmap: TBitmap;
begin
     NewBitmap := ReSizeBitmap(bitmap,width,height);
     try
       WriteBitmap(NewBitmap)
     finally
       NewBitmap.Free
     end
end;

procedure TJPEGCompressor.WriteBitmap(bitmap: TBitMap);
var BitMapInfo: PBitmapInfo;
    bits: PChar;
    ImageSize:  TImageSize;
    InfoHeaderSize: integer;
    mem: THandle;
begin
     GetDIBSizes(bitmap.Handle,bmDefault,InfoHeaderSize,ImageSize);
     mem := GlobalAlloc(GHND,ImageSize);
     if mem = 0 then OutOfMemoryError;
     bits := GlobalLock(mem);
     GetMem(BitMapInfo,InfoHeaderSize);
     if BitMapInfo = nil then OutOfMemoryError;
     try
        Bitmap2DIB(bitmap,bmDefault,BitMapInfo^,bits^);
        WriteDIBitmap(BitMapInfo^,bits)
     finally
       Freemem(BitmapInfo,InfoHeaderSize);
       GlobalUnLock(mem);
       GlobalFree(mem)
     end
end;

procedure TJPEGCompressor.WriteMetaFile(metafile: TMetaFile; width, height: longint);
var  bitmap: TBitmap;
begin
     bitmap := MetaToBitMap(metafile,width,height);
     try
       WriteBitmap(bitmap)
     finally
       bitmap.Free
     end;
end;

procedure TJPEGCompressor.WriteMarker(Marker: int; const buf; Count: uint);
begin
     jpeg_write_marker(@cinfo,Marker,@buf,Count)
end;


{TJPEGStreamCompressor------------------------------------------------}

constructor TJPEGStreamCompressor.create(AOwner: TComponent);
begin
     inherited create(AOwner);
     free_in := FBufSize;
     BufSize := DefaultBufSize;
     if DefaultCompressor and (DefaultJPEGCompressor = nil) then
        DefaultJPEGCompressor := Self
end;


destructor TJPEGStreamCompressor.Destroy;
begin
     if assigned(FBuffer) then FreeMem(FBuffer,FBufSize);
     if DefaultJPEGCompressor = Self then
        DefaultJPEGCompressor := nil;
     inherited Destroy
end;

procedure TJPEGStreamCompressor.SetBufSize(Value: integer);
begin
     if assigned(FBuffer) then
       if free_in <> FBufSize then
         raise Exception.Create(sCantSetBufSize)
       else
         FreeMem(FBuffer,FBufSize);
     FBuffer := nil;
     FBufSize := Value;
     GetMem(FBuffer,BufSize);
     if FBuffer = nil then OutOfMemoryError;
end;


procedure TJPEGStreamCompressor.InitDestination;
begin
     next_out := FBuffer;
     free_in := FBufSize
end;

function TJPEGStreamCompressor.EmptyOutputBuffer: boolean;
begin
     Result := FStream.Write(FBuffer^,FBufSize) = FBufSize;
     next_out := FBuffer;
     free_in := FBufSize
end;

procedure TJPEGStreamCompressor.TermDestination;
begin
     FStream.Write(FBuffer^,FBufSize - free_in);
     next_out := FBuffer;
     free_in := FBufSize
end;

procedure TJPEGStreamCompressor.OpenStream(Stream: TStream);
begin
     FStream := Stream
end;

procedure TJPEGStreamCompressor.CloseStream;
begin
    FStream := nil
end;

procedure TJPEGStreamCompressor.SavePictureToStream(Picture: TPicture; Stream: TStream);
begin
     OpenStream(Stream);
     with Picture do
     try
        if Graphic is TBitmap then
           SaveBitMapToStream(bitmap,Stream)
        else
        if Graphic is TMetafile then
           SaveMetaFileToStream(Metafile,Stream,Width,Height)
        else
           raise Exception.Create(sNoJPEGImage)
     finally
       CloseStream
     end
end;

procedure TJPEGStreamCompressor.SaveStretchedPictureToStream(Picture: TPicture;
                        width,height: integer; Stream: TStream);
begin
     OpenStream(Stream);
     try
        if Picture.Graphic is TBitmap then
           SaveStretchedBitMapToStream(Picture.bitmap,width,height,Stream)
        else
        if Picture.Graphic is TMetafile then
           SaveMetaFileToStream(Picture.Metafile,Stream,Width,Height)
        else
           raise Exception.Create(sNoJPEGImage)
     finally
       CloseStream
     end
end;



procedure TJPEGStreamCompressor.SaveBitMapToStream(bitmap: TBitmap; Stream: TStream);
begin
     OpenStream(Stream);
     try
       WriteBitmap(bitmap)
     finally
       CloseStream
     end
end;

procedure TJPEGStreamCompressor.SaveStretchedBitMapToStream(bitmap: TBitmap; width,height: integer;
                     Stream: TStream);
begin
     OpenStream(Stream);
     try
       WriteStretchedBitmap(bitmap, width,height)
     finally
       CloseStream
     end
end;


procedure TJPEGStreamCompressor.SaveMetaFileToStream(metafile: TMetafile;
                                       Stream: TStream; width, height: integer);
begin
     OpenStream(Stream);
     try
       WriteMetaFile(metafile,width,height)
     finally
       CloseStream
     end
end;

procedure TJPEGStreamCompressor.SaveDIBitmapToStream(Stream: TStream;
                                    const BitmapInfo: TBitmapInfo;
                                    bits: PChar);
begin
     OpenStream(Stream);
     try
       WriteDIBitmap(BitmapInfo,bits)
     finally
       CloseStream
     end
end;


{JPEGDecompressor--------------------------------------------------------}
procedure InitSource(cinfo : j_decompress_ptr);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.common_fields.UserRef as TJPEGDecompressor).InitSource
end;

function FillInputBuffer(cinfo : j_decompress_ptr) : boolean;
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     Result :=
       (cinfo^.common_fields.UserRef as TJPEGDecompressor).FillInputBuffer
end;

procedure SkipInputBytes(cinfo : j_decompress_ptr; num_bytes : long);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.common_fields.UserRef as TJPEGDecompressor).SkipInputBytes(num_bytes)
end;

function ResyncToRestart(cinfo : j_decompress_ptr;
                                  desired : int) : boolean;
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     Result :=
       (cinfo^.common_fields.UserRef as TJPEGDecompressor).ResyncToRestart(desired)
end;

procedure TermSource(cinfo : j_decompress_ptr);
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     (cinfo^.common_fields.UserRef as TJPEGDecompressor).TermSource
end;

function HandleJPEGComments(cinfo : j_decompress_ptr) : boolean;
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     Result := (cinfo^.common_fields.UserRef as TJPEGDecompressor).HandleJPEGComment
end;

function HandleAPPMarker(cinfo : j_decompress_ptr) : boolean;
{$IFDEF WIN32} stdcall; {$ELSE} export; {$ENDIF}
begin
     Result := (cinfo^.common_fields.UserRef as TJPEGDecompressor).HandleAPPMarker
end;


constructor TJPEGDecompressor.create(AOwner: TComponent);
var I: integer;
begin
   inherited create(AOwner);
   with cinfo do
   begin
     FDCT_METHOD := JDCT_DEFAULT;
     FDoFancyUpSampling := true;
     FDoBlockSmoothing := true;
     FTwoPassQuantize := true;
     FDitherMode := JDITHER_FS;
     FColoursIn8bitMode := DefaultColoursIn8bitMode;
     new(src);
     if src = nil then OutOfMemoryError;
     with src^ do
     begin
          init_source := mwajpeg.InitSource;
          fill_input_buffer := mwajpeg.FillInputBuffer;
          skip_input_data := mwajpeg.SkipInputBytes;
          resync_to_restart := mwajpeg.ResyncToRestart;
          term_source := mwajpeg.TermSource
     end
   end;
   jpeg_set_marker_processor(@cinfo, JPEG_COM, HandleJPEGComments);
   for I := 1 to 13 do
     jpeg_set_marker_processor(@cinfo, JPEG_APP0 + I, mwajpeg.HandleAPPMarker);
   {APP14 is Adobe Marker and this is handled by IJG Library}
   jpeg_set_marker_processor(@cinfo, JPEG_APP0 + 15, mwajpeg.HandleAPPMarker);
   FCMYKInvert := true
end;

destructor TJPEGDecompressor.Destroy;
begin
     if assigned(cinfo.src) then dispose(cinfo.src);
     inherited Destroy
end;

procedure TJPEGDecompressor.CreateJPEGObject(err: jpeg_error_mgr_ptr);
begin
     cinfo.common_fields.err := err;
     cinfo.common_fields.UserRef := Self;
     JPEGObject := j_common_ptr(@cinfo);
     jpeg_Create_Decompress(@cinfo);
end;

{$IFDEF CBBUILDER3OR4OR5}
function TJPEGDecompressor.Getcinfoout_color_space: J_COLOR_SPACE;
begin
  Result := cinfo.out_color_space
end;

procedure TJPEGDecompressor.Setcinfoout_color_space(Value: J_COLOR_SPACE);
begin
 cinfo.out_color_space := Value;
end;

function TJPEGDecompressor.Getcinfoscale_num: cardinal;
begin
  Result := cinfo.scale_num
end;

procedure TJPEGDecompressor.Setcinfoscale_num(Value: cardinal);
begin
 cinfo.scale_num := Value;
end;

function TJPEGDecompressor.Getcinfoscale_denom: cardinal;
begin
  Result := cinfo.scale_denom
end;

procedure TJPEGDecompressor.Setcinfoscale_denom(Value: cardinal);
begin
 cinfo.scale_denom := Value;
end;

function TJPEGDecompressor.Getcinfooutput_gamma: double;
begin
  Result := cinfo.output_gamma
end;

procedure TJPEGDecompressor.Setcinfooutput_gamma(Value: double);
begin
 cinfo.output_gamma := Value;
end;

function TJPEGDecompressor.Getcinfoquantize_colors: boolean;
begin
  Result := cinfo.quantize_colors
end;

procedure TJPEGDecompressor.Setcinfoquantize_colors(Value: boolean);
begin
 cinfo.quantize_colors := Value;
end;

function TJPEGDecompressor.Getcinfodesired_number_of_colors: int;
begin
  Result := cinfo.desired_number_of_colors
end;

procedure TJPEGDecompressor.Setcinfodesired_number_of_colors(Value: int);
begin
 cinfo.desired_number_of_colors := Value;
end;

function TJPEGDecompressor.Getcinfocolormap: JSAMPARRAY;
begin
  Result := cinfo.colormap
end;

procedure TJPEGDecompressor.Setcinfocolormap(Value: JSAMPARRAY);
begin
 cinfo.colormap := Value;
end;

function TJPEGDecompressor.Getcinfoactual_number_of_colors: int;
begin
  Result := cinfo.actual_number_of_colors
end;

procedure TJPEGDecompressor.Setcinfoactual_number_of_colors(Value: int);
begin
 cinfo.actual_number_of_colors := Value;
end;

function TJPEGDecompressor.Getcinfoimage_width: JDIMENSION;
begin
  Result := cinfo.image_width
end;

procedure TJPEGDecompressor.Setcinfoimage_width(Value: JDIMENSION);
begin
 cinfo.image_width := Value;
end;

function TJPEGDecompressor.Getcinfoimage_height: JDIMENSION;
begin
  Result := cinfo.image_height
end;

procedure TJPEGDecompressor.Setcinfoimage_height(Value: JDIMENSION);
begin
 cinfo.image_height := Value;
end;

function TJPEGDecompressor.Getcinfojpeg_color_space: J_COLOR_SPACE;
begin
  Result := cinfo.jpeg_color_space
end;

procedure TJPEGDecompressor.Setcinfojpeg_color_space(Value: J_COLOR_SPACE);
begin
 cinfo.jpeg_color_space := Value;
end;

function TJPEGDecompressor.Getcinfosaw_JFIF_marker: boolean;
begin
  Result := cinfo.saw_JFIF_marker
end;

procedure TJPEGDecompressor.Setcinfosaw_JFIF_marker(Value: boolean);
begin
 cinfo.saw_JFIF_marker := Value;
end;

function TJPEGDecompressor.Getcinfodensity_unit: UINT8;
begin
  Result := cinfo.density_unit
end;

procedure TJPEGDecompressor.Setcinfodensity_unit(Value: UINT8);
begin
 cinfo.density_unit := Value;
end;

function TJPEGDecompressor.GetcinfoX_density: UINT16;
begin
  Result := cinfo.X_density
end;

procedure TJPEGDecompressor.SetcinfoX_density(Value: UINT16);
begin
 cinfo.X_density := Value;
end;

function TJPEGDecompressor.GetcinfoY_density: UINT16;
begin
  Result := cinfo.Y_density
end;

procedure TJPEGDecompressor.SetcinfoY_density(Value: UINT16);
begin
 cinfo.Y_density := Value;
end;

function TJPEGDecompressor.GetcinfoAdobe_transform: UINT8;
begin
  Result := cinfo.Adobe_transform
end;

procedure TJPEGDecompressor.SetcinfoAdobe_transform(Value: UINT8);
begin
 cinfo.Adobe_transform := Value;
end;

function TJPEGDecompressor.Getcinfoenable_1pass_quant: boolean;
begin
  Result := cinfo.enable_1pass_quant
end;

procedure TJPEGDecompressor.Setcinfoenable_1pass_quant(Value: boolean);
begin
 cinfo.enable_1pass_quant := Value;
end;

function TJPEGDecompressor.Getcinfoenable_external_quant: boolean;
begin
  Result := cinfo.enable_external_quant
end;

procedure TJPEGDecompressor.Setcinfoenable_external_quant(Value: boolean);
begin
 cinfo.enable_external_quant := Value;
end;

function TJPEGDecompressor.Getcinfoenable_2pass_quant: boolean;
begin
  Result := cinfo.enable_2pass_quant
end;

procedure TJPEGDecompressor.Setcinfoenable_2pass_quant(Value: boolean);
begin
 cinfo.enable_2pass_quant := Value;
end;

function TJPEGDecompressor.Getcinfooutput_height: JDIMENSION;
begin
  Result := cinfo.output_height
end;

procedure TJPEGDecompressor.Setcinfooutput_height(Value: JDIMENSION);
begin
 cinfo.output_height := Value;
end;

function TJPEGDecompressor.Getcinfooutput_width: JDIMENSION;
begin
  Result := cinfo.output_width
end;

procedure TJPEGDecompressor.Setcinfooutput_width(Value: JDIMENSION);
begin
 cinfo.output_width := Value;
end;

{$ENDIF}

function TJPEGDecompressor.GetNextInputByte: JOCTET_PTR;
begin
     Result := cinfo.src^.next_input_byte
end;

function TJPEGDecompressor.GetBytesInBuffer: localsize_t;
begin
     Result := cinfo.src^.bytes_in_buffer
end;

procedure TJPEGDecompressor.SetNextInputByte(value: JOCTET_PTR);
begin
     cinfo.src^.next_input_byte := value
end;

procedure TJPEGDecompressor.SetBytesInBuffer(value: localsize_t);
begin
     cinfo.src^.bytes_in_buffer := value
end;

function TJPEGDecompressor.GetByte: JOCTET;
begin
     if (BytesInBuffer = 0) and not FillInputBuffer then
        raise Exception.create(sReadOverFlow);

     Result := NextInputByte^;
     NextInputByte := JOCTET_PTR(PChar(NextInputByte) + 1);
     BytesInBuffer := BytesInBuffer - 1
end;

function TJPEGDecompressor.HandleJPEGComment: boolean;
var length: word;
    comment: PChar;
    I: word;
begin
     Result := true;
     length := GetByte;
     length := (length shl 8) + GetByte - 2;
     if Length > 0 then
     begin
          GetMem(comment,length+1);
          if comment = nil then OutOfMemoryError;
          try
             For I := 0 to Length - 1 do
                 (comment + I)^ := chr(GetByte);
             (comment+length)^ := #0;
             Result := DoJPEGComment(comment)
          finally
            Freemem(comment,length+1)
          end
     end
end;

function TJPEGDecompressor.HandleAPPMarker: boolean;
var Done: boolean;
    length: word;
begin
     Done := false;
     if assigned(FOnJPEGMarker) then
        OnJPEGMarker(Self,cinfo.unread_marker-JPEG_APP0,Done);
     if not Done then {skip the marker}
     begin
          length := GetByte;
          length := (length shl 8) + GetByte - 2;
          while length > 0 do
          begin
               GetByte;
               Dec(Length)
          end
     end;
     Result := true
end;

function TJPEGDecompressor.DoJPEGComment(comment: PChar): boolean;
begin
     if assigned(FOnJPEGComment) then OnJPEGComment(self,comment);
     Result := true
end;


function TJPEGDecompressor.GetDIBitsSize(OutputType: TJPEGOutputType): longint;
begin
     if OutputType = jp4bit then
        Result := Round4((OutputWidth + 1) div 2)* Outputheight
     else
        Result := Round4(OutputWidth * cinfo.output_components)* OutputHeight
end;

function TJPEGDecompressor.GetBitmapInfoSize(OutputType: TJPEGOutputType): longint;
begin
     Result := sizeof(TBitmapInfoHeader);
     case OutputType of
     jp8bit:      Inc(Result,256*sizeof(TRGBQuad));
     jp4bit:      Inc(Result,16*sizeof(TRGBQuad));
     jpGrayScale: Inc(Result,GrayscaleResolution*sizeof(TRGBQuad));
     end
end;

procedure TJPEGDecompressor.ReadDIBitmap(var BitMapInfo: TBitMapInfo; OutputType: TJPEGOutputType;
                                       bits: pointer);
const GrayscaleMap: array [1..3,1..GrayscaleResolution] of JSAMPLE =
  ((0,6,13,19,25,32,38,44,51,57,63,69,75,81,87,93,99,105,111,116,122,128,133,138,144,149,
    154,159,164,169,173,178,183,187,191,195,199,203,207,211,214,218,221,224,227,230,232,
    235,237,240,242,244,245,247,249,250,251,252,253,254,254,255,255,255),
   (0,6,13,19,25,32,38,44,51,57,63,69,75,81,87,93,99,105,111,116,122,128,133,138,144,149,
    154,159,164,169,173,178,183,187,191,195,199,203,207,211,214,218,221,224,227,230,232,
    235,237,240,242,244,245,247,249,250,251,252,253,254,254,255,255,255),
   (0,6,13,19,25,32,38,44,51,57,63,69,75,81,87,93,99,105,111,116,122,128,133,138,144,149,
    154,159,164,169,173,178,183,187,191,195,199,203,207,211,214,218,221,224,227,230,232,
    235,237,240,242,244,245,247,249,250,251,252,253,254,254,255,255,255));

  procedure AddColorMap(var BitmapInfo: TBitmapInfo; colormap: JSAMPROW);
  var P: ^TRGBQuad;
      I: integer;
  begin
       P := @(BitmapInfo.bmiColors);
       for I := 1 to BitmapInfo.bmiHeader.biClrUsed do
       begin
           P^.rgbBlue := colormap^;
           P^.rgbReserved := 0;
           Inc(P);
           Inc(colormap)
       end;
       P := @(BitmapInfo.bmiColors);
       for I := 1 to BitmapInfo.bmiHeader.biClrUsed do
       begin
           P^.rgbGreen := colormap^;
           Inc(P);
           Inc(colormap)
       end;
       P := @(BitmapInfo.bmiColors);
       for I := 1 to BitmapInfo.bmiHeader.biClrUsed do
       begin
           P^.rgbRed := colormap^;
           Inc(P);
           Inc(colormap)
       end
end;

procedure PackScanLine(Source, Destination: JSAMPROW; RowSize: integer);
var I: integer;
    b: byte;
begin
     for I := 1 to RowSize do
     begin
          b := (ord(Source^) shl 4);
          Inc(Source);
          Destination^ :=  b or (ord(Source^) and $0f);
          Inc(Source);
          {$IFDEF VER80}
          IncPointer(PChar(Destination),1)
          {$ELSE}
          Inc(Destination)
          {$ENDIF}
     end
end;

procedure DegradeGrayscale(Row: PChar; Size: integer);
var I: integer;
begin
     for I := 1 to Size do
     begin
          Row^ := chr(ord(Row^) shr 2);
          {$IFDEF VER80}
          IncPointer(Row,1)
          {$ELSE}
          Inc(Row)
          {$ENDIF}
     end
end;

(*CMYK to RGB:
 -----------
 red   = 255 - minimum(255,((cyan/255)    * (255 - black) + black))
 green = 255 - minimum(255,((magenta/255) * (255 - black) + black))
 blue  = 255 - minimum(255,((yellow/255)  * (255 - black) + black))*)

procedure CMYK2RGB(Source, Destination: JSAMPROW; Width: integer);
var I: integer;
    R, G, B: byte;
    C, Y, M, K: byte;
begin
  for I := 1 to Width do
  begin
    if CMYKInvert then
    begin
      C := not Source^;
      Inc(Source);
      M := not (Source)^;
      Inc(Source);
      Y := not (Source)^;
      Inc(Source);
      K := not (Source)^;
      Inc(Source);
    end
    else
    begin
      C := Source^;
      Inc(Source);
      M := Source^;
      Inc(Source);
      Y := Source^;
      Inc(Source);
      K := Source^;
      Inc(Source);
    end;
    R := 255 - min(255,Round((C/255)*(255-K)+K));
    G := 255 - min(255,Round((M/255)*(255-K)+K));
    B := 255 - min(255,Round((Y/255)*(255-K)+K));
    Destination^ := B;
    Inc(Destination);
    Destination^ := G;
    Inc(Destination);
    Destination^ := R;
    Inc(Destination);
  end;
end;

var RowSize: longint;
    NextRow: PChar;
    ScanLine: JSAMPROW;
begin
     ScanLine := nil;

     if (OutputColorSpace = JCS_GRAYSCALE) and (OutputType <> jpGrayscale) then
        raise Exception.Create(sOutputMustBeGrayscale);

     if cinfo.out_color_space = JCS_CMYK then
     begin
       if OutputType <> jp24bit then
         raise Exception.Create('Output type for a CMYKmust be 24 bit');
       GetMem(ScanLine,Round4(cinfo.output_width * cinfo.output_components));
       if ScanLine = nil then OutOfMemoryError;
       FillChar(ScanLine^,OutputWidth,0)
     end
     else
     {setup decompression according to output type desired}
     case OutputType of
     jp8bit:          begin
                        QuantizeColors := true;
                        NumColorsDesired := ColoursIn8bitMode
                      end;
     jp4bit:          begin
                        QuantizeColors := true;
                        NumColorsDesired := 16;
                        GetMem(ScanLine,OutputWidth);
                        if ScanLine = nil then OutOfMemoryError;
                        FillChar(ScanLine^,OutputWidth,0)
                      end;
     jpGrayscale:     cinfo.out_color_space := JCS_GRAYSCALE;
     end;

     try
       {Now perform the decompression}

       jpeg_start_decompress(@cinfo);
       if OutputType = jp4bit then
         RowSize := Round4((cinfo.output_width + 1) div 2)
       else
       if cinfo.out_color_space = JCS_CMYK then
         RowSize := Round4(cinfo.output_width * 3)
       else
         RowSize := Round4(cinfo.output_width * cinfo.output_components);

       {$IFDEF VER80}
       NextRow := PChar(bits);
       IncPointer(NextRow,RowSize * (cinfo.output_height - 1));
       {$ELSE}
       NextRow := PChar(bits) + RowSize * (cinfo.output_height - 1);
       {$ENDIF}
       FAbortRequested := false;
       while cinfo.output_scanline < cinfo.output_height do
       begin
            if OutputType = jp4bit then
            begin
                 jpeg_read_scanLines(@cinfo,JSAMPARRAY(@ScanLine),1);
                 PackScanLine(ScanLine,JSAMPROW(NextRow),RowSize)
            end
            else
            if cinfo.out_color_space = JCS_CMYK then
            begin
                 jpeg_read_scanLines(@cinfo,JSAMPARRAY(@ScanLine),1);
                 CMYK2RGB(ScanLine,JSAMPROW(NextRow),cinfo.output_width)
            end
            else
            begin
              jpeg_read_scanlines(@cinfo,JSAMPARRAY(@NextRow),1);
              if OutputType = jpGrayscale then DegradeGrayscale(NextRow,RowSize)
            end;
            {$IFDEF VER80}
            IncPointer(NextRow,-RowSize);
            {$ELSE}
            Dec(NextRow,RowSize);
            {$ENDIF}
            if FAbortRequested then
            begin
              Abort;
              raise Exception.Create(sUserAbort)
            end
       end
     finally
       if assigned(ScanLine) then
          FreeMem(ScanLine,OutputWidth)
     end;

     {Create the DIB Header}

     FillChar(BitmapInfo.bmiHeader,sizeof(TBitMapInfoHeader),0);
     with BitMapInfo.bmiHeader do
     begin
         biSize := sizeof(TBitMapInfoHeader);
         biWidth := cinfo.output_width;
         biHeight := cinfo.output_height;
         biPlanes := 1;
         if (cinfo.out_color_space = JCS_CMYK) or (cinfo.output_components = 3) then
            biBitCount := 24
         else
         begin
           if OutputType = jp4bit then
              biBitCount := 4
           else
              biBitCount := 8;
           if cinfo.out_color_space = JCS_GRAYSCALE then
           begin
              biClrUsed := GrayscaleResolution;
              AddColorMap(BitMapInfo,@GrayscaleMap)
           end
           else
           if cinfo.colormap <> nil then
           begin
              biClrUsed := cinfo.actual_number_of_colors;
              AddColorMap(BitMapInfo,cinfo.colormap^)
           end
         end
     end;
     with JPEGObject^.Progress^ do
     begin
       pass_counter := 0;
       completed_passes := total_passes; {force 100%}
     end;
     DoProgress;
     jpeg_finish_decompress(@cinfo)
end;

procedure TJPEGDecompressor.ReadDIBtoStream(Destination: TStream;
                                                   OutputType: TJPEGOutputType);
const magic: array[0..1] of char = 'BM';
      reserved: array [0..1] of ushort = (0,0);
var BitMapInfo: PBitMapInfo;
    bits: pointer;
    mem: THandle;
    HeaderSize: longint;
    DIBSize: longint;
    DIBFileSize: longint;
begin
    DIBSize := GetDIBitsSize(OutputType);
    mem := GlobalAlloc(GHND,DIBSize);
    if mem = 0 then OutOfMemoryError;
    bits := GlobalLock(mem);
    try
      HeaderSize := GetBitmapInfoSize(OutputType);
      GetMem(BitMapInfo,HeaderSize);
      if BitmapInfo = nil then OutOfMemoryError;
      try
        ReadDIBitmap(BitMapInfo^,OutputType,bits);
        with Destination do
        begin
          Write(magic,sizeof(magic));
          DIBFileSize := 14 + HeaderSize + DIBSize;
          Write(DIBFileSize,sizeof(DIBFileSize));
          Write(Reserved,sizeof(reserved));
          Write(HeaderSize,sizeof(HeaderSize));
          Write(BitmapInfo^,HeaderSize);
          Write(bits^,DIBSize)
        end
      finally
        FreeMem(BitmapInfo,HeaderSize)
      end
    finally
      GlobalUnLock(mem);
      GlobalFree(mem)
    end
end;


{$IFDEF DELPHI3ORLATER}
function TJPEGDecompressor.ReadBitmap: TBitmap;
var M: TMemoryStream;
    OutputType: TJPEGOutputType;
begin
     M := TMemoryStream.Create;
     try
       if GrayscaleOutput  or (OutputColorSpace = JCS_GRAYSCALE) then
         OutputType := jpGrayscale {force grayscale output}
       else
         OutputType := jp24bit;
       ReadDIBtoStream(M,OutputType);
       M.Position := 0;
       Result := TBitmap.Create;
       try
         Result.LoadFromStream(M);
       except
         Result.Free;
         raise
       end
     finally
       M.Free
     end
end;
{$ELSE}
function TJPEGDecompressor.ReadBitmap: TBitmap;
var Bitmap: HBITMAP;
    Palette: HPALETTE;
begin
     Result := TBitmap.create;
     try
        ReadWinBitmap(Bitmap,Palette);
        Result.Palette := Palette;
        Result.Handle := Bitmap
     except
       Result.Free;
       raise
     end
end;
{$ENDIF}

procedure TJPEGDecompressor.ReadWinBitmap(var Bitmap: HBITMAP; var Palette: HPALETTE);

  function CreateWinPalette(const BitmapInfo: TBitmapInfo): HPalette;
  var I: integer;
      LogPalette: PLogPalette;
      PalSize: integer;
      colors: integer;
  begin
       colors := BitmapInfo.bmiHeader.biClrUsed;
       PalSize := sizeof(TLogPalette) + sizeof(TPaletteEntry) * colors;
       GetMem(LogPalette,PalSize);
       if LogPalette = nil then OutOfMemoryError;
       FillChar(LogPalette^, PalSize, 0);
       with LogPalette^ do
       try
          palVersion := $300;
          palNumEntries := colors;
          { Copy the palette from the Bitmap header }
          for I := 0 to Colors - 1 do
          begin
            palPalEntry[I].peRed := BitmapInfo.bmiColors[I].rgbRed;
            palPalEntry[I].peGreen := BitmapInfo.bmiColors[I].rgbGreen;
            palPalEntry[I].peBlue := BitmapInfo.bmiColors[I].rgbBlue;
            palPalEntry[I].peFlags := 0;
          end;
          Result := CreatePalette(LogPalette^);
       finally
         FreeMem(LogPalette,PalSize)
       end
  end;


var BitMapInfo: PBitMapInfo;
    bits: pointer;
    ScreenDC: HDC;
    dc: HDC;
    mem: THandle;
    HeaderSize: integer;
    OldPal: HPALETTE;
    OldImage,
    ScreenImage: HBitmap;
    OutputType: TJPEGOutputType;
begin
  ScreenDC := GetDC(0);
  try
    dc := CreateCompatibleDC(ScreenDC); {use a memory DC for actual realisation}
    try
      ScreenImage := CreateCompatibleBitMap(ScreenDC,1,1);
      try
       OldImage := SelectObject(dc,ScreenImage);
       try
         if GrayscaleOutput  or (OutputColorSpace = JCS_GRAYSCALE) then
           OutputType := jpGrayscale {force grayscale output}
         else
         if GetDeviceCaps(DC,RASTERCAPS) and RC_PALETTE <> 0 then
           OutputType := jp8bit
         else
         if GetDeviceCaps(DC,NUMCOLORS) = 16 then
            OutputType := jp4bit
         else
            OutputType := jp24bit;

         mem := GlobalAlloc(GHND,GetDIBitsSize(OutputType));
         if mem= 0 then OutOfMemoryError;
         bits := GlobalLock(mem);
         try
           HeaderSize := GetBitmapInfoSize(OutputType);
           GetMem(BitMapInfo,HeaderSize);
           if BitmapInfo = nil then OutOfMemoryError;
           try
             ReadDIBitmap(BitMapInfo^,OutputType,bits);
             if BitMapInfo^.bmiHeader.biBitCount <> 24 then
             begin
               Palette := CreateWinPalette(BitMapInfo^);
               OldPal := SelectPalette(dc,Palette,false)
             end
             else
               OldPal := 0;
             try
                 RealizePalette(dc);
                 Bitmap := CreateDIBitmap(dc,BitMapInfo^.bmiHeader,CBM_INIT,
                                              bits,BitMapInfo^,DIB_RGB_COLORS);
             finally
                 if OldPal <> 0 then
                 begin
                    SelectPalette(dc,OldPal,false);
                    RealizePalette(dc)
                 end
             end
           finally
             FreeMem(BitmapInfo,HeaderSize)
           end
         finally
           GlobalUnLock(mem);
           GlobalFree(mem)
         end
       finally
        SelectObject(dc,OldImage);
       end
      finally
        DeleteObject(ScreenImage)
      end
    finally
      DeleteDC(dc)
    end
  finally
    ReleaseDC(0,ScreenDC)
  end
end;

procedure TJPEGDecompressor.ReadHeader;
begin
       jpeg_read_header(@cinfo,true);
       cinfo.do_fancy_upsampling := FDoFancyUpSampling;
       cinfo.dct_method := FDCT_METHOD;
       cinfo.do_block_smoothing := FDoBlockSmoothing;
       cinfo.two_pass_quantize := FTwoPassQuantize;
       cinfo.dither_mode := FDitherMode;
       jpeg_calc_output_dimensions(@cinfo);
end;


{TJPEGStreamDecompressor------------------------------------------------}

constructor TJPEGStreamDecompressor.create(AOwner: TComponent);
begin
     inherited create(AOwner);
     BufSize := DefaultBufSize;
     if DefaultDecompressor and (DefaultJPEGDecompressor = nil) then
        DefaultJPEGDecompressor := Self
end;


destructor TJPEGStreamDecompressor.Destroy;
begin
     if assigned(FBuffer) then FreeMem(FBuffer,FBufSize);
     if DefaultJPEGDecompressor = Self then
        DefaultJPEGDecompressor := nil;
     inherited Destroy
end;

procedure TJPEGStreamDecompressor.SetBufSize(Value: integer);
begin
     if assigned(FBuffer) then
        if BytesInBuffer <> 0 then
           raise Exception.Create(sCantSetBufSize)
        else
           FreeMem(FBuffer,FBufSize);
     FBuffer := nil;
     FBufSize := Value;
     GetMem(FBuffer,BufSize);
     if FBuffer = nil then OutOfMemoryError;
end;

procedure TJPEGStreamDecompressor.InitSource;
begin
     BytesInBuffer := 0
end;

function TJPEGStreamDecompressor.FillInputBuffer: boolean;
begin
     BytesInBuffer := FStream.Read(FBuffer^,FBufSize);
     NextInputByte := JOCTET_PTR(FBuffer);
     if BytesInBuffer <= 0 then
     begin
          if FStream.Position = 0 then {treat empty file as an error}
          begin
               cinfo.common_fields.err^.msg_code := 42;
               cinfo.common_fields.err^.error_exit(@cinfo)
          end;
          cinfo.common_fields.err^.msg_code := 116;
          cinfo.common_fields.err^.emit_message(@cinfo,-1);
          { Insert a fake EOI marker }
          FBuffer^ := #$FF;
          (FBuffer + 1)^ := chr(JPEG_EOI);
          BytesInBuffer := 2
     end;
     Result := true
end;

procedure TJPEGStreamDecompressor.SkipInputBytes(num_bytes : long);
begin
     if num_bytes <= 0 then Exit;

     if num_bytes > BytesInBuffer then
     begin
          FStream.Seek(num_bytes-BytesInBuffer,soFromCurrent);
          BytesInBuffer := 0
     end
     else
     begin
          NextInputByte := JOCTET_PTR(PChar(NextInputByte) + num_bytes);
          BytesInBuffer := BytesInBuffer - num_bytes
     end
end;

function TJPEGStreamDecompressor.ResyncToRestart(desired: int): boolean;
begin
    Result := jpeg_resync_to_restart(@Cinfo,desired)
end;

procedure TJPEGStreamDecompressor.TermSource;
begin
end;

procedure TJPEGStreamDecompressor.OpenStream(Stream: TStream);
begin
     FStream := Stream;
     try
       ReadHeader
     except
       CloseStream;
       raise
     end
end;

procedure TJPEGStreamDecompressor.CloseStream;
begin
     FStream := nil
end;

procedure TJPEGStreamDecompressor.ConvertToDIB(Source, Destination: TStream;
                                                                    OutputType: TJPEGOutputType);
begin
     OpenStream(Source);
     try
       ReadDIBtoStream(Destination,OutputType)
     finally
       CloseStream
     end
end;


procedure TJPEGStreamDecompressor.LoadPictureFromStream(Picture: TPicture; Stream: TStream);
var Bitmap: TBitmap;
begin
     if assigned(Picture) then
     begin 
        Bitmap := ReadBitMapFromStream(Stream);
        try
          Picture.Bitmap := Bitmap
       finally
         Bitmap.Free
     end
  end
     else
         raise Exception.Create(sNoImage)
end;

procedure TJPEGStreamDecompressor.LoadPictureFromResource(Picture: TPicture; Instance: THandle; const ResName: string);
var S: TResourceStream;
begin
     S := TResourceStream.Create(Instance,ResName,sJPEGResourceType);
     try
        LoadPictureFromStream(Picture,S)
     finally
       S.Free
     end
end;

procedure TJPEGStreamDecompressor.LoadPictureFromResID(Picture: TPicture; Instance: THandle; ResID: Integer);
var S: TResourceStream;
begin
     S := TResourceStream.CreateFromID(Instance,ResID,sJPEGResourceType);
     try
        LoadPictureFromStream(Picture,S)
     finally
       S.Free
     end
end;

function TJPEGStreamDecompressor.ReadBitMapFromStream(Stream: TStream): TBitmap;
begin
     OpenStream(Stream);
     try
       Result := ReadBitmap
     finally
       CloseStream
     end
end;

procedure TJPEGStreamDecompressor.ReadDIBitmapFromStream(Stream: TStream;
                                       var BitMapInfo: TBitMapInfo;
                                       OutputType: TJPEGOutputType;
                                       var bits: THandle);
begin
     OpenStream(Stream);
     try
       bits := GlobalAlloc(GHND,GetDIBitsSize(OutputType));
       if bits = 0 then OutOfMemoryError;
       try
         try
           ReadDIBitmap(BitMapInfo,OutputType,GlobalLock(bits))
         finally
           GlobalUnlock(bits)
         end
       except
         GlobalFree(bits);
         raise
       end
     finally
       CloseStream
     end
end;

{TJPEGFileDecompressor-------------------------------------------------------}

procedure TJPEGFileDecompressor.LoadPictureFromFile(Picture: TPicture; const FileName: string);
var S: TFileStream;
begin
     S := TFileStream.Create(FileName,fmOpenRead);
     try
        LoadPictureFromStream(Picture,S)
     finally
        S.Free
     end
end;

{TJPEGFileCompressor-------------------------------------------------------}
procedure TJPEGFileCompressor.SavePictureToFile(Picture: TPicture; const FileName: string);
var S: TFileStream;
begin
     S := TFileStream.Create(FileName,fmCreate);
     try
        SavePictureToStream(Picture,S)
     finally
        S.Free
     end
end;

procedure TJPEGFileCompressor.SaveStretchedPictureToFile(Picture: TPicture; width, height: integer;
                           const FileName: string);
var S: TFileStream;
begin
     S := TFileStream.Create(FileName,fmCreate);
     try
        SaveStretchedPictureToStream(Picture,width,height,S)
     finally
        S.Free
     end
end;

procedure TJPEGFileCompressor.SaveBitmapToFile(bitmap: TBitmap; const FileName: string);
var S: TFileStream;
begin
     S := TFileStream.Create(FileName,fmCreate);
     try
        SaveBitmapToStream(bitmap,S)
     finally
        S.Free
     end
end;

procedure TJPEGFileCompressor.SaveStretchedBitmapToFile(bitmap: TBitmap; width, height: integer;
                     const FileName: string);
var S: TFileStream;
begin
     S := TFileStream.Create(FileName,fmCreate);
     try
        SaveStretchedBitmapToStream(bitmap,width,height,S)
     finally
        S.Free
     end
end;

procedure TJPEGFileCompressor.SaveMetafileToFile(metafile: TMetafile; width, height: integer;
                           const FileName: string);
var S: TFileStream;
begin
     S := TFileStream.Create(FileName,fmCreate);
     try
        SaveMetafileToStream(metafile,S,width,height)
     finally
        S.Free
     end
end;

{MetaToBitmap
 ============

 Converts a WIndows metafile to a bitmap.}

function MetaToBitmap(metafile: TMetaFile; Width, Height: longint): TBitmap;

var dc: HDC;
    MetaPal, OldPal: HPALETTE;
begin
     Result := TBitmap.create;
     try
       dc  := GetDC(0);
       try
         Result.Handle := CreateCompatibleBitmap(dc,Width,Height);
       finally
         ReleaseDC(0,dc);
       end;
       {$IFDEF WIN32}
       MetaPal := metafile.Palette;
       OldPal := 0;
       if MetaPal <> 0 then
       begin
            OldPal := SelectPalette(Result.Canvas.Handle, MetaPal, True);
            RealizePalette(Result.Canvas.Handle);
       end;
       Result.Canvas.FillRect(Rect(0,0,Width,Height));
       if not PlayEnhMetaFile(Result.Canvas.Handle, metafile.Handle,
                   Rect(0,0,Width,Height)) then
         raise Exception.CreateFmt(sPlayMetaFailed,[GetLastError]);
       if MetaPal <> 0 then
          SelectPalette(Result.Canvas.Handle, OldPal, True);
       {$ELSE}
       SetMapMode(Result.Canvas.Handle, MM_ANISOTROPIC);
       SetWindowExtEx(Result.Canvas.Handle, Width, Height, nil);
       SetViewportExtEx(Result.Canvas.Handle,Width,Height,nil);
       SetViewportOrgEx(Result.Canvas.Handle,0,0,nil);
       Result.Canvas.FillRect(Rect(0,0,Width,Height));
       if not PlayMetafile(Result.Canvas.Handle, metafile.Handle) then
         raise Exception.Create(sPlayMetaFailed)
       {$ENDIF}
     except
       Result.Free;
       raise
     end
end;

{TJPEGBitmap-----------------------------------------------------------------}

{$IFDEF DELPHI3ORLATER}
procedure TJPEGBitmap.HandleDecompressOnProgress(Sender: TObject);
begin
     if assigned(FProgressEvent) then FProgressEvent(Sender);
     Progress(Sender,psRunning,FDecompressor.PercentDone,false,Rect(0,0,0,0),sDecompressing);
end;

procedure TJPEGBitmap.HandleCompressOnProgress(Sender: TObject);
begin
     if assigned(FProgressEvent) then FProgressEvent(Sender);
     Progress(Sender,psRunning,FCompressor.PercentDone,false,Rect(0,0,0,0),sCompressing);
end;

{$ENDIF}

procedure TJPEGBitmap.LoadFromStream(Stream: TStream);
var Bitmap: TBitmap;
begin
  if not assigned(DefaultJPEGDecompressor) then
       FDecompressor := TJPEGStreamDecompressor.create(nil)
  else
       FDecompressor := DefaultJPEGDecompressor;

  with FDecompressor do
  try
    {$IFDEF DELPHI3ORLATER}
     Progress(Self,psStarting,0,false,Rect(0,0,0,0),sOpening);
     FProgressEvent := FDecompressor.OnProgressReport;
     FDecompressor.OnProgressReport := HandleDecompressOnProgress;
     try
     {$ENDIF}
       OpenStream(Stream);
       try
         Bitmap := ReadBitmap;
         try
           Self.Assign(Bitmap);
         finally
           Bitmap.Free
         end
       finally
         CloseStream
       end
    {$IFDEF DELPHI3ORLATER}
     finally
       Progress(Self,psEnding,0,false,Rect(0,0,0,0),sClosing);
       FDecompressor.OnProgressReport := FProgressEvent;
     end
    {$ENDIF}
  finally
    if DefaultJPEGDecompressor = nil then Free
  end
end;

procedure TJPEGBitmap.SaveToStream(Stream: TStream);
begin
     if FSaveAsBitmap then
        inherited SaveToStream(Stream)
     else {Save as a JPEG}
     begin
          if not assigned(DefaultJPEGCompressor) then
             FCompressor := TJPEGStreamCompressor.create(nil)
          else
             FCompressor := DefaultJPEGCompressor;
          try
            {$IFDEF DELPHI3ORLATER}
            Progress(Self,psStarting,0,false,Rect(0,0,0,0),sOpening);
            FProgressEvent := FCompressor.OnProgressReport;
            FCompressor.OnProgressReport := HandleCompressOnProgress;
            {$ENDIF}
            FCompressor.SaveBitmapToStream(Self,Stream)
          finally
            {$IFDEF DELPHI3ORLATER}
            Progress(Self,psEnding,0,false,Rect(0,0,0,0),sClosing);
            FCompressor.OnProgressReport := FProgressEvent;
            {$ENDIF}
            if DefaultJPEGDecompressor = nil then FCompressor.Free
          end
     end
end;

procedure TJPEGBitmap.SaveToFile(const FileName: string);
begin
   try
     FSaveAsBitmap := not(
{$IFDEF WIN32}
             (CompareText(ExtractFileExt(FileName),'.jpeg') = 0) or
{$ENDIF}
             (CompareText(ExtractFileExt(FileName),'.jpg') = 0));
     inherited SaveToFile(FileName)
   finally
     FSaveAsBitmap := false
   end
end;

{Initialisation Code}

{$IFDEF VER80}
begin
{$ELSE}
initialization
{$ENDIF}
{$IFNDEF DESIGNTIME}
     TPicture.RegisterFileFormat('jpg','JPEG Image',TJPEGBitmap);
{$IFDEF WIN32}
     TPicture.RegisterFileFormat('jpeg','JPEG Image',TJPEGBitmap);
{$ENDIF}
{$ENDIF}

{$IFDEF Delphi3orLater}
finalization
  TPicture.UnregisterGraphicClass(TJPEGBitmap);
{$ENDIF}
end.
