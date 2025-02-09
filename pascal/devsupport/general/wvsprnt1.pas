program wvsprnt1;

{ Example of how to use WvsPrintF,
  to work with more than one string
  at a time. Use PChars not arrays
  of char. }

uses
  WinCrt,
  WinProcs,
  WinTypes,
  strings;

type
  TA = array[0..1] of LongInt;

var
  S: array[0..100] of char;
  S1, S2: PChar;
  A: TA;

begin
  Getmem(S1, 100);
  Getmem(S2, 100);
  Strcopy(S1, 'Hello ');
  Strcopy(S2, 'Sam');
  A[0] := LongInt(S1);
  A[1] := LongInt(S2);
  wvsprintf(S, 'the words: %s %s', A);
  WriteLn(S);
  Freemem(S1, 100);
  Freemem(S2, 100);
end.