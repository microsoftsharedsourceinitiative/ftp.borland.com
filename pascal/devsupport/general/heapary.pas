Program HeapAry;
{
  I hope this is enough. The $X is just so I can use ReadKey
  without returning a result, the FlushKeyBuffer and Pause
  methods are thrown in case you are interested. The body
  of the program and the Type declaration are the parts
  you want to look at. Always remember to dispose memory
  allocated with New!
                        - Charlie
}

{$X+}
Uses
  Dos,
  Crt;

Type
  PMyArray = ^TMyArray;
  TMyArray = array[0..999] of LongInt;


procedure FlushKeyBuffer;
var Recpack : registers;
begin
  with recpack do begin
    Ax := ($0c shl 8) or 6;
    Dx := $00ff;
  end;
  Intr($21,recpack);
end;

procedure Pause;
begin
  FlushKeyBuffer;             { Make sure key buffer is empty!  }
  ReadKey;                    { Pause                           }
end;

var
  MyAry: PMyArray;
  i: Integer;

begin
  ClrScr;
  New(MyAry);                 { Allocate the memory on the heap }
  for i := 0 to 999 do        { Fill out array                  }
    MyAry^[i] := i;
  for i := 500 to 510 do      { Write the array to the screen   }
    WriteLn(MyAry^[i]);
  Pause;
  Dispose(MyAry);             { Dispose memory!                 }
end.