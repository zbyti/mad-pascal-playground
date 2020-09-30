program Depacker;

uses crt, fastgraph;

var
  qrCode: pchar = '```````QCFH_IBX[GQP\^UKSE][FUKKG[[FUL_O[KFX[ZEE\^QCVKVIB``MY_P`TD[NKNBTFFSPWNUKZZZ_TV^SU_XZ^AUBFPHUOPYWANWCWA]]TTEVZ^IJWYZEDW`W^MOVPNXQTVZ_TSF^VR]P]KK^CC`SVFS\W^^SPDR_\__SZ[`PRLD^DAT`_MJ`O\QDOVRKHX[_UQOJUKEMTA^ULKSPPZULVBZPLX[IFZQPQCRLD\^```````';
  i0, i1, x, y            : byte;
  dicFirstLetter, qrBlock : byte;

begin
  InitGraph(5+16); SetColor(1);
  
  x := 0; y := 0;
  dicFirstLetter := ord('A');

  for i0 := 0 to 244 do begin
    qrBlock := ord(qrCode[i0]) - dicFirstLetter;
    for i1 := 4 downto 0 do begin
      if (qrBlock and %10000) <> 0 then PutPixel(x,y);
      qrBlock := qrBlock shl 1;
      x := x + 1;
      if x = 35 then begin
        x := 0; y := y + 1;
      end;
    end;
  end;

  ReadKey; TextMode(0);
end.
