unit uP4P.PyWeakref;

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
  TPyWeakref = class
    public
      class function CheckRef(const aPyObject: IPyObject): boolean;
      class function CheckRefExact(const aPyObject: IPyObject): boolean;
      class function CheckProxy(const aPyObject: IPyObject): boolean;
      class function Check(const aPyObject: IPyObject): boolean;
      class function NewRef(const ob, callback: IPyObject): IPyObject;
      class function NewProxy(const ob, callback: IPyObject): IPyObject;
      class function GetRef(const ref: IPyObject; var pobj: IPyObject): integer;
      class function IsDead(const ref: IPyObject): integer;
  end;

implementation

class function TPyWeakref.CheckRef(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(_PyWeakref_RefType);
end;

class function TPyWeakref.CheckRefExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            (aPyObject.IsType(_PyWeakref_ProxyType) or (aPyObject.IsType(_PyWeakref_CallableProxyType)));
end;

class function TPyWeakref.CheckProxy(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(_PyWeakref_RefType);
end;

class function TPyWeakref.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyWeakref.CheckRef(aPyObject) or
            TPyWeakref.CheckProxy(aPyObject);
end;

class function TPyWeakref.NewRef(const ob, callback: IPyObject): IPyObject;
var
  TempCallback : PPyObject;
begin
  Result := nil;

  if assigned(PyWeakref_NewRef) and
     TPyObject.IsInitialized(ob) then
    begin
      if TPyObject.IsInitialized(callback) then
        TempCallback := callback.PyObject
       else
        TempCallback := nil;

      Result := TPyObject.Wrap(PyWeakref_NewRef(ob.PyObject, TempCallback));
    end;
end;

class function TPyWeakref.NewProxy(const ob, callback: IPyObject): IPyObject;
var
  TempCallback : PPyObject;
begin
  Result := nil;

  if assigned(PyWeakref_NewProxy) and
     TPyObject.IsInitialized(ob) then
    begin
      if TPyObject.IsInitialized(callback) then
        TempCallback := callback.PyObject
       else
        TempCallback := nil;

      Result := TPyObject.Wrap(PyWeakref_NewProxy(ob.PyObject, TempCallback));
    end;
end;

class function TPyWeakref.GetRef(const ref: IPyObject; var pobj: IPyObject): integer;
var
  TempPObj : PPyObject;
begin
  Result := -1;
  pobj   := nil;

  if assigned(PyWeakref_GetRef) and
     TPyObject.IsInitialized(ref) then
    begin
      Result := PyWeakref_GetRef(ref.PyObject, TempPObj);

      if (Result = 1) then
        pobj := TPyObject.Wrap(TempPObj);
    end;
end;

class function TPyWeakref.IsDead(const ref: IPyObject): integer;
begin
  if assigned(PyWeakref_IsDead) and
     TPyObject.IsInitialized(ref) then
    Result := PyWeakref_IsDead(ref.PyObject)
   else
    Result := -1;
end;

end.
