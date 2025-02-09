{
The GetWinVersion function shown below will return the current version
of Windows or will return 'Windows not running' if Windows is not 
running. Not valid on versions below 3.0, but if you need that kind
of info (real obscure) then:
  ====================================================================
  Al = 00h if Windows 3.x in enhanced or Windows/386 2.x is not running
  
}

function Int2Str(A: LongInt): String;
var
  S: String;
begin
  Str(A, S);
  Int2Str := S;
end;

function GetWinVersion: String;
var
  Minor, Major: Byte;
  S: String;
begin
  asm
    mov ax, $1600
    int $2F
    mov Minor, Ah
    mov Major, Al
  end;
  if (Major = 0) or (Major = $80) then
    S := 'Windows not running'
  else
    if (Major = 1) or (Major = $FF) then
      S := 'Windows/386 is running'
  else
    S := Int2Str(Major) + '.' + Int2Str(Minor);
  GetWinVersion := S;
end;

begin
  WriteLn(GetWinVersion);
end.
