object ProgressBox: TProgressBox
  Left = 321
  Top = 181
  Width = 286
  Height = 125
  BorderIcons = []
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Title: TLabel
    Left = 8
    Top = 8
    Width = 257
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'testing'
    WordWrap = True
  end
  object ProgressBar1: TProgressBar
    Left = 40
    Top = 40
    Width = 201
    Height = 13
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 96
    Top = 64
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkCancel
  end
end
