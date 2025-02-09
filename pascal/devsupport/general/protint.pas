program ProtInt;

const
  BreakFlag:Boolean = False;

type
  TDPMIRegs = record
    edi, esi, ebp, reserved, ebx, edx, ecx, eax: LongInt;
    flags, es, ds, fs, gs, ip, cs, sp, ss: Word;
  end;

{$F+}
procedure MyBreak; assembler;
asm
  push ds  
  mov ax, seg BreakFlag
  mov ds, ax
  mov breakflag, 1
  pop ds
                                { See page 61 of DPMI Spec .9       }
  cld                           { We need to set up real mode CS:IP }
  lodsw                         { Get IP off the stack and into ax  }
  mov es:[di + 2Ah], ax         { Move IP into the TDPMIRegs struc  }       
  lodsw                         { Get CS off the stack and into ax  }
  mov es:[di + 2Ch], ax         { Move CS into the TDPMIRegs struc  } 
  add word ptr es:[di + 2Eh], 6 { Adjust SP of TDPMIRegs past CS, IP and flags }
  iret
end;
{$F-}

var
  Buf: TDPMIRegs;
  NewPtr,
  OldPtr : Pointer;

begin
  asm
    { Allocate real mode callback }
    push ds
    mov ax, Seg MyBreak
    mov ds, ax
    mov si, Offset MyBreak
    mov ax, Seg Buf
    mov es, ax
    mov di, Offset Buf
    mov ax, 0303h
    int 31h
    pop ds
    push cx
    push dx

    { Get Real Mode Int Vec }
    mov ax, 0200h
    mov bl, 1Bh
    int 31h
    mov word ptr OldPtr + 2, cx
    mov word ptr OldPtr, dx

    { Set Real Mode Int Vec }
    pop dx
    pop cx
    mov ax, 0201h
    mov bl, 1Bh
    int 31h
  end;

  WriteLn('Press Control Break to stop');

  repeat
  until BreakFlag;

  asm
    mov cx, Seg OldPtr
    mov dx, Offset OldPtr
    mov ax, 0201h
    mov bl, 1Bh
  end;
end.
