unit uP4P.PyRun;

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
  TPyRun = class
    public
      class function SimpleStringFlags(const command: string; flags: PPyCompilerFlags): boolean;
      class function AnyFileExFlags(fp: PFILE; const filename: string; closeit: boolean; flags: PPyCompilerFlags): boolean;
      class function SimpleFileExFlags(fp: PFILE; const filename: string; closeit: boolean; flags: PPyCompilerFlags): boolean;
      class function InteractiveOneFlags(fp: PFILE; const filename: string; flags: PPyCompilerFlags): boolean;
      class function InteractiveOneObject(fp: PFILE; const filename: IPyObject; flags: PPyCompilerFlags): boolean;
      class function InteractiveLoopFlags(fp: PFILE; const filename: string; flags: PPyCompilerFlags): boolean;
      class function StringFlags(const str: string; start: integer; const globals, locals: IPyObject; flags: PPyCompilerFlags): IPyObject;
      class function FileExFlags(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; closeit: boolean; flags: PPyCompilerFlags): IPyObject;
      class function String_(const str: string; start: integer; const globals, locals: IPyObject): IPyObject;
      class function AnyFile(fp: PFILE; const name_: string): boolean;
      class function AnyFileEx(fp: PFILE; const name_: string; closeit: boolean): boolean;
      class function AnyFileFlags(fp: PFILE; const name_: string; flags: PPyCompilerFlags): boolean;
      class function SimpleString(const command: string): boolean;
      class function SimpleFile(fp: PFILE; const filename: string): boolean;
      class function SimpleFileEx(fp: PFILE; const filename: string; closeit: boolean): boolean;
      class function InteractiveOne(fp: PFILE; const filename: string): boolean;
      class function InteractiveLoop(fp: PFILE; const filename: string): boolean;
      class function File_(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject): IPyObject;
      class function FileEx(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; closeit: boolean): IPyObject;
      class function FileFlags(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; flags: PPyCompilerFlags): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyRun.SimpleStringFlags(const command: string; flags: PPyCompilerFlags): boolean;
var
  TempCommand : AnsiString;
begin
  Result := False;

  if assigned(PyRun_SimpleStringFlags) then
    begin
      TempCommand := StringToPyUTF8(command);
      Result      := (PyRun_SimpleStringFlags(PAnsiChar(TempCommand), flags) = 0);
    end;
end;

class function TPyRun.AnyFileExFlags(fp: PFILE; const filename: string; closeit: boolean; flags: PPyCompilerFlags): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_AnyFileExFlags) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_AnyFileExFlags(fp, PAnsiChar(TempFilename), ord(closeit), flags) = 0);
    end;
end;

class function TPyRun.SimpleFileExFlags(fp: PFILE; const filename: string; closeit: boolean; flags: PPyCompilerFlags): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_SimpleFileExFlags) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_SimpleFileExFlags(fp, PAnsiChar(TempFilename), ord(closeit), flags) = 0);
    end;
end;

class function TPyRun.InteractiveOneFlags(fp: PFILE; const filename: string; flags: PPyCompilerFlags): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_InteractiveOneFlags) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_InteractiveOneFlags(fp, PAnsiChar(TempFilename), flags) = 0);
    end;
end;

class function TPyRun.InteractiveOneObject(fp: PFILE; const filename: IPyObject; flags: PPyCompilerFlags): boolean;
begin
  Result := assigned(PyRun_InteractiveOneObject) and
            TPyObject.IsInitialized(filename) and
            (PyRun_InteractiveOneObject(fp, filename.PyObject, flags) = 0);
end;

class function TPyRun.InteractiveLoopFlags(fp: PFILE; const filename: string; flags: PPyCompilerFlags): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_InteractiveLoopFlags) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_InteractiveLoopFlags(fp, PAnsiChar(TempFilename), flags) = 0);
    end;
end;

class function TPyRun.StringFlags(const str: string; start: integer; const globals, locals: IPyObject; flags: PPyCompilerFlags): IPyObject;
var
  TempStr : AnsiString;
begin
  Result := nil;

  if assigned(PyRun_StringFlags) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := TPyObject.Wrap(PyRun_StringFlags(PAnsiChar(TempStr), start, globals.PyObject, locals.PyObject, flags));
    end;
end;

class function TPyRun.FileExFlags(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; closeit: boolean; flags: PPyCompilerFlags): IPyObject;
var
  TempFilename : AnsiString;
begin
  Result := nil;

  if assigned(PyRun_FileExFlags) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyRun_FileExFlags(fp, PAnsiChar(TempFilename), start, globals.PyObject, locals.PyObject, ord(closeit), flags));
    end;
end;

class function TPyRun.String_(const str: string; start: integer; const globals, locals: IPyObject): IPyObject;
var
  TempStr : AnsiString;
begin
  Result := nil;

  if assigned(PyRun_String) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := TPyObject.Wrap(PyRun_String(PAnsiChar(TempStr), start, globals.PyObject, locals.PyObject));
    end;
end;

class function TPyRun.AnyFile(fp: PFILE; const name_: string): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyRun_AnyFile) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyRun_AnyFile(fp, PAnsiChar(TempName)) = 0);
    end;
end;

class function TPyRun.AnyFileEx(fp: PFILE; const name_: string; closeit: boolean): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyRun_AnyFileEx) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyRun_AnyFileEx(fp, PAnsiChar(TempName), ord(closeit)) = 0);
    end;
end;

class function TPyRun.AnyFileFlags(fp: PFILE; const name_: string; flags: PPyCompilerFlags): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyRun_AnyFileFlags) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyRun_AnyFileFlags(fp, PAnsiChar(TempName), flags) = 0);
    end;
end;

class function TPyRun.SimpleString(const command: string): boolean;
var
  TempCommand : AnsiString;
begin
  Result := False;

  if assigned(PyRun_SimpleString) then
    begin
      TempCommand := StringToPyUTF8(command);
      Result      := (PyRun_SimpleString(PAnsiChar(TempCommand)) = 0);
    end;
end;

class function TPyRun.SimpleFile(fp: PFILE; const filename: string): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_SimpleFile) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_SimpleFile(fp, PAnsiChar(TempFilename)) = 0);
    end;
end;

class function TPyRun.SimpleFileEx(fp: PFILE; const filename: string; closeit: boolean): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_SimpleFileEx) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_SimpleFileEx(fp, PAnsiChar(TempFilename), ord(closeit)) = 0);
    end;
end;

class function TPyRun.InteractiveOne(fp: PFILE; const filename: string): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_InteractiveOne) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_InteractiveOne(fp, PAnsiChar(TempFilename)) = 0);
    end;
end;

class function TPyRun.InteractiveLoop(fp: PFILE; const filename: string): boolean;
var
  TempFilename : AnsiString;
begin
  Result := False;

  if assigned(PyRun_InteractiveLoop) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := (PyRun_InteractiveLoop(fp, PAnsiChar(TempFilename)) = 0);
    end;
end;

class function TPyRun.File_(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject): IPyObject;
var
  TempFilename : AnsiString;
begin
  Result := nil;

  if assigned(PyRun_File) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyRun_File(fp, PAnsiChar(TempFilename), start, globals.PyObject, locals.PyObject));
    end;
end;

class function TPyRun.FileEx(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; closeit: boolean): IPyObject;
var
  TempFilename : AnsiString;
begin
  Result := nil;

  if assigned(PyRun_FileEx) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyRun_FileEx(fp, PAnsiChar(TempFilename), start, globals.PyObject, locals.PyObject, ord(closeit)));
    end;
end;

class function TPyRun.FileFlags(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; flags: PPyCompilerFlags): IPyObject;
var
  TempFilename : AnsiString;
begin
  Result := nil;

  if assigned(PyRun_FileFlags) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyRun_FileFlags(fp, PAnsiChar(TempFilename), start, globals.PyObject, locals.PyObject, flags));
    end;
end;

end.
