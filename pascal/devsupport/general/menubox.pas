{
This example shows how to display a pop-up menu box on the desktop.
Make all of the changes described here to listing 2.1
}

{$X+}
uses
  Objects, Menus, Drivers, Views, App;

const
  cmMenuBox = 101;
  cmFoo     = 102;
type


PMyApp = ^TMyApp;
TMyApp = object(TApplication)
  MenuBox : PMenuBox;  { declare a MenuBox object}
  MyBackGround : PBackGround;
  constructor Init;
  procedure InitMenuBar; virtual;
  procedure HandleEvent(var Event: TEvent); virtual;
  procedure DoMenuBox;
 end;

constructor TMyApp.Init;
var
 R : TRect;
begin
 TApplication.Init;

{ DeskTop^.Delete(DeskTop^.BackGround);
 MyBackGround := New(PBackGround, Init(R,' '));
 DeskTop^.Insert(MyBackGround); }
end;

procedure TMyApp.InitMenuBar;
var R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('~M~enuBox', 'F1', kbF1, cmMenuBox, hcNoContext,
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil))),
    NewSubMenu('~W~indow', hcNoContext, NewMenu(
      NewItem('~N~ext', 'F6', kbF6, cmNext, hcNoContext,
      NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcNoContext,
      nil))),
    nil))
  )));
end;

{ Main application HandleEvent }
procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmMenuBox : DoMenuBox;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.DoMenuBox;
var
  R: TRect;
  C: Word;
  Event: TEvent;
begin
  GetExtent(R);
  R.Assign(15,15,25,25);
  { R.B.Y := R.A.Y + 25; }
  MenuBox := New(PMenuBox, Init(R, NewMenu(
    NewSubMenu('~T~est', hcNoContext, NewMenu(
      NewItem('~E~xit','Alt-X',kbAltX,cmQuit,hcNoContext,
      NewItem('~E~xit','Alt-C',kbAltC,cmFoo,hcNoContext,
     nil))),
   nil)),
  nil));
  C := DeskTop^.ExecView(MenuBox);
  Event.What := evCommand;
  Event.Command := C;
  PutEvent(Event);
end;

var
 MyApp: TMyApp;

begin
 MyApp.Init;
 MyApp.Run;
 MyApp.Done;
end.



 