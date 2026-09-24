unit uP4P.PySignal;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions;

type
  /// <summary>
  /// Helper class for all PySignal_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#signal-handling">See the article about Signal Handling.</see></para>
  /// </remarks>
  TPySignal = class
    public
      /// <summary>
      /// <para>This utility function specifies a file descriptor to which the
      /// signal number is written as a single byte whenever a signal is
      /// received. fd must be non-blocking. It returns the previous such file
      /// descriptor.</para>
      /// <para>The value -1 disables the feature; this is the initial state.
      /// This is equivalent to signal.set_wakeup_fd() in Python, but without
      /// any error checking. fd should be a valid file descriptor. The function
      /// should only be called from the main thread.</para>
      /// </summary>
      class function SetWakeupFd(fd: integer): integer;
  end;

implementation

class function TPySignal.SetWakeupFd(fd: integer): integer;
begin
  if assigned(PySignal_SetWakeupFd) then
    Result := PySignal_SetWakeupFd(fd)
   else
    Result := -1;
end;

end.
