{$X+}
Program TwoDlgs;
{
  The weird background is intentional
  We capture cancel messages just to see how it works.
  We capture the two "Press This" buttons.
  To bring up the dialog select Alt F and then D.
}

Uses
  App,
  Dialogs,
  Drivers,
  Menus,
  MsgBox,
  Views,
  Objects;

const
  cmDialogBox = 101;
  cmPress2 = 102;

type
  Consistency = (Solid, Runny, Melted);
  Cheese = (None, Hvarti, Tilset, Jarlsberg);


  PTrainDialog = ^TTrainDialog;
  TTrainDialog = Object(TDialog)
    constructor Init(Bounds: TRect; ATitle: String);
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Press2;
  end;

  PTwoDialog = ^TTwoDialog;
  TTwoDialog = Object(TDialog)
      Dlg1: PDialog;
    constructor Init(Bounds: TRect; ATitle:String; Dialog1: PDialog);
  end;

  TMyApp = Object(TApplication)
    constructor Init;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure DialogBox;
  end;

constructor TTwoDialog.Init(Bounds: TRect; ATitle:String; Dialog1: PDialog);
begin
  inherited Init(Bounds, ATitle);
  Dlg1 := Dialog1;
end;

constructor TTrainDialog.Init(Bounds: TRect; ATitle: String);
var
  R: TRect;
  Control: PView;
begin
  TDialog.Init(Bounds, ATitle);

  R.Assign(2, (Bounds.B.Y - Bounds.A.Y) - 12, (Bounds.B.X - Bounds.A.X) - 2, (Bounds.B.Y - Bounds.A.Y) - 3);
  Insert(New(PButton, Init(R, 'Click Here', cmPress2, bfNormal)));
end;

procedure TTrainDialog.HandleEvent(var Event: TEvent);
begin
  TDialog.HandleEvent(Event);
  if Event.What = EvCommand then begin
    case Event.Command of
      cmPress2: Press2;
      else Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TTrainDialog.Press2;
var
  D: PTwoDialog;
  R: TRect;
  Control: Word;
begin
  R.Assign(48,3,74,14);
  D := New(PTwoDialog, Init(R, 'Another Dialog', @Self));

  R.Assign(4, 2, 22, 10);
  D^.Insert(New(PButton, Init(R, 'Click To Close', cmOk, bfDefault)));

  Control := DeskTop^.ExecView(D);
  Dispose(D, Done);
end;

constructor TMyApp.Init;
var
  R: TRect;
begin
  TApplication.Init;
end;

procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What = EvCommand then begin
    case Event.Command of
      cmDialogBox: DialogBox;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('~D~ialogs', 'Alt-D', kbAltD, cmDialogBox, hcNoContext,
      NewLine(
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)))),
    nil))
  ));
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
      NewStatusKey('~Alt-D~ Dialog', kbAltD, cmDialogBox,
      NewStatusKey('~Alt-F3~ Close', kbAltF3, cmClose,
      nil)))),
    nil)
  ));
end;

procedure TMyApp.DialogBox;
var
  R: TRect;
  D: PDialog;
  Control: Word;
begin
  R.Assign(20,5,60,21);
  D := New(PTrainDialog, Init(R, 'Training Dialog'));
  DeskTop^.Insert(D);
end;

var
  A: TMyApp;
begin
  A.Init;
  A.Run;
  A.Done;
end.