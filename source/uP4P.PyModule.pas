unit uP4P.PyModule;

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
  TPyModule = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function NewObject(const name_: IPyObject): IPyObject;
      class function New(const name_: string): IPyObject;
      class function GetDict(const module_: IPyObject): IPyObject;
      class function GetNameObject(const module_: IPyObject): IPyObject;
      class function GetName(const module_: IPyObject): string;
      class function GetFilenameObject(const module_: IPyObject): IPyObject;
      class function GetDef(const module_: IPyObject): PPyModuleDef;
      class function GetState(const module_: IPyObject): Pointer;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyModule.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyModule_Type);
end;

class function TPyModule.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyModule_Type);
end;

class function TPyModule.NewObject(const name_: IPyObject): IPyObject;
begin
  if assigned(PyModule_NewObject) and
     TPyObject.IsInitialized(name_) then
    Result := TPyObject.Wrap(PyModule_NewObject(name_.PyObject))
   else
    Result := nil;
end;

class function TPyModule.New(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyModule_New) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyModule_New(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPyModule.GetDict(const module_: IPyObject): IPyObject;
begin
  if assigned(PyModule_GetDict) and
     TPyObject.IsInitialized(module_) then
    Result := TPyObject.Wrap(PyModule_GetDict(module_.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyModule.GetNameObject(const module_: IPyObject): IPyObject;
begin
  if assigned(PyModule_GetNameObject) and
     TPyObject.IsInitialized(module_) then
    Result := TPyObject.Wrap(PyModule_GetNameObject(module_.PyObject))
   else
    Result := nil;
end;

class function TPyModule.GetName(const module_: IPyObject): string;
begin
  if assigned(PyModule_GetName) and
     TPyObject.IsInitialized(module_) then
    Result := PyUTF8ToString(PyModule_GetName(module_.PyObject))
   else
    Result := '';
end;

class function TPyModule.GetFilenameObject(const module_: IPyObject): IPyObject;
begin
  if assigned(PyModule_GetFilenameObject) and
     TPyObject.IsInitialized(module_) then
    Result := TPyObject.Wrap(PyModule_GetFilenameObject(module_.PyObject))
   else
    Result := nil;
end;

class function TPyModule.GetDef(const module_: IPyObject): PPyModuleDef;
begin
  if assigned(PyModule_GetDef) and
     TPyObject.IsInitialized(module_) then
    Result := PyModule_GetDef(module_.PyObject)
   else
    Result := nil;
end;

class function TPyModule.GetState(const module_: IPyObject): Pointer;
begin
  if assigned(PyModule_GetState) and
     TPyObject.IsInitialized(module_) then
    Result := PyModule_GetState(module_.PyObject)
   else
    Result := nil;
end;

end.
