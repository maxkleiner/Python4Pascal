unit uP4P.PyException;

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
  uP4P.LibFunctions, uP4P.Interfaces, uP4P.PyObject, uP4P.Types;

type
  /// <summary>
  /// <para>Helper class for all the PyException_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#exception-objects">See the Exception Objects article.</see></para>
  /// </remarks>
  TPyException = class
    public
      /// <summary>
      /// <para>Set the traceback associated with the exception to tb.
      /// Use nil to clear it.</para>
      /// </summary>
      class function  SetTraceback(const ex, tb: IPyObject): boolean;
      /// <summary>
      /// <para>Return the traceback associated with the exception as a new
      /// reference, as accessible from Python through the __traceback__
      /// attribute. If there is no traceback associated, this returns
      /// nil.</para>
      /// </summary>
      class function  GetTraceback(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the cause (either an exception instance, or None,
      /// set by raise ... from ...) associated with the exception as a new
      /// reference, as accessible from Python through the __cause__
      /// attribute.</para>
      /// </summary>
      class function  GetCause(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the cause associated with the exception to cause.
      /// Use nil to clear it. There is no type check to make sure that cause
      /// is either an exception instance or None. This "steals" a reference to
      /// cause.</para>
      /// <para>The __suppress_context__ attribute is implicitly set to True by
      /// this function.</para>
      /// </summary>
      class procedure SetCause(const ex, cause: IPyObject);
      /// <summary>
      /// <para>Return the context (another exception instance during whose
      /// handling ex was raised) associated with the exception as a new
      /// reference, as accessible from Python through the __context__
      /// attribute. If there is no context associated, this returns nil.</para>
      /// </summary>
      class function  GetContext(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the context associated with the exception to ctx. Use nil
      /// to clear it. There is no type check to make sure that ctx is an
      /// exception instance. This "steals" a reference to ctx.</para>
      /// </summary>
      class procedure SetContext(const ex, ctx: IPyObject);
      /// <summary>
      /// <para>Return args of exception ex.</para>
      /// </summary>
      class function  GetArgs(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set args of exception ex to args.</para>
      /// </summary>
      class procedure SetArgs(const ex, args: IPyObject);
      /// <summary>
      /// <para>Custom function that returns the right exception type python
      /// object using the type_ argument.</para>
      /// </summary>
      class function GetExceptionType(type_: TPyExceptionType): PPyObject;
  end;

implementation

uses
  uP4P.PyNone;

class function TPyException.SetTraceback(const ex, tb: IPyObject): boolean;
begin
  Result := False;

  if assigned(PyException_SetTraceback) and
     TPyObject.IsInitialized(ex) then
    begin
      if TPyObject.IsInitialized(tb) then
        Result := (PyException_SetTraceback(ex.PyObject, tb.PyObject) <> 0)
       else
        Result := (PyException_SetTraceback(ex.PyObject, TPyNone.ReturnNone) <> 0);
    end;
end;

class function TPyException.GetTraceback(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetTraceback) then
    Result := TPyObject.Wrap(PyException_GetTraceback(ex.PyObject))
   else
    Result := nil;
end;

class function TPyException.GetCause(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetCause) then
    Result := TPyObject.Wrap(PyException_GetCause(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetCause(const ex, cause: IPyObject);
begin
  if assigned(PyException_SetCause) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(cause) then
    PyException_SetCause(ex.PyObject, cause.Unwrap);
end;

class function TPyException.GetContext(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetContext) then
    Result := TPyObject.Wrap(PyException_GetContext(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetContext(const ex, ctx: IPyObject);
begin
  if assigned(PyException_SetContext) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(ctx) then
    PyException_SetContext(ex.PyObject, ctx.Unwrap);
end;

class function TPyException.GetArgs(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetArgs) then
    Result := TPyObject.Wrap(PyException_GetArgs(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetArgs(const ex, args: IPyObject);
begin
  if assigned(PyException_SetArgs) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(args) then
    PyException_SetArgs(ex.PyObject, args.PyObject);
end;

class function TPyException.GetExceptionType(type_: TPyExceptionType): PPyObject;
begin
  case type_ of
    petBaseException                 : Result := PyExc_BaseException;
    petException                     : Result := PyExc_Exception;
    petBaseExceptionGroup            : Result := PyExc_BaseExceptionGroup;
    petStopAsyncIteration            : Result := PyExc_StopAsyncIteration;
    petStopIteration                 : Result := PyExc_StopIteration;
    petGeneratorExit                 : Result := PyExc_GeneratorExit;
    petArithmeticError               : Result := PyExc_ArithmeticError;
    petLookupError                   : Result := PyExc_LookupError;
    petAssertionError                : Result := PyExc_AssertionError;
    petAttributeError                : Result := PyExc_AttributeError;
    petBufferError                   : Result := PyExc_BufferError;
    petEOFError                      : Result := PyExc_EOFError;
    petFloatingPointError            : Result := PyExc_FloatingPointError;
    petOSError                       : Result := PyExc_OSError;
    petImportError                   : Result := PyExc_ImportError;
    petImportCycleError              : Result := PyExc_ImportCycleError;
    petModuleNotFoundError           : Result := PyExc_ModuleNotFoundError;
    petIndexError                    : Result := PyExc_IndexError;
    petKeyError                      : Result := PyExc_KeyError;
    petKeyboardInterrupt             : Result := PyExc_KeyboardInterrupt;
    petMemoryError                   : Result := PyExc_MemoryError;
    petNameError                     : Result := PyExc_NameError;
    petOverflowError                 : Result := PyExc_OverflowError;
    petRuntimeError                  : Result := PyExc_RuntimeError;
    petRecursionError                : Result := PyExc_RecursionError;
    petNotImplementedError           : Result := PyExc_NotImplementedError;
    petSyntaxError                   : Result := PyExc_SyntaxError;
    petIndentationError              : Result := PyExc_IndentationError;
    petTabError                      : Result := PyExc_TabError;
    petReferenceError                : Result := PyExc_ReferenceError;
    petSystemError                   : Result := PyExc_SystemError;
    petSystemExit                    : Result := PyExc_SystemExit;
    petTypeError                     : Result := PyExc_TypeError;
    petUnboundLocalError             : Result := PyExc_UnboundLocalError;
    petUnicodeError                  : Result := PyExc_UnicodeError;
    petUnicodeEncodeError            : Result := PyExc_UnicodeEncodeError;
    petUnicodeDecodeError            : Result := PyExc_UnicodeDecodeError;
    petUnicodeTranslateError         : Result := PyExc_UnicodeTranslateError;
    petValueError                    : Result := PyExc_ValueError;
    petZeroDivisionError             : Result := PyExc_ZeroDivisionError;
    petBlockingIOError               : Result := PyExc_BlockingIOError;
    petBrokenPipeError               : Result := PyExc_BrokenPipeError;
    petChildProcessError             : Result := PyExc_ChildProcessError;
    petConnectionError               : Result := PyExc_ConnectionError;
    petConnectionAbortedError        : Result := PyExc_ConnectionAbortedError;
    petConnectionRefusedError        : Result := PyExc_ConnectionRefusedError;
    petConnectionResetError          : Result := PyExc_ConnectionResetError;
    petFileExistsError               : Result := PyExc_FileExistsError;
    petFileNotFoundError             : Result := PyExc_FileNotFoundError;
    petInterruptedError              : Result := PyExc_InterruptedError;
    petIsADirectoryError             : Result := PyExc_IsADirectoryError;
    petNotADirectoryError            : Result := PyExc_NotADirectoryError;
    petPermissionError               : Result := PyExc_PermissionError;
    petProcessLookupError            : Result := PyExc_ProcessLookupError;
    petTimeoutError                  : Result := PyExc_TimeoutError;
    petEnvironmentError              : Result := PyExc_EnvironmentError;
    petIOError                       : Result := PyExc_IOError;
    {$IFDEF MSWINDOWS}
    petWindowsError                  : Result := PyExc_WindowsError;
    {$ENDIF}
    petWarning                       : Result := PyExc_Warning;
    petUserWarning                   : Result := PyExc_UserWarning;
    petDeprecationWarning            : Result := PyExc_DeprecationWarning;
    petPendingDeprecationWarning     : Result := PyExc_PendingDeprecationWarning;
    petSyntaxWarning                 : Result := PyExc_SyntaxWarning;
    petRuntimeWarning                : Result := PyExc_RuntimeWarning;
    petFutureWarning                 : Result := PyExc_FutureWarning;
    petImportWarning                 : Result := PyExc_ImportWarning;
    petUnicodeWarning                : Result := PyExc_UnicodeWarning;
    petBytesWarning                  : Result := PyExc_BytesWarning;
    petEncodingWarning               : Result := PyExc_EncodingWarning;
    petResourceWarning               : Result := PyExc_ResourceWarning;
    else                               Result := nil;
  end;
end;

end.
