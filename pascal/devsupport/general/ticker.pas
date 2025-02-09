program Ticker;

uses
  Crt, Prints, WinApi;

var
  Sel : Word;
  Ticks : ^LongInt;


function RealToProt(P : Pointer; Siz : Word; var Sel : Word) : Pointer;
begin
  SetSelectorBase(Sel, LongInt(HiWord(LongInt(P))) shl 4+LoWord(LongInt(P)));
  SetSelectorLimit(Sel, Siz);
  RealToProt := Ptr(Sel, 0);
end;

var
  R : Real;
begin
  Sel := AllocSelector(DSeg);
  Ticks := Ptr($0046, $000C);
  Ticks := RealToProt(Ticks, SizeOf(LongInt), Sel);
  repeat
    R := Ticks^;
    WriteLn('Ticks: ', R:2:2);
  until KeyPressed;
FreeSelector(Sel);
end.
