unit Report;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, mwaQRjpg, QuickRpt, ExtCtrls;

type
  TReportForm = class(TForm)
    Report: TQuickRep;
    TitleBand1: TQRBand;
    QRLabel1: TQRLabel;
    DetailBand1: TQRBand;
    QRDBJPEGImage1: TQRDBJPEGImage;
    QRDBText1: TQRDBText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportForm: TReportForm;

implementation

uses JpegData;

{$R *.dfm}

end.
