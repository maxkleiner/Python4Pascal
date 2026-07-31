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
  /// <summary>
  /// <para>Helper class for all the PyRun_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/veryhigh.html#the-very-high-level-layer">See the article about The Very High Level Layer.</see></para>
  /// </remarks>
  TPyRun = class
    public
      /// <summary>
      /// <para>Executes the Python source code from command in the __main__
      /// module according to the flags argument. If __main__ does not already
      /// exist, it is created. Returns True on success or False if an exception
      /// was raised. If there was an error, there is no way to get the
      /// exception information. For the meaning of flags, see below.</para>
      /// <para>Note that if an otherwise unhandled SystemExit is raised, this
      /// function will not return False, but exit the process, as long as
      /// PyConfig.inspect is zero.</para>
      /// </summary>
      class function SimpleStringFlags(const command: string; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>If fp refers to a file associated with an interactive device
      /// (console or terminal input or Unix pseudo-terminal), return the value
      /// of TPyRun.InteractiveLoop(), otherwise return the result of
      /// TPyRun.SimpleFile(). filename is decoded from the filesystem encoding
      /// (sys.getfilesystemencoding()). If filename is nil, this function
      /// uses "???" as the filename. If closeit is true, the file is closed
      /// before TPyRun.SimpleFileExFlags() returns.</para>
      /// </summary>
      class function AnyFileExFlags(fp: PFILE; const filename: string; closeit: boolean; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>Similar to TPyRun.SimpleStringFlags(), but the Python source
      /// code is read from fp instead of an in-memory string. filename should
      /// be the name of the file, it is decoded from filesystem encoding and
      /// error handler. If closeit is true, the file is closed before
      /// TPyRun.SimpleFileExFlags() returns.</para>
      /// <para>Note: On Windows, fp should be opened as binary mode
      /// (e.g. fopen(filename, "rb")). Otherwise, Python may not handle script
      /// file with LF line ending correctly.</para>
      /// </summary>
      class function SimpleFileExFlags(fp: PFILE; const filename: string; closeit: boolean; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>Similar to TPyRun.InteractiveOneObject(), but filename is a
      /// string, which is decoded from the filesystem encoding and error
      /// handler.</para>
      /// </summary>
      class function InteractiveOneFlags(fp: PFILE; const filename: string; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>Read and execute a single statement from a file associated with
      /// an interactive device according to the flags argument. The user will
      /// be prompted using sys.ps1 and sys.ps2. filename must be a Python str
      /// object.</para>
      /// <para>Returns True when the input was executed successfully, False if
      /// there was an exception, or an error code from the errcode.h include
      /// file distributed as part of Python if there was a parse error.
      /// (Note that errcode.h is not included by Python.h, so must be included
      /// specifically if needed.)</para>
      /// </summary>
      class function InteractiveOneObject(fp: PFILE; const filename: IPyObject; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>Read and execute statements from a file associated with an
      /// interactive device until EOF is reached. The user will be prompted
      /// using sys.ps1 and sys.ps2. filename is decoded from the filesystem
      /// encoding and error handler. Returns 0 at EOF or a negative number upon
      /// failure.</para>
      /// </summary>
      class function InteractiveLoopFlags(fp: PFILE; const filename: string; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>Execute Python source code from str in the context specified by
      /// the objects globals and locals with the compiler flags specified by
      /// flags. globals must be a dictionary; locals can be any object that
      /// implements the mapping protocol. The parameter start specifies the
      /// start symbol and must be one of the available start symbols.</para>
      /// <para>Returns the result of executing the code as a Python object,
      /// or nil if an exception was raised.</para>
      /// </summary>
      class function StringFlags(const str: string; start: integer; const globals, locals: IPyObject; flags: PPyCompilerFlags): IPyObject;
      /// <summary>
      /// <para>Similar to TPyRun.StringFlags(), but the Python source code is
      /// read from fp instead of an in-memory string. filename should be the
      /// name of the file, it is decoded from the filesystem encoding and error
      /// handler. If closeit is true, the file is closed before
      /// TPyRun.FileExFlags() returns.</para>
      /// </summary>
      class function FileExFlags(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; closeit: boolean; flags: PPyCompilerFlags): IPyObject;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.StringFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function String_(const str: string; start: integer; const globals, locals: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.AnyFileExFlags(),
      /// leaving closeit set to False and flags set to nil.</para>
      /// </summary>
      class function AnyFile(fp: PFILE; const name_: string): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.AnyFileExFlags(),
      /// leaving the flags argument set to nil.</para>
      /// </summary>
      class function AnyFileEx(fp: PFILE; const name_: string; closeit: boolean): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.AnyFileExFlags(),
      /// leaving the closeit argument set to False.</para>
      /// </summary>
      class function AnyFileFlags(fp: PFILE; const name_: string; flags: PPyCompilerFlags): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.SimpleStringFlags(),
      /// leaving the PPyCompilerFlags argument set to nil.</para>
      /// </summary>
      class function SimpleString(const command: string): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.SimpleFileExFlags(),
      /// leaving closeit set to False and flags set to nil.</para>
      /// </summary>
      class function SimpleFile(fp: PFILE; const filename: string): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.SimpleFileExFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function SimpleFileEx(fp: PFILE; const filename: string; closeit: boolean): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.InteractiveOneFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function InteractiveOne(fp: PFILE; const filename: string): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.InteractiveLoopFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function InteractiveLoop(fp: PFILE; const filename: string): boolean;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.FileExFlags(),
      /// leaving closeit set to False and flags set to nil.</para>
      /// </summary>
      class function File_(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.FileExFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function FileEx(fp: PFILE; const filename: string; start: integer; const globals, locals: IPyObject; closeit: boolean): IPyObject;
      /// <summary>
      /// <para>This is a simplified interface to TPyRun.FileExFlags(),
      /// leaving closeit set to False.</para>
      /// </summary>
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
