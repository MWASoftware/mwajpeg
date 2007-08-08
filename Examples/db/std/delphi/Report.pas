unit Report;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, mwaQRjpg;

type
  TQuickReport1 = class(TQuickRep)
    TitleBand1: TQRBand;
    DetailBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRDBJPEGImage1: TQRDBJPEGImage;
    QRDBText1: TQRDBText;
  private

  public

  end;

var
  QuickReport1: TQuickReport1;

implementation

uses JpegData;

{$R *.DFM}

end.
