program no_os_tamplate;

//==============================================================================

var
  RTCLOK  : byte absolute $14;
  TRIG0   : byte absolute $D010;
  COLPF0  : byte absolute $D016;
  COLPF1  : byte absolute $D017;
  COLPF2  : byte absolute $D018;
  COLPF3  : byte absolute $D019;
  COLBK   : byte absolute $D01A;
  PRIOR   : byte absolute $D01B;  // (W) Priority selection register
  GRACTL  : byte absolute $D01D;  // (W) Used with DMACTL to latch all stick and paddle triggers
  RND     : byte absolute $D20A;  // (R) When this location is read, it acts as a random number generator
  PORTA   : byte absolute $D300;  // (W/R) Reads or writes data from controller jacks one and two if BIT 2 of PACTL is one. Writes to direction control if BIT 2 of PACTL is zero.
  PORTB   : byte absolute $D301;  // (W/R) Port B Reads or writes data to and/or from jacks three and four
  PACTL   : byte absolute $D302;  // (W/R) Port A controller
  DMACTL  : byte absolute $D400;  // (W) Direct Memory Access (DMA) control
  DLIST   : word absolute $D402;  // Display list pointer
  CHBAS   : byte absolute $D409;
  WSYNC   : byte absolute $D40A;  // (W) Wait for horizontal synchronization
  VCOUNT  : byte absolute $D40B;  // (R) Vertical line counter. Used to keep track of which line is currently being generated on the screen
  NMIEN   : byte absolute $D40E;  // (W) Non-maskable interrupt (NMI) enable
  NMIVEC  : word absolute $FFFA;  // The NMI interrupts are vectored through 65530 ($FFFA) to the NMI service routine

//==============================================================================




//==============================================================================

procedure nmi; assembler; interrupt;
asm
      bit NMIST
      bpl vbi                 ; check kind of interrupt
.def  :__dlijmp
      jmp __off               ; VDSLST
vbi:  inc RTCLOK
.def  :__vbijmp
      jmp __off               ; VBIVEC
.def  :__off
end;

//------------------------------------------------------------------------------

procedure set_vbi(a: pointer); assembler;
asm
  mwa a __vbijmp+1
end;

procedure reset_vbi; assembler;
asm
  mwa __off __vbijmp+1
end;

//------------------------------------------------------------------------------

procedure set_dli(a: pointer); assembler;
asm
  mwa a __dlijmp+1
end;

procedure reset_dli; assembler;
asm
  mwa __off __dlijmp+1
end;

//------------------------------------------------------------------------------

procedure system_off;
begin
  asm
    sei
  end;
  NMIEN := 0; PORTB := $FE; NMIVEC := word(@nmi); NMIEN := $C0;
end;

//------------------------------------------------------------------------------

procedure vbi; interrupt;
begin
  asm phr end;

  COLBK := RTCLOK;

  asm plr end;
end;

//==============================================================================

begin
  Pause; DMACTL := 0; system_off;
  set_vbi(@vbi);
  Pause; DMACTL := %00100010;

  repeat until false;
end.

//==============================================================================
