/*
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
*/
/* jconfig.bcc --- jconfig.h for Borland C (Turbo C) on MS-DOS or OS/2. */
/* see jconfig.doc for explanations */

/* AJW we need to quickly identify the Win16 environment */
#ifdef _Windows
#ifndef __WIN32__
#define __WIN16__
#endif
#endif
/* AJW Define NO_GETENV to avoid having the include sscanf with Delphi */
#define NO_GETENV
/* AJW Define USER_ERROR_HANDLING to avoid calls to printf etc. */
#define USER_ERROR_HANDLING

/* AJW use wsprinf instead of sprintf in a windows environment. This makes
   linking to Delphi easier */
#ifdef _Windows
#include <windows.h>
#define sprintf wsprintf
#endif

#define HAVE_PROTOTYPES
#define HAVE_UNSIGNED_CHAR
#define HAVE_UNSIGNED_SHORT
/* #define void char */
/* #define const */
#undef CHAR_IS_UNSIGNED
#define HAVE_STDDEF_H
#define HAVE_STDLIB_H
#undef NEED_BSD_STRINGS
#undef NEED_SYS_TYPES_H
#ifdef __MSDOS__
#define NEED_FAR_POINTERS	/* for small or medium memory model */
#endif
#undef NEED_SHORT_EXTERNAL_NAMES
#undef INCOMPLETE_TYPES_BROKEN	/* this assumes you have -w-stu in CFLAGS */

#ifdef JPEG_INTERNALS

#undef RIGHT_SHIFT_IS_UNSIGNED

#ifdef __MSDOS__
#define USE_MSDOS_MEMMGR	/* Define this if you use jmemdos.c */
#define MAX_ALLOC_CHUNK 65520L	/* Maximum request to malloc() */
#ifndef __WIN16__
#define USE_FMEM		/* Borland has _fmemcpy() and _fmemset() */
#endif
#endif

#endif /* JPEG_INTERNALS */

#ifdef JPEG_CJPEG_DJPEG

#define BMP_SUPPORTED		/* BMP image file format */
#define GIF_SUPPORTED		/* GIF image file format */
#define PPM_SUPPORTED		/* PBMPLUS PPM/PGM image file format */
#undef RLE_SUPPORTED		/* Utah RLE image file format */
#define TARGA_SUPPORTED		/* Targa image file format */

#define TWO_FILE_COMMANDLINE
#define USE_SETMODE		/* Borland has setmode() */
#ifdef __MSDOS__
#define NEED_SIGNAL_CATCHER	/* Define this if you use jmemdos.c */
#endif
#undef DONT_USE_B_MODE
#undef PROGRESS_REPORT		/* optional */

#endif /* JPEG_CJPEG_DJPEG */
