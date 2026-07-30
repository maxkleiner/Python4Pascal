unit uP4P.PyMutex;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>A mutual exclusion lock. The PyMutex should be initialized to zero
  /// to represent the unlocked state. For example:</para>
  /// <code>PyMutex mutex = {0};</code>
  /// <para>Instances of PyMutex should not be copied or moved. Both the
  /// contents and address of a PyMutex are meaningful, and it must remain at a
  /// fixed, writable location in memory.</para>
  /// <para>Note A PyMutex currently occupies one byte, but the size should be
  /// considered unstable. The size may change in future Python releases without
  /// a deprecation period.</para>
  /// <para>Added in version 3.13.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#c.PyMutex">See the article about PyMutex.</see></para>
  /// </remarks>
  TPyMutex = class(TInterfacedObject, IPyMutex)
    protected
      FPyMutex : PyMutex;

      function GetPyMutex: Pointer;

    public
      constructor Create; overload;
      constructor Create(const aPyMutex: PyMutex); overload;
      /// <summary>
      /// <para>Lock mutex. If another thread has already locked it, the
      /// calling thread will block until the mutex is unlocked. While blocked,
      /// the thread will temporarily detach the thread state if one
      /// exists.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      procedure Lock;
      /// <summary>
      /// <para>Unlock mutex. The mutex must be locked - otherwise, the
      /// function will issue a fatal error.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      procedure Unlock;
      /// <summary>
      /// <para>Returns True if the mutex is currently locked, False
      /// otherwise.</para>
      /// <para>Note This function is intended for use in assertions and
      /// debugging only and should not be used to make concurrency control
      /// decisions, as the lock state may change immediately after the
      /// check.</para>
      /// </summary>
      function  IsLocked: boolean;
      /// <summary>
      /// <para>Pointer to the PyMutex record.</para>
      /// </summary>
      property PyMutex : Pointer read GetPyMutex;
  end;

implementation

constructor TPyMutex.Create;
begin
  inherited Create;

  FillChar(FPyMutex, SizeOf(FPyMutex), #0);
end;

constructor TPyMutex.Create(const aPyMutex: PyMutex);
begin
  inherited Create;

  FPyMutex := aPyMutex;
end;

procedure TPyMutex.Lock;
begin
  if assigned(PyMutex_Lock) then
    PyMutex_Lock(PyMutex);
end;

procedure TPyMutex.Unlock;
begin
  if assigned(PyMutex_Unlock) then
    PyMutex_Unlock(PyMutex);
end;

function TPyMutex.IsLocked: boolean;
begin
  Result := assigned(PyMutex_IsLocked) and
            (PyMutex_IsLocked(PyMutex) <> 0);
end;

function TPyMutex.GetPyMutex: Pointer;
begin
  Result := @FPyMutex;
end;

end.
