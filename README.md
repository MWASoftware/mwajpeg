# ﻿MWA JPEG Component Library

Welcome to the MWA JPEG Component Library. The JPEG Component Library provides 
two additional non-visual components for use under either Delphi or C++Builder. 
It also provides a Data Aware JPEG Image component which may be used to save 
and access JPEG encoded images in a database blob field. A corresponding 
printable component is also provided so that you may print images from a 
database using Quick Reports. 

The MWA JPEG Component Library was made available between 1996 and 2009 under a 
shareware licence with separate evaluation and registered user versions. By 
2009, Delphi included native JPEG support and the need for the library ended. 
This version of the MWA JPEG Component Library has now been made available 
under the LGPL. It is primarily of historical interest but may be useful for 
any users of old versions of Delphi and C++ Builder as well as a useful example 
of this type of component and the strategies used to produce it.

The MWA JPEG Component Library uses original software for JPEG developed by the 
Independent JPEG Group (see https://www.ijg.org/). The IJG have made available 
a library of generic 'C' code supporting JPEG compression and decompression and have 
permitted its free use provided the source is acknowledged. The IJG code has 
been modified for use with Delphi and MS Windows and is provided as compiled 
object files. Optionally, they may be separately compiled into a dll.

#Installation

For later versions of Delphi and C++Builder, a design time package "mwajpg" 
is provided - see source\mwajpeg.dpk and mwajpg.mak. For older versions of Delphi, 
you will need to recompile the IDE using source\source\jpegreg1.pas (delphi 1)
or source\source\jpegreg2.pas (Delphi 2 and later).

When compiling, you must:

1. Set the DEFINED smbol QREPORTS if you want to use mwajpeg with Quick Reports.

2. Delphi 2 and later: set the path for linking with external objects to source\obj
(i.e. the compiled

3. Set the unit path to include the mwajpeg source\source directory.

With Delphi 1 a DLL dll\mwajpeg.dll must be in the path at runtime as the IJG code
is located in this DLL. For Delphi 2 and later, the DLL (dll/mwajpg32.dll) is optional
(Defined Symbol DYNAMIC_DLL). In most cases, linking the IJG object files into the 
.dcu is the preferred approach.

# Using the Library

The two non-visual components are TJPEGFileCompressor and 
TJPEGFileDecompressor. These support compression of images to JPEG Format and 
decompression respectively, and their properties allow full control of the JPEG 
algorithm. The data aware component is TDBJPEGImage, and the printable 
component is TQRDBJPEGImage (for Delphi 2005 and later only available if you 
also have Quick Reports 4 installed). You will find these components on the 
"MWA JPEG" tab on the component palette.

Simply installing these components JPEG enables the Delphi IDE. The components 
register themselves as supporting .jpg files and the JPEG compression format 
and, when you come to load an image into a TImage Picture, the JPEG format will 
be found amongst the list of supported file formats. An image loaded from a 
JPEG source can also be saved back to JPEG. These components support the JPEG 
File Interchange Format (JFIF).

These two components also support TImage at run-time too. As at design time, if 
TJPEGFileDecompressor is included in your project, then calling 
TImage.Picture.LoadFromFile when the file extension is .jpg will automatically 
invoke the JPEG decompressor. You can also explicitly call 
TJPEGFileDecompressor to load a JPEG image from any file.

TJPEGFileCompressor can be used to save a TImage.Picture in JPEG format, and 
can handle pictures that are either bitmaps or metafiles. It can also compress 
a device independent bitmap, and change the size of bitmaps before compression.

TDBJPEGImage is linked to a database blob field and also uses 
TJPEGFileDecompressor and TJPEGFileCompressor to save and load JPEG encoded 
images from the Blob Field. Use of the JPEG compressor and decompressor 
components can be implicit if the default parameter settings are sufficient. On 
the other hand, the reference may be explicit to copies of these components 
with non-default parameter settings. TQRDBJPEGImage can be used to print a JPEG 
Image using Quick Reports. 

An interface to the IJG software is provided by the unit jpeglib.pas. This is 
encapsulated as a set of Delphi components in the unit mwajpeg.pas, which also 
supports the mapping of the environment independent image format expected by 
the IJG code into MS Windows bitmap and metafile formats.

# Installation

Installation is fully automated when using the packages deployed using Windows 
installer. The installer will detect each supported version of Delphi and 
C++Builder installed on your system and offer to install the JPEG Components 
for each one. You may deselect installation for any supported version of Delphi 
and C++Builder in the customisation dialog. The installer will also install the 
example applications and help file in your Personal Folder. You can also modify 
this in the customisation dialog. In the full version, the source files will 
also be installed here.

The evaluation version is fully functional except that any programs you create 
with it will only function when the Delphi or C++Builder IDE is also active.

On compiling your applications that use the JPEG Component Library, for the 
first time after installing the full version over the evaluation version, you 
should “build” rather than “make” the application, ensuring that the 
new units/object files are picked up.

# After Installation

Once installation is complete, the MWA JPEG components will have been added to 
each selected version of Delphi and C++Builder. The supporting .dcu (and .obj) 
files will have been installed in the "lib" folder and, for C++Builder, the hpp 
files will be installed in the "include" folder. A design time package will 
have been installed in the "bin" folder.

# Quick Reports

Quick Reports from Qsoft, was bundled with Delphi/C++Builder until Delphi 
7/C++Builder 6. However, post Delphi 2005 it is only available separately. The 
MWA JPEG Component Library contains a data aware component to include JPEG 
images on reports generated using Quick Reports. This is installed by default 
for Delphi 7/C++Builder 6 and earlier. For later releases, the installation 
script will automatically determine if Quick Reports 4 is installed and if it 
is, the installed design time package will include support for Quick Reports. 
Otherwise, the version without Quick Reports support will be installed. 

# Example Applications

Three demo applications are provided. A JPEG Viewer application demonstrates 
the opening and saving of JPEG image files and conversion to and from bitmap 
files (.bmp) and from Windows Metafiles (.wmf). One database application 
(DBDemo) demonstrates use of the data aware component with the DB Navigation 
bar, while another (DBGrDemo) demonstrates the use of the data aware component 
in a TDBCtrlGrid.

The JPEG Viewer application may be found in the Examples\Viewer folder. To 
activate, load the jpegdemo.dpr file into the IDE using the File|Open Project 
menu item. This provides a simple application that can open and save .jpg 
(JPEG), .bmp (Windows Bitmap) and .wmf (Windows metfaile) files, and copy and 
paste bitmaps and metafiles to and from the clipboard. To test out, simply 
compile and run the application.

To load and view a JPEG file, click on the open button and load the test.jpg 
file contained in the subdirectory created above. You can also try saving it to 
another file name (you can save it as either a JPEG or a bitmap). You can also 
use the demo application to convert windows bitmaps and metafiles to jpegs 
simply by opening the file containing them (or pasting from the clipboard) and 
saving them as jpegs. The viewer window can also be resized by simply dragging 
the bottom right hand corner with the mouse. Saving the image will save it at 
the new size.

The application also demonstrates a simple method for printing a JPEG Image.

You can also use the Object Inspector to see the properties published by the 
two JPEG components.

The JPEG database applications may be found in the Examples\db folder. To 
activate, load the respective .dpr file into the IDE using the File|Open 
Project menu item.

The DBDemo application is an extension of the Viewer and presents images held 
in an example database. The database records may be perused using the 
DBNavigator bar provided. It is still possible to save images from the database 
record and to replace/insert images from files or the clipboard. The 
application also demonstrates how to print a report including JPEG Images.

The DBGrDemo application uses the same image database but presents the images 
using a TDBCtrlGrid which enables them to be viewed as an image strip.

# More Information

An Online Help File is installed and may be found under the Programs->MWA JPEG 
Component Library Start Menu. 

MWA Software
http://www.mwasoftware.co.uk
