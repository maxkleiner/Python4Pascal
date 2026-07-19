unit uP4P.PyUnicodeDecodeError;

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
  TPyUnicodeDecodeError = class
    public
      class function Create(const encoding, object_: string; length, start, end_: Py_ssize_t; const reason: string): IPyObject;
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

class function TPyUnicodeDecodeError.Create(const encoding, object_: string; length, start, end_: Py_ssize_t; const reason: string): IPyObject;
var
  TempEncoding, TempObject, TempReason: AnsiString;
begin
  if assigned(PyUnicodeDecodeError_Create) then
    begin
      TempEncoding := StringToPyUTF8(encoding);
      TempObject   := StringToPyUTF8(object_);
      TempReason   := StringToPyUTF8(reason);

      Result := TPyObject.Wrap(PyUnicodeDecodeError_Create(PAnsiChar(TempEncoding), PAnsiChar(TempObject), length, start, end_, PAnsiChar(TempReason)));
    end
   else
    Result := nil;
end;

class function TPyUnicodeDecodeError.GetEncoding(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeDecodeError_GetEncoding) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeDecodeError_GetEncoding(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeDecodeError.GetObject(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeDecodeError_GetObject) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeDecodeError_GetObject(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeDecodeError.GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeDecodeError_GetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeDecodeError_GetStart(exc.PyObject, @start) = 0);
end;

class function TPyUnicodeDecodeError.SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeDecodeError_SetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeDecodeError_SetStart(exc.PyObject, start) = 0);
end;

class function TPyUnicodeDecodeError.GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeDecodeError_GetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeDecodeError_GetEnd(exc.PyObject, @end_) = 0);
end;

class function TPyUnicodeDecodeError.SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeDecodeError_SetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeDecodeError_SetEnd(exc.PyObject, end_) = 0);
end;

class function TPyUnicodeDecodeError.GetReason(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeDecodeError_GetReason) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeDecodeError_GetReason(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeDecodeError.SetReason(const exc: IPyObject; const reason: string): boolean;
var
  TempReason : AnsiString;
begin
  if assigned(PyUnicodeDecodeError_SetReason) and
     TPyObject.IsInitialized(exc) then
    begin
      TempReason := StringToPyUTF8(reason);
      Result     := (PyUnicodeDecodeError_SetReason(exc.PyObject, PAnsiChar(TempReason)) = 0);
    end
   else
    Result := False;
end;

end.
