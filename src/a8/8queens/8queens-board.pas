//Eight queens puzzle
//link: https://en.wikipedia.org/wiki/Eight_queens_puzzle
//---------------------------------------------------------

uses crt, sysutils, graph;

//---------------------------------------------------------

const
  speed  = 25;
  size   = 8;
  filled = $ff;

//---------------------------------------------------------

type TChessman = array[0..56] of byte;

//---------------------------------------------------------

const
{* White queen on black, invert Black queen on white *}
QUEEN_SE              : TChessman = (
  $00,$00,$00,$00,$00,$00,$00,$00,$00,$11,$18,$88,$1B,$BD,$D8,$1B,$BD,$D8,$1B,
  $BD,$D8,$1F,$FF,$F8,$1F,$FF,$F8,$1F,$FF,$F8,$1F,$FF,$F8,$0F,$FF,$F0,$0F,$FF,
  $F0,$0C,$00,$30,$07,$FF,$E0,$06,$00,$60,$03,$FF,$C0,$03,$00,$C0,$01,$FF,$80
);
{* Black queen on black, invert White queen on white *}
QUEEN_EE              : TChessman = (
  $00,$00,$00,$00,$00,$00,$11,$18,$88,$2A,$A5,$54,$24,$42,$24,$24,$42,$24,$24,
  $42,$24,$20,$00,$04,$20,$00,$04,$20,$00,$04,$20,$00,$04,$10,$00,$08,$10,$00,
  $08,$13,$FF,$C8,$08,$00,$10,$09,$FF,$90,$04,$00,$20,$04,$FF,$20,$02,$00,$40
);

//---------------------------------------------------------

var
  p       : PByte absolute $e0;
  i1b     : byte absolute $e2;
  i2b     : byte absolute $e3;
  i3b     : byte absolute $e4;
  tmp1b   : byte absolute $e5;
  tmp2b   : byte absolute $e6;
  counter : byte = 0;
  board   : array [0..size] of byte;

//---------------------------------------------------------

procedure init;
begin
  InitGraph(8);
  SetBKColor(2); TextBackground(2);
  for i1b := 0 to size do board[i1b] := 0;
end;

//---------------------------------------------------------

procedure renderQueen(chessman: word; x, y, invert: byte);
var i0b : byte;
begin
  p := pointer(DPeek($58) + (x * 3) + (y * 760));
  for i0b := 0 to 18 do begin
    p[0]:= peek(chessman) xor invert; Inc(chessman);
    p[1]:= peek(chessman) xor invert; Inc(chessman);
    p[2]:= peek(chessman) xor invert; Inc(chessman);
    Inc(p, 40);
  end;
end;

procedure putQueens;
begin;
  for i1b := 1 to size do
    begin
      tmp1b := board[i1b] - 1; tmp2b := i1b - 1;
      if (i1b and 1) = 1 then
        if (tmp1b and 1) = 1 then
          renderQueen(word(QUEEN_SE), tmp1b, tmp2b, 0)
        else
          renderQueen(word(QUEEN_EE), tmp1b, tmp2b, filled)
      else
        if (tmp1b and 1) = 0 then
          renderQueen(word(QUEEN_SE), tmp1b, tmp2b, 0)
        else
          renderQueen(word(QUEEN_EE), tmp1b, tmp2b, filled);
    end;
end;

procedure drawBoard;
begin
  p := pointer(DPeek($58));

  FillChar(p, $1800, 0);

  for i1b := 7 downto 0 do begin
    for i2b := 18 downto 0 do begin
      for i3b := 3 downto 0 do begin
          p[0] := filled;
          p[1] := filled;
          p[2] := filled;
          Inc(p,6);
      end;
      Inc(p,16);
    end;
    if (i1b and 1) = 0 then Dec(p,3) else Inc(p,3);
  end;

  putQueens; Inc(counter);

  Write('solution nr.', counter, ' ');
  for i1b := 1 to size do Write(board[i1b]);
  WriteLn;

  pause(speed);
end;

//---------------------------------------------------------

function check(n, c : byte): boolean;
var
  i: byte;
begin
  check := true;
  for i := 1 to (n - 1) do
    if (board[i] = c) or
       (byte(board[i] - i) = byte(c - n)) or
       (byte(board[i] + i) = byte(c + n))
    then exit(false);
end;

procedure generate(n: byte);
var
  c: byte;
begin

  if n > size then drawBoard
  else
    for c := 1 to size do
      if check(n, c) then begin
        board[n] := c;
        generate(n + 1);
      end;

end;

//---------------------------------------------------------

begin
  init; generate(1);
  repeat until KeyPressed;
end.
