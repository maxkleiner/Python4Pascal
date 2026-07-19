unit uP4P.PyVectorcall;

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
  TPyVectorcall = class
    public
      class function NARGS(nargsf: NativeUInt): Py_ssize_t;
      class function Call(const callable, tuple, dict: IPyObject): IPyObject;
      class function Function_(const callable: IPyObject): vectorcallfunc;
  end;

implementation

class function TPyVectorcall.NARGS(nargsf: NativeUInt): Py_ssize_t;
begin
  if assigned(PyVectorcall_NARGS) then
    Result := PyVectorcall_NARGS(nargsf)
   else
    Result := 0;
end;

class function TPyVectorcall.Call(const callable, tuple, dict: IPyObject): IPyObject;
begin
  if assigned(PyVectorcall_Call) and
     TPyObject.IsInitialized(callable) and
     TPyObject.IsInitialized(tuple) then
    begin
      if TPyObject.IsInitialized(dict) then
        Result := TPyObject.Wrap(PyVectorcall_Call(callable.PyObject, tuple.PyObject, dict.PyObject))
       else
        Result := TPyObject.Wrap(PyVectorcall_Call(callable.PyObject, tuple.PyObject, nil));
    end
   else
    Result := nil;
end;

class function TPyVectorcall.Function_(const callable: IPyObject): vectorcallfunc;
begin
  if assigned(PyVectorcall_Function) and
     TPyObject.IsInitialized(callable) then
    Result := PyVectorcall_Function(callable.PyObject)
   else
    Result := nil;
end;

end.
