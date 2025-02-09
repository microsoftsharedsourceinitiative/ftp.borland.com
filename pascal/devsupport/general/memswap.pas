{
  The Borland Pascal Open Architecture Handbook mentions two
  routines for creating swap files. These routines are
  called MemInitSwapFile and MemCloseSwapFile and they are
  declared in the unit DPMI.PAS that ships with the Borland Open
  Architecture Handbook for Pascal. The following example shows how
  to use them.
}

program MemSwap;

uses
  WinApi,
  DPMI;

const
  SIZE = 160;

var
  p: array [1..$3F00] of Pointer;
  i: Integer;

begin
  if MemInitSwapFile('Sam.$$$', $FFFF * 60) <> 0 then Halt(1);  

  WriteLn('Allocating ', SIZE * $FFFF, ' bytes');
  WriteLn(' Press enter to continue ');
  ReadLn;
  for i := 1 to SIZE do begin
    WriteLn('Allocating... Iteration: ', i, '  Memory available: ', MemAvail);
    P[i] := GlobalAllocPtr(gmem_Moveable, $FFFF);
  end;

  WriteLn('Freeing Memory');

  for i := 1 to SIZE do begin
    WriteLn('Freeing... Iteration: ', i, '  Memory available: ', MemAvail);
    GlobalFreePtr(P[i]);
  end;

  MemCloseSwapFile(1);
end.
