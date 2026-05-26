unit uP4P.PyException;

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
  TPyException = class
    public
      class function  SetTraceback(const ex, tb: IPyObject): boolean;
      class function  GetTraceback(const ex: IPyObject): IPyObject;
      class function  GetCause(const ex: IPyObject): IPyObject;
      class procedure SetCause(const ex, cause: IPyObject);
      class function  GetContext(const ex: IPyObject): IPyObject;
      class procedure SetContext(const ex, ctx: IPyObject);
      class function  GetArgs(const ex: IPyObject): IPyObject;
      class procedure SetArgs(const ex, args: IPyObject);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyNone;

class function TPyException.SetTraceback(const ex, tb: IPyObject): boolean;
var
  TempNone : IPyObject;
begin
  Result := False;

  if assigned(PyException_SetTraceback) and
     TPyObject.IsInitialized(ex) then
    begin
      if TPyObject.IsInitialized(tb) then
        Result := (PyException_SetTraceback(ex.PyObject, tb.PyObject) <> 0)
       else
        begin
          TempNone := TPyNone.New;
          Result   := (PyException_SetTraceback(ex.PyObject, TempNone.PyObject) <> 0);
          TempNone := nil;
        end;
    end;
end;

class function TPyException.GetTraceback(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetTraceback) then
    Result := TPyObject.Wrap(PyException_GetTraceback(ex.PyObject))
   else
    Result := nil;
end;

class function TPyException.GetCause(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetCause) then
    Result := TPyObject.Wrap(PyException_GetCause(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetCause(const ex, cause: IPyObject);
begin
  if assigned(PyException_SetCause) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(cause) then
    PyException_SetCause(ex.PyObject, cause.Unwrap);
end;

class function TPyException.GetContext(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetContext) then
    Result := TPyObject.Wrap(PyException_GetContext(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetContext(const ex, ctx: IPyObject);
begin
  if assigned(PyException_SetContext) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(ctx) then
    PyException_SetContext(ex.PyObject, ctx.Unwrap);
end;

class function TPyException.GetArgs(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetArgs) then
    Result := TPyObject.Wrap(PyException_GetArgs(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetArgs(const ex, args: IPyObject);
begin
  if assigned(PyException_SetArgs) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(args) then
    PyException_SetArgs(ex.PyObject, args.PyObject);
end;

end.
