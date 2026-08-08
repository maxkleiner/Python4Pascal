unit uP4P.PyCFunction;

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
  /// Helper class for all PyCFunction_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#common-object-structures">See the article about Common Object Structures.</see></para>
  /// </remarks>
  TPyCFunction = class
    public
      /// <summary>
      /// <para>Return true if op is an instance of the PyCFunction_Type type or
      /// a subtype of it. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>This is the same as TPyCFunction.Check(), but does not account
      /// for subtypes.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Get the function pointer on func as it was passed to
      /// ml_meth.</para>
      /// <para>If func is not a function object, this fails with an
      /// exception. func must not be nil.</para>
      /// <para>This function returns the function pointer on success, and nil
      /// with an exception set on failure.</para>
      /// </summary>
      class function GetFunction(const func: IPyObject): PyCFunction;
      /// <summary>
      /// <para>Get the "self" object on func. This is the object that would be
      /// passed to the first argument of a PyCFunction. For function objects
      /// created through a PyMethodDef on a PyModuleDef, this is the resulting
      /// module object.</para>
      /// <para>If func is not a function object, this fails with an exception.
      /// func must not be nil.</para>
      /// <para>This function returns a borrowed reference to the "self" object
      /// on success, and nil with an exception set on failure.</para>
      /// </summary>
      class function GetSelf(const func: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the function's flags on func as they were passed to
      /// ml_flags.</para>
      /// <para>If func is not a function object, this fails with an exception.
      /// func must not be nil.</para>
      /// <para>This function returns the function's flags on success, and -1
      /// with an exception set on failure.</para>
      /// </summary>
      class function GetFlags(const func: IPyObject): integer;
      /// <summary>
      /// <para>Equivalent to TPyCMethod.New(method, self_, nil, nil).</para>
      /// </summary>
      class function New(const method: PyMethodDef; const self_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Equivalent to TPyCMethod.New(method, self_, module, nil).</para>
      /// </summary>
      class function NewEx(const method: PyMethodDef; const self_, module: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCFunction.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyCFunction_Type);
end;

class function TPyCFunction.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCFunction_Type);
end;

class function TPyCFunction.GetFunction(const func: IPyObject): PyCFunction;
begin
  if assigned(PyCFunction_GetFunction) and
     TPyObject.IsInitialized(func) then
    Result := PyCFunction_GetFunction(func.PyObject)
   else
    Result := nil;
end;

class function TPyCFunction.GetSelf(const func: IPyObject): IPyObject;
begin
  if assigned(PyCFunction_GetSelf) and
     TPyObject.IsInitialized(func) then
    Result := TPyObject.Wrap(PyCFunction_GetSelf(func.PyObject))
   else
    Result := nil;
end;

class function TPyCFunction.GetFlags(const func: IPyObject): integer;
begin
  if assigned(PyCFunction_GetFlags) and
     TPyObject.IsInitialized(func) then
    Result := PyCFunction_GetFlags(func.PyObject)
   else
    Result := -1;
end;

class function TPyCFunction.New(const method: PyMethodDef; const self_: IPyObject): IPyObject;
begin
  if assigned(PyCFunction_New) and
     TPyObject.IsInitialized(self_) then
    Result := TPyObject.Wrap(PyCFunction_New(@method, self_.PyObject))
   else
    Result := nil;
end;

class function TPyCFunction.NewEx(const method: PyMethodDef; const self_, module: IPyObject): IPyObject;
begin
  if assigned(PyCFunction_NewEx) and
     TPyObject.IsInitialized(self_) and
     TPyObject.IsInitialized(module) then
    Result := TPyObject.Wrap(PyCFunction_NewEx(@method, self_.PyObject, module.PyObject))
   else
    Result := nil;
end;

end.
