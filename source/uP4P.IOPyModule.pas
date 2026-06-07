unit uP4P.IOPyModule;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject, uP4P.CustomPyModule;

type
  TIOPyModule = class(TCustomPyModule)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.MiscFunctions;

function pyio_write(self, args: PPyObject): PPyObject; cdecl;
begin
  Result := nil;
end;

function pyio_read(self, args: PPyObject): PPyObject; cdecl;
begin
  Result := nil;
end;

function pyio_SetDelayWrites(self, args: PPyObject): PPyObject; cdecl;
begin
  Result := nil;
end;

function pyio_SetMaxLines(self, args: PPyObject): PPyObject; cdecl;
begin
  Result := nil;
end;

function pyio_GetTypesStats(self, args: PPyObject): PPyObject; cdecl;
begin
  Result := nil;
end;

procedure TIOPyModule.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('write', 'write(string) -> None', @pyio_write, METH_VARARGS);
  AddMethod('read', 'read() -> string', @pyio_read, METH_VARARGS);
  AddMethod('SetDelayWrites', 'SetDelayWrites(Boolean) -> None', @pyio_SetDelayWrites, METH_VARARGS);
  AddMethod('SetMaxLines', 'SetMaxLines(Integer) -> None', @pyio_SetMaxLines, METH_VARARGS);
  AddMethod('GetTypesStats', 'GetTypesStats( [type name] ) -> a list of tuple (TypeName, InstanceCount, CreateHits, DeleteHits)', @pyio_GetTypesStats, METH_VARARGS);
end;

end.
