object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 651
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 513
    Height = 513
    ColCount = 10
    DefaultColWidth = 50
    DefaultRowHeight = 50
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
    OnSelectCell = StringGrid1SelectCell
  end
  object Memo1: TMemo
    Left = 513
    Top = 0
    Width = 148
    Height = 513
    Align = alRight
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 513
    Width = 661
    Height = 138
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 185
      Top = 27
      Width = 36
      Height = 13
      Caption = 'Tempo:'
    end
    object Button2: TButton
      Left = 32
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Bresenham'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Clear: TButton
      Left = 513
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 1
      OnClick = ClearClick
    end
    object ComboBox1: TComboBox
      Left = 227
      Top = 24
      Width = 57
      Height = 21
      ParentColor = True
      TabOrder = 2
      Text = '500'
      Items.Strings = (
        '10 Milessegundos'
        '100 Milessegundos:'
        '500 Milessegundos:'
        '1 segundo'
        '2 segundos')
    end
  end
end
