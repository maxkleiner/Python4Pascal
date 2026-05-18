unit uP4P.PyStructSequence;

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
  TPyStructSequence = class
    public
      class procedure InitType(type_: PPyTypeObject; desc: PPyStructSequence_Desc);
      class function InitType2(type_: PPyTypeObject; desc: PPyStructSequence_Desc): boolean;
      class function NewType(desc: PPyStructSequence_Desc): PPyTypeObject;
      class function New(type_: PPyTypeObject): IPyObject;
      class procedure SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject);
      class function GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
  end;

implementation

class procedure TPyStructSequence.InitType(type_: PPyTypeObject; desc: PPyStructSequence_Desc);
begin
  if assigned(PyStructSequence_InitType) then
    PyStructSequence_InitType(type_, desc);
end;

class function TPyStructSequence.InitType2(type_: PPyTypeObject; desc: PPyStructSequence_Desc): boolean;
begin
  Result := assigned(PyStructSequence_InitType2) and
            (PyStructSequence_InitType2(type_, desc) = 0);
end;

class function TPyStructSequence.NewType(desc: PPyStructSequence_Desc): PPyTypeObject;
begin
  if assigned(PyStructSequence_NewType) then
    Result := PyStructSequence_NewType(desc)
   else
    Result := nil;
end;

class function TPyStructSequence.New(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyStructSequence_New) then
    Result := TPyObject.Wrap(PyStructSequence_New(type_))
   else
    Result := nil;
end;

class procedure TPyStructSequence.SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject);
begin
  if assigned(PyStructSequence_SetItem) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(o) then
    PyStructSequence_SetItem(p.PyObject, pos, o.Unwrap);
end;

class function TPyStructSequence.GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
begin
  if assigned(PyStructSequence_GetItem) and
     TPyObject.IsInitialized(p) then
    TPyObject.Wrap(PyStructSequence_GetItem(p.PyObject, pos), False);
end;

end.
