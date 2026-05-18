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
      class function NewMethod(const type_: PyTypeObject; const meth: PyMethodDef): IPyObject;
      class function NewClassMethod(const type_: PyTypeObject; const meth: PyMethodDef): IPyObject;
      class function NewMember(const type_: PyTypeObject; const meth: PyMemberDef): IPyObject;
      class function NewGetSet(const type_: PyTypeObject; const getset: PyGetSetDef): IPyObject;
      class function NewWrapper(const type_: PyTypeObject; const wrapper: wrapperbase; wrapped: Pointer): IPyObject;
      class function IsData(const descr: IPyObject): boolean;
  end;

implementation

class function TPyDescr.NewMethod(const type_: PyTypeObject; const meth: PyMethodDef): IPyObject;
begin
  if assigned(PyDescr_NewMethod) then
    Result := TPyObject.Wrap(PyDescr_NewMethod(@type_, @meth))
   else
    Result := nil;
end;

class function TPyDescr.NewClassMethod(const type_: PyTypeObject; const meth: PyMethodDef): IPyObject;
begin
  if assigned(PyDescr_NewClassMethod) then
    Result := TPyObject.Wrap(PyDescr_NewClassMethod(@type_, @meth))
   else
    Result := nil;
end;

class function TPyDescr.NewMember(const type_: PyTypeObject; const meth: PyMemberDef): IPyObject;
begin
  if assigned(PyDescr_NewMember) then
    Result := TPyObject.Wrap(PyDescr_NewMember(@type_, @meth))
   else
    Result := nil;
end;

class function TPyDescr.NewGetSet(const type_: PyTypeObject; const getset: PyGetSetDef): IPyObject;
begin
  if assigned(PyDescr_NewGetSet) then
    Result := TPyObject.Wrap(PyDescr_NewGetSet(@type_, @getset))
   else
    Result := nil;
end;

class function TPyDescr.NewWrapper(const type_: PyTypeObject; const wrapper: wrapperbase; wrapped: Pointer): IPyObject;
begin
  if assigned(PyDescr_NewWrapper) then
    Result := TPyObject.Wrap(PyDescr_NewWrapper(@type_, @wrapper, wrapped))
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
