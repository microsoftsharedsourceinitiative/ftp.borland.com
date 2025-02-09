{************************************************}
{                                                }
{   Turbo Pascal for Windows                     }
{   Pascallian  Demo                             }
{   Copyright (c) 2001 by Pascallian Press       }
{                                                }
{************************************************}

program TopMost;

uses WinTypes, WinProcs, OWindows, Strings, Win31;

type
  TMyApplication = object(TApplication)
    procedure InitMainWindow; virtual;
  end;

type
  PMyWindow = ^TMyWindow;
  TMyWindow = object(TWindow)
    constructor Init(AParent: PWindowsObject; AName: PChar);
    procedure SetUpWindow; virtual;
    function CanClose: Boolean; virtual;
    procedure WMLButtonDown(var Msg: TMessage);
      virtual wm_First + wm_LButtonDown;
    procedure WMRButtonDown(var Msg: TMessage);
      virtual wm_First + wm_RButtonDown;
  end;

{--------------------------------------------------}
{ TMyWindow's method implementations:              }
{--------------------------------------------------}
constructor TMyWIndow.Init(AParent: PWindowsObject; AName: PChar);
begin
  TWindow.Init(AParent, AName);
end;

procedure TMyWindow.SetUpWIndow;
begin
  TWindow.SetUpWIndow;
  SetWindowPos(HWindow, HWnd_TopMost, 0, 0, 0, 0, swp_ShowWindow);
end;

function TMyWindow.CanClose: Boolean;
var
  Reply: Integer;
begin
  CanClose := True;
end;

procedure TMyWindow.WMLButtonDown(var Msg: TMessage);
var
  S: String;
  S1: array[0..100] of Char;
  F: Text;
begin
end;

procedure TMyWindow.WMRButtonDown(var Msg: TMessage);
begin
  MessageBox(HWindow, 'You have pressed the right mouse button',
    'Message Dispatched', mb_Ok);
end;

{--------------------------------------------------}
{ TMyApplication's method implementations:         }
{--------------------------------------------------}

procedure TMyApplication.InitMainWindow;
begin
  MainWindow := New(PMyWindow, Init(nil, 'Sample ObjectWindows Program'));
end;

{--------------------------------------------------}
{ Main program:                                    }
{--------------------------------------------------}

var
  MyApp: TMyApplication;

begin
  MyApp.Init('MyProgram');
  MyApp.Run;
  MyApp.Done;
end.
