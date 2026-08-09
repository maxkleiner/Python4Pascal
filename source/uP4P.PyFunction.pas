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
  /// <summary>
  /// Helper class for all PyFunction_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/function.html#function-objects">See the article about Function Objects.</see></para>
  /// </remarks>
  TPyFunction = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a function object
      /// (has type PyFunction_Type). The parameter must not be nil.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new function object associated with the code object
      /// code. globals must be a dictionary with the global variables
      /// accessible to the function.</para>
      /// <para>The function's docstring and name are retrieved from the code
      /// object. __module__ is retrieved from globals. The argument defaults,
      /// annotations and closure are set to nil. __qualname__ is set to the
      /// same value as the code object's co_qualname field.</para>
      /// </summary>
      class function New(const code, globals: IPyObject): IPyObject;
      /// <summary>
      /// <para>As TPyFunction.New(), but also allows setting the function
      /// object's __qualname__ attribute. qualname should be a unicode object
      /// or nil; if nil, the __qualname__ attribute is set to the same value
      /// as the code object's co_qualname field.</para>
      /// </summary>
      class function NewWithQualName(const code, globals, qualname: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the code object associated with the function
      /// object op.</para>
      /// </summary>
      class function GetCode(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the globals dictionary associated with the function
      /// object op.</para>
      /// </summary>
      class function GetGlobals(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a borrowed reference to the __module__ attribute of the
      /// function object op. It can be nil.</para>
      /// <para>This is normally a string containing the module name, but can
      /// be set to any other object by Python code.</para>
      /// </summary>
      class function GetModule(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the argument default values of the function object op.
      /// This can be a tuple of arguments or nil.</para>
      /// </summary>
      class function GetDefaults(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the argument default values for the function object op.
      /// defaults must be Py_None or a tuple.</para>
      /// <para>Raises SystemError and returns False on failure.</para>
      /// </summary>
      class function SetDefaults(const op, defaults: IPyObject): boolean;
      /// <summary>
      /// <para>Set the vectorcall field of a given function object func.</para>
      /// <para>Warning: extensions using this API must preserve the behavior
      /// of the unaltered (default) vectorcall function!</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class procedure SetVectorcall(const func: PyFunctionObject; vectorcall: vectorcallfunc);
      /// <summary>
      /// <para>Return the keyword-only argument default values of the function
      /// object op. This can be a dictionary of arguments or nil.</para>
      /// </summary>
      class function GetKwDefaults(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the keyword-only argument default values of the function
      /// object op. defaults must be a dictionary of keyword-only arguments
      /// or Py_None.</para>
      /// <para>This function returns True on success, and returns False with an
      /// exception set on failure.</para>
      /// </summary>
      class function SetKwDefaults(const op, defaults: IPyObject): boolean;
      /// <summary>
      /// <para>Return the closure associated with the function object op.
      /// This can be nil or a tuple of cell objects.</para>
      /// </summary>
      class function GetClosure(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the closure associated with the function object op.
      /// closure must be Py_None or a tuple of cell objects.</para>
      /// <para>Raises SystemError and returns False on failure.</para>
      /// </summary>
      class function SetClosure(const op, closure: IPyObject): boolean;
      /// <summary>
      /// <para>Return the annotations of the function object op. This can be a
      /// mutable dictionary or nil.</para>
      /// </summary>
      class function GetAnnotations(const op: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the annotations for the function object op.
      /// annotations must be a dictionary or Py_None.</para>
      /// <para>Raises SystemError and returns False on failure.</para>
      /// </summary>
      class function SetAnnotations(const op, annotations: IPyObject): boolean;
      /// <summary>
      /// <para>Register callback as a function watcher for the current
      /// interpreter. Return an ID which may be passed to
      /// TPyFunction.ClearWatcher(). In case of error (e.g. no more watcher
      /// IDs available), return -1 and set an exception.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function AddWatcher(callback: PyFunction_WatchCallback): integer;
      /// <summary>
      /// <para>Clear watcher identified by watcher_id previously returned
      /// from TPyFunction.AddWatcher() for the current interpreter.
      /// Return True on success, or False and set an exception on error
      /// (e.g. if the given watcher_id was never registered.)</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
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
    Result := TPyObject.Wrap(PyFunction_GetCode(op.PyObject), False)
   else
    Result := nil;
end;

class function TPyFunction.GetGlobals(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetGlobals) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetGlobals(op.PyObject), False)
   else
    Result := nil;
end;

class function TPyFunction.GetModule(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetModule) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetModule(op.PyObject), False)
   else
    Result := nil;
end;

class function TPyFunction.GetDefaults(const op: IPyObject): IPyObject;
begin
  if assigned(PyFunction_GetDefaults) and
     TPyObject.IsInitialized(op) then
    Result := TPyObject.Wrap(PyFunction_GetDefaults(op.PyObject), False)
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
    Result := TPyObject.Wrap(PyFunction_GetKwDefaults(op.PyObject), False)
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
    Result := TPyObject.Wrap(PyFunction_GetClosure(op.PyObject), False)
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
    Result := TPyObject.Wrap(PyFunction_GetAnnotations(op.PyObject), False)
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
