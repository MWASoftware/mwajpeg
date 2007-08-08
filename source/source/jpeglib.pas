unit jpeglib;

{$A-,F+}
{define STATIC_LIBRARY if you want to link in the DLL statically.
 define NODLL if you want to link the jpeg objects into your runtime program.
 Define DYNAMIC_DLL to load the DLL dynamically.
 Note: the NODLL option currently only works with Delphi 3 or C++Builder or later}
{ $DEFINE DYNAMIC_DLL}
{ $DEFINE STATIC_LIBRARY}
{ $DEFINE NODLL}

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

{$IFDEF VER93} {$DEFINE CBUILDER} {$ENDIF}
{$IFDEF CBBUILDER3OR4OR5}{$DEFINE CBUILDER} {$ENDIF}

interface

uses dialogs, sysutils;

(*
 * jpeglib.h
 *
 * Copyright (C) 1991-1998, Thomas G. Lane.
 * This file is part of the Independent JPEG Group's software.
 * For conditions of distribution and use, see the accompanying README file.
 *
 * This file defines the application interface for the JPEG library.
 * Most applications using the library need only include this file,
 * and perhaps jerror.h if they want to know the exact error codes.
 *)

 {Converted to a Delphi Import unit by Tony Whyman <tony.whyman@mwasoftware.co.uk>
  February 1997 and August 2001}

(*
 * First we include the configuration files that record how this
 * installation of the JPEG library is set up.  jconfig.h can be
 * generated automatically for many systems.  jmorecfg.h contains
 * manual configuration options that most people need not worry about.
 *)

{$I jmorecfg.inc}


(* Version ID for the JPEG library.
 * Might be useful for tests like "#if JPEG_LIB_VERSION >= 60".
 *)

Const
  JPEG_LIB_VERSION = 62;        { Version 6b }

  JMSG_STR_PARM_MAX = 80;       {For error Handler}
  JMSG_LENGTH_MAX  = 200;       { recommended size of format_message buffer }


(* Various constants determining the sizes of things.
 * All of these are specified by the JPEG standard, so don't change them
 * if you want to be compatible.
 *)

const
  DCTSIZE             = 8;      { The basic DCT block is 8x8 samples }
  DCTSIZE2            = 64;     { DCTSIZE squared; # of elements in a block }
  NUM_QUANT_TBLS      = 4;      { Quantization tables are numbered 0..3 }
  NUM_HUFF_TBLS       = 4;      { Huffman tables are numbered 0..3 }
  NUM_ARITH_TBLS      = 16;     { Arith-coding tables are numbered 0..15 }
  MAX_COMPS_IN_SCAN   = 4;      { JPEG limit on # of components in one scan }
  MAX_SAMP_FACTOR     = 4;      { JPEG limit on sampling factors }
(* Unfortunately, some bozo at Adobe saw no reason to be bound by the standard;
 * the PostScript DCT filter can emit files with many more than 10 blocks/MCU.
 * If you happen to run across such a file, you can up D_MAX_BLOCKS_IN_MCU
 * to handle it.  We even let you do this from the jconfig.h file.  However,
 * we strongly discourage changing C_MAX_BLOCKS_IN_MCU; just because Adobe
 * sometimes emits noncompliant files doesn't mean you should too.
 *)
  C_MAX_BLOCKS_IN_MCU = 10;     { compressor's limit on blocks per MCU }
  D_MAX_BLOCKS_IN_MCU = 10;     { decompressor's limit on blocks per MCU }


(* Data structures for images (arrays of samples and of DCT coefficients).
 * On 80x86 machines, the image arrays are too big for near pointers,
 * but the pointer arrays can fit in near memory.
 *)

type
  JSAMPROW = ^JSAMPLE;
  JSAMPARRAY = ^JSAMPROW ;	(* ptr to some rows (a 2-D sample array) *)
  JSAMPIMAGE = ^JSAMPARRAY;	(* a 3-D sample array: top index is color *)

  JBLOCK = array [1.. DCTSIZE2] of JCOEF;	(* one block of coefficients *)
  JBLOCKROW = ^JBLOCK;	          (* pointer to one row of coefficient blocks *)
  JBLOCKARRAY = ^JBLOCKROW;		(* a 2-D array of coefficient blocks *)
  JBLOCKIMAGE = ^JBLOCKARRAY;	(* a 3-D array of coefficient blocks *)

  JCOEFPTR = ^JCOEF;	        (* useful in a couple of places *)


(* Types for JPEG compression parameters and working tables. *)


(* DCT coefficient quantization tables. *)

JQUANT_TBL_PTR = ^JQUANT_TBL;
JQUANT_TBL = record
  (* This array gives the coefficient quantizers in natural array order
   * (not the zigzag order in which they are stored in a JPEG DQT marker).
   * CAUTION: IJG versions prior to v6a kept this array in zigzag order.
   *)
      quantval : Array[1..DCTSIZE2] of UINT16; (* quantization step for each coefficient *)
  (* This field is used only during compression.  It's initialized FALSE when
   * the table is created, and set TRUE when it's been output to the file.
   * You could suppress output of a table by setting this to TRUE.
   * (See jpeg_suppress_tables for an example.)
   *)
    sent_table : boolean;      { TRUE when table has been output }
  end;


(* Huffman coding tables. *)

  JHUFF_TBL_PTR = ^JHUFF_TBL;
  JHUFF_TBL = record
  { These two fields directly represent the contents of a JPEG DHT marker }
    bits : Array[1..17] of UINT8; { bits[k] = # of symbols with codes of }
                                    { length k bits; bits[0] is unused }
    huffval : Array[1..256] of UINT8;
                                    { The symbols, in order of incr code length }
  { This field is used only during compression.  It's initialized FALSE when
    the table is created, and set TRUE when it's been output to the file.
    You could suppress output of a table by setting this to TRUE.
    (See jpeg_suppress_tables for an example.) }
    sent_table : boolean;           { TRUE when table has been output }
  end;


(* Basic info about one component (color channel). *)

  jpeg_component_info_ptr = ^jpeg_component_info;
  jpeg_component_info = record
    { These values are fixed over the whole image. }
    { For compression, they must be supplied by parameter setup; }
    { for decompression, they are read from the SOF marker. }
    component_id : int;           { identifier for this component (0..255) }
    component_index : int;        { its index in SOF or cinfo->comp_info[] }
    h_samp_factor : int;          { horizontal sampling factor (1..4) }
    v_samp_factor : int;          { vertical sampling factor (1..4) }
    quant_tbl_no : int;           { quantization table selector (0..3) }
    { These values may vary between scans. }
    { For compression, they must be supplied by parameter setup; }
    { for decompression, they are read from the SOS marker. }
    { The decompressor output side may not use these variables. }
    dc_tbl_no : int;              { DC entropy table selector (0..3) }
    ac_tbl_no : int;              { AC entropy table selector (0..3) }

    { Remaining fields should be treated as private by applications. }

    { These values are computed during compression or decompression startup: }
    { Component's size in DCT blocks.
      Any dummy blocks added to complete an MCU are not counted; therefore
      these values do not depend on whether a scan is interleaved or not. }
    width_in_blocks : JDIMENSION;
    height_in_blocks : JDIMENSION;
    { Size of a DCT block in samples.  Always DCTSIZE for compression.
      For decompression this is the size of the output from one DCT block,
      reflecting any scaling we choose to apply during the IDCT step.
      Values of 1,2,4,8 are likely to be supported.  Note that different
      components may receive different IDCT scalings. }

    DCT_scaled_size : int;
    { The downsampled dimensions are the component's actual, unpadded number
      of samples at the main buffer (preprocessing/compression interface), thus
      downsampled_width = ceil(image_width * Hi/Hmax)
      and similarly for height.  For decompression, IDCT scaling is included, so
      downsampled_width = ceil(image_width * Hi/Hmax * DCT_scaled_size/DCTSIZE)}

    downsampled_width : JDIMENSION;        { actual width in samples }
    downsampled_height : JDIMENSION;       { actual height in samples }
    { This flag is used only for decompression.  In cases where some of the
      components will be ignored (eg grayscale output from YCbCr image),
      we can skip most computations for the unused components. }

    component_needed : boolean;     { do we need the value of this component? }

    { These values are computed before starting a scan of the component. }
    { The decompressor output side may not use these variables. }
    MCU_width : int;      { number of blocks per MCU, horizontally }
    MCU_height : int;     { number of blocks per MCU, vertically }
    MCU_blocks : int;     { MCU_width * MCU_height }
    MCU_sample_width : int;       { MCU width in samples, MCU_width*DCT_scaled_size }
    last_col_width : int;         { # of non-dummy blocks across in last MCU }
    last_row_height : int;        { # of non-dummy blocks down in last MCU }

    { Saved quantization table for component; NIL if none yet saved.
      See jdinput.c comments about the need for this information.
      This field is currently used only for decompression. }

    quant_table : JQUANT_TBL_PTR;

    { Private per-component storage for DCT or IDCT subsystem. }
    dct_table : pointer;
  end; { record jpeg_component_info }


(* The script for encoding a multiple-scan file is an array of these: *)

  jpeg_scan_info_ptr = ^jpeg_scan_info;
  jpeg_scan_info = record
    comps_in_scan : int;                { number of components encoded in this scan }
    component_index : Array[1..MAX_COMPS_IN_SCAN] of int;
                                        { their SOF/comp_info[] indexes }
    Ss, Se : int;                       { progressive JPEG spectral selection parms }
    Ah, Al : int;                       { progressive JPEG successive approx. parms }
  end;


(* The decompressor can save APPn and COM markers in a list of these: *)

jpeg_saved_marker_ptr = ^jpeg_marker_struct;

jpeg_marker_struct = record
  next: jpeg_saved_marker_ptr;	(* next in list, or NULL *)
  marker: UINT8;                (* marker code: JPEG_COM, or JPEG_APP0+n *)
  original_length: uInt;	(* # bytes of data in the file *)
  data_length: uInt;            (* # bytes of data saved at data[] *)
  data: JOCTET_PTR;		(* the data contained in the marker *)
  (* the marker length word is not counted in data_length or original_length *)
end;

(* Known color spaces. *)

J_COLOR_SPACE = (
	JCS_UNKNOWN,		(* error/unspecified *)
	JCS_GRAYSCALE,		(* monochrome *)
	JCS_RGB,		(* red/green/blue *)
	JCS_YCbCr,		(* Y/Cb/Cr (also known as YUV) *)
	JCS_CMYK,		(* C/M/Y/K *)
	JCS_YCCK		(* Y/Cb/Cr/K *)
) ;

(* DCT/IDCT algorithm options. *)

J_DCT_METHOD = (
	JDCT_ISLOW,		(* slow but accurate integer algorithm *)
	JDCT_IFAST,		(* faster, less accurate integer method *)
	JDCT_FLOAT		(* floating-point: accurate, fast on fast HW *)
) ;

const
  JDCT_DEFAULT  = JDCT_ISLOW;
  JDCT_FASTEST  = JDCT_IFAST;

  JPOOL_PERMANENT  = 0; { lasts until master record is destroyed }
  JPOOL_IMAGE      = 1; { lasts until done with image/datastream }
  JPOOL_NUMPOOLS   = 2;

  (* Dithering options for decompression. *)

type
J_DITHER_MODE = (
	JDITHER_NONE,		(* no dithering *)
	JDITHER_ORDERED,	(* simple ordered dither *)
	JDITHER_FS		(* Floyd-Steinberg error diffusion dither *)
) ;

  {Pointers to various structures defined later}
  jpeg_error_mgr_ptr = ^jpeg_error_mgr;
  jpeg_memory_mgr_ptr = ^jpeg_memory_mgr;
  jpeg_progress_mgr_ptr = ^jpeg_progress_mgr;
  jpeg_destination_mgr_ptr = ^jpeg_destination_mgr;
  jpeg_source_mgr_ptr = ^jpeg_source_mgr;


  j_common_ptr = ^jpeg_common_struct;
  j_compress_ptr = ^jpeg_compress_struct;
  j_decompress_ptr = ^jpeg_decompress_struct;


(* Common fields between JPEG compression and decompression master structs. *)

  jpeg_common_struct = record
  { Fields common to both master struct types }
    err : jpeg_error_mgr_ptr;           { Error handler module }
    mem : jpeg_memory_mgr_ptr;          { Memory manager module }
    progress : jpeg_progress_mgr_ptr;   { Progress monitor, or NIL if none }
    UserRef: TObject;                    {User information - points to Delphi Obkect}
    is_decompressor : boolean;     { so common code can tell which is which }
    global_state : int;            { for checking call sequence validity }

  { Additional fields follow in an actual jpeg_compress_struct or
    jpeg_decompress_struct.  All three structs must agree on these
    initial fields!  (This would be a lot cleaner in C++. - or Delphi :-) }
  end;


(* Master record for a compression instance *)

  jpeg_compress_struct = record
    { Fields shared with jpeg_decompress_struct }
    common_fields: jpeg_common_struct;

  { Destination for compressed data }
    dest : jpeg_destination_mgr_ptr;

  { Description of source image --- these fields must be filled in by
    outer application before starting compression.  in_color_space must
    be correct before you can even call jpeg_set_defaults(). }


    image_width : JDIMENSION;         { input image width }
    image_height : JDIMENSION;        { input image height }
    input_components : int;           { # of color components in input image }
    in_color_space : J_COLOR_SPACE;   { colorspace of input image }

    input_gamma : double;             { image gamma of input image }

    { Compression parameters --- these fields must be set before calling
      jpeg_start_compress().  We recommend calling jpeg_set_defaults() to
      initialize everything to reasonable defaults, then changing anything
      the application specifically wants to change.  That way you won't get
      burnt when new parameters are added.  Also note that there are several
      helper routines to simplify changing parameters. }

    data_precision : int;             { bits of precision in image data }

    num_components : int;             { # of color components in JPEG image }
    jpeg_color_space : J_COLOR_SPACE; { colorspace of JPEG image }

    comp_info : jpeg_component_info_ptr;
    { actually a jpeg_component_info_list_ptr; - Nomssi }
    { comp_info[i] describes component that appears i'th in SOF }

    quant_tbl_ptrs: Array[1..NUM_QUANT_TBLS] of JQUANT_TBL_PTR;
    { ptrs to coefficient quantization tables, or NIL if not defined }

    dc_huff_tbl_ptrs : Array[1..NUM_HUFF_TBLS] of JHUFF_TBL_PTR;
    ac_huff_tbl_ptrs : Array[1..NUM_HUFF_TBLS] of JHUFF_TBL_PTR;
    { ptrs to Huffman coding tables, or NIL if not defined }

    arith_dc_L : Array[1..NUM_ARITH_TBLS] of UINT8; { L values for DC arith-coding tables }
    arith_dc_U : Array[1..NUM_ARITH_TBLS] of UINT8; { U values for DC arith-coding tables }
    arith_ac_K : Array[1..NUM_ARITH_TBLS] of UINT8; { Kx values for AC arith-coding tables }

    num_scans : int;		 { # of entries in scan_info array }
    scan_info : jpeg_scan_info_ptr; { script for multi-scan file, or NIL }
    { The default value of scan_info is NIL, which causes a single-scan
      sequential JPEG file to be emitted.  To create a multi-scan file,
      set num_scans and scan_info to point to an array of scan definitions. }

    raw_data_in : boolean;        { TRUE=caller supplies downsampled data }
    arith_code : boolean;         { TRUE=arithmetic coding, FALSE=Huffman }
    optimize_coding : boolean;    { TRUE=optimize entropy encoding parms }
    CCIR601_sampling : boolean;   { TRUE=first samples are cosited }
    smoothing_factor : int;       { 1..100, or 0 for no input smoothing }
    dct_method : J_DCT_METHOD;    { DCT algorithm selector }

    { The restart interval can be specified in absolute MCUs by setting
      restart_interval, or in MCU rows by setting restart_in_rows
      (in which case the correct restart_interval will be figured
      for each scan). }

    restart_interval : uint;      { MCUs per restart, or 0 for no restart }
    restart_in_rows : int;        { if > 0, MCU rows per restart interval }

    { Parameters controlling emission of special markers. }

    write_JFIF_header : boolean;  { should a JFIF marker be written? }
    JFIF_major_version: UINT8;	  { What to write for the JFIF version number}
    JFIF_minor_version: UINT8;
    { These three values are not used by the JPEG code, merely copied }
    { into the JFIF APP0 marker.  density_unit can be 0 for unknown, }
    { 1 for dots/inch, or 2 for dots/cm.  Note that the pixel aspect }
    { ratio is defined by X_density/Y_density even when density_unit=0. }
    density_unit : UINT8;         { JFIF code for pixel size units }
    X_density : UINT16;           { Horizontal pixel density }
    Y_density : UINT16;           { Vertical pixel density }
    write_Adobe_marker : boolean; { should an Adobe marker be written? }

    { State variable: index of next scanline to be written to
      jpeg_write_scanlines().  Application may use this to control its
      processing loop, e.g., "while (next_scanline < image_height)". }

    next_scanline : JDIMENSION;   { 0 .. image_height-1  }

    { Remaining fields are known throughout compressor, but generally
      should not be touched by a surrounding application. }

    { These fields are computed during compression startup }
    progressive_mode : boolean;   { TRUE if scan script uses progressive mode }
    max_h_samp_factor : int;      { largest h_samp_factor }
    max_v_samp_factor : int;      { largest v_samp_factor }

    total_iMCU_rows : JDIMENSION; { # of iMCU rows to be input to coef ctlr }
    { The coefficient controller receives data in units of MCU rows as defined
      for fully interleaved scans (whether the JPEG file is interleaved or not).
      There are v_samp_factor * DCTSIZE sample rows of each component in an
      "iMCU" (interleaved MCU) row. }

    { These fields are valid during any one scan.
      They describe the components and MCUs actually appearing in the scan. }

    comps_in_scan : int;          { # of JPEG components in this scan }
    cur_comp_info : Array[1..MAX_COMPS_IN_SCAN] of jpeg_component_info_ptr;
    { cur_comp_info[i]^ describes component that appears i'th in SOS }

    MCUs_per_row : JDIMENSION;    { # of MCUs across the image }
    MCU_rows_in_scan : JDIMENSION;{ # of MCU rows in the image }

    blocks_in_MCU : int;          { # of DCT blocks per MCU }
    MCU_membership : Array[1..C_MAX_BLOCKS_IN_MCU] of int;
    { MCU_membership[i] is index in cur_comp_info of component owning }
    { i'th block in an MCU }

    Ss, Se, Ah, Al : int;         { progressive JPEG parameters for scan }

    { Links to compression subobjects (methods and private variables of modules) }
    master : pointer;
    main : pointer;
    prep : pointer;
    coef : pointer;
    marker : pointer;
    cconvert : pointer;
    downsample : pointer;
    fdct : pointer;
    entropy : pointer;
    script_space: jpeg_scan_info_ptr; { workspace for jpeg_simple_progression }
    script_space_size: int;
  end;


{ Master record for a decompression instance }

  coef_bits_field = Array[1..DCTSIZE2] of int;
  coef_bits_ptr = ^coef_bits_field;
  coef_bits_ptrfield =  Array[1..MAX_COMPS_IN_SCAN] of coef_bits_field;
  coef_bits_ptrrow = ^coef_bits_ptrfield;

  range_limit_table = array[-(MAXJSAMPLE+1)..4*(MAXJSAMPLE+1)
                            + CENTERJSAMPLE -1] of JSAMPLE;
  range_limit_table_ptr = ^range_limit_table;

  jpeg_decompress_struct = record
  { Fields shared with jpeg_compress_struct }
    common_fields: jpeg_common_struct;

    { Source of compressed data }
    src : jpeg_source_mgr_ptr;

    { Basic description of image --- filled in by jpeg_read_header(). }
    { Application may inspect these values to decide how to process image. }

    image_width : JDIMENSION;      { nominal image width (from SOF marker) }
    image_height : JDIMENSION;     { nominal image height }
    num_components : int;          { # of color components in JPEG image }
    jpeg_color_space : J_COLOR_SPACE; { colorspace of JPEG image }

    { Decompression processing parameters --- these fields must be set before
      calling jpeg_start_decompress().  Note that jpeg_read_header()
      initializes them to default values. }

    out_color_space : J_COLOR_SPACE; { colorspace for output }

    scale_num, scale_denom : uint ;  { fraction by which to scale image }

    output_gamma : double;           { image gamma wanted in output }

    buffered_image : boolean;        { TRUE=multiple output passes }
    raw_data_out : boolean;          { TRUE=downsampled data wanted }

    dct_method : J_DCT_METHOD;       { IDCT algorithm selector }
    do_fancy_upsampling : boolean;   { TRUE=apply fancy upsampling }
    do_block_smoothing : boolean;    { TRUE=apply interblock smoothing }

    quantize_colors : boolean;       { TRUE=colormapped output wanted }
    { the following are ignored if not quantize_colors: }
    dither_mode : J_DITHER_MODE;     { type of color dithering to use }
    two_pass_quantize : boolean;     { TRUE=use two-pass color quantization }
    desired_number_of_colors : int;  { max # colors to use in created colormap }
    { these are significant only in buffered-image mode: }
    enable_1pass_quant : boolean;    { enable future use of 1-pass quantizer }
    enable_external_quant : boolean; { enable future use of external colormap }
    enable_2pass_quant : boolean;    { enable future use of 2-pass quantizer }

    { Description of actual output image that will be returned to application.
      These fields are computed by jpeg_start_decompress().
      You can also use jpeg_calc_output_dimensions() to determine these values
      in advance of calling jpeg_start_decompress(). }

    output_width : JDIMENSION;       { scaled image width }
    output_height: JDIMENSION;       { scaled image height }
    out_color_components : int;  { # of color components in out_color_space }
    output_components : int;     { # of color components returned }
    { output_components is 1 (a colormap index) when quantizing colors;
      otherwise it equals out_color_components. }

    rec_outbuf_height : int;     { min recommended height of scanline buffer }
    { If the buffer passed to jpeg_read_scanlines() is less than this many
      rows high, space and time will be wasted due to unnecessary data
      copying. Usually rec_outbuf_height will be 1 or 2, at most 4. }

    { When quantizing colors, the output colormap is described by these
      fields. The application can supply a colormap by setting colormap
      non-NIL before calling jpeg_start_decompress; otherwise a colormap
      is created during jpeg_start_decompress or jpeg_start_output. The map
      has out_color_components rows and actual_number_of_colors columns. }

    actual_number_of_colors : int;      { number of entries in use }
    colormap : JSAMPARRAY;              { The color map as a 2-D pixel array }

    { State variables: these variables indicate the progress of decompression.
      The application may examine these but must not modify them. }

    { Row index of next scanline to be read from jpeg_read_scanlines().
      Application may use this to control its processing loop, e.g.,
      "while (output_scanline < output_height)". }

    output_scanline : JDIMENSION; { 0 .. output_height-1  }

    { Current input scan number and number of iMCU rows completed in scan.
      These indicate the progress of the decompressor input side. }

    input_scan_number : int;      { Number of SOS markers seen so far }
    input_iMCU_row : JDIMENSION;  { Number of iMCU rows completed }

    { The "output scan number" is the notional scan being displayed by the
      output side.  The decompressor will not allow output scan/row number
      to get ahead of input scan/row, but it can fall arbitrarily far behind.}

    output_scan_number : int;     { Nominal scan number being displayed }
    output_iMCU_row : int;        { Number of iMCU rows read }

    { Current progression status.  coef_bits[c][i] indicates the precision
      with which component c's DCT coefficient i (in zigzag order) is known.
      It is -1 when no data has yet been received, otherwise it is the point
      transform (shift) value for the most recent scan of the coefficient
      (thus, 0 at completion of the progression).
      This pointer is NIL when reading a non-progressive file. }

    coef_bits : coef_bits_ptr;
                 { -1 or current Al value for each coef }

    { Internal JPEG parameters --- the application usually need not look at
      these fields.  Note that the decompressor output side may not use
      any parameters that can change between scans. }

    { Quantization and Huffman tables are carried forward across input
      datastreams when processing abbreviated JPEG datastreams. }

    quant_tbl_ptrs : Array[1..NUM_QUANT_TBLS] of JQUANT_TBL_PTR;
    { ptrs to coefficient quantization tables, or NIL if not defined }

    dc_huff_tbl_ptrs : Array[1..NUM_HUFF_TBLS] of JHUFF_TBL_PTR;
    ac_huff_tbl_ptrs : Array[1..NUM_HUFF_TBLS] of JHUFF_TBL_PTR;
    { ptrs to Huffman coding tables, or NIL if not defined }

    { These parameters are never carried across datastreams, since they
      are given in SOF/SOS markers or defined to be reset by SOI. }

    data_precision : int;          { bits of precision in image data }

    comp_info : jpeg_component_info_ptr;
    { actually a jpeg_component_info_list_ptr; - Nomssi }
    { comp_info[i] describes component that appears i'th in SOF }

    progressive_mode : boolean;    { TRUE if SOFn specifies progressive mode }
    arith_code : boolean;          { TRUE=arithmetic coding, FALSE=Huffman }

    arith_dc_L : Array[1..NUM_ARITH_TBLS] of UINT8; { L values for DC arith-coding tables }
    arith_dc_U : Array[1..NUM_ARITH_TBLS] of UINT8; { U values for DC arith-coding tables }
    arith_ac_K : Array[1..NUM_ARITH_TBLS] of UINT8; { Kx values for AC arith-coding tables }

    restart_interval : uint; { MCUs per restart interval, or 0 for no restart }

    { These fields record data obtained from optional markers recognized by
      the JPEG library. }

    saw_JFIF_marker : boolean;  { TRUE iff a JFIF APP0 marker was found }
    JFIF_major_version: UINT8;	{ JFIF version number }
    JFIF_minor_version: UINT8;
    { Data copied from JFIF marker: }
    density_unit : UINT8;       { JFIF code for pixel size units }
    X_density : UINT16;         { Horizontal pixel density }
    Y_density : UINT16;         { Vertical pixel density }
    saw_Adobe_marker : boolean; { TRUE iff an Adobe APP14 marker was found }
    Adobe_transform : UINT8;    { Color transform code from Adobe marker }

    CCIR601_sampling : boolean; { TRUE=first samples are cosited }

    { Aside from the specific data retained from APPn markers known to the
      library, the uninterpreted contents of any or all APPn and COM markers
      can be saved in a list for examination by the application.
    }
    marker_list: jpeg_saved_marker_ptr; { Head of list of saved markers }

    { Remaining fields are known throughout decompressor, but generally
      should not be touched by a surrounding application. }


    { These fields are computed during decompression startup }

    max_h_samp_factor : int;    { largest h_samp_factor }
    max_v_samp_factor : int;    { largest v_samp_factor }

    min_DCT_scaled_size : int;  { smallest DCT_scaled_size of any component }

    total_iMCU_rows : JDIMENSION; { # of iMCU rows in image }
    { The coefficient controller's input and output progress is measured in
      units of "iMCU" (interleaved MCU) rows.  These are the same as MCU rows
      in fully interleaved JPEG scans, but are used whether the scan is
      interleaved or not.  We define an iMCU row as v_samp_factor DCT block
      rows of each component.  Therefore, the IDCT output contains
      v_samp_factor*DCT_scaled_size sample rows of a component per iMCU row.}

    sample_range_limit : range_limit_table_ptr; { table for fast range-limiting }


    { These fields are valid during any one scan.
      They describe the components and MCUs actually appearing in the scan.
      Note that the decompressor output side must not use these fields. }

    comps_in_scan : int;           { # of JPEG components in this scan }
    cur_comp_info : Array[1..MAX_COMPS_IN_SCAN] of jpeg_component_info_ptr;
    { cur_comp_info[i]^ describes component that appears i'th in SOS }

    MCUs_per_row : JDIMENSION;     { # of MCUs across the image }
    MCU_rows_in_scan : JDIMENSION; { # of MCU rows in the image }

    blocks_in_MCU : JDIMENSION;    { # of DCT blocks per MCU }
    MCU_membership : Array[1..D_MAX_BLOCKS_IN_MCU] of int;
    { MCU_membership[i] is index in cur_comp_info of component owning }
    { i'th block in an MCU }

    Ss, Se, Ah, Al : int;          { progressive JPEG parameters for scan }

    { This field is shared between entropy decoder and marker parser.
      It is either zero or the code of a JPEG marker that has been
      read from the data source, but has not yet been processed. }

    unread_marker : int;

    { Links to decompression subobjects
      (methods, private variables of modules) }

    master : pointer;
    main : pointer;
    coef : pointer;
    post : pointer;
    inputctl : pointer;
    marker : pointer;
    entropy : pointer;
    idct : pointer;
    upsample : pointer;
    cconvert : pointer;
    cquantize : pointer;
  end;




(* "Object" declarations for JPEG modules that may be supplied or called
 * directly by the surrounding application.
 * As with all objects in the JPEG library, these structs only define the
 * publicly visible methods and state variables of a module.  Additional
 * private fields may exist after the public ones.
 *)


(* Error handler object *)

  jpeg_error_mgr = record
    { Error exit handler: does not return to caller }
    error_exit : procedure  (cinfo : j_common_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    { Conditionally emit a trace or warning message }
    emit_message : procedure (cinfo : j_common_ptr; msg_level : int);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    { Routine that actually outputs a trace or error message }
    output_message : procedure (cinfo : j_common_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    { Format a message string for the most recent JPEG error or message }
    format_message : procedure  (cinfo : j_common_ptr; buffer : PChar);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    { Reset error state variables at start of a new image }
    reset_error_mgr : procedure (cinfo : j_common_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    { The message ID code and any parameters are saved here.
      A message can have one string parameter or up to 8 int parameters. }

    msg_code : int;

    msg_parm : record
      case byte of
      0:(i : int8array);
      1:(s : array [1..JMSG_STR_PARM_MAX] of char);
    end;

    { Standard state variables for error facility }

    trace_level : int;         { max msg_level that will be displayed }

    { For recoverable corrupt-data errors, we emit a warning message,
      but keep going unless emit_message chooses to abort.  emit_message
      should count warnings in num_warnings.  The surrounding application
      can check for bad data by seeing if num_warnings is nonzero at the
      end of processing. }

    num_warnings : long;       { number of corrupt-data warnings }

    { These fields point to the table(s) of error message strings.
      An application can change the table pointer to switch to a different
      message list (typically, to change the language in which errors are
      reported).  Some applications may wish to add additional error codes
      that will be handled by the JPEG library error mechanism; the second
      table pointer is used for this purpose.

      First table includes all errors generated by JPEG library itself.
      Error code 0 is reserved for a "no such error string" message. }

    {const char * const * jpeg_message_table; }
    jpeg_message_table : pointer; { Library errors }

    last_jpeg_message : int;
      { Table contains strings 0..last_jpeg_message }
    { Second table can be added by application (see cjpeg/djpeg for example).
      It contains strings numbered first_addon_message..last_addon_message. }

    {const char * const * addon_message_table; }
    addon_message_table : pointer; { Non-library errors }

    first_addon_message : int;  { code for first string in addon table }
    last_addon_message : int;   { code for last string in addon table }
  end;


(* Progress monitor object *)

  jpeg_progress_mgr = record
    progress_monitor : procedure(cinfo : j_common_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    pass_counter : long;        { work units completed in this pass }
    pass_limit : long;          { total number of work units in this pass }
    completed_passes : int;	{ passes completed so far }
    total_passes : int;         { total number of passes expected }
  end;


(* Data destination object for compression *)

  jpeg_destination_mgr = record
    next_output_byte : JOCTET_PTR;  { => next byte to write in buffer }
    free_in_buffer : localsize_t;    { # of byte spaces remaining in buffer }

    init_destination : procedure (cinfo : j_compress_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    empty_output_buffer : function (cinfo : j_compress_ptr) : boolean;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    term_destination : procedure (cinfo : j_compress_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
  end;


(* Data source object for decompression *)

  jpeg_source_mgr = record
    {const JOCTET * next_input_byte;}
    next_input_byte : JOCTET_PTR;      { => next byte to read from buffer }
    bytes_in_buffer : localsize_t;       { # of bytes remaining in buffer }

    init_source : procedure  (cinfo : j_decompress_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    fill_input_buffer : function (cinfo : j_decompress_ptr) : boolean;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    skip_input_data : procedure (cinfo : j_decompress_ptr; num_bytes : long);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    resync_to_restart : function (cinfo : j_decompress_ptr;
                                  desired : int) : boolean;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    term_source : procedure (cinfo : j_decompress_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
  end;


(* Memory manager object.
 * Allocates "small" objects (a few K total), "large" objects (tens of K),
 * and "really big" objects (virtual arrays with backing store if needed).
 * The memory manager does not allow individual objects to be freed; rather,
 * each created object is assigned to a pool, and whole pools can be freed
 * at once.  This is faster and more convenient than remembering exactly what
 * to free, especially where malloc()/free() are not too speedy.
 * NB: alloc routines never return NULL.  They exit to error_exit if not
 * successful.
 *)

  jvirt_sarray_ptr = pointer;
  jvirt_barray_ptr = pointer;

  jpeg_memory_mgr = record
    { Method pointers }
    alloc_small : function (cinfo : j_common_ptr; pool_id : int;
				  sizeofobject : localsize_t) : pointer;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    alloc_large : function (cinfo : j_common_ptr; pool_id : int;
				  sizeofobject : localsize_t) : pointer; {far}
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    alloc_sarray : function (cinfo : j_common_ptr; pool_id : int;
                             samplesperrow : JDIMENSION;
                             numrows : JDIMENSION) : JSAMPARRAY;

                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    alloc_barray : function (cinfo : j_common_ptr; pool_id : int;
                             blocksperrow : JDIMENSION;
                             numrows : JDIMENSION) : JBLOCKARRAY;

                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    request_virt_sarray : function(cinfo : j_common_ptr;
                                   pool_id : int;
                                   pre_zero : boolean;
                                   samplesperrow : JDIMENSION;
                                   numrows : JDIMENSION;
                                   maxaccess : JDIMENSION) : jvirt_sarray_ptr;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    request_virt_barray : function(cinfo : j_common_ptr;
                                   pool_id : int;
                                   pre_zero : boolean;
                                   blocksperrow : JDIMENSION;
                                   numrows : JDIMENSION;
                                   maxaccess : JDIMENSION) : jvirt_barray_ptr;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    realize_virt_arrays : procedure (cinfo : j_common_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    access_virt_sarray : function (cinfo : j_common_ptr;
                                   ptr : jvirt_sarray_ptr;
                                   start_row : JDIMENSION;
                                   num_rows : JDIMENSION;
				   writable : boolean) : JSAMPARRAY;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    access_virt_barray : function (cinfo : j_common_ptr;
                                   ptr : jvirt_barray_ptr;
                                   start_row : JDIMENSION;
                                   num_rows : JDIMENSION;
                                   writable : boolean) : JBLOCKARRAY;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    free_pool : procedure  (cinfo : j_common_ptr; pool_id : int);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}
    self_destruct : procedure (cinfo : j_common_ptr);
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

    { Limit on memory allocation for this JPEG object.  (Note that this is
      merely advisory, not a guaranteed maximum; it only affects the space
      used for virtual-array buffers.)  May be changed by outer application
      after creating the JPEG object. }
    max_memory_to_use : long;

    { Maximum allocation request accepted by alloc_large. }
    max_alloc_chunk: long;
  end;


const
  JPEG_SUSPENDED              = 0; { Suspended due to lack of input data }
  JPEG_HEADER_OK              = 1; { Found valid image datastream }
  JPEG_HEADER_TABLES_ONLY     = 2; { Found valid table-specs-only datastream }
{ If you pass require_image = TRUE (normal case), you need not check for
  a TABLES_ONLY return code; an abbreviated file will cause an error exit.
  JPEG_SUSPENDED is only possible if you use a data source module that can
  give a suspension return (the stdio source module doesn't). }


{ function jpeg_consume_input (cinfo : j_decompress_ptr) : int;
  Return value is one of: }

  JPEG_REACHED_SOS            = 1; { Reached start of new scan }
  JPEG_REACHED_EOI            = 2; { Reached end of image }
  JPEG_ROW_COMPLETED          = 3; { Completed one iMCU row }
  JPEG_SCAN_COMPLETED         = 4; { Completed last iMCU row of a scan }

{ These marker codes are exported since applications and data source modules
  are likely to want to use them. }

const
  JPEG_RST0     = $D0;  { RST0 marker code }
  JPEG_EOI      = $D9;  { EOI marker code }
  JPEG_APP0     = $E0;  { APP0 marker code }
  JPEG_COM      = $FE;  { COM marker code }


type

{ Routine signature for application-supplied marker processing methods.
  Need not pass marker code since it is stored in cinfo^.unread_marker. }

  jpeg_marker_parser_method = function(cinfo : j_decompress_ptr) : boolean;
                                    {$IFDEF WIN32} stdcall; {$ENDIF}

{  Initialization of JPEG compression objects.
 * NB: you must set up the error-manager BEFORE calling jpeg_Create_xxx.
  }
procedure jpeg_Create_Compress(cinfo: j_compress_ptr);

procedure jpeg_Create_Decompress(cinfo: j_decompress_ptr);

{$IFDEF NODLL}
{provides required external reference}
function _wsprintfA(Output: PAnsiChar; Format: PAnsiChar): Integer; stdcall;
{$UNDEF DYNAMIC_DLL}
{$ENDIF}

{$IFNDEF DYNAMIC_DLL}
{  Destruction of JPEG compression objects  }
procedure jpeg_destroy_compress(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

procedure jpeg_destroy_decompress(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}


{  Default parameter setup for compression  }
procedure jpeg_set_defaults(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

{  Compression parameter setup aids  }
procedure jpeg_set_colorspace(cinfo: j_compress_ptr;
				      colorspace: J_COLOR_SPACE);
                                      {$IFDEF WIN32} stdcall;
                                      {$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

procedure jpeg_default_colorspace(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

procedure jpeg_set_quality(cinfo: j_compress_ptr; quality: int;
				   force_baseline: boolean);
                                   {$IFDEF WIN32} stdcall;
                                   {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

procedure jpeg_set_linear_quality(cinfo: j_compress_ptr;
					  scale_factor: int;
					  force_baseline: boolean);
                                          {$IFDEF WIN32} stdcall;
                                          {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

procedure jpeg_add_quant_table(cinfo: j_compress_ptr; which_tbl: int;
				       const basic_table: uint_ptr;
				       scale_factor: int;
				       force_baseline: boolean);
                                       {$IFDEF WIN32} stdcall;
                                       {$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

function jpeg_quality_scaling(quality: int):int;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

procedure jpeg_simple_progression(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

procedure jpeg_suppress_tables(cinfo: j_compress_ptr;
				       suppress: boolean);
                                       {$IFDEF WIN32} stdcall;
                                       {$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

function jpeg_alloc_quant_table(cinfo: jpeg_common_struct): JQUANT_TBL_PTR;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

function jpeg_alloc_huff_table(cinfo: jpeg_common_struct):JHUFF_TBL_PTR;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Main entry points for compression  }
procedure jpeg_start_compress(cinfo: j_compress_ptr;
				      write_all_tables: boolean);
                                      {$IFDEF WIN32} stdcall;
                                      {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

function jpeg_write_scanlines(cinfo: j_compress_ptr;
					     scanlines: JSAMPARRAY;
					     num_lines: JDIMENSION): JDIMENSION;
                                             {$IFDEF WIN32} stdcall;
                                             {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

procedure jpeg_finish_compress(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Replaces jpeg_write_scanlines when writing raw downsampled data.  }
function jpeg_write_raw_data(cinfo: j_compress_ptr;
					    data: JSAMPIMAGE;
					    num_lines: JDIMENSION): JDIMENSION;
                                            {$IFDEF WIN32} stdcall;
                                            {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Write a special marker.  See libjpeg.doc concerning safe usage.  }
procedure jpeg_write_marker
	(cinfo: j_compress_ptr; marker: int ;
	     const dataptr: JOCTET_PTR; datalen: uint);
             {$IFDEF WIN32} stdcall;
             {$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

{ Same, but piecemeal. }
procedure jpeg_write_m_header
	(cinfo: j_compress_ptr; marker: int; datalen: uint);
             {$IFDEF WIN32} stdcall;
             {$IFDEF NODLL} external; {$ENDIF} {$ENDIF}
procedure jpeg_write_m_byte
	(cinfo: j_compress_ptr; val: int);
             {$IFDEF WIN32} stdcall;
             {$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

{  Alternate compression function: just write an abbreviated table file  }
procedure jpeg_write_tables(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}  {$ENDIF}


{  Decompression startup: read start of JPEG datastream to see what's there  }
function jpeg_read_header(cinfo: j_decompress_ptr;
				  require_image: boolean): int;
                                  {$IFDEF WIN32} stdcall;
                                  {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  If you pass require_image = TRUE (normal case), you need not check for
 * a TABLES_ONLY return code; an abbreviated file will cause an error exit.
 * JPEG_SUSPENDED is only possible if you use a data source module that can
 * give a suspension return (the stdio source module doesn't).
  }

{  Main entry points for decompression  }
function jpeg_start_decompress(cinfo: j_decompress_ptr ):boolean;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

function jpeg_read_scanlines(cinfo: j_decompress_ptr;
					    scanlines: JSAMPARRAY;
					    max_lines: JDIMENSION): JDIMENSION;
                                            {$IFDEF WIN32} stdcall;
                                            {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

function  jpeg_finish_decompress(cinfo: j_decompress_ptr):boolean;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}


{  Replaces jpeg_read_scanlines when reading raw downsampled data.  }
function jpeg_read_raw_data(cinfo: j_decompress_ptr;
					   data: JSAMPIMAGE;
					   max_lines: JDIMENSION): JDIMENSION;
                                           {$IFDEF WIN32} stdcall;
                                           {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Additional entry points for buffered-image mode.  }
function jpeg_has_multiple_scans(cinfo: j_decompress_ptr): boolean;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

function jpeg_start_output(cinfo: j_decompress_ptr;
				       scan_number: int): boolean;
                                       {$IFDEF WIN32} stdcall;
                                       {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

function jpeg_finish_output(cinfo: j_decompress_ptr ):boolean;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

function jpeg_input_complete(cinfo: j_decompress_ptr ): boolean;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

procedure jpeg_new_colormap(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

function  jpeg_consume_input(cinfo: j_decompress_ptr):int;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Precalculate output dimensions for current decompression parameters.  }
procedure jpeg_calc_output_dimensions(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{ Control saving of COM and APPn markers into marker_list. }
procedure jpeg_save_markers
	(cinfo: j_decompress_ptr; marker_code: int;
	      length_limit: uint);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}

{  Install a special processing method for COM or APPn markers.  }
procedure jpeg_set_marker_processor
	(cinfo: j_decompress_ptr; marker_code: int;
	     routine: jpeg_marker_parser_method );
                 {$IFDEF WIN32} stdcall;
                 {$IFDEF NODLL} external; {$ENDIF}{$ENDIF}



{  If you choose to abort compression or decompression before completing
 * jpeg_finish_(de)compress, then you need to clean up to release memory,
 * temporary files, etc.  You can just call jpeg_destroy_(de)compress
 * if you're done with the JPEG object, but if you want to clean it up and
 * reuse it, call this:
  }
procedure jpeg_abort_compress(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

procedure jpeg_abort_decompress(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Generic versions of jpeg_abort and jpeg_destroy that work on either
 * flavor of JPEG object.  These may be more convenient in some places.
  }
procedure jpeg_abort(cinfo: j_common_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF} {$ENDIF}

procedure jpeg_destroy(cinfo: j_common_ptr);
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}{$ENDIF}


{  Default restart-marker-resync procedure for use by data source modules  }
function  jpeg_resync_to_restart(cinfo: j_decompress_ptr;
					    desired: int): boolean;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}  {$ENDIF}


function jpeg_std_error (err: jpeg_error_mgr_ptr): jpeg_error_mgr_ptr;
{$IFDEF WIN32} stdcall;
{$IFDEF NODLL} external; {$ENDIF}  {$ENDIF}

{$ELSE}

var
{  Destruction of JPEG compression objects  }
jpeg_destroy_compress: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_destroy_decompress: procedure(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Default parameter setup for compression  }
jpeg_set_defaults: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

{  Compression parameter setup aids  }
jpeg_set_colorspace: procedure(cinfo: j_compress_ptr;
				      colorspace: J_COLOR_SPACE);
                                      {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_default_colorspace: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_set_quality: procedure(cinfo: j_compress_ptr; quality: int;
				   force_baseline: boolean);
                                   {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_set_linear_quality: procedure(cinfo: j_compress_ptr;
					  scale_factor: int;
					  force_baseline: boolean);
                                          {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_add_quant_table: procedure(cinfo: j_compress_ptr; which_tbl: int;
				       const basic_table: uint_ptr;
				       scale_factor: int;
				       force_baseline: boolean);
                                       {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_quality_scaling: function(quality: int):int;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_simple_progression: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_suppress_tables: procedure(cinfo: j_compress_ptr;
				       suppress: boolean);
                                       {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_alloc_quant_table: function(cinfo: jpeg_common_struct): JQUANT_TBL_PTR;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_alloc_huff_table: function(cinfo: jpeg_common_struct):JHUFF_TBL_PTR;
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Main entry points for compression  }
jpeg_start_compress: procedure(cinfo: j_compress_ptr;
				      write_all_tables: boolean);
                                      {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_write_scanlines: function(cinfo: j_compress_ptr;
					     scanlines: JSAMPARRAY;
					     num_lines: JDIMENSION): JDIMENSION;
                                             {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_finish_compress: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Replaces jpeg_write_scanlines when writing raw downsampled data.  }
jpeg_write_raw_data: function(cinfo: j_compress_ptr;
					    data: JSAMPIMAGE;
					    num_lines: JDIMENSION): JDIMENSION;
                                            {$IFDEF WIN32} stdcall; {$ENDIF}


{  Write a special marker.  See libjpeg.doc concerning safe usage.  }
jpeg_write_marker
	: procedure(cinfo: j_compress_ptr; marker: int ;
	     const dataptr: JOCTET_PTR; datalen: uint);
             {$IFDEF WIN32} stdcall; {$ENDIF}


{ Same, but piecemeal. }
jpeg_write_m_header: procedure(cinfo: j_compress_ptr; marker: int; datalen: uint);
             {$IFDEF WIN32} stdcall; {$ENDIF}
jpeg_write_m_byte: procedure(cinfo: j_compress_ptr; val: int);
             {$IFDEF WIN32} stdcall; {$ENDIF}

{  Alternate compression function: just write an abbreviated table file  }
jpeg_write_tables: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Decompression startup: read start of JPEG datastream to see what's there  }
jpeg_read_header: function(cinfo: j_decompress_ptr;
				  require_image: boolean): int;
                                  {$IFDEF WIN32} stdcall; {$ENDIF}


{  If you pass require_image = TRUE (normal case), you need not check for
 * a TABLES_ONLY return code; an abbreviated file will cause an error exit.
 * JPEG_SUSPENDED is only possible if you use a data source module that can
 * give a suspension return (the stdio source module doesn't).
  }

{  Main entry points for decompression  }
jpeg_start_decompress: function(cinfo: j_decompress_ptr ):boolean;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_read_scanlines: function(cinfo: j_decompress_ptr;
					    scanlines: JSAMPARRAY;
					    max_lines: JDIMENSION): JDIMENSION;
                                            {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_finish_decompress: function(cinfo: j_decompress_ptr):boolean;
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Replaces jpeg_read_scanlines when reading raw downsampled data.  }
jpeg_read_raw_data: function(cinfo: j_decompress_ptr;
					   data: JSAMPIMAGE;
					   max_lines: JDIMENSION): JDIMENSION;
                                           {$IFDEF WIN32} stdcall; {$ENDIF}


{  Additional entry points for buffered-image mode.  }
jpeg_has_multiple_scans: function(cinfo: j_decompress_ptr): boolean;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_start_output: function(cinfo: j_decompress_ptr;
				       scan_number: int): boolean;
                                       {$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_finish_output: function(cinfo: j_decompress_ptr ):boolean;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_input_complete: function(cinfo: j_decompress_ptr ): boolean;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_new_colormap: procedure(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_consume_input: function(cinfo: j_decompress_ptr):int;
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Precalculate output dimensions for current decompression parameters.  }
jpeg_calc_output_dimensions: procedure(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

{ Control saving of COM and APPn markers into marker_list. }
jpeg_save_markers: procedure(cinfo: j_decompress_ptr; marker_code: int;
	      length_limit: uint);
{$IFDEF WIN32} stdcall;{$ENDIF}

{  Install a special processing method for COM or APPn markers.  }
jpeg_set_marker_processor: procedure(cinfo: j_decompress_ptr; marker_code: int;
	     routine: jpeg_marker_parser_method );
                 {$IFDEF WIN32} stdcall; {$ENDIF}



{  If you choose to abort compression or decompression before completing
 * jpeg_finish_(de)compress, then you need to clean up to release memory,
 * temporary files, etc.  You can just call jpeg_destroy_(de)compress
 * if you're done with the JPEG object, but if you want to clean it up and
 * reuse it, call this:
  }
jpeg_abort_compress: procedure(cinfo: j_compress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_abort_decompress: procedure(cinfo: j_decompress_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Generic versions of jpeg_abort and jpeg_destroy that work on either
 * flavor of JPEG object.  These may be more convenient in some places.
  }
jpeg_abort: procedure(cinfo: j_common_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_destroy: procedure(cinfo: j_common_ptr);
{$IFDEF WIN32} stdcall; {$ENDIF}


{  Default restart-marker-resync for use by data source modules  }
jpeg_resync_to_restart: function(cinfo: j_decompress_ptr;
					    desired: int): boolean;
{$IFDEF WIN32} stdcall; {$ENDIF}

jpeg_std_error: function (err: jpeg_error_mgr_ptr): jpeg_error_mgr_ptr;
{$IFDEF WIN32} stdcall; {$ENDIF}

procedure LoadJpegLibrary;
{$ENDIF}

implementation

uses winprocs, wintypes;

{$IFDEF WIN32}
const jpeglibdll = 'mwjpeg32.dll';
{$ELSE}
const jpeglibdll = 'mwjpeg.dll';
{$ENDIF}

{  Initialization of JPEG compression objects.
 * NB: you must set up the error-manager BEFORE calling jpeg_Create_xxx.
  }

{$IFDEF NODLL}
{$IFDEF CBUILDER}
function _wsprintfA; external user32 name '_wsprintfA';
{$ELSE}
function _wsprintfA; external user32 name 'wsprintfA';
{$ENDIF}

procedure jpeg_CreateCompress(cinfo: j_compress_ptr;
				      version: int; structsize: localsize_t);
                                      {$IFDEF WIN32} stdcall; {$ELSE} far; {$ENDIF}
                                       external;
procedure jpeg_CreateDecompress(cinfo: j_decompress_ptr;
					version: int; structsize: localsize_t);
                                        {$IFDEF WIN32} stdcall; {$ELSE} far; {$ENDIF}
                                        external;

{ Stubs for external C RTL functions referenced by JPEG OBJ files.}

function _malloc(size: Integer): Pointer; cdecl;
begin
  GetMem(Result, size);
end;

procedure _free(P: Pointer); cdecl;
begin
  FreeMem(P);
end;

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer);cdecl;
begin
  Move(source^, dest^, count);
end;

function __ftol: Integer;
var
  f: double;
begin
  asm
    lea    eax, f             //  BC++ passes floats on the FPU stack
    fstp  qword ptr [eax]     //  Delphi passes floats on the CPU stack
  end;
  Result := Trunc(f);
end;

var
  __turboFloat: LongBool = False;

{IDG JPEG objects modules to both compression and decompression}

{$L jdapimin.obj}
{$L jmemmgr.obj}
{$L jmemnobs.obj}
{$L jerror.obj}


{IDG JPEG modules for decompression}

{$L jdinput.obj}
{$L jdtrans.obj}
{$L jdapistd.obj}
{$L jdmaster.obj}
{$L jdphuff.obj}
{$L jdhuff.obj}
{$L jdmerge.obj}
{$L jdcolor.obj}
{$L jquant1.obj}
{$L jquant2.obj}
{$L jdmainct.obj}
{$L jdcoefct.obj}
{$L jdpostct.obj}
{$L jddctmgr.obj}
{$L jdsample.obj}
{$L jidctflt.obj}
{$L jidctfst.obj}
{$L jidctint.obj}
{$L jidctred.obj}
{$L jdmarker.obj}
{$L jutils.obj}
{$L jcomapi.obj}

{IDG JPEG modules for decompression}

{$L jdtrans.obj}
{$L jcparam.obj}
{$L jcapistd.obj}
{$L jcapimin.obj}
{$L jcinit.obj}
{$L jcmarker.obj}
{$L jcmaster.obj}
{$L jcmainct.obj}
{$L jcprepct.obj}
{$L jccoefct.obj}
{$L jccolor.obj}
{$L jcsample.obj}
{$L jcdctmgr.obj}
{$L jcphuff.obj}
{$L jfdctint.obj}
{$L jfdctfst.obj}
{$L jfdctflt.obj}
{$L jchuff.obj}

{$ELSE}
{$IFNDEF DYNAMIC_DLL}
procedure jpeg_CreateCompress(cinfo: j_compress_ptr;
				      version: int; structsize: localsize_t);
                                      {$IFDEF WIN32} stdcall; {$ELSE} far; {$ENDIF}
                                       external jpeglibdll;
procedure jpeg_CreateDecompress(cinfo: j_decompress_ptr;
					version: int; structsize: localsize_t);
                                        {$IFDEF WIN32} stdcall; {$ELSE} far; {$ENDIF}
                                        external jpeglibdll;
procedure jpeg_destroy_compress; external jpeglibdll;
procedure jpeg_destroy_decompress; external jpeglibdll;
procedure jpeg_set_defaults; external jpeglibdll;
procedure jpeg_set_colorspace; external jpeglibdll;
procedure jpeg_default_colorspace; external jpeglibdll;
procedure jpeg_set_quality; external jpeglibdll;
procedure jpeg_set_linear_quality; external jpeglibdll;
procedure jpeg_add_quant_table; external jpeglibdll;
function jpeg_quality_scaling; external jpeglibdll;
procedure jpeg_simple_progression; external jpeglibdll;
procedure jpeg_suppress_tables; external jpeglibdll;
function jpeg_alloc_quant_table; external jpeglibdll;
function jpeg_alloc_huff_table; external jpeglibdll;
procedure jpeg_start_compress; external jpeglibdll;
function jpeg_write_scanlines; external jpeglibdll;
procedure jpeg_finish_compress; external jpeglibdll;
function jpeg_write_raw_data; external jpeglibdll;
procedure jpeg_write_marker; external jpeglibdll;
procedure jpeg_write_m_header; external jpeglibdll;
procedure jpeg_write_m_byte; external jpeglibdll;
procedure jpeg_write_tables; external jpeglibdll;
function jpeg_read_header; external jpeglibdll;
function jpeg_start_decompress; external jpeglibdll;
function jpeg_read_scanlines; external jpeglibdll;
function  jpeg_finish_decompress; external jpeglibdll;
function jpeg_read_raw_data; external jpeglibdll;
function jpeg_has_multiple_scans; external jpeglibdll;
function jpeg_start_output; external jpeglibdll;
function jpeg_finish_output; external jpeglibdll;
function jpeg_input_complete; external jpeglibdll;
procedure jpeg_new_colormap; external jpeglibdll;
function  jpeg_consume_input; external jpeglibdll;
procedure jpeg_calc_output_dimensions; external jpeglibdll;
procedure jpeg_save_markers; external jpeglibdll;
procedure jpeg_set_marker_processor; external jpeglibdll;
procedure jpeg_abort_compress; external jpeglibdll;
procedure jpeg_abort_decompress; external jpeglibdll;
procedure jpeg_abort; external jpeglibdll;
procedure jpeg_destroy; external jpeglibdll;
function  jpeg_resync_to_restart; external jpeglibdll;
function jpeg_std_error; external jpeglibdll;
{$ELSE}

 var
 jpeg_CreateCompress: procedure(cinfo: j_compress_ptr;
				      version: int; structsize: localsize_t);
                                      {$IFDEF WIN32} stdcall;  {$ENDIF}

 jpeg_CreateDecompress: procedure(cinfo: j_decompress_ptr;
					version: int; structsize: localsize_t);
                                        {$IFDEF WIN32} stdcall;{$ENDIF}
{$IFDEF VER80}

type
  HModule = THandle;
  FARPROC = TFarProc;
{$ENDIF}

const
   HJpegLibrary: HModule = 0;

{$IFDEF VER80}
var OldExitProc: Pointer;

procedure JPEGExitProc; far;
begin
  ExitProc := OldExitProc;
  FreeModule(HJpegLibrary);
end;
{$ENDIF}

function GetProcAddressChecked(Module: HModule; Name: string): FARPROC;
var S: array[0..256] of char;
begin
     Result := GetProcAddress(Module,strpcopy(S,Name));
     if Result = nil then
        raise Exception.CreateFmt('Unable to load function "%s" from library "%s"',
                                          [Name,jpeglibdll])
end;

procedure LoadJpegLibrary;
begin
  if (HJpegLibrary = 0) then
  begin
       HJpegLibrary := LoadLibrary(jpeglibdll);
  {$IFDEF WIN32}
       if HJpegLibrary = 0 then
  {$ELSE}
       if HJpegLibrary <= 32 then
  {$ENDIF}
          raise Exception.Create('Unable to find a required dll - ' + jpeglibdll);

{$IFDEF VER80}
       OldExitProc := ExitProc;
       ExitProc := @JPEGExitProc;
{$ENDIF}

{Note the use of the '@' prefix is only really necessary for Delphi 1}

       @jpeg_CreateCompress := GetProcAddressChecked(HJpegLibrary,'jpeg_CreateCompress');
       @jpeg_CreateDecompress := GetProcAddressChecked(HJpegLibrary,'jpeg_CreateDecompress');
       @jpeg_destroy_compress := GetProcAddressChecked(HJpegLibrary,'jpeg_destroy_compress');
       @jpeg_destroy_decompress := GetProcAddressChecked(HJpegLibrary,'jpeg_destroy_decompress');
       @jpeg_set_defaults := GetProcAddressChecked(HJpegLibrary,'jpeg_set_defaults');
       @jpeg_set_colorspace := GetProcAddressChecked(HJpegLibrary,'jpeg_set_colorspace');
       @jpeg_default_colorspace := GetProcAddressChecked(HJpegLibrary,'jpeg_default_colorspace');
       @jpeg_set_quality := GetProcAddressChecked(HJpegLibrary,'jpeg_set_quality');
       @jpeg_set_linear_quality := GetProcAddressChecked(HJpegLibrary,'jpeg_set_linear_quality');
       @jpeg_add_quant_table := GetProcAddressChecked(HJpegLibrary,'jpeg_add_quant_table');
       @jpeg_simple_progression := GetProcAddressChecked(HJpegLibrary,'jpeg_simple_progression');
       @jpeg_suppress_tables := GetProcAddressChecked(HJpegLibrary,'jpeg_suppress_tables');
       @jpeg_start_compress := GetProcAddressChecked(HJpegLibrary,'jpeg_start_compress');
       @jpeg_finish_compress := GetProcAddressChecked(HJpegLibrary,'jpeg_finish_compress');
       @jpeg_write_marker := GetProcAddressChecked(HJpegLibrary,'jpeg_write_marker');
       @jpeg_write_m_header := GetProcAddressChecked(HJpegLibrary,'jpeg_write_m_header');
       @jpeg_write_m_byte := GetProcAddressChecked(HJpegLibrary,'jpeg_write_m_byte');
       @jpeg_write_tables := GetProcAddressChecked(HJpegLibrary,'jpeg_write_tables');
       @jpeg_new_colormap := GetProcAddressChecked(HJpegLibrary,'jpeg_new_colormap');
       @jpeg_calc_output_dimensions := GetProcAddressChecked(HJpegLibrary,'jpeg_calc_output_dimensions');
       @jpeg_save_markers := GetProcAddressChecked(HJpegLibrary,'jpeg_save_markers');
       @jpeg_set_marker_processor := GetProcAddressChecked(HJpegLibrary,'jpeg_set_marker_processor');
       @jpeg_abort_compress := GetProcAddressChecked(HJpegLibrary,'jpeg_abort_compress');
       @jpeg_abort_decompress := GetProcAddressChecked(HJpegLibrary,'jpeg_abort_decompress');
       @jpeg_abort := GetProcAddressChecked(HJpegLibrary,'jpeg_abort');
       @jpeg_destroy := GetProcAddressChecked(HJpegLibrary,'jpeg_destroy');
       @jpeg_quality_scaling := GetProcAddressChecked(HJpegLibrary,'jpeg_quality_scaling');
       @jpeg_alloc_quant_table := GetProcAddressChecked(HJpegLibrary,'jpeg_alloc_quant_table');
       @jpeg_alloc_huff_table := GetProcAddressChecked(HJpegLibrary,'jpeg_alloc_huff_table');
       @jpeg_write_scanlines := GetProcAddressChecked(HJpegLibrary,'jpeg_write_scanlines');
       @jpeg_write_raw_data := GetProcAddressChecked(HJpegLibrary,'jpeg_write_raw_data');
       @jpeg_read_header := GetProcAddressChecked(HJpegLibrary,'jpeg_read_header');
       @jpeg_start_decompress := GetProcAddressChecked(HJpegLibrary,'jpeg_start_decompress');
       @jpeg_read_scanlines := GetProcAddressChecked(HJpegLibrary,'jpeg_read_scanlines');
       @jpeg_finish_decompress := GetProcAddressChecked(HJpegLibrary,'jpeg_finish_decompress');
       @jpeg_read_raw_data := GetProcAddressChecked(HJpegLibrary,'jpeg_read_raw_data');
       @jpeg_has_multiple_scans := GetProcAddressChecked(HJpegLibrary,'jpeg_has_multiple_scans');
       @jpeg_start_output := GetProcAddressChecked(HJpegLibrary,'jpeg_start_output');
       @jpeg_finish_output := GetProcAddressChecked(HJpegLibrary,'jpeg_finish_output');
       @jpeg_input_complete := GetProcAddressChecked(HJpegLibrary,'jpeg_input_complete');
       @jpeg_consume_input := GetProcAddressChecked(HJpegLibrary,'jpeg_consume_input');
       @jpeg_resync_to_restart := GetProcAddressChecked(HJpegLibrary,'jpeg_resync_to_restart');
       @jpeg_std_error := GetProcAddressChecked(HJpegLibrary,'jpeg_std_error')
  end
end;
{$ENDIF} {Static versus dynamic library}
{$ENDIF} {NODLL}


procedure jpeg_Create_Compress(cinfo: j_compress_ptr);
begin
     jpeg_CreateCompress(cinfo,JPEG_LIB_VERSION,sizeof(jpeg_compress_struct))
end;

procedure jpeg_Create_Decompress(cinfo: j_decompress_ptr);
begin
     jpeg_CreateDecompress(cinfo,JPEG_LIB_VERSION,sizeof(jpeg_decompress_struct))
end;

{$IFNDEF VER80}
{$IFDEF DYNAMIC_DLL}

initialization

finalization

  if HJpegLibrary <> 0 then
    FreeLibrary(HJpegLibrary)
{$ENDIF}
{$ENDIF}

end.
