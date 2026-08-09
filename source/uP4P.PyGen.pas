unit uP4P.PyGen;

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
  /// Helper class for all PyGen_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/gen.html#generator-objects">See the article about Generator Objects.</see></para>
  /// </remarks>
  TPyGen = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a generator object; aPyObject
      /// must not be nil. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject's type is PyGen_Type; aPyObject
      /// must not be nil. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create and return a new generator object based on the frame
      /// object. A reference to frame is "stolen" by this function
      /// (even on error). The argument must not be nil.</para>
      /// </summary>
      class function New(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create and return a new generator object based on the frame
      /// object, with __name__ and __qualname__ set to name and qualname.
      /// A reference to frame is "stolen" by this function (even on error).
      /// The frame argument must not be nil.</para>
      /// </summary>
      class function NewWithQualName(const frame, name_, qualname: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a new strong reference to the code object wrapped by gen.
      /// This function always succeeds.</para>
      /// </summary>
      class function GetCode(const gen: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyGen.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyGen_Type);
end;

class function TPyGen.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyGen_Type);
end;

class function TPyGen.New(const frame: IPyObject): IPyObject;
begin
  if assigned(PyGen_New) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyGen_New(PPyFrameObject(frame.Unwrap)))
   else
    Result := nil;
end;

class function TPyGen.NewWithQualName(const frame, name_, qualname: IPyObject): IPyObject;
begin
  if assigned(PyGen_NewWithQualName) and
     TPyObject.IsInitialized(frame) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(qualname) then
    Result := TPyObject.Wrap(PyGen_NewWithQualName(PPyFrameObject(frame.Unwrap), name_.PyObject, qualname.PyObject))
   else
    Result := nil;
end;

class function TPyGen.GetCode(const gen: IPyObject): IPyObject;
begin
  if assigned(PyGen_GetCode) and
     TPyObject.IsInitialized(gen) then
    Result := TPyObject.Wrap(PyGen_GetCode(PPyGenObject(gen.PyObject)))
   else
    Result := nil;
end;

end.
