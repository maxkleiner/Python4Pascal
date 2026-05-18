unit uP4P.PyPickleBuffer;

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
  TPyPickleBuffer = class
    public
      class function Check(const op: IPyObject): boolean;
      class function FromObject(const obj: IPyObject): IPyObject;
      class function GetBuffer(const picklebuf: IPyObject): PPy_buffer;
      class function Release(const picklebuf: IPyObject): boolean;
  end;

implementation

class function TPyPickleBuffer.Check(const op: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(op) and
            op.IsType(PyPickleBuffer_Type);
end;

class function TPyPickleBuffer.FromObject(const obj: IPyObject): IPyObject;
begin
  if assigned(PyPickleBuffer_FromObject) and
     TPyObject.IsInitialized(obj) then
    Result := TPyObject.Wrap(PyPickleBuffer_FromObject(obj.PyObject))
   else
    Result := nil;
end;

class function TPyPickleBuffer.GetBuffer(const picklebuf: IPyObject): PPy_buffer;
begin
  if assigned(PyPickleBuffer_GetBuffer) and
     TPyObject.IsInitialized(picklebuf) then
    Result := PyPickleBuffer_GetBuffer(picklebuf.PyObject)
   else
    Result := nil;
end;

class function TPyPickleBuffer.Release(const picklebuf: IPyObject): boolean;
begin
  Result := assigned(PyPickleBuffer_Release) and
            TPyObject.IsInitialized(picklebuf) and
            (PyPickleBuffer_Release(picklebuf.PyObject) = 0);
end;

end.
