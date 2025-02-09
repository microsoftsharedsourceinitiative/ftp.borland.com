{      This Unit is a replacement for the Printer unit that   }
{ came with Turbo Pascal Version 4.  It's purpose is two      }
{ fold.  It will allow a user to change the device that       }
{ the LST file is writing to on the fly.                      }
{ The second purpose of this unit is that when writing to     }
{ a Printer it will also circumvent DOS's stripping of a      }
{ Ctrl-Z ($1A, the End Of File character) when writing to the }
{ printer as an ASCII device.  Ctrl-Z was usually sent as     }
{ part of a graphics string to a printer.  In version 3.0 of  }
{ Turbo Pascal an ASCII device was opened in binary mode, and }
{ in version 4 an ASCII device is opened in ASCII mode and    }
{ DOS thus strips a Ctrl-Z.                                   }
{                                                             }
{      This also provides a good example of a Text file       }
{ device driver.                                              }
{                                                             }
{      Type this to a file called PRINTER3.PAS                }

Unit Printer3;

Interface

Uses DOS;                                  { for using INTR() }

Var
  LST : Text;                  { Public LST file variable     }
  PrintToPrinter,              { Public Printer on/off toggle }
  PrintToScreen : Boolean;     { Public Screen on/off toggle  }

Procedure SetPrinter( Port:Byte );
{      SetPrinter sets the printer number to Port where Port  }
{ is 'n' in 'LPTn'.  ie.  To write to LPT1: SetPrinter(1),    }
{ for LPT2: SetPrinter(2).  SetPrinter changes the Port that  }
{ subsequent Write operations will write to.  This lets you   }
{ change the printer that you are printing to on the fly.     }

Implementation

{      The following routines MUST be FAR calls because they  }
{ are called by the Read and Write routines.  (They are not   }
{ Public (in the implementation section ) because they should }
{ only be accessed by the Read and Write routines.            }

{$F+}

{      LSTNoFunction performs a NUL operation for a Reset or  }
{ Rewrite on LST (Just in case)                               }

Function LSTNoFunction( Var F: TextRec ): integer;
Begin
  LSTNoFunction := 0;                    { No error           }
end;

{      LSTOutputToPrinter sends a the output to the Printer   }
{ port number stored in the first byte or the UserData area   }
{ of the Text Record.                                         }

Function LSTOutputToPrinter( Var F: TextRec ): integer;
var
  Regs: Registers;
  P : word;
begin
  With F do
  Begin
    P := 0;
    Regs.AH := 16;
    While (P < BufPos) and ((regs.ah and 16) = 16) do
    Begin
      If PrintToScreen Then
        Begin
          Regs.AH := $02;
          Regs.DL := Ord(BufPtr^[P]);
          Intr($21,Regs);
          Regs.AH := 16;
        End;
      If PrintToPrinter then
        Begin
          Regs.AL := Ord(BufPtr^[P]);
          Regs.AH := 0;
          Regs.DX := UserData[1];
          Intr($17,Regs);
        end;
      Inc(P);
    end;
    BufPos := 0;
  End;
  if (Regs.AH and 16) = 16 then
    LSTOutputToPrinter := 0              { No error           }
   else
     if (Regs.AH and 32 ) = 32 then
       LSTOutputToPrinter := 159         { Out of Paper       }
   else
       LSTOutputToPrinter := 160;        { Device write Fault }
End;

{$F-}

{      AssignLST both sets up the LST text file record as     }
{ would ASSIGN, and initializes it as would a RESET.  It also }
{ stores the Port number in the first Byte of the UserData    }
{ area.                                                       }

Procedure AssignLST( Port:Byte );
Begin
  With TextRec(LST) do
    begin
      Handle      := $FFF0;
      Mode        := fmOutput;
      BufSize     := SizeOf(Buffer);
      BufPtr      := @Buffer;
      BufPos      := 0;
      OpenFunc    := @LSTNoFunction;
      InOutFunc   := @LSTOutputToPrinter;
      FlushFunc   := @LSTOutputToPrinter;
      CloseFunc   := @LSTOutputToPrinter;
      UserData[1] := Port - 1;  { We subtract one because }
  end;                          { Dos Counts from zero.   }
end;


Procedure SetPrinter( Port:Byte ); { Documented above     }
Begin
  With TextRec(LST) do
    UserData[1] := Port - 1;{ We subtract one because DOS }
End;                        { Counts from zero.           }

Begin  { Initilization }
  PrintToPrinter := True;   { Print To Printer but not    }
  PrintToScreen := False;   { the Screen by default.      }

  AssignLST( 1 );           { Call assignLST so it works  }
end.                        { like Turbo's Printer unit   }


************ Type this to a Second file ************

Program Test_Printer3_Unit;

Uses Printer3;

Begin
  Writeln(     'Testing...');
  Writeln( LST,'Testing...Printer #1');
  SetPrinter( 1 );
  Writeln( LST,'Testing...Same Printer');
  SetPrinter( 2 );
  Writeln( LST,'Testing...Printer #2');
  SetPrinter( 1 );
  PrintToScreen := True;
  Writeln( LST, 'Testing...Printer #1 and Screen');
  PrintToPrinter := False;
  Writeln( LST, 'Testing...Screen only');
End.

