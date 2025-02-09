{
  This is code for getting the active child window
  in an MDI app. It demonstrates how to iterate through
  the child windows belonging to a parent window.
}
procedure TMyWindow.MDIGetActive(var Msg: TMessage);
var
  Return: LongInt;
  BHWindow: HWnd;
  ActWindow: PWindowsObject;
  function IsActive(AChild: PWindowsObject): Boolean; far;
  begin
    IsActive := AChild^.HWindow = BHWindow;
  end;
begin
  Return := SendMessage(ClientWnd^.HWindow, wm_MDIGetActive, 0, 0);
  BHWindow := LoWord(Return);
  ActWindow := FirstThat(@IsActive);
  ActWindow^.CloseWindow; { Just to prove we actually have the Object! }
end;
