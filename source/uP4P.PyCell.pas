unit uP4P.PyCell;

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
  TPyCell = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function New(const ob: IPyObject): IPyObject;
      class function Get(const cell: IPyObject): IPyObject;
      class function Set_(const cell, value: IPyObject): boolean;
  end;

implementation

class function TPyCell.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCell_Type);
end;

class function TPyCell.New(const ob: IPyObject): IPyObject;
begin
  if assigned(PyCell_New) and
     TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyCell_New(ob.PyObject))
   else
    Result := nil;
end;

class function TPyCell.Get(const cell: IPyObject): IPyObject;
begin
  if assigned(PyCell_Get) and
     TPyObject.IsInitialized(cell) then
    Result := TPyObject.Wrap(PyCell_Get(cell.PyObject))
   else
    Result := nil;
end;

class function TPyCell.Set_(const cell, value: IPyObject): boolean;
begin
  if assigned(PyCell_Set) and
     TPyObject.IsInitialized(cell) then
    begin
      if TPyObject.IsInitialized(value) then
        Result := (PyCell_Set(cell.PyObject, value.PyObject) = 0)
       else
        Result := (PyCell_Set(cell.PyObject, nil) = 0);
    end
   else
    Result := False;
end;

end.
