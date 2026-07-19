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
  TPyContextVar = class
    public
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const name_: string; const def: IPyObject): IPyObject;
      class function Get(const var_, default_value: IPyObject; out value: IPyObject): boolean;
      class function Set_(const var_, value: IPyObject): IPyObject;
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
