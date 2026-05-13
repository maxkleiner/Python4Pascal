unit uP4P.PyUnicodeTranslateError;

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
  TPyUnicodeTranslateError = class
    public
      class function GetObject(const exc: IPyObject): IPyObject;
      class function GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
      class function SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
      class function GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
      class function SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
      class function GetReason(const exc: IPyObject): IPyObject;
      class function SetReason(const exc: IPyObject; const reason: string): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyUnicodeTranslateError.GetObject(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeTranslateError_GetObject) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeTranslateError_GetObject(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeTranslateError.GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_GetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_GetStart(exc.PyObject, @start) = 0);
end;

class function TPyUnicodeTranslateError.SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_SetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_SetStart(exc.PyObject, start) = 0);
end;

class function TPyUnicodeTranslateError.GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_GetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_GetEnd(exc.PyObject, @end_) = 0);
end;

class function TPyUnicodeTranslateError.SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_SetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_SetEnd(exc.PyObject, end_) = 0);
end;

class function TPyUnicodeTranslateError.GetReason(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeTranslateError_GetReason) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeTranslateError_GetReason(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeTranslateError.SetReason(const exc: IPyObject; const reason: string): boolean;
var
  TempReason : AnsiString;
begin
  if assigned(PyUnicodeTranslateError_SetReason) and
     TPyObject.IsInitialized(exc) then
    begin
      TempReason := StringToPyUTF8(reason);
      Result     := (PyUnicodeTranslateError_SetReason(exc.PyObject, PAnsiChar(TempReason)) = 0);
    end
   else
    Result := False;
end;

end.
