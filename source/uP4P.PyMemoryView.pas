unit uP4P.PyMemoryView;

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
  TPyMemoryView = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function GetContiguous(const obj: IPyObject; buffertype: integer; order: TPyMemoryViewOrder): IPyObject;
      class function FromObject(const obj: IPyObject): IPyObject;
      class function FromMemory(mem: Pointer; size: Py_ssize_t; flags: integer): IPyObject;
      class function FromBuffer(const view: PPy_buffer): IPyObject;
  end;

implementation

class function TPyMemoryView.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyMemoryView_Type);
end;

class function TPyMemoryView.FromObject(const obj: IPyObject): IPyObject;
begin
  if assigned(PyMemoryView_FromObject) and TPyObject.IsInitialized(obj) then
    Result := TPyObject.Wrap(PyMemoryView_FromObject(obj.PyObject))
   else
    Result := nil;
end;

class function TPyMemoryView.FromMemory(mem: Pointer; size: Py_ssize_t; flags: integer): IPyObject;
begin
  if assigned(PyMemoryView_FromMemory) then
    Result := TPyObject.Wrap(PyMemoryView_FromMemory(mem, size, flags))
   else
    Result := nil;
end;

class function TPyMemoryView.FromBuffer(const view: PPy_buffer): IPyObject;
begin
  if assigned(PyMemoryView_FromBuffer) then
    Result := TPyObject.Wrap(PyMemoryView_FromBuffer(view))
   else
    Result := nil;
end;

class function TPyMemoryView.GetContiguous(const obj: IPyObject; buffertype: integer; order: TPyMemoryViewOrder): IPyObject;
var
  TempOrder : AnsiChar;
begin
  case order of
    pmvoFortran : TempOrder := 'F';
    else          TempOrder := 'C';   // pmvoC
  end;

  if assigned(PyMemoryView_GetContiguous) then
    Result := TPyObject.Wrap(PyMemoryView_GetContiguous(obj.PyObject, buffertype, TempOrder))
   else
    Result := nil;
end;

end.
