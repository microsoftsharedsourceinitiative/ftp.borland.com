function WinExecAndWait(Path : Pchar; Visibility : word) : word;
var
  InstanceID : THandle;
  Msg : TMSg;
begin
  InstanceID := WinExec(Path,Visibility);
  if InstanceID < 32 then { a value less than 32 indicates an Exec error }
     WinExecAndWait := InstanceID
  else
   repeat
    while PeekMessage(Msg,0,0,0,PM_REMOVE) do
       begin
       if Msg.Message = WM_QUIT then
          halt(Msg.wParam);
       TranslateMessage(Msg);
       DispatchMessage(Msg);
       end;
   until GetModuleUsage(InstanceID) = 0;
end;
