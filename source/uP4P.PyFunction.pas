unit uP4P.PyFunction;

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
  TPyFunction = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function New(const code, globals: IPyObject): IPyObject;
      class function NewWithQualName(const code, globals, qualname: IPyObject): IPyObject;
      class function GetCode(const op: IPyObject): IPyObject;
      class function GetGlobals(const op: IPyObject): IPyObject;
      class function GetModule(const op: IPyObject): IPyObject;
      class function GetDefaults(const op: IPyObject): IPyObject;
      class function SetDefaults(const op, defaults: IPyObject): boolean;
      class procedure SetVectorcall(const func: PyFunctionObject; vectorcall: vectorcallfunc);
      class function GetKwDefaults(const op: IPyObject): IPyObject;
      class function SetKwDefaults(const op, defaults: IPyObject): boolean;
      class function GetClosure(const op: IPyObject): IPyObject;
      class function SetClosure(const op, closure: IPyObject): boolean;
      class function GetAnnotations(const op: IPyObject): IPyObject;
      class function SetAnnotations(const op, annotations: IPyObject): boolean;
      class function AddWatcher(callback: PyFunction_WatchCallback): integer;
      class function ClearWatcher(watcher_id: integer): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyNone;

class function TPyFunction.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFunction_Type);
end;

class function TPyFunction.New(const code, globals: IPyObject): IPyObject;
begin
  if assigned(PyFunction_New) and
     TPyObject.IsInitialized(code) and
     TPyObject.IsInitialized(globals) then
    Result := TPyObject.Wrap(PyFunction_New(code.PyObject, globals.PyObject))
   else
    Result := nil;
end;

class function TPyFunction.NewWithQualName(const code, globals, qualname: IPyObject): IPyObject;
begin
  if assigned(PyFunction_NewWithQualName) and
     TPyObject.IsInitialized(code) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(qualname) then
    Result := TPyObject.Wrap(PyFunction_NewWithQualName(code.PyObject, globals.PyObject, qualname.PyObject))
   else
    Result := nil;
end;

class function TPyFunction.GetCode(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetCode) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetCode(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.GetGlobals(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetGlobals) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetGlobals(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.GetModule(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetModule) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetModule(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.GetDefaults(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetDefaults) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetDefaults(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.SetDefaults(const op, defaults: IPyObject): boolean;
var
  TempNone : IPyObject;
begin
  Result := False;

  if assigned(PyFunction_SetDefaults) and
     TPyObject.IsInitialized(op) then
    begin
      if TPyObject.IsInitialized(defaults) then
        Result := (PyFunction_SetDefaults(op.PyObject, defaults.PyObject) <> -1)
       else
        begin
          TempNone := TPyNone.New;
          Result   := (PyFunction_SetDefaults(op.PyObject, TempNone.PyObject) <> -1);
          TempNone := nil;
        end;
    end;
end;

class procedure TPyFunction.SetVectorcall(const func: PyFunctionObject; vectorcall: vectorcallfunc);
begin
  if assigned(PyFunction_SetVectorcall) then
    PyFunction_SetVectorcall(@func, vectorcall);
end;

class function TPyFunction.GetKwDefaults(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetKwDefaults) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetKwDefaults(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.SetKwDefaults(const op, defaults: IPyObject): boolean;
var
  TempNone : IPyObject;
begin
  Result := False;

  if assigned(PyFunction_SetKwDefaults) and
     TPyObject.IsInitialized(op) then
    begin
      if TPyObject.IsInitialized(defaults) then
        Result := (PyFunction_SetKwDefaults(op.PyObject, defaults.PyObject) = 0)
       else
        begin
          TempNone := TPyNone.New;
          Result   := (PyFunction_SetKwDefaults(op.PyObject, TempNone.PyObject) = 0);
          TempNone := nil;
        end;
    end;
end;

class function TPyFunction.GetClosure(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetClosure) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetClosure(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.SetClosure(const op, closure: IPyObject): boolean;
var
  TempNone : IPyObject;
begin
  Result := False;

  if assigned(PyFunction_SetClosure) and
     TPyObject.IsInitialized(op) then
    begin
      if TPyObject.IsInitialized(closure) then
        Result := (PyFunction_SetClosure(op.PyObject, closure.PyObject) <> -1)
       else
        begin
          TempNone := TPyNone.New;
          Result   := (PyFunction_SetClosure(op.PyObject, TempNone.PyObject) <> -1);
          TempNone := nil;
        end;
    end;
end;

class function TPyFunction.GetAnnotations(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetAnnotations) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetAnnotations(op.PyObject), False, False)
   else
    Result := nil;
end;

class function TPyFunction.SetAnnotations(const op, annotations: IPyObject): boolean;
var
  TempNone : IPyObject;
begin
  Result := False;

  if assigned(PyFunction_SetAnnotations) and
     TPyObject.IsInitialized(op) then
    begin
      if TPyObject.IsInitialized(annotations) then
        Result := (PyFunction_SetAnnotations(op.PyObject, annotations.PyObject) <> -1)
       else
        begin
          TempNone := TPyNone.New;
          Result   := (PyFunction_SetAnnotations(op.PyObject, TempNone.PyObject) <> -1);
          TempNone := nil;
        end;
    end;
end;

class function TPyFunction.AddWatcher(callback: PyFunction_WatchCallback): integer;
begin
  if assigned(PyFunction_AddWatcher) then
    Result := PyFunction_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyFunction.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyFunction_ClearWatcher) and
            (PyFunction_ClearWatcher(watcher_id) = 0);
end;

end.
