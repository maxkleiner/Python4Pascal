unit uP4P.PyContextVar;

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
  /// Helper class for all PyContextVar_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/contextvars.html#context-variables-objects">See the article about the Context Variables Objects.</see></para>
  /// </remarks>
  TPyContextVar = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is of type PyContextVar_Type.
      /// aPyObject must not be nil. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create a new ContextVar object. The name parameter is used for
      /// introspection and debug purposes. The def parameter specifies a
      /// default value for the context variable, or nil for no default.
      /// If an error has occurred, this function returns nil.</para>
      /// </summary>
      class function New(const name_: string; const def: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the value of a context variable. Returns False if an error
      /// has occurred during lookup, and True if no error occurred, whether or
      /// not a value was found.</para>
      /// <para>If the context variable was found, value will be a pointer to it.
      /// If the context variable was not found, value will point to:</para>
      /// <code>
      /// - default_value, if not nil;
      /// - the default value of var, if not nil;
      /// - nil
      /// </code>
      /// <para>Except for nil, the function returns a new reference.</para>
      /// </summary>
      class function Get(const var_, default_value: IPyObject; out value: IPyObject): boolean;
      /// <summary>
      /// <para>Set the value of var to value in the current context.
      /// Returns a new token object for this change, or nil if an error has
      /// occurred.</para>
      /// </summary>
      class function Set_(const var_, value: IPyObject): IPyObject;
      /// <summary>
      /// <para>Reset the state of the var context variable to that it was in
      /// before TPyContextVar.Set_() that returned the token was called.
      /// This function returns True on success and False on error.</para>
      /// </summary>
      class function Reset(const var_, token: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyContextVar.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyContextVar_Type);
end;

class function TPyContextVar.New(const name_: string; const def: IPyObject): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyContextVar_New) then
    begin
      TempName := StringToPyUTF8(name_);

      if TPyObject.IsInitialized(def) then
        Result := TPyObject.Wrap(PyContextVar_New(PAnsiChar(TempName), def.PyObject))
       else
        Result := TPyObject.Wrap(PyContextVar_New(PAnsiChar(TempName), nil));
    end
   else
    Result := nil;
end;

class function TPyContextVar.Get(const var_, default_value: IPyObject; out value: IPyObject): boolean;
var
  TempDef, TempValue: PPyObject;
begin
  Result := False;
  value  := nil;

  if assigned(PyContextVar_Get) and
     TPyObject.IsInitialized(var_) then
    begin
      if TPyObject.IsInitialized(default_value) then
        TempDef := default_value.PyObject
       else
        TempDef := nil;

      if (PyContextVar_Get(var_.PyObject, TempDef, TempValue) = 0) then
        begin
          value  := TPyObject.Wrap(TempValue);
          Result := True;
        end;
    end;
end;

class function TPyContextVar.Set_(const var_, value: IPyObject): IPyObject;
var
  TempValue : PPyObject;
begin
  if assigned(PyContextVar_Set) and
     TPyObject.IsInitialized(var_) then
    begin
      if TPyObject.IsInitialized(value) then
        TempValue := value.PyObject
       else
        TempValue := nil;

      Result := TPyObject.Wrap(PyContextVar_Set(var_.PyObject, TempValue));
    end
   else
    Result := nil;
end;

class function TPyContextVar.Reset(const var_, token: IPyObject): boolean;
begin
  Result := assigned(PyContextVar_Reset) and
            TPyObject.IsInitialized(var_) and
            TPyObject.IsInitialized(token) and
            (PyContextVar_Reset(var_.PyObject, token.PyObject) = 0);
end;

end.
