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
      function  Write(args: PPyObject): PPyObject;
      function  Read(args: PPyObject): PPyObject;
      function  SetDelayWrites(args: PPyObject): PPyObject;
      function  SetMaxLines(args: PPyObject): PPyObject;
      function  GetTypesStats(args: PPyObject): PPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Engine;

function pyio_write(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule : TCustomPyModule;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.SearchModule(self, TempModule) then
    Result := TIOPyModule(TempModule).Write(args)
   else
    Result := nil;
end;

function pyio_read(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule : TCustomPyModule;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.SearchModule(self, TempModule) then
    Result := TIOPyModule(TempModule).Read(args)
   else
    Result := nil;
end;

function pyio_SetDelayWrites(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule : TCustomPyModule;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.SearchModule(self, TempModule) then
    Result := TIOPyModule(TempModule).SetDelayWrites(args)
   else
    Result := nil;
end;

function pyio_SetMaxLines(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule : TCustomPyModule;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.SearchModule(self, TempModule) then
    Result := TIOPyModule(TempModule).SetMaxLines(args)
   else
    Result := nil;
end;

function pyio_GetTypesStats(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule : TCustomPyModule;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.SearchModule(self, TempModule) then
    Result := TIOPyModule(TempModule).GetTypesStats(args)
   else
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

function TIOPyModule.Write(args: PPyObject): PPyObject;
begin
  Result := nil;
end;

function TIOPyModule.Read(args: PPyObject): PPyObject;
begin
  Result := nil;
end;

function TIOPyModule.SetDelayWrites(args: PPyObject): PPyObject;
begin
  Result := nil;
end;

function TIOPyModule.SetMaxLines(args: PPyObject): PPyObject;
begin
  Result := nil;
end;

function TIOPyModule.GetTypesStats(args: PPyObject): PPyObject;
begin
  Result := nil;
end;

end.
