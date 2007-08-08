object Form1: TForm1
  Left = 279
  Top = 145
  AutoScroll = False
  Caption = 'Image Viewer'
  ClientHeight = 254
  ClientWidth = 427
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  OnCreate = FormCreate
  OnShow = About1Click
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 32
    Width = 377
    Height = 185
    AutoSize = True
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 234
    Width = 427
    Height = 20
    Panels = <>
    SimplePanel = True
  end
  object SpeedPanel: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 30
    Align = alTop
    TabOrder = 1
    object OpenBtn: TSpeedButton
      Left = 8
      Top = 3
      Width = 25
      Height = 25
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        333FFFFFFFFFFFFFF3333380000000000000333333888888888888883F333300
        7B7B7B7B7B7B033333883F33333333338F33330F07B7B7B7B7B70333338F8F33
        3333333383F3330B0B7B7B7B7B7B7033338F83F33333333338F3330FB0B7B7B7
        B7B7B033338F38F333333333383F330BF07B7B7B7B7B7B03338F383FFFFF3333
        338F330FBF000007B7B7B703338F33888883FFFFFF83330BFBFBFBF000000033
        338F3333333888888833330FBFBFBFBFBFB03333338F333333333338F333330B
        FBFBFBFBFBF03333338F33333FFFFFF83333330FBFBF0000000333333387FFFF
        8888888333333330000033333333333333388888333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        33333333333333333333}
      NumGlyphs = 2
      OnClick = OpenBtnClick
    end
    object SaveBtn: TSpeedButton
      Left = 34
      Top = 3
      Width = 25
      Height = 25
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333FFFFFFFFFFFFFF3333380000000000008333
        333888F8FF888F888F333330CC08CCF770CC0333333888F8FF888F888F333330
        CC08CCF770CC0333333888F888888F888F333330CC07887770CC03333338888F
        FFFFF8888F333330CC60000006CC033333388888888888888F333330CCCCCCCC
        CCCC033333388888888888888F333330C6000000006C03333338888888888888
        8F333330C0FFFFFFFF0C0333333888FFFFFFFF888F333330C0FFFFFFFF0C0333
        333888FFFFFFFF888F333330C0FFFFFFFF0C0333333888FFFFFFFF888F333330
        C0FFFFFFFF0C0333333888FFFFFFFF888F33333000FFFFFFFF000333333888FF
        FFFFFF888F333330C0FFFFFFFF0C0333333888FFFFFFFF888F33333800000000
        0000833333388888888888888333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        33333333333333333333}
      NumGlyphs = 2
      OnClick = Save1Click
    end
    object PrintBtn: TSpeedButton
      Left = 72
      Top = 2
      Width = 25
      Height = 25
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        0003377777777777777308888888888888807F33333333333337088888888888
        88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
        8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
        8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
      OnClick = Print1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 320
    Top = 40
    object File1: TMenuItem
      Caption = '&File'
      object open1: TMenuItem
        Caption = '&Open'
        OnClick = OpenBtnClick
      end
      object Save1: TMenuItem
        Caption = '&Save'
        OnClick = Save1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = '&Print'
        OnClick = Print1Click
      end
      object PrintSetup1: TMenuItem
        Caption = 'Print &Setup'
        OnClick = PrintSetup1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Copy1: TMenuItem
        Caption = '&Copy'
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = '&Paste'
        OnClick = Paste1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object JPEGFileCompressor1: TJPEGFileCompressor
    Trace_Level = 0
    GrayscaleOutput = False
    Comment = 'Created by the MWA JPEG Component Linrary Demonstration Program'
    InputGamma = 1
    ProgressiveJPEG = False
    DCTMethod = JDCT_ISLOW
    OptimizeCoding = False
    RestartInterval = 0
    RestartInRows = 0
    SmoothingFactor = 0
    WriteJFIFHeader = True
    DensityUnit = 0
    X_Density = 1
    Y_Density = 1
    DefaultCompressor = False
    OnProgressReport = JPEGFileCompressor1ProgessReport
    Left = 224
    Top = 40
  end
  object JPEGFileDecompressor1: TJPEGFileDecompressor
    Trace_Level = 0
    GrayScaleOutput = False
    OnJPEGComment = JPEGFileDecompressor1JPEGComment
    DefaultDecompressor = False
    OnProgressReport = JPEGFileCompressor1ProgessReport
    CMYKInvert = True
    Left = 224
    Top = 88
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'jpg'
    Filter = 'Image Files (*.jpg, *.wmf, *.bmp)|*.jpg;*.wmf;*.bmp'
    Options = [ofHideReadOnly, ofFileMustExist]
    Left = 112
    Top = 40
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 
      'JPEG Image (*.jpg)|*.jpg|Bitmap (*.bmp)|*.bmp|Metafile (*.wmf)|*' +
      '.wmf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Left = 112
    Top = 88
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 320
    Top = 88
  end
  object PrintDialog1: TPrintDialog
    Left = 320
    Top = 136
  end
end
