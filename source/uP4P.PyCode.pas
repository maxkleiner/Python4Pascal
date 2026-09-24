unit uP4P.PyCode;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyCode_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/code.html#code-objects">See the article about Code Objects.</see></para>
  /// </remarks>
  TPyCode = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a code object.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new empty code object with the specified filename,
      /// function name, and first line number. The resulting code object
      /// will raise an Exception if executed.</para>
      /// </summary>
      class function NewEmpty(const filename, funcname: string; firstlineno: integer): IPyObject;
      /// <summary>
      /// <para>Register callback as a code object watcher for the current
      /// interpreter. Return an ID which may be passed to
      /// TPyCode.ClearWatcher(). In case of error (e.g. no more watcher IDs
      /// available), return -1 and set an exception.</para>
      /// </summary>
      class function AddWatcher(callback: PyCode_WatchCallback): integer;
      /// <summary>
      /// <para>Clear watcher identified by watcher_id previously returned from
      /// TPyCode.AddWatcher() for the current interpreter. Return True on
      /// success, or False and set an exception on error (e.g. if the given
      /// watcher_id was never registered.)</para>
      /// </summary>
      class function ClearWatcher(watcher_id: integer): boolean;
      /// <summary>
      /// <para>Return the line number of the instruction that occurs on or
      /// before byte_offset and ends after it. If you just need the line
      /// number of a frame, use TPyFrame.GetLineNumber() instead.</para>
      /// <para>For efficiently iterating over the line numbers in a code
      /// object, use the API described in PEP 626.</para>
      /// </summary>
      class function Addr2Line(const co: IPyObject; byte_offset: integer): integer;
      /// <summary>
      /// <para>Sets the passed int pointers to the source code line and column
      /// numbers for the instruction at byte_offset. Sets the value to 0 when
      /// information is not available for any particular element.</para>
      /// <para>Returns True if the function succeeds and False otherwise.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function Addr2Location(const co: IPyObject; byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): boolean;
      /// <summary>
      /// <para>Equivalent to the Python code getattr(co, 'co_code'). Returns a
      /// strong reference to a PyBytesObject representing the bytecode in a
      /// code object. On error, nil is returned and an exception is
      /// raised.</para>
      /// <para>This PyBytesObject may be created on-demand by the interpreter
      /// and does not necessarily represent the bytecode actually executed by
      /// CPython. The primary use case for this function is debuggers and
      /// profilers.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetCode(const co: IPyObject): IPyObject;
      /// <summary>
      /// <para>Equivalent to the Python code getattr(co, 'co_varnames').
      /// Returns a new reference to a PyTupleObject containing the names of
      /// the local variables. On error, nil is returned and an exception is
      /// raised.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetVarnames(const co: IPyObject): IPyObject;
      /// <summary>
      /// <para>Equivalent to the Python code getattr(co, 'co_cellvars').
      /// Returns a new reference to a PyTupleObject containing the names of
      /// the local variables that are referenced by nested functions.
      /// On error, nil is returned and an exception is raised.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetCellvars(const co: IPyObject): IPyObject;
      /// <summary>
      /// <para>Equivalent to the Python code getattr(co, 'co_freevars').
      /// Returns a new reference to a PyTupleObject containing the names of
      /// the free (closure) variables. On error, nil is returned and an
      /// exception is raised.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetFreevars(const co: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyCode.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCode_Type);
end;

class function TPyCode.NewEmpty(const filename, funcname: string; firstlineno: integer): IPyObject;
var
  TempFilename, TempFuncname : AnsiString;
begin
  if assigned(PyCode_NewEmpty) then
    begin
      TempFilename := StringToPyUTF8(filename);
      TempFuncname := StringToPyUTF8(funcname);
      Result       := TPyObject.Wrap(PyCode_NewEmpty(PAnsiChar(TempFilename), PAnsiChar(TempFuncname), firstlineno));
    end
   else
    Result := nil;
end;

class function TPyCode.AddWatcher(callback: PyCode_WatchCallback): integer;
begin
  if assigned(PyCode_AddWatcher) then
    Result := PyCode_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyCode.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyCode_ClearWatcher) and
            (PyCode_ClearWatcher(watcher_id) = 0);
end;

class function TPyCode.Addr2Line(const co: IPyObject; byte_offset: integer): integer;
begin
  if assigned(PyCode_Addr2Line) and
     TPyObject.IsInitialized(co) then
    Result := PyCode_Addr2Line(PPyCodeObject(co.PyObject), byte_offset)
   else
    Result := -1;
end;

class function TPyCode.Addr2Location(const co: IPyObject; byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): boolean;
begin
  Result := assigned(PyCode_Addr2Location) and
            TPyObject.IsInitialized(co) and
            (PyCode_Addr2Location(PPyCodeObject(co.PyObject), byte_offset, start_line, start_column, end_line, end_column) <> 0);
end;

class function TPyCode.GetCode(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetCode) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetCode(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

class function TPyCode.GetVarnames(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetVarnames) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetVarnames(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

class function TPyCode.GetCellvars(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetCellvars) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetCellvars(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

class function TPyCode.GetFreevars(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetFreevars) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetFreevars(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

end.
