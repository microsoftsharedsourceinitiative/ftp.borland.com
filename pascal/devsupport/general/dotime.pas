program DoTime;
{
     Hook the timer interrupt.
     We're using DSEG_Vec and Kbd_Vec not as real procedures but as a
  place to store bytes in the Code Segment.
     If you want to chain to the interrupt then call ScreenChain, else
  call ScreenRet.
}

Uses
  Dos,
  Crt;

var
  Ch: Char;
  MyPtr: Pointer;
  n: Word;

procedure DSEG_Vec; Assembler;
asm
  DB 0
end;

procedure Kbd_Vec; Assembler;
asm
  DB 0, 0, 0
end;

procedure MyThing; assembler;
asm
  push ds
  mov ds, word ptr cs:[DSEG_Vec]  { Get the value of programs data seg }
  inc N                           { Don't try a writeln inside an ISR }
  pop DS                          { Instead just set a flag or inc a value }
  jmp DWORD PTR CS:[Kbd_Vec]      { Be sure to chain on to old interrupt }
end;

var
  w : Word;

begin
  ClrScr;
  n := 0;
  w := dseg;
  move(w, pointer(@DSEG_vec^) , 2);
  GetIntVec($1C, Pointer(@Kbd_Vec^));
  SetIntVec($1C, @MyThing);
  WriteLn('Press any key to end this program');
  WriteLn('Value N now equals: ');
  Repeat
    GotoXY(21, 2);                 { Don't try anything this complex }
    WriteLn(n);                    { inside a timer interrupt }
  Until KeyPressed;
  SetIntVec($1C, pointer(@kbd_Vec^));
end.