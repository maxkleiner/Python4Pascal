unit uP4P.PyContext;

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
  TPyContext = class
    public
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(): IPyObject;
      class function Copy(const ctx: IPyObject): IPyObject;
      class function CopyCurrent(): IPyObject;
      class function Enter(const ctx: IPyObject): boolean;
      class function Exit(const ctx: IPyObject): boolean;
      class function AddWatcher(callback: PyContext_WatchCallback): integer;
      class function ClearWatcher(watcher_id: integer): boolean;
  end;

implementation

class function TPyContext.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyContext_Type);
end;

class function TPyContext.New(): IPyObject;
begin
  if assigned(PyContext_New) then
    Result := TPyObject.Wrap(PyContext_New())
   else
    Result := nil;
end;

class function TPyContext.Copy(const ctx: IPyObject): IPyObject;
begin
  if assigned(PyContext_Copy) and
     TPyObject.IsInitialized(ctx) then
    Result := TPyObject.Wrap(PyContext_Copy(ctx.PyObject))
   else
    Result := nil;
end;

class function TPyContext.CopyCurrent(): IPyObject;
begin
  if assigned(PyContext_CopyCurrent) then
    Result := TPyObject.Wrap(PyContext_CopyCurrent())
   else
    Result := nil;
end;

class function TPyContext.Enter(const ctx: IPyObject): boolean;
begin
  Result := assigned(PyContext_Enter) and
            TPyObject.IsInitialized(ctx) and
            (PyContext_Enter(ctx.PyObject) = 0);
end;

class function TPyContext.Exit(const ctx: IPyObject): boolean;
begin
  Result := assigned(PyContext_Exit) and
            TPyObject.IsInitialized(ctx) and
            (PyContext_Exit(ctx.PyObject) = 0);
end;

class function TPyContext.AddWatcher(callback: PyContext_WatchCallback): integer;
begin
  if assigned(PyContext_AddWatcher) then
    Result := PyContext_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyContext.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyContext_ClearWatcher) and
            (PyContext_ClearWatcher(watcher_id) = 0);
end;

end.
