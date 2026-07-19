unit uP4P.PyUnicodeEncodeError;

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
  TPyUnicodeEncodeError = class
    public
      class function GetEncoding(const exc: IPyObject): IPyObject;
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

class function TPyUnicodeEncodeError.GetEncoding(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeEncodeError_GetEncoding) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeEncodeError_GetEncoding(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeEncodeError.GetObject(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeEncodeError_GetObject) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeEncodeError_GetObject(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeEncodeError.GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_GetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_GetStart(exc.PyObject, @start) = 0);
end;

class function TPyUnicodeEncodeError.SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_SetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_SetStart(exc.PyObject, start) = 0);
end;

class function TPyUnicodeEncodeError.GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_GetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_GetEnd(exc.PyObject, @end_) = 0);
end;

class function TPyUnicodeEncodeError.SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_SetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_SetEnd(exc.PyObject, end_) = 0);
end;

class function TPyUnicodeEncodeError.GetReason(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeEncodeError_GetReason) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeEncodeError_GetReason(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeEncodeError.SetReason(const exc: IPyObject; const reason: string): boolean;
var
  TempReason : AnsiString;
begin
  if assigned(PyUnicodeEncodeError_SetReason) and
     TPyObject.IsInitialized(exc) then
    begin
      TempReason := StringToPyUTF8(reason);
      Result     := (PyUnicodeEncodeError_SetReason(exc.PyObject, PAnsiChar(TempReason)) = 0);
    end
   else
    Result := False;
end;

end.
