{ 
  This happens not to be an ideal interrupt to call,
  since it leaves two bytes on the stack, but the
  basic principle is clear. Absolutely no
  guarantees, this is just an example.
  What it does is read a sector from a floppy disk in
  the A drive.
}
uses
  Crt,
  WinApi;

type
  TDPMIRegs = record
    edi, esi, ebp, reserved, ebx, edx, ecx, eax: LongInt;
    flags, es, ds, fs, gs, ip, cs, sp, ss: Word;
  end;

  PBuffer = ^TBuffer;
  TBuffer = array[0..(9*512) - 1] of Byte;

  TBootSec = record
    Signature         : Byte;
    Skip              : Word;
    Vendor            : Array[1..8] of Char;
    BytesPerSector    : Word;
    SecPerClus        : Byte;
    ReservedSectors   : Word;
    FatCopies         : Byte;
    RootEntries       : Word;
    TotalSectors      : Word;
    Media             : Byte;
    SecPerFat         : Word;
    SectorsPerTrack   : Word;
    Heads             : Word;
    HiddenSectors     : Word;
    Loader            : Array[1..482] of Byte;
  End;


function DPMIRealInt(IntNo, CopyWords: Word; var R: TDPMIRegs): Boolean; assembler;
asm
  mov ax, 0300h
  mov bx, IntNo
  mov cx, CopyWords
  les di, R
  int 31h
  jc @error
  mov ax, 1
  jmp @done
@error:
  xor ax, ax
  @Done:
end;

function LongFromBytes(HighByte, LowByte: Byte): LongInt; assembler;
asm
  mov dx, 0
  mov ah, HighByte
  mov al, LowByte
end;

function LongFromWord(LoWord: Word): LongInt; assembler;
asm
  mov dx, 0
  mov ax, LoWord;
end;

function RealToProt(P: Pointer; Size: Word; var Sel: Word): Pointer;
begin
  SetSelectorBase(Sel, LongInt(HiWord(LongInt(P))) Shl 4 + LoWord(LongInt(P)));
  SetSelectorLimit(Sel, Size);
  RealToProt := Ptr(Sel, 0);
end;

procedure WriteIt(Buf: PBuffer);
var
  SecRead: TBootSec;
  i: Integer;
begin
  Move(Buf^, SecRead, 512);
  with SecRead do begin
    WriteLn('Signature = ', Signature);  
    WriteLn('Bytes Per Sector = ', BytesPerSector);
    WriteLn('Total Sectors = ', TotalSectors);
    WriteLn('Sec Per Fat = ', SecPerFat);
    WriteLn('Sectors Per Track = ', SectorsPerTrack);
    WriteLn('Heads = ', Heads);
    Write('Vendor = ');
    for i := 1 to 8 do Write(Vendor[i]);
  end;
  ReadLn;
end;

var
  R: TDPMIRegs;
  Address : LongInt;
  TempBuf : PBuffer;
begin
  ClrScr;
  FillChar(R, SizeOf(TDPMIRegs), #0);
  R.Eax := LongFromBytes(0,0);
  R.Ecx := LongFromWord(1);
  R.Edx := LongFromWord(0);
  Address := GlobalDosAlloc(9 * 512);
  R.ds := HiWord(Address);
  R.Ebx := 0;
  DPMIRealInt($25, 0, R);
  TempBuf := Ptr(LoWord(Address), 0);   { Get the selector pointing to 1 Meg}
  WriteIt(TempBuf);
  GlobalDosFree(LoWord(Address));
end.