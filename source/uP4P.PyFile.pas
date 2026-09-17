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
  /// <summary>
  /// Helper class for all PyFile_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/file.html#file-objects">See the article about File objects.</see></para>
  /// </remarks>
  TPyFile = class
    public
      /// <summary>
      /// <para>Create a Python file object from the file descriptor of an
      /// already opened file fd. The arguments name, encoding, errors and
      /// newline can be nil to use the defaults; buffering can be -1 to use
      /// the default. name is ignored and kept for backward compatibility.
      /// Return nil on failure. For a more comprehensive description of the
      /// arguments, please refer to the io.open() function documentation.</para>
      /// <para>Warning: Since Python streams have their own buffering layer,
      /// mixing them with OS-level file descriptors can produce various issues
      /// (such as unexpected ordering of data).</para>
      /// </summary>
      class function FromFd(fd: integer; const mode: string; buffering: integer; const encoding, errors, newline: string; closefd: boolean): IPyObject;
      /// <summary>
      /// <para>Equivalent to p.readline([n]), this function reads one line
      /// from the object p. p may be a file object or any object with a
      /// readline() method. If n is 0, exactly one line is read, regardless
      /// of the length of the line. If n is greater than 0, no more than
      /// n bytes will be read from the file; a partial line can be returned.
      /// In both cases, an empty string is returned if the end of the file is
      /// reached immediately. If n is less than 0, however, one line is read
      /// regardless of length, but EOFError is raised if the end of the file
      /// is reached immediately.</para>
      /// </summary>
      class function GetLine(const p: IPyObject; n: integer): IPyObject;
      /// <summary>
      /// <para>Write object obj to file object p. The only supported flag for
      /// flags is Py_PRINT_RAW; if given, the str() of the object is written
      /// instead of the repr().</para>
      /// <para>If obj is nil, write the string "<NULL>".</para>
      /// <para>Return True on success or False on failure; the appropriate
      /// exception will be set.</para>
      /// </summary>
      class function WriteObject(const obj, p: IPyObject; flags: integer): boolean;
      /// <summary>
      /// <para>Write string s to file object p. Return True on success or
      /// False on failure; the appropriate exception will be set.</para>
      /// </summary>
      class function WriteString(const s: string; const p: IPyObject): boolean;
      /// <summary>
      /// <para>Use TPyFile.FromFd() with defaults
      /// (fd, nil, 'w', -1, nil, nil, nil, 0) instead.</para>
      /// </summary>
      class function NewStdPrinter(fd: integer): IPyObject;
      /// <summary>
      /// <para>Similar to TPyFile.OpenCodeObject(), but path is a string.</para>
      /// </summary>
      class function OpenCode(const path: string): IPyObject;
      /// <summary>
      /// <para>Open path with the mode 'rb'. path must be a Python str object.
      /// The behavior of this function may be overridden by
      /// TPyFile.SetOpenCodeHook() to allow for some preprocessing of the
      /// text.</para>
      /// <para>This is analogous to io.open_code() in Python.</para>
      /// <para>On success, this function returns a strong reference to a
      /// Python file object. On failure, this function returns nil with an
      /// exception set.</para>
      /// </summary>
      class function OpenCodeObject(const path: IPyObject): IPyObject;
      /// <summary>
      /// <para>Overrides the normal behavior of io.open_code() to pass its
      /// parameter through the provided handler.</para>
      /// <para>The handler is a function of type:</para>
      /// <code>typedef PyObject *(*Py_OpenCodeHookFunction)(PyObject*, void*)</code>
      /// <para>Equivalent of PyObject *(*)(PyObject *path, void *userData),
      /// where path is guaranteed to be PyUnicodeObject.</para>
      /// <para>The userData pointer is passed into the hook function. Since
      /// hook functions may be called from different runtimes, this pointer
      /// should not refer directly to Python state.</para>
      /// <para>As this hook is intentionally used during import, avoid
      /// importing new modules during its execution unless they are known to
      /// be frozen or available in sys.modules.</para>
      /// <para>Once a hook has been set, it cannot be removed or replaced,
      /// and later calls to TPyFile.SetOpenCodeHook() will fail. On failure,
      /// the function returns False and sets an exception if the interpreter
      /// has been initialized.</para>
      /// <para>This function is safe to call before TPy.Initialize().</para>
      /// <para>Raises an auditing event setopencodehook with no
      /// arguments.</para>
      /// </summary>
      class function SetOpenCodeHook(handler: Py_OpenCodeHookFunction; userData: Pointer): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

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
