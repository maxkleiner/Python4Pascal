unit uP4P.PyDescr;

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
  TPyDescr = class
    public
      class function NewMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
      class function NewClassMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
      class function NewMember(type_: PPyTypeObject; meth: PPyMemberDef): IPyObject;
      class function NewGetSet(type_: PPyTypeObject; getset: PPyGetSetDef): IPyObject;
      class function NewWrapper(type_: PPyTypeObject; const wrapper: wrapperbase; wrapped: Pointer): IPyObject;
      class function IsData(const descr: IPyObject): boolean;
  end;

implementation

class function TPyDescr.NewMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
begin
  if assigned(PyDescr_NewMethod) then
    Result := TPyObject.Wrap(PyDescr_NewMethod(type_, meth))
   else
    Result := nil;
end;

class function TPyDescr.NewClassMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
begin
  if assigned(PyDescr_NewClassMethod) then
    Result := TPyObject.Wrap(PyDescr_NewClassMethod(type_, meth))
   else
    Result := nil;
end;

class function TPyDescr.NewMember(type_: PPyTypeObject; meth: PPyMemberDef): IPyObject;
begin
  if assigned(PyDescr_NewMember) then
    Result := TPyObject.Wrap(PyDescr_NewMember(type_, meth))
   else
    Result := nil;
end;

class function TPyDescr.NewGetSet(type_: PPyTypeObject; getset: PPyGetSetDef): IPyObject;
begin
  if assigned(PyDescr_NewGetSet) then
    Result := TPyObject.Wrap(PyDescr_NewGetSet(type_, getset))
   else
    Result := nil;
end;

class function TPyDescr.NewWrapper(type_: PPyTypeObject; const wrapper: wrapperbase; wrapped: Pointer): IPyObject;
begin
  if assigned(PyDescr_NewWrapper) then
    Result := TPyObject.Wrap(PyDescr_NewWrapper(type_, @wrapper, wrapped))
   else
    Result := nil;
end;

class function TPyDescr.IsData(const descr: IPyObject): boolean;
begin
  Result := assigned(PyDescr_IsData) and
            TPyObject.IsInitialized(descr) and
            (PyDescr_IsData(descr.PyObject) <> 0);
end;


end.
