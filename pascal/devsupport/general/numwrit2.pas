program NumWrit2;
{
  Lesson 12
  Write and read arrays of numbers from a text file
  From the book Turbo Pascal 101 by Charles Calvert
  A Sams book, ISBN 0-672-30285-3
}
uses
  Crt;

type
  TNumbers= array [0..9] of Integer;

var
  F: Text;

{ Write the array to the screen }
procedure WriteArray(TheArray: array of Integer; NumItems: Integer);
var
  i: Integer;
begin
  Dec(NumItems);

  for i := 0 to NumItems do
    Write(TheArray[i], ' ');

  WriteLn; { End the line }
end;

{ Create a file containing three rows of numbers }
procedure WriteFile;
var
  i,j: Integer;

begin
  Assign(F, 'Numbers2.Dta');
  ReWrite(F);

  for j := 0 to 2 do begin
    for i := 0 to 9 do
      Write(F, Random(10), ' ');
    WriteLn(F);
  end;

  Close(F);
end;


var
  Numbers: TNumbers;
  i,j: Integer;

begin
  ClrScr;
  Randomize;

  WriteFile;

  { Read the contents of the file and
    write each row to the screen }
  Reset(F);
  for j := 0 to 2 do begin
    for i := 0 to 9 do
      Read(F, Numbers[i]);
    ReadLn(F);
    WriteArray(Numbers, 10);
  end;

  WriteLn;
  WriteLn('Press ENTER to end this program');
  ReadLn;
end.
