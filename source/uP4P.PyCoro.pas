unit uP4P.PyCoro;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyCoro_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/coro.html#coroutine-objects">See the article about the Coroutine Objects.</see></para>
  /// </remarks>
  TPyCoro = class
    public
      /// <summary>
      /// <para>Return true if aPyObject's type is PyCoro_Type; ob must not
      /// be nil. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create and return a new coroutine object based on the frame
      /// object, with __name__ and __qualname__ set to name and qualname.
      /// A reference to frame is stolen by this function. The frame argument
      /// must not be nil.</para>
      /// </summary>
      class function New(const frame, name_, qualname: IPyObject): IPyObject;
  end;

implementation

class function TPyCoro.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCoro_Type);
end;

class function TPyCoro.New(const frame, name_, qualname: IPyObject): IPyObject;
begin
  if assigned(PyCoro_New) and
     TPyObject.IsInitialized(frame) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(qualname) then
    Result := TPyObject.Wrap(PyCoro_New(PPyFrameObject(frame.Unwrap), name_.PyObject, qualname.PyObject))
   else
    Result := nil;
end;

end.
