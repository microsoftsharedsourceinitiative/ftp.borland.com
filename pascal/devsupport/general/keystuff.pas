program KeyStuff;
{
  Program: KeyStuff
  Date: 5/10/92
  Description: Stuff keyboard buffer exampler
}

var
  KeyHead: Word Absolute $40:$1A;
  KeyTail: Word Absolute $40:$1C;
  KeyBuffer: array[0..15] of Word absolute $40:$1E;

function StuffIt(S: String): Boolean;
var
  i,j: Integer;
begin
  asm cli; end;
  j := Length(S) + 2;
  if j > 15 then j := 15;
  Keyhead := $1E; KeyTail := $1E + (2 * j);
  for i := 0 to j - 2 do KeyBuffer[i] := Word(S[i + 1]);
  KeyBuffer[i] := 13;
  KeyBuffer[i + 1] := 0;
  asm sti; end;
end;

begin
  StuffIt(ParamStr(1));
end.