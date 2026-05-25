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
      class function AddObjectRef(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;
      class function Add(const module_: IPyObject; const name_: string; const value: IPyObject): boolean; 
      class function AddObject(const module_: IPyObject; const name_: string; const value: IPyObject): boolean; 
      class function AddIntConstant(const module_: IPyObject; const name_: string; value: C_Long): boolean; 
      class function AddStringConstant(const module_: IPyObject; const name_, value: string): boolean; 
      class function AddType(const module_: IPyObject; type_: PPyTypeObject): boolean; 
      class function SetDocString(const module_: IPyObject; const docstring: string): boolean; 
      class function AddFunctions(const module_: IPyObject; functions: PPyMethodDef): boolean; 
      class function ExecDef(const module_: IPyObject; def: PPyModuleDef): boolean; 
      class function Create(def: PPyModuleDef): IPyObject; 
      class function Create2(def: PPyModuleDef; module_api_version: integer): IPyObject;                                      
      class function FromDefAndSpec(def: PPyModuleDef; const spec: IPyObject): IPyObject;       
      class function FromDefAndSpec2(def: PPyModuleDef; const spec: IPyObject; module_api_version: integer): IPyObject;       
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
    Result := TPyObject.Wrap(PyModule_GetDict(module_.PyObject), False)
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

class function TPyModule.AddObjectRef(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddObjectRef) and
     TPyObject.IsInitialized(module_) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_AddObjectRef(module_.PyObject, PAnsiChar(TempName), value.PyObject) = 0);
    end;
end;

class function TPyModule.Add(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;   
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_Add) and
     TPyObject.IsInitialized(module_) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_Add(module_.PyObject, PAnsiChar(TempName), value.UnWrap) = 0);
    end;
end;

class function TPyModule.AddObject(const module_: IPyObject; const name_: string; const value: IPyObject): boolean;     
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_Add) and
     TPyObject.IsInitialized(module_) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_Add(module_.PyObject, PAnsiChar(TempName), value.PyObject) = 0);

      if not(Result) then
        value.ObjRefOwner := False;  
    end;
end;

class function TPyModule.AddIntConstant(const module_: IPyObject; const name_: string; value: C_Long): boolean; 
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddIntConstant) and
     TPyObject.IsInitialized(module_) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyModule_AddIntConstant(module_.PyObject, PAnsiChar(TempName), value) = 0);
    end;
end;

class function TPyModule.AddStringConstant(const module_: IPyObject; const name_, value: string): boolean;    
var
  TempName, TempValue : AnsiString;
begin
  Result := False;

  if assigned(PyModule_AddStringConstant) and
     TPyObject.IsInitialized(module_) then
    begin
      TempName  := StringToPyUTF8(name_);
      TempValue := StringToPyUTF8(value);
      Result    := (PyModule_AddStringConstant(module_.PyObject, PAnsiChar(TempName), PAnsiChar(TempValue)) = 0);
    end;
end;

class function TPyModule.AddType(const module_: IPyObject; type_: PPyTypeObject): boolean;    
begin
  Result := assigned(PyModule_AddType) and
            TPyObject.IsInitialized(module_) and
            (PyModule_AddType(module_.PyObject, type_) = 0);
end;

class function TPyModule.SetDocString(const module_: IPyObject; const docstring: string): boolean;  
var
  TempDoc : AnsiString;
begin
  Result := False;

  if assigned(PyModule_SetDocString) and
     TPyObject.IsInitialized(module_) then
    begin
      TempDoc := StringToPyUTF8(docstring);
      Result  := (PyModule_SetDocString(module_.PyObject, PAnsiChar(TempDoc)) = 0);
    end;
end;

class function TPyModule.AddFunctions(const module_: IPyObject; functions: PPyMethodDef): boolean;     
begin
  Result := assigned(PyModule_AddFunctions) and
            TPyObject.IsInitialized(module_) and
            (PyModule_AddFunctions(module_.PyObject, functions) = 0);
end;

class function TPyModule.ExecDef(const module_: IPyObject; def: PPyModuleDef): boolean;  
begin
  Result := assigned(PyModule_ExecDef) and
            TPyObject.IsInitialized(module_) and
            (PyModule_ExecDef(module_.PyObject, def) = 0);
end;

class function TPyModule.Create(def: PPyModuleDef): IPyObject; 
begin
  Result := TPyModule.Create2(def, PYTHON_API_VERSION);
end;

class function TPyModule.Create2(def: PPyModuleDef; module_api_version: integer): IPyObject; 
begin
  if assigned(PyModule_Create2) then
    Result := TPyObject.Wrap(PyModule_Create2(def, module_api_version))
   else 
    Result := nil;
end;

class function TPyModule.FromDefAndSpec(def: PPyModuleDef; const spec: IPyObject): IPyObject;       
begin
  Result := TPyModule.FromDefAndSpec2(def, spec, PYTHON_API_VERSION); 
end;

class function TPyModule.FromDefAndSpec2(def: PPyModuleDef; const spec: IPyObject; module_api_version: integer): IPyObject; 
begin
  if assigned(PyModule_FromDefAndSpec2) and
     TPyObject.IsInitialized(spec) then
    Result := TPyObject.Wrap(PyModule_FromDefAndSpec2(def, spec.PyObject, module_api_version))
   else 
    Result := nil;
end;
 
end.
