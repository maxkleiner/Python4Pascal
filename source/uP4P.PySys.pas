unit uP4P.PySys;

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
  /// Helper class for all PySys_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/sys.html#system-functions">See the article about System Functions.</see></para>
  /// </remarks>
  TPySys = class
    public
      /// <summary>
      /// <para>Get the attribute name of the sys module. Return a strong
      /// reference. Raise RuntimeError and return nil if it does not exist
      /// or if the sys module cannot be found.</para>
      /// <para>If the non-existing object should not be treated as a failure,
      /// you can use TPySys.GetOptionalAttr() instead.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetAttr(const name_: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is the same as TPySys.GetAttr(), but name is specified as
      /// a string, rather than a IPyObject.</para>
      /// <para>If the non-existing object should not be treated as a failure,
      /// you can use TPySys.GetOptionalAttrString() instead.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetAttrString(const name_: string): IPyObject;
      /// <summary>
      /// <para>Variant of TPySys.GetAttr() which doesn't raise exception if
      /// the object does not exist.</para>
      /// <code>
      /// - Set result_ to a new strong reference to the object and return
      ///   1 if the object exists.
      /// - Set result_ to nil and return 0 without setting an
      ///   exception if the object does not exist.
      /// - Set an exception, set result_ to nil, and return -1, if an
      ///   error occurred.
      /// </code>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetOptionalAttr(const name_: IPyObject; var result_: IPyObject): integer;
      /// <summary>
      /// <para>This is the same as TPySys.GetOptionalAttr(), but name is
      /// specified as a string, rather than a IPyObject.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetOptionalAttrString(const name_: string; var result_: IPyObject): integer;
      /// <summary>
      /// <para>Similar to TPySys.GetAttrString(), but return a borrowed
      /// reference and return nil without setting exception on failure.</para>
      /// <para>Preserves exception that was set before the call.</para>
      /// </summary>
      class function GetObject(const name_: string): IPyObject;
      /// <summary>
      /// <para>Set name_ in the sys module to v unless v is nil, in which case
      /// name_ is deleted from the sys module. Returns True on success, False
      /// on error.</para>
      /// </summary>
      class function SetObject(const name_: string; const v: IPyObject): boolean;
      /// <summary>
      /// <para>Return the current dictionary of -X options, similarly to
      /// sys._xoptions. On error, nil is returned and an exception is
      /// set.</para>
      /// </summary>
      class function GetXOptions: IPyObject;
      /// <summary>
      /// <para>Similar to TPySys.Audit(), but pass arguments as a Python
      /// object. args must be a tuple. To pass no arguments, args can be
      /// nil.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function AuditTuple(const event: string; const args: IPyObject): boolean;
      /// <summary>
      /// <para>Append the callable hook to the list of active auditing hooks.
      /// Return True on success and False on failure. If the runtime has been
      /// initialized, also set an error on failure. Hooks added through this
      /// API are called for all interpreters created by the runtime.</para>
      /// <para>The userData pointer is passed into the hook function. Since
      /// hook functions may be called from different runtimes, this pointer
      /// should not refer directly to Python state.</para>
      /// <para>This function is safe to call before TPy.Initialize(). When
      /// called after runtime initialization, existing audit hooks are notified
      /// and may silently abort the operation by raising an error subclassed
      /// from Exception (other errors will not be silenced).</para>
      /// <para>The hook function is always called with an attached thread state
      /// by the Python interpreter that raised the event.</para>
      /// <para>See PEP 578 for a detailed description of auditing. Functions
      /// in the runtime and standard library that raise events are listed in
      /// the audit events table. Details are in each function's
      /// documentation.</para>
      /// <para>If the interpreter is initialized, this function raises an
      /// auditing event sys.addaudithook with no arguments. If any existing
      /// hooks raise an exception derived from Exception, the new hook will
      /// not be added and the exception is cleared. As a result, callers cannot
      /// assume that their hook has been added unless they control all
      /// existing hooks.</para>
      /// </summary>
      class function AddAuditHook(hook: Py_AuditHookFunction; userData: Pointer): boolean;
      /// <summary>
      /// <para>Write the output string described by format to sys.stdout.
      /// No exceptions are raised, even if truncation occurs.</para>
      /// <para>format should limit the total size of the formatted output
      /// string to 1000 bytes or less - after 1000 bytes, the output string is
      /// truncated. In particular, this means that no unrestricted "%s" formats
      /// should occur; these should be limited using "%.<N>s" where <N> is a
      /// decimal number calculated so that <N> plus the maximum size of other
      /// formatted text does not exceed 1000 bytes. Also watch out for "%f",
      /// which can print hundreds of digits for very large numbers.</para>
      /// <para>If a problem occurs, or sys.stdout is unset, the formatted
      /// message is written to the real (C level) stdout.</para>
      /// </summary>
      class procedure WriteStdout(const format_: string; const args: array of const); overload;
      /// <summary>
      /// <para>Write the output string described by format to sys.stdout.
      /// No exceptions are raised, even if truncation occurs.</para>
      /// <para>format should limit the total size of the formatted output
      /// string to 1000 bytes or less - after 1000 bytes, the output string is
      /// truncated. In particular, this means that no unrestricted "%s" formats
      /// should occur; these should be limited using "%.<N>s" where <N> is a
      /// decimal number calculated so that <N> plus the maximum size of other
      /// formatted text does not exceed 1000 bytes. Also watch out for "%f",
      /// which can print hundreds of digits for very large numbers.</para>
      /// <para>If a problem occurs, or sys.stdout is unset, the formatted
      /// message is written to the real (C level) stdout.</para>
      /// </summary>
      class procedure WriteStdout(const format_: string); overload;
      /// <summary>
      /// <para>As TPySys.WriteStdout(), but write to sys.stderr or stderr
      /// instead.</para>
      /// </summary>
      class procedure WriteStderr(const format_: string; const args: array of const); overload;
      /// <summary>
      /// <para>As TPySys.WriteStdout(), but write to sys.stderr or stderr
      /// instead.</para>
      /// </summary>
      class procedure WriteStderr(const format_: string); overload;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPySys.GetAttr(const name_: IPyObject): IPyObject;
begin
  if assigned(PySys_GetAttr) and
     TPyObject.isInitialized(name_) then
    Result := TPyObject.Wrap(PySys_GetAttr(name_.PyObject))
   else
    Result := nil;
end;

class function TPySys.GetAttrString(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PySys_GetAttrString) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PySys_GetAttrString(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPySys.GetOptionalAttr(const name_: IPyObject; var result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  result_ := nil;
  Result  := 0;

  if assigned(PySys_GetOptionalAttr) and
     TPyObject.isInitialized(name_) then
    begin
      Result := PySys_GetOptionalAttr(name_.PyObject, TempResult);

      if assigned(TempResult) then
        result_ := TPyObject.Wrap(TempResult);
    end;
end;

class function TPySys.GetOptionalAttrString(const name_: string; var result_: IPyObject): integer;
var
  TempName   : AnsiString;
  TempResult : PPyObject;
begin
  result_ := nil;
  Result  := 0;

  if assigned(PySys_GetOptionalAttrString) and
     (length(name_) > 0) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := PySys_GetOptionalAttrString(PAnsiChar(TempName), TempResult);

      if assigned(TempResult) then
        result_ := TPyObject.Wrap(TempResult);
    end;
end;

class function TPySys.GetObject(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PySys_GetObject) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PySys_GetObject(PAnsiChar(TempName)), False);
    end
   else
    Result := nil;
end;

class function TPySys.SetObject(const name_: string; const v: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  if assigned(PySys_SetObject) and
     TPyObject.IsInitialized(v) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PySys_SetObject(PAnsiChar(TempName), v.PyObject) = 0);
    end
   else
    Result := False;
end;

class function TPySys.GetXOptions: IPyObject;
begin
  if assigned(PySys_GetXOptions) then
    Result := TPyObject.Wrap(PySys_GetXOptions(), False)
   else
    Result := nil;
end;

class function TPySys.AuditTuple(const event: string; const args: IPyObject): boolean;
var
  TempEvent : AnsiString;
begin
  if assigned(PySys_AuditTuple) then
    begin
      TempEvent := StringToPyUTF8(event);

      if TPyObject.IsInitialized(args) then
        Result := (PySys_AuditTuple(PAnsiChar(TempEvent), args.PyObject) = 0)
       else
        Result := (PySys_AuditTuple(PAnsiChar(TempEvent), nil) = 0);
    end
   else
    Result := False;
end;

class function TPySys.AddAuditHook(hook: Py_AuditHookFunction; userData: Pointer): boolean;
begin
  Result := assigned(PySys_AddAuditHook) and
            (PySys_AddAuditHook(hook, userData) = 0);
end;

class procedure TPySys.WriteStdout(const format_: string; const args: array of const);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStdout) then
    begin
      TempMsg := StringToPyUTF8(format_);
      //TODO: Find a better way to call PySys_WriteStdout with a variable number of arguments.
      case length(args) of
        05 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3], args[4]);
        04 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3]);
        03 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1], args[2]);
        02 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1]);
        01 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0]);
        else PySys_WriteStdout(PAnsiChar(TempMsg));
      end;
    end;
end;

class procedure TPySys.WriteStdout(const format_: string);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStdout) then
    begin
      TempMsg := StringToPyUTF8(format_);
      PySys_WriteStdout(PAnsiChar(TempMsg));
    end;
end;

class procedure TPySys.WriteStderr(const format_: string; const args: array of const);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStderr) then
    begin
      TempMsg := StringToPyUTF8(format_);
      //TODO: Find a better way to call PySys_WriteStderr with a variable number of arguments.
      case length(args) of
        05 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3], args[4]);
        04 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3]);
        03 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1], args[2]);
        02 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1]);
        01 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0]);
        else PySys_WriteStderr(PAnsiChar(TempMsg));
      end;
    end;
end;

class procedure TPySys.WriteStderr(const format_: string);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStderr) then
    begin
      TempMsg := StringToPyUTF8(format_);
      PySys_WriteStderr(PAnsiChar(TempMsg));
    end;
end;

end.
