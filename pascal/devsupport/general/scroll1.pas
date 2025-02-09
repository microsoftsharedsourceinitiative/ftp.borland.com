{************************************************}
{                                                }
{   Demo program from the Turbo Vision Guide     }
{                                                }
{************************************************}

program Scroll1;

uses Objects, Drivers, Views, Menus, App, Dialogs;

const
  FileToRead = 'SCROLL1.PAS';
  MaxLines   = 100;
  cmFileOpen = 100;
  cmNewWin   = 101;

var
  LineCount: Integer;
  Lines: array[0..MaxLines - 1] of PString;

type
  PInterior = ^TInterior;
  TInterior = object(TScroller)
    constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Draw; virtual;
  end;

  PDemoWindow = ^TDemoWindow;
  TDemoWindow = object(TWindow)
    constructor Init(Bounds: TRect; WinTitle: String; WindowNo: Word);
  end;

  TMyApp = object(TApplication)
      MyScroller: PInterior;
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure ScrollWindow;
  end;

procedure ReadFile;
var
  F: Text;
  S: String;
begin
  LineCount := 0;
  Assign(F, FileToRead);
  {$I-}
  Reset(F);
  {$I+}
  if IOResult <> 0 then
  begin
    Writeln('Cannot open ', FileToRead);
    Halt(1);
  end;
  while not Eof(F) and (LineCount < MaxLines) do
  begin
    Readln(F, S);
    Lines[LineCount] := NewStr(S);
    Inc(LineCount);
  end;
  Close(F);
end;

procedure DoneFile;
var
  I: Integer;
begin
  for I := 0 to LineCount - 1 do
    if Lines[I] <> nil then DisposeStr(Lines[i]);
end;

{ TInterior }
constructor TInterior.Init(var Bounds: TRect; AHScrollBar,
                           AVScrollBar: PScrollBar);
begin
  TScroller.Init(Bounds, AHScrollBar, AVScrollBar);
  Options := Options and not ofFramed;
  SetLimit(100, LineCount);
end;

procedure TInterior.HandleEvent(var Event: TEvent);
begin
  Inherited HandleEvent(Event);
end;

procedure TInterior.Draw;
var
  Color: Byte;
  I, Y: Integer;
  B: TDrawBuffer;
begin
  Color := GetColor(1);
  for Y := 0 to Size.Y - 1 do
  begin
    MoveChar(B, ' ', Color, Size.X);
    i := Delta.Y + Y;
    if (I < LineCount) and (Lines[I] <> nil) then
      MoveStr(B, Copy(Lines[I]^, Delta.X + 1, Size.X), Color);
    WriteLine(0, Y, Size.X, 1, B);
  end;
end;

constructor TDemoWindow.Init(Bounds: TRect; WinTitle: String; WindowNo: Word);
begin
  TGroup.Init(Bounds);
  Options := Options or (ofSelectable + ofTopSelect);
  Title := NewStr(WinTitle);
  Number := WindowNo;
  Palette := wpBlueWindow;
end;

{ TMyApp }

constructor TMyApp.Init;
var
  Bounds: TRect;
  R: TRect;
  VScrollBar,HScrollBar: PScrollBar;
  Window: PWindow;
begin
  inherited Init;
  DeskTop^.GetExtent(Bounds);
  Window := New(PDemoWindow, Init(Bounds, 'Sam', 0));
  DeskTop^.Insert(Window);
  R.Assign(Bounds.B.X-1, Bounds.A.Y, Bounds.B.X, Bounds.B.Y);
  VScrollBar := New(PScrollBar, Init(R));
  VScrollBar^.Options := VScrollBar^.Options or ofPostProcess;
  Window^.Insert(VScrollBar);
  R.Assign(Bounds.A.X, Bounds.B.Y-1, Bounds.B.X-1, Bounds.B.Y);
  HScrollBar := New(PScrollBar, Init(R));
  HScrollBar^.Options := HScrollBar^.Options or ofPostProcess;
  HScrollBar^.GrowMode := gfGrowHiY + gfGrowLoY;
  Window^.Insert(HScrollBar);
  R.Assign(Bounds.A.X, Bounds.A.Y, Bounds.B.X - 1, Bounds.B.Y-1);
  MyScroller := New(PInterior, Init(R, HScrollBar, VScrollBar));
  Window^.Insert(MyScroller);
end;

procedure TMyApp.InitMenuBar;
var R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('~O~pen', 'F3', kbF3, cmFileOpen, hcNoContext,
      NewItem('~N~ew', 'F4', kbF4, cmNewWin, hcNoContext,
      NewLine(
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil))))),
    NewSubMenu('~W~indow', hcNoContext, NewMenu(
      NewItem('~N~ext', 'F6', kbF6, cmNext, hcNoContext,
      NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcNoContext,
      nil))),
    nil))
  )));
end;

procedure TMyApp.InitStatusLine;
var R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F4~ New', kbF4, cmNewWin,
      NewStatusKey('~Alt-F3~ Close', kbAltF3, cmClose,
      nil)))),
    nil)
  ));
end;

procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmNewWin: ScrollWindow;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.ScrollWindow;
begin
  MyScroller^.ScrollTo(10, 10);
end;

var
  MyApp: TMyApp;

begin
  ReadFile;
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
  DoneFile;
end.
