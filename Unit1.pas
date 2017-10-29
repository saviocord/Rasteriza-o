unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, Generics.Collections, ComCtrls, Spin;

type

  TForm1 = class(TForm)
    SG_Grid: TStringGrid;
    procedure SG_GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SG_GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure B_LimparClick(Sender: TObject);
    procedure CB_TipoChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Matriz : array of array of Integer;
    pontoA, pontoB :TPoint;

    function pontoDoClick(linha, coluna: integer): TPoint;
    procedure pintaLinha(pontoIni, pontoFim : TPoint);
    procedure preenchePontoAB(linha, coluna: integer);
    procedure rasterizacaoReta;
    procedure rasterizacaoCircunferencia;
    procedure rasterizacaoElipse;
    procedure zeraMatriz;
    procedure limpaTudo;
  public
    { Public declarations }
    v_tipo, v_tempo, v_raio, v_raio2, v_ajuste : integer;
    v_tamanho_celula, v_tamanho_matriz : integer;
    v_tamanho_linha : Double;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetMousePos(janela:tform):TPoint;
var
 ponto: Tpoint;
begin
  ponto:=janela.ClientOrigin;
  ponto.x:=mouse.CursorPos.x-ponto.x - 5;
  ponto.y:=mouse.CursorPos.y-ponto.y - 5;

  result:=ponto;
end;

function ABS(x : integer) : integer;
begin
  if x < 0 then
    result := -x
  else
    result := x;
end;

function SIGN(x : Integer) : integer;
begin
  if x < 0 then
    result := -1
  else
    result := 1;
end;

function Bresenham(point1, point2 : Tpoint) : TList<TPoint> ;
var list : TList<TPoint> ;
    deltax, deltay, signalx, signaly : integer;
    x1, y1, x2, y2 : integer;
    x, y, erro, tmp, i : integer;
    interchange : boolean;
begin
  list := TList<TPoint>.Create;

  x1 := point1.X;
  y1 := point1.Y;

  x2 := point2.X;
  y2 := point2.Y;

  deltax := ABS( (x2 - x1) );
  deltay := ABS( (y2 - y1) );
  signalx := SIGN( (x2 - x1) );
  signaly := SIGN( (y2 - y1) );

  x := x1;
  y := y1;

  // trocar deltax com deltay dependendo da inclinacao da reta
  interchange := false;

  if ( deltay > deltax) then
  begin
    tmp := deltax;
    deltax := deltay;
    deltay := tmp;
    interchange := true;
  end;

  erro := (2 * deltay - deltax);

  i := 0;
  while(i < deltax) do // for i := 0 to (i < deltax do
  begin

    list.Add(Point(x, y));

    while (erro >= 0) do
    begin
      if (interchange) then
        x := x + signalx
      else
        y := y + signaly;

      erro := (erro - 2 * deltax);
    end; // while

    if (interchange) then
      y := y + signaly
    else
      x := x + signalx;

    erro := (erro + 2 * deltay);

    inc(i);
  end; // for

  result := list;
end;

function circleSimple(ponto: TPoint; raio : integer) : TList<Tpoint> ;
var x, y, r2 : integer;
    list : TList<TPoint> ;
begin
  list := TList<TPoint>.Create;
  r2 := raio * raio;

  x := -raio;
  while x <= raio do
  begin
    y := Round( Sqrt(r2 - x*x ) );
    list.Add(Point(ponto.X+x, ponto.Y+y));
    list.Add(Point(ponto.X+x, ponto.Y-y));
    inc(x);
  end;
  Result := list;
end;

function metodoPolinomialCirculo(ponto: TPoint; raio : integer) : TList<Tpoint> ;
var x, y, xFim : integer;
    r2, h, k : integer;
    list : TList<TPoint> ;
begin
  list := TList<TPoint>.Create;

  r2 := raio * raio;

  xFim := Trunc( raio / Sqrt(2) );
  x := 0;
  h := ponto.X;
  k := ponto.Y;
  while x <= xFim do
  begin
    y := Round( Sqrt(r2 - x*x ) );
    list.Add(Point(x+h, y+k)); list.Add(Point(-x+h, -y+k));
    list.Add(Point(y+h, x+k)); list.Add(Point(-y+h, -x+k));
    list.Add(Point(-y+h, x+k)); list.Add(Point(y+h, -x+k));
    list.Add(Point(-x+h, y+k)); list.Add(Point(x+h, -y+k));

    inc(x);
  end;
  Result := list;
end;

function metodoPolinomialElipse(ponto: TPoint; eixoMaior, eixoMenor : integer) : TList<Tpoint> ;
var x, y, xFim : integer;
    r2, h, k : integer;
    list : TList<TPoint> ;
begin
  list := TList<TPoint>.Create;

  xFim := eixoMaior;

  x := 0;
  h := ponto.X;
  k := ponto.Y;
  while x <= xFim do
  begin

    y := eixoMenor * Round( Sqrt(1- (( x*x) / (eixoMaior*eixoMaior)) ) );

    list.Add(Point(x+h, y+k));  list.Add(Point(-x+h, -y+k));
    list.Add(Point(-x+h, y+k));  list.Add(Point(x+h, -y+k));
    inc(x);
  end;
  Result := list;
end;

procedure TForm1.SG_GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var i, j : Integer;
begin
  if Matriz[ARow,ACol] = 1 then
    TDBGrid(Sender).Canvas.Brush.Color := clBlack
  else
    TDBGrid(Sender).Canvas.Brush.Color := clWindow;

  TDBGrid(Sender).Canvas.FillRect(Rect);

  if v_tipo = 0 then
  begin
    if (pontoA.X <> -1) and (pontoB.X <> -1) then
    begin
      pintaLinha(pontoA, pontoB);
    end;
  end;

end;

procedure TForm1.SG_GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  preenchePontoAB(ARow, ACol);
  zeraMatriz;

  if pontoA.X <> -1 then
    Matriz[pontoA.X, pontoA.Y] := 1;

  if pontoB.X <> -1 then
    Matriz[pontoB.X, pontoB.Y] := 1;

  SG_Grid.Repaint;

  case v_tipo of
    0:
    begin
      if (pontoA.X <> -1) and (pontoB.X <> -1) then
        rasterizacaoReta;
    end;
    1:
    begin
      if (pontoA.X <> -1) then
        rasterizacaoCircunferencia;
    end;
    2:
    begin
      if (pontoA.X <> -1) then
        rasterizacaoElipse;
    end;
  end;

end;

procedure TForm1.zeraMatriz;
var i, j : Integer;
begin
  for i := 0 to v_tamanho_matriz - 1 do
  begin
    for j := 0 to v_tamanho_matriz - 1 do
    begin
      Matriz[i,j] := 0;
    end;
  end;
end;

procedure TForm1.B_LimparClick(Sender: TObject);
begin
  limpaTudo;
  SG_Grid.Repaint;
end;

procedure TForm1.CB_TipoChange(Sender: TObject);
begin
  limpaTudo;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Form1 := nil;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  SetLength(Matriz,v_tamanho_matriz,v_tamanho_matriz);
  limpaTudo;

  SG_Grid.ColCount := v_tamanho_matriz;
  SG_Grid.RowCount := v_tamanho_matriz;
  SG_Grid.DefaultColWidth := v_tamanho_celula;
  SG_Grid.DefaultRowHeight := v_tamanho_celula;
end;

procedure TForm1.pintaLinha(pontoIni, pontoFim: TPoint);
var pt1, pt2 : tPoint;
begin
  with TControlCanvas.Create do
  begin
    Control := SG_Grid;
    Pen.Style := psSolid;
    Pen.Color := clBlue;
    Pen.Width := 2;
    pt1 := pontoDoClick(pontoIni.X, pontoIni.Y);
    MoveTo(pt1.X+v_ajuste, pt1.Y+v_ajuste);
    pt2 := pontoDoClick(pontoFim.X, pontoFim.Y);
    LineTo(pt2.X+v_ajuste, pt2.Y+v_ajuste);
  end;
end;

function TForm1.pontoDoClick(linha, coluna: integer): TPoint;
var pt : tPoint;
begin
  pt.x := (coluna * v_tamanho_celula) + (v_tamanho_celula div 2) + round((coluna * v_tamanho_linha ) -1);
  pt.y := (linha * v_tamanho_celula) + (v_tamanho_celula div 2) + round((linha * v_tamanho_linha ) -1);

  result := pt;
end;

procedure TForm1.limpaTudo;
begin
  zeraMatriz;
//  Memo1.Clear;

  pontoA.X := -1;
  pontoA.Y := -1;
  pontoB.X := -1;
  pontoB.Y := -1;
end;

procedure TForm1.preenchePontoAB(linha, coluna : integer);
var ponto : TPoint;
begin
  ponto.X := linha;
  ponto.Y := Coluna;

  if pontoA.X = -1 then
  begin
    pontoA := ponto;
//    Memo1.Lines.Add('pontoA.x='+IntToStr(pontoA.X)+' pontoA.y='+IntToStr(pontoA.Y));
  end
  else if (v_tipo = 0) and (pontoB.X = -1) then
  begin
    pontoB := ponto;
//    Memo1.Lines.Add('pontoB.x='+IntToStr(pontoB.X)+' pontoB.y='+IntToStr(pontoB.Y));
  end
  else
  begin
    pontoA := ponto;
//    memo1.Lines.Add('');
//    Memo1.Lines.Add('pontoA.x='+IntToStr(pontoA.X)+' pontoA.y='+IntToStr(pontoA.Y));
    pontoB.X := -1;
    pontoB.Y := -1;
  end;
end;

procedure TForm1.rasterizacaoCircunferencia;
var l : TList<TPoint>;
    i : Integer;
    ponto : TPoint;
    tempo : integer;
begin
  l := metodoPolinomialCirculo(pontoA, v_raio );

//  Memo1.Lines.Add(' -------inicio-------') ;
  i := 0;
  while i < l.Count do
  begin
    ponto := l.Items[i];

//    Memo1.Lines.Add('X=' + IntToStr(ponto.X) + ' Y=' + IntToStr(ponto.Y) );
    Matriz[ponto.X,ponto.Y] := 1;
    SG_Grid.Repaint;

    Inc(i);
  end;

  SG_Grid.Repaint;

end;

procedure TForm1.rasterizacaoElipse;
var l : TList<TPoint>;
    i : Integer;
    ponto : TPoint;
    tempo : integer;
begin
  l := metodoPolinomialElipse(pontoA, v_raio, v_raio2 );

//  Memo1.Lines.Add(' -------inicio-------') ;
  i := 0;
  while i < l.Count do
  begin
    ponto := l.Items[i];

//    Memo1.Lines.Add('X=' + IntToStr(ponto.X) + ' Y=' + IntToStr(ponto.Y) );
    Matriz[ponto.X,ponto.Y] := 1;
    SG_Grid.Repaint;

    Inc(i);
  end;

  SG_Grid.Repaint;

end;

procedure TForm1.rasterizacaoReta;
var l : TList<TPoint>;
    i : Integer;
    ponto : TPoint;
begin
  l := Bresenham(pontoA, pontoB);

//  Memo1.Lines.Add(' -------inicio-------') ;
  i := 0;
  while i < l.Count do
  begin
    ponto := l.Items[i];
    if not ((ponto.X = pontoA.X) and (ponto.Y = pontoA.Y)) then
    begin
      Sleep(v_tempo);
//      Memo1.Lines.Add('X=' + IntToStr(ponto.X) + ' Y=' + IntToStr(ponto.Y) );
      Matriz[ponto.X,ponto.Y] := 1;
      SG_Grid.Repaint;
    end;
    Inc(i);
  end;

  SG_Grid.Repaint;
end;

end.
