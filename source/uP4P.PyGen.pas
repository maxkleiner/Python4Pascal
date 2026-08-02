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
  TPyGen = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const frame: IPyObject): IPyObject;
      class function NewWithQualName(const frame, name_, qualname: IPyObject): IPyObject;
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
