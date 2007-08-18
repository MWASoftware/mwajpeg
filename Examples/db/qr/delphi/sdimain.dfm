object SDIAppForm: TSDIAppForm
  Left = 282
  Top = 123
  ActiveControl = SpeedPanel
  AutoScroll = False
  Caption = 'Image Viewer'
  ClientHeight = 362
  ClientWidth = 437
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Image1: TDBJPEGImage
    Left = 0
    Top = 63
    Width = 437
    Height = 249
    Align = alClient
    Center = True
    OnProgress = Image1Progress
    DataField = 'Picture'
    DataSource = DataSource1
    ReadOnly = False
    JPEGCompressor = JPEGFileCompressor1
    JPEGDecompressor = JPEGFileDecompressor1
  end
  object SpeedPanel: TPanel
    Left = 0
    Top = 0
    Width = 437
    Height = 30
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object OpenBtn: TSpeedButton
      Left = 10
      Top = 2
      Width = 25
      Height = 25
      Hint = 'Open|'
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
      OnClick = OpenItemClick
    end
    object SaveBtn: TSpeedButton
      Left = 34
      Top = 2
      Width = 25
      Height = 25
      Hint = 'Save|'
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
      OnClick = SaveItemClick
    end
    object ExitBtn: TSpeedButton
      Left = 67
      Top = 2
      Width = 25
      Height = 25
      Hint = 'Exit|'
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00377777777777
        777777773FFFFFFFFFFFF333333F888888888888F7F7F7888888888888883333
        33888888888888877F7F788888888888888F333FF88844444400888FFF444444
        88888888888333888883333334D5007FFF433333333338F888F3338F33333333
        345D50FFFF4333333333388788F3338F3333333334D5D0FFFF433333333338F8
        78F3338F33333333345D50FEFE4333333333388788F3338F3333333334D5D0FF
        FF433333333338F878F3338F33333333345D50FEFE4333333333388788F3338F
        3333333334D5D0FFFF433333333338F878F3338F33333333345D50FEFE433333
        3333388788F3338F3333333334D5D0EFEF433333333338F878F3338F33333333
        345D50FEFE4333333333388788F3338F3333333334D5D0EFEF433333333338F8
        F8FFFF8F33333333344444444443333333333888888888833333333333333333
        3333333333333333FFFFFF333333333333300000033333333333333888888F33
        333333333330AAAA0333333333333338FFFF8F33333333333330000003333333
        33333338888883333333}
      NumGlyphs = 2
      OnClick = ExitItemClick
    end
    object PrintBtn: TSpeedButton
      Left = 104
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
  object StatusBar: TPanel
    Left = 0
    Top = 345
    Width = 437
    Height = 17
    Align = alBottom
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object ProgressBar1: TProgressBar
      Left = 96
      Top = 2
      Width = 150
      Height = 10
      TabOrder = 0
      Visible = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 437
    Height = 33
    Align = alBottom
    TabOrder = 2
    object DBNavigator1: TDBNavigator
      Left = 8
      Top = 4
      Width = 240
      Height = 25
      DataSource = DataSource1
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 30
    Width = 437
    Height = 33
    Align = alTop
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 48
      Height = 16
      Caption = 'Subject:'
      FocusControl = DBEdit1
    end
    object DBEdit1: TDBEdit
      Left = 64
      Top = 4
      Width = 185
      Height = 24
      DataField = 'Subject'
      DataSource = DataSource1
      TabOrder = 0
    end
  end
  object MainMenu: TMainMenu
    Left = 335
    Top = 30
    object FileMenu: TMenuItem
      Caption = '&File'
      object OpenItem: TMenuItem
        Caption = '&Open...'
        Hint = 'Open a file'
        OnClick = OpenItemClick
      end
      object SaveItem: TMenuItem
        Caption = '&Save...'
        Hint = 'Save Image to a file'
        OnClick = SaveItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = '&Print'
        OnClick = Print1Click
      end
      object Clear1: TMenuItem
        Caption = '&Clear'
        Hint = 'Clear Image'
        OnClick = Clear1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ExitItem: TMenuItem
        Caption = 'E&xit'
        Hint = 'Exit application'
        ShortCut = 32856
        OnClick = ExitItemClick
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Copy1: TMenuItem
        Caption = '&Copy'
        Hint = 'Copy an image from the Clipboard'
        ShortCut = 16451
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = '&Paste'
        Hint = 'Paste a Bitmap or Metafile to the Clipboard'
        ShortCut = 16470
        OnClick = Paste1Click
      end
      object Cut1: TMenuItem
        Caption = 'C&ut'
        Hint = 'Cut a bitmap to the clipboard'
        ShortCut = 16472
        OnClick = Cut1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'jpg'
    Filter = 'Image Files (*.jpg,*.bmp,*.wmf)|*.jpg;*.bmp;*.wmf'
    Options = [ofHideReadOnly, ofFileMustExist]
    Left = 335
    Top = 86
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'JPEG Files (*.jpg)|*.jpg|Bitmaps (*.bmp)|*.bmp|Metafiles (*.wmf)' +
      '|*.wmf'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 335
    Top = 142
  end
  object JPEGFileCompressor1: TJPEGFileCompressor
    Trace_Level = 0
    GrayscaleOutput = False
    Comment = 'Generated by the MWA Software JPEG Demo Program'
    InputGamma = 1.000000000000000000
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
    OnProgressReport = OnProgress
    Left = 192
    Top = 96
  end
  object JPEGFileDecompressor1: TJPEGFileDecompressor
    Trace_Level = 0
    GrayScaleOutput = False
    OnJPEGComment = JPEGFileDecompressor1JPEGComment
    DefaultDecompressor = False
    OnProgressReport = OnProgress
    CMYKInvert = True
    Left = 192
    Top = 136
  end
  object DataSource1: TDataSource
    DataSet = DataModule1.Table1
    OnDataChange = DataSource1DataChange
    Left = 112
    Top = 256
  end
end
