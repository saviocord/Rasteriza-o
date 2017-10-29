unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    CB_Tipo: TComboBox;
    CB_Tempo: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    CB_Tamanho: TComboBox;
    Button1: TButton;
    E_Raio: TEdit;
    L_Raio: TLabel;
    E_Raio2: TEdit;
    L_Raio2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure CB_TipoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
{$R *.dfm}

Uses Unit1;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if Form1 = nil Then
    Application.CreateForm(TForm1, Form1);

  case CB_Tamanho.ItemIndex of
    0:
    begin
      Form1.v_tamanho_matriz := 10;
      Form1.v_tamanho_celula := 50;
      Form1.v_tamanho_linha := 0.5;
      Form1.v_ajuste := 3;

      Form1.ClientWidth := 514;
      Form1.ClientHeight := 514;
    end;
    1:
    begin
      Form1.v_tamanho_matriz := 20;
      Form1.v_tamanho_celula := 25;
      Form1.v_tamanho_linha := 1;
      Form1.v_ajuste := 1;

      Form1.ClientWidth := 524;
      Form1.ClientHeight := 524;
    end;
    2:
    begin
      Form1.v_tamanho_matriz := 30;
      Form1.v_tamanho_celula := 20;
      Form1.v_tamanho_linha := 1;
      Form1.v_ajuste := 0;

      Form1.ClientWidth := 634;
      Form1.ClientHeight := 634;
    end;
  end;

  case CB_Tempo.ItemIndex of
    0: Form1.v_tempo := 10;
    1: Form1.v_tempo := 100;
    2: Form1.v_tempo := 500;
    3: Form1.v_tempo := 1000;
    4: Form1.v_tempo := 2000;
  end;

  case CB_Tipo.ItemIndex of
    0: Form1.v_tipo := CB_Tipo.ItemIndex;

    1:
    begin
      Form1.v_tipo := CB_Tipo.ItemIndex;
      if E_Raio.Text = '' then
      begin
        ShowMessage('Para este tipo é necessario informar o Raio');
        Exit;
      end;
      Form1.v_raio := StrToInt(E_Raio.Text);
    end;

    2:
    begin
      Form1.v_tipo := CB_Tipo.ItemIndex;
      if (E_Raio.Text = '') or (E_Raio2.Text = '') then
      begin
        ShowMessage('Para este tipo é necessario informar o Eixo Maior e Eixo Menor');
        Exit;
      end;
      Form1.v_raio := StrToInt(E_Raio.Text);
      Form1.v_raio2 := StrToInt(E_Raio2.Text);
    end;
  end;


  Form1.ShowModal;
end;

procedure TForm2.CB_TipoChange(Sender: TObject);
begin
  case CB_Tipo.ItemIndex of
    0:
    begin
      L_Raio.Visible := False;
      E_Raio.Visible := False;
      L_Raio2.Visible := False;
      E_Raio2.Visible := False;
    end;
    1:
    begin
      L_Raio.Caption := 'Raio:';
      L_Raio.Left := 98;
      L_Raio.Visible := True;
      E_Raio.Visible := True;
      L_Raio2.Visible := False;
      E_Raio2.Visible := False;
    end;
    2:
    begin
      L_Raio.Caption := 'Eixo Maior:';
      L_Raio.Left := 70;
      L_Raio.Visible := True;
      E_Raio.Visible := True;
      L_Raio2.Caption := 'Eixo Menor:';
      L_Raio2.Visible := True;
      E_Raio2.Visible := True;
    end;
  end;
end;

end.
