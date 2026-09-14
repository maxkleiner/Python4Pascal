unit uP4P.PyInterpreterView;

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
  /// <para>A view of an interpreter.</para>
  /// <para>In some cases, it may be necessary to access an interpreter that
  /// may have been deleted. This can be done using interpreter views.</para>
  /// <para>This is a thread-safe way to access an interpreter that may have
  /// be finalizing or already destroyed.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/interp-lifecycle.html#cautions-regarding-interpreter-finalization">See the Python article about Cautions regarding interpreter finalization.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPyInterpreterView = class(TInterfacedObject, IPyInterpreterView)
    protected
      FPyInterpreterView : PPyInterpreterView;

      function  GetInitialized: boolean;
      function  GetView: PPyInterpreterView;
      procedure SetView(aValue: PPyInterpreterView);
      /// <summary>
      /// <para>Close an interpreter view.</para>
      /// <para>If an interpreter view is never closed, the view's memory will
      /// never be freed, but there are no other consequences. (In contrast,
      /// forgetting to close a guard will infinitely hang the main thread
      /// during finalization.)</para>
      /// <para>This function cannot fail, and the caller doesn't need to hold
      /// an attached thread state.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      procedure Close;

    public
      constructor Create(aView: PPyInterpreterView);
      destructor  Destroy; override;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      class function IsInitialized(const aView: IPyInterpreterView): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Helper function used to wrap a PyInterpreterView pointer with a
      /// TPyInterpreterView instance.</para>
      /// </summary>
      class function Wrap(aView: PPyInterpreterView): IPyInterpreterView; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Create a view to the current interpreter.</para>
      /// <para>This function is generally meant to be used alongside
      /// TPyInterpreterGuard.FromView() or
      /// TPyThreadState.EnsureFromView().</para>
      /// <para>On success, this function returns a view to the current
      /// interpreter; on failure, it returns NULL with an exception set.</para>
      /// <para>The caller must hold an attached thread state.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function FromCurrent(): IPyInterpreterView;
      /// <summary>
      /// <para>Create a view for the main interpreter (the first and default
      /// interpreter in a Python process;
      /// see TPyInterpreterState.Main()).</para>
      /// <para>On success, this function returns a view to the main
      /// interpreter; on failure, it returns NULL without an exception set.
      /// Failure indicates that the process is out of memory.</para>
      /// <para>Use this function when an interpreter pointer or view cannot be
      /// supplied by the caller, such as when a native threading library does
      /// not provide a void *arg parameter that could carry a
      /// PyInterpreterGuard or PyInterpreterView. In code that supports
      /// subinterpreters, prefer TPyInterpreterView.FromCurrent() so the guard
      /// tracks the calling interpreter rather than the main one.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function FromMain(): IPyInterpreterView;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean               read GetInitialized;
      /// <summary>
      /// <para>Pointer to PyInterpreterView</para>
      /// </summary>
      property View         : PPyInterpreterView    read GetView         write SetView;
  end;

implementation

constructor TPyInterpreterView.Create(aView: PPyInterpreterView);
begin
  inherited Create;

  View := aView;
end;

procedure TPyInterpreterView.Close;
begin
  if initialized and
     assigned(PyInterpreterView_Close) then
    begin
      PyInterpreterView_Close(FPyInterpreterView);
      FPyInterpreterView := nil;
    end;
end;

destructor TPyInterpreterView.Destroy;
begin
  Close;

  inherited Destroy;
end;

class function TPyInterpreterView.IsInitialized(const aView: IPyInterpreterView): boolean;
begin
  Result := (aView <> nil) and aView.Initialized;
end;

class function TPyInterpreterView.Wrap(aView: PPyInterpreterView): IPyInterpreterView;
begin
  if assigned(aView) then
    Result := TPyInterpreterView.Create(aView)
   else
    Result := nil;
end;

class function TPyInterpreterView.FromCurrent: IPyInterpreterView;
begin
  if assigned(PyInterpreterView_FromCurrent) then
    Result := TPyInterpreterView.Wrap(PyInterpreterView_FromCurrent())
   else
    Result := nil;
end;

class function TPyInterpreterView.FromMain: IPyInterpreterView;
begin
  if assigned(PyInterpreterView_FromMain) then
    Result := TPyInterpreterView.Wrap(PyInterpreterView_FromMain())
   else
    Result := nil;
end;

function TPyInterpreterView.GetInitialized: boolean;
begin
  Result := assigned(FPyInterpreterView);
end;

function TPyInterpreterView.GetView: PPyInterpreterView;
begin
  Result := FPyInterpreterView;
end;

procedure TPyInterpreterView.SetView(aValue: PPyInterpreterView);
begin
  FPyInterpreterView := aValue;
end;

end.
