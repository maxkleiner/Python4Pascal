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
  uP4P.LibFunctions, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyCell_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/cell.html#cell-objects">See the article about Cell Objects.</see></para>
  /// </remarks>
  TPyCell = class
    public
      /// <summary>
      /// <para>Return true if ob is a cell object; ob must not be nil.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create and return a new cell object containing the value ob.
      /// The parameter may be nil.</para>
      /// </summary>
      class function New(const ob: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the contents of the cell cell, which can be nil.
      /// If cell is not a cell object, returns nil with an exception set.</para>
      /// </summary>
      class function Get(const cell: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the contents of the cell object cell to value.
      /// This releases the reference to any current content of the cell.
      /// value may be nil. cell must be non-nil.</para>
      /// <para>On success, return True. If cell is not a cell object, set an
      /// exception and return False.</para>
      /// </summary>
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
  if assigned(PyCell_New) then
    begin
      if TPyObject.IsInitialized(ob) then
        Result := TPyObject.Wrap(PyCell_New(ob.PyObject))
       else
        Result := TPyObject.Wrap(PyCell_New(nil));
    end
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
