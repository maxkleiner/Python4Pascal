unit uP4P.PyFile;

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
  TPyFile = class
    public
      class function FromFd(fd: integer; const mode: string; buffering: integer; const encoding, errors, newline: string; closefd: boolean): IPyObject;
      class function GetLine(const p: IPyObject; n: integer): IPyObject;
      class function WriteObject(const obj, p: IPyObject; flags: integer): boolean;
      class function WriteString(const s: string; const p: IPyObject): boolean;
      class function NewStdPrinter(fd: integer): IPyObject;
      class function OpenCode(const path: string): IPyObject;
      class function OpenCodeObject(const path: IPyObject): IPyObject;
      class function SetOpenCodeHook(handler: Py_OpenCodeHookFunction; userData: Pointer): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyFile.FromFd(fd: integer; const mode: string; buffering: integer; const encoding, errors, newline: string; closefd: boolean): IPyObject;
var
  TempMode, TempEncoding, TempErrors, TempNewline : AnsiString;
  TempModePtr, TempEncodingPtr, TempErrorsPtr, TempNewlinePtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyFile_FromFd) then
    begin
      if (length(mode) > 0) then
        begin
          TempMode    := StringToPyUTF8(mode);
          TempModePtr := PAnsiChar(TempMode);
        end
       else
        TempModePtr := nil;

      if (length(encoding) > 0) then
        begin
          TempEncoding    := StringToPyUTF8(encoding);
          TempEncodingPtr := PAnsiChar(TempEncoding);
        end
       else
        TempEncodingPtr := nil;

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      if (length(newline) > 0) then
        begin
          TempNewline    := StringToPyUTF8(newline);
          TempNewlinePtr := PAnsiChar(TempNewline);
        end
       else
        TempNewlinePtr := nil;

      // Changed in version 3.2: Ignore name attribute.
      Result := TPyObject.Wrap(PyFile_FromFd(fd, nil, TempModePtr, buffering, TempEncodingPtr, TempErrorsPtr, TempNewlinePtr, ord(closefd)));
    end;
end;

class function TPyFile.GetLine(const p: IPyObject; n: integer): IPyObject;
begin
  if assigned(PyFile_GetLine) and
     TPyObject.IsInitialized(p) then
    Result := TPyObject.Wrap(PyFile_GetLine(p.PyObject, n))
   else
    Result := nil;
end;

class function TPyFile.WriteObject(const obj, p: IPyObject; flags: integer): boolean;
begin
  Result := False;

  if assigned(PyFile_WriteObject) and
     TPyObject.IsInitialized(p) then
    begin
      if TPyObject.IsInitialized(obj) then
        Result := (PyFile_WriteObject(obj.PyObject, p.PyObject, flags) = 0)
       else
        Result := (PyFile_WriteObject(nil, p.PyObject, flags) = 0);
    end;
end;

class function TPyFile.WriteString(const s: string; const p: IPyObject): boolean;
var
  TempString : AnsiString;
begin
  Result := False;

  if assigned(PyFile_WriteString) and
     TPyObject.IsInitialized(p) then
    begin
      TempString := StringToPyUTF8(s);
      Result     := (PyFile_WriteString(PAnsiChar(TempString), p.PyObject) = 0);
    end;
end;

class function TPyFile.NewStdPrinter(fd: integer): IPyObject;
begin
  // Soft deprecated since version 3.15.
  if assigned(PyFile_NewStdPrinter) then
    Result := TPyObject.Wrap(PyFile_NewStdPrinter(fd))
   else
    Result := FromFd(fd, 'w', -1, '', '', '', False);
end;

class function TPyFile.OpenCode(const path: string): IPyObject;
var
  TempPath : AnsiString;
begin
  if assigned(PyFile_OpenCode) then
    begin
      TempPath := StringToPyUTF8(path);
      Result   := TPyObject.Wrap(PyFile_OpenCode(PAnsiChar(TempPath)));
    end
   else
    Result := nil;
end;

class function TPyFile.OpenCodeObject(const path: IPyObject): IPyObject;
begin
  if assigned(PyFile_OpenCodeObject) and
     TPyObject.IsInitialized(path) then
    Result := TPyObject.Wrap(PyFile_OpenCodeObject(path.PyObject))
   else
    Result := nil;
end;

class function TPyFile.SetOpenCodeHook(handler: Py_OpenCodeHookFunction; userData: Pointer): boolean;
begin
  Result := assigned(PyFile_SetOpenCodeHook) and
            (PyFile_SetOpenCodeHook(handler, userData) <> -1);
end;

end.
