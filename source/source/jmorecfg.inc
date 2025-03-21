(*
 * jmorecfg.h
 *
 * Copyright (C) 1991-1996, Thomas G. Lane.
 * This file is part of the Independent JPEG Group's software.
 * For conditions of distribution and use, see the accompanying README file.
 *
 * This file contains additional configuration options that customize the
 * JPEG software for special applications or support machine-dependent
 * optimizations.  Most users will not need to touch this file.
 *)

 {Converted to a Delphi Import unit by Tony Whyman <whyman@mwassocs.demon.co.uk>
  February 1997}


  {Additional types to make it easier to convert 'C' to Pascal}
type
  Int = integer;
  int_ptr = ^int;
  localsize_t = int;
  uInt = Cardinal;
  uint_ptr = ^uInt;
  Short = SmallInt;
  ushort = Word;
  Long = longint;
  int8array = Array[0..8-1] of int;

(*
 * Define BITS_IN_JSAMPLE as either
 *   8   for 8-bit sample values (the usual setting)
 *   12  for 12-bit sample values
 * Only 8 and 12 are legal data precisions for lossy JPEG according to the
 * JPEG standard, and the IJG code does not support anything else!
 * We do not support run-time selection of data precision, sorry.
 *)

{
  BITS_IN_JSAMPLE  = 8	}(* use 8 or 12 *)


(*
 * Maximum number of components (color channels) allowed in JPEG image.
 * To meet the letter of the JPEG spec, set this to 255.  However, darn
 * few applications need more than 4 channels (maybe 5 for CMYK + alpha
 * mask).  We recommend 10 as a reasonable compromise; use 4 if you are
 * really short on memory.  (Each allowed component costs a hundred or so
 * bytes of storage, whether actually used in an image or not.)
 *)

 const
  MAX_COMPONENTS = 10;          { maximum number of image components }


(*
 * Basic data types.
 * You may need to change these if you have a machine with unusual data
 * type sizes; for example, "char" not 8 bits, "short" not 16 bits,
 * or "long" not 32 bits.  We don't care whether "int" is 16 or 32 bits,
 * but it had better be at least 16.
 *)

(* Representation of a single sample (pixel element value).
 * We frequently allocate large arrays of these, so it's important to keep
 * them small.  But if you have memory to burn and access to char or short
 * arrays is very slow on your hardware, you might want to change these.
 *)

(* #if BITS_IN_JSAMPLE == 8
 * JSAMPLE should be the smallest type that will hold the values 0..255.
 * You can use a signed char by having GETJSAMPLE mask it with 0xFF.
 *)

type
  JSAMPLE = byte; { Pascal unsigned char }

const
  MAXJSAMPLE = 255;
  CENTERJSAMPLE = 128;


{#if BITS_IN_JSAMPLE == 12
(* JSAMPLE should be the smallest type that will hold the values 0..4095.
 * On nearly all machines "short" will do nicely.
 *)

typedef short JSAMPLE;
#define GETJSAMPLE(value)  ((int) (value))

#define MAXJSAMPLE	4095
#define CENTERJSAMPLE	2048

#endif (* BITS_IN_JSAMPLE == 12 *)}


(* Representation of a DCT frequency coefficient.
 * This should be a signed value of at least 16 bits; "short" is usually OK.
 * Again, we allocate large arrays of these, but you can change to int
 * if you have memory to burn and "short" is really slow.
 *)

type
  JCOEF = short;
  JCOEF_PTR = ^JCOEF;


(* Compressed datastreams are represented as arrays of JOCTET.
 * These must be EXACTLY 8 bits wide, at least once they are written to
 * external storage.  Note that when using the stdio data source/destination
 * managers, this is also the data type passed to fread/fwrite.
 *)


  JOCTET = Byte;
  JOCTET_PTR = ^JOCTET;

(* These typedefs are used for various table entries and so forth.
 * They must be at least as wide as specified; but making them too big
 * won't cost a huge amount of memory, so we don't provide special
 * extraction code like we did for JSAMPLE.  (In other words, these
 * typedefs live at a different point on the speed/space tradeoff curve.)
 *)

(* UINT8 must hold at least the values 0..255. *)

  UINT8 = byte;

(* UINT16 must hold at least the values 0..65535. *)

  UINT16 = Word;

(* INT16 must hold at least the values -32768..32767. *)

  INT16 = shortInt;

(* INT32 must hold at least signed 32-bit values. *)

  INT32 = longint;
  INT32PTR = ^INT32;

(* Datatype used for image dimensions.  The JPEG standard only supports
 * images up to 64K*64K due to 16-bit fields in SOF markers.  Therefore
 * "unsigned int" is sufficient on all machines.  However, if you need to
 * handle larger images and you don't mind deviating from the spec, you
 * can change this datatype.
 *)

  JDIMENSION = uInt;

const
   JPEG_MAX_DIMENSION  = 65500;  (* a tad under 64K to prevent overflows *)



