program LinkList;
{
  Lesson 29
  A simple linked list
}
uses
  Crt;

type
  PMyRecord = ^TMyRecord;
  TMyRecord = Record
    Name: String;
    Next: PMyRecord;
  end;

var
  Total: Integer;


function Int2Str(L : LongInt) : string;
{ Converts an integer to a string for use with OutText, OutTextXY }
var
  S : string;
begin
  Str(L, S);
  Int2Str := S;
end; { Int2Str }

procedure CreateNew(var Item: PMyRecord);
begin
  New(Item);
  Item^.Next := nil;
  Item^.Name := '';
end;

procedure GetData(var Item: PMyRecord);
begin
  Item^.Name := 'Sam' + Int2Str(Total);
end;

procedure DoFirst(var First, Current: PMyRecord);
begin
  CreateNew(Current);
  GetData(Current);
  First := Current;
end;

procedure Add(var Prev, Current: PMyRecord);
begin
  Prev := Current;
  CreateNew(Current);
  GetData(Current);
  Prev^.Next := Current;
end;

procedure Show(Head: PMyRecord);
begin
  while Head^.Next <> nil do begin
    WriteLn(Head^.Name);
    Head := Head^.Next;
  end;
  WriteLn(Head^.Name);
end;

procedure FreeAll(var Head: PMyRecord);
var
  Temp: PMyRecord;
begin
  while Head^.Next <> nil do begin
    Temp := Head^.Next;
    Dispose(Head);
    Head := Temp;
  end;
  Dispose(Head);
end;

var
  i: Integer;
  First,
  Prev,
  Current: PMyRecord;
  Start: LongInt;
  Size: LongInt;
begin
  ClrScr;
  WriteLn('Memavail = ', MemAvail);
  Total := 1;
  DoFirst(First, Current);
  repeat
    Inc(Total);
    Add(Prev, Current);
  until Total > 20;
  Show(First);
  FreeAll(First);
  WriteLn('MemAvail = ', MemAvail);
  ReadLn;
end.
