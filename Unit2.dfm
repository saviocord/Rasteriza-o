object Form2: TForm2
  Left = 0
  Top = 0
  ClientHeight = 235
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 364
    Height = 235
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 221
    object Label1: TLabel
      Left = 87
      Top = 140
      Width = 36
      Height = 13
      Caption = 'Tempo:'
    end
    object Label2: TLabel
      Left = 99
      Top = 113
      Width = 24
      Height = 13
      Caption = 'Tipo:'
    end
    object Label3: TLabel
      Left = 73
      Top = 0
      Width = 221
      Height = 48
      Caption = 'Rasteriza'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 75
      Top = 86
      Width = 48
      Height = 13
      Caption = 'Tamanho:'
    end
    object L_Raio: TLabel
      Left = 98
      Top = 167
      Width = 25
      Height = 13
      Caption = 'Raio:'
      Visible = False
    end
    object L_Raio2: TLabel
      Left = 180
      Top = 167
      Width = 57
      Height = 13
      Caption = 'Eixo Menor:'
      Visible = False
    end
    object CB_Tipo: TComboBox
      Left = 126
      Top = 110
      Width = 103
      Height = 21
      ItemIndex = 0
      TabOrder = 1
      Text = 'Reta'
      OnChange = CB_TipoChange
      Items.Strings = (
        'Reta'
        'Circunfer'#234'ncia'
        'Elipse')
    end
    object CB_Tempo: TComboBox
      Left = 126
      Top = 137
      Width = 118
      Height = 21
      ItemIndex = 0
      ParentColor = True
      TabOrder = 2
      Text = '10 Milessegundos'
      Items.Strings = (
        '10 Milessegundos'
        '100 Milessegundos'
        '500 Milessegundos'
        '1 segundo'
        '2 segundos')
    end
    object CB_Tamanho: TComboBox
      Left = 126
      Top = 83
      Width = 67
      Height = 21
      ItemIndex = 0
      TabOrder = 0
      Text = '10 x 10'
      Items.Strings = (
        '10 x 10'
        '20 x 20'
        '30 x 30')
    end
    object Button1: TButton
      Left = 142
      Top = 197
      Width = 75
      Height = 25
      Caption = 'Iniciar'
      TabOrder = 3
      OnClick = Button1Click
    end
    object E_Raio: TEdit
      Left = 126
      Top = 164
      Width = 43
      Height = 21
      TabOrder = 4
      Visible = False
    end
    object E_Raio2: TEdit
      Left = 243
      Top = 164
      Width = 43
      Height = 21
      TabOrder = 5
      Visible = False
    end
  end
end
