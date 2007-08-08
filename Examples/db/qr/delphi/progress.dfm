object ProgressBox: TProgressBox
  Left = 291
  Top = 201
  Width = 276
  Height = 136
  BorderIcons = []
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Title: TLabel
    Left = 8
    Top = 8
    Width = 257
    Height = 25
    Alignment = taCenter
    AutoSize = False
    WordWrap = True
  end
  object BitBtn1: TBitBtn
    Left = 96
    Top = 80
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkCancel
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 48
    Width = 225
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 1
  end
end
