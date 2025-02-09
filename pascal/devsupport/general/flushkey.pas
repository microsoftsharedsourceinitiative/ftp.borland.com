{
  Sometimes, Pascal might be appearing to skip over ReadKey or ReadLn
  statements in your program. This occurs because keystrokes are lingering
  in the keyboard buffer. So when ReadLn is called, it finds keystrokes
  waiting, and it reads them in. Use the FlushKeyBuffer to change this
  behavior.

  Use this procedure before you call Read, ReadLn or ReadKey. It will
  flush out any keystrokes lingering in the keyboard buffer.  
}

procedure FlushKeyBuffer;
var
  Recpack : registers;
begin
  with recpack do begin
    Ax := ($0c shl 8) or 6;
    Dx := $00ff;
  end;
  Intr($21,recpack);
end;
