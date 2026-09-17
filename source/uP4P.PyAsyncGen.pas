unit uP4P.PyAsyncGen;

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
  /// Helper class for all PyAsyncGen_* methods.
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/gen.html#asynchronous-generator-objects">See the article about Asynchronous Generator Objects.</see></para>
  /// </remarks>
  TPyAsyncGen = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is an asynchronous generator object,
      /// false otherwise. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create a new asynchronous generator wrapping frame, with
      /// __name__ and __qualname__ set to name and qualname. frame is "stolen"
      /// by this function (even on error) and must not be nil.</para>
      /// <para>On success, this function returns a strong reference to the new
      /// asynchronous generator. On failure, this function returns nil with
      /// an exception set.</para>
      /// </summary>
      class function New(const frame, name_, qualname: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType, uP4P.PyFrame, uP4P.PyCode;

class function TPyAsyncGen.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyAsyncGen_Type);
end;

class function TPyAsyncGen.New(const frame, name_, qualname: IPyObject): IPyObject;
begin
  if assigned(PyAsyncGen_New) and
     TPyObject.IsInitialized(frame) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(qualname) then
    Result := TPyObject.Wrap(PyAsyncGen_New(PPyFrameObject(frame.Unwrap), name_.PyObject, qualname.PyObject))
   else
    Result := nil;
end;

end.
