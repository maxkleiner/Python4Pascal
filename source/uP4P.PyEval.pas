unit uP4P.PyEval;

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
  /// <para>Helper class for all the PyEval_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/veryhigh.html#the-very-high-level-layer">See the Very High Level Layer article.</see></para>
  /// </remarks>
  TPyEval = class
    public
      /// <summary>
      /// <para>This is a simplified interface to TPyEval.EvalCodeEx(), with
      /// just the code object, and global and local variables. The other
      /// arguments are set to nil.</para>
      /// </summary>
      class function EvalCode(const co, globals, locals: IPyObject): IPyObject;
      /// <summary>
      /// <para>Evaluate a precompiled code object, given a particular
      /// environment for its evaluation. This environment consists of
      /// a dictionary of global variables, a mapping object of local
      /// variables, arrays of arguments, keywords and defaults, a dictionary
      /// of default values for keyword-only arguments and a closure tuple of
      /// cells.</para>
      /// </summary>
      class function EvalCodeEx(const co, globals, locals: IPyObject; const args, kwds, defs: IPyObjectArray; const kwdefs, closure: IPyObject): IPyObject;
      /// <summary>
      /// <para>Deprecated since version 3.13: Use TPyEval.GetFrameBuiltins()
      /// instead.</para>
      /// <para>Return a dictionary of the builtins in the current execution
      /// frame, or the interpreter of the thread state if no frame is
      /// currently executing.</para>
      /// </summary>
      class function GetBuiltins: IPyObject;
      /// <summary>
      /// <para>Deprecated since version 3.13: Use TPyEval.GetFrameGlobals()
      /// instead.</para>
      /// <para>Return a dictionary of the global variables in the current
      /// execution frame, or nil if no frame is currently executing.</para>
      /// </summary>
      class function GetGlobals: IPyObject;
      /// <summary>
      /// <para>Deprecated since version 3.13: Use either
      /// TPyEval.GetFrameLocals() to obtain the same behaviour as calling
      /// locals() in Python code, or else call TPyFrame.GetLocals() on the
      /// result of TPyEval.GetFrame() to access the f_locals attribute of the
      /// currently executing frame.</para>
      /// <para>Return a mapping providing access to the local variables in the
      /// current execution frame, or nil if no frame is currently
      /// executing.</para>
      /// <para>Refer to locals() for details of the mapping returned at
      /// different scopes.</para>
      /// <para>As this function returns a borrowed reference, the dictionary
      /// returned for optimized scopes is cached on the frame object and will
      /// remain alive as long as the frame object does. Unlike
      /// TPyEval.GetFrameLocals() and locals(), subsequent calls to this
      /// function in the same frame will update the contents of the cached
      /// dictionary to reflect changes in the state of the local variables
      /// rather than returning a new snapshot.</para>
      /// <para>Changed in version 3.13: As part of PEP 667,
      /// TPyFrame.GetLocals(), locals(), and FrameType.f_locals no longer make
      /// use of the shared cache dictionary. Refer to the What's New entry for
      /// additional details.</para>
      /// </summary>
      class function GetLocals: IPyObject;
      /// <summary>
      /// <para>Return the attached thread state's frame, which is nil if no
      /// frame is currently executing.</para>
      /// <para>See also TPyThreadState.GetFrame().</para>
      /// </summary>
      class function GetFrame: IPyObject;
      /// <summary>
      /// <para>Return a dictionary of the builtins in the current execution
      /// frame, or the interpreter of the thread state if no frame is
      /// currently executing.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetFrameBuiltins: IPyObject;
      /// <summary>
      /// <para>Return a dictionary of the global variables in the current
      /// execution frame, or nil if no frame is currently executing.
      /// Equivalent to calling globals() in Python code.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetFrameGlobals: IPyObject;
      /// <summary>
      /// <para>Return a dictionary of the local variables in the current
      /// execution frame, or nil if no frame is currently executing.
      /// Equivalent to calling locals() in Python code.</para>
      /// <para>To access f_locals on the current frame without making an
      /// independent snapshot in optimized scopes, call TPyFrame.GetLocals()
      /// on the result of TPyEval.GetFrame().</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetFrameLocals: IPyObject;
      /// <summary>
      /// <para>Return the name of func if it is a function, class or instance
      /// object, else the name of funcs type.</para>
      /// </summary>
      class function GetFuncName(const func: IPyObject): string;
      /// <summary>
      /// <para>Return a description string, depending on the type of func.
      /// Return values include "()" for functions and methods, "constructor",
      /// "instance", and "object". Concatenated with the result of
      /// TPyEval.GetFuncName(), the result will be a description
      /// of func.</para>
      /// </summary>
      class function GetFuncDesc(const func: IPyObject): string;
      /// <summary>
      /// <para>Evaluate an execution frame. This is a simplified interface to
      /// TPyEval.EvalFrameEx(), for backward compatibility.</para>
      /// </summary>
      class function EvalFrame(const f: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is the main, unvarnished function of Python interpretation.
      /// The code object associated with the execution frame f is executed,
      /// interpreting bytecode and executing calls as needed. The additional
      /// throwflag parameter can mostly be ignored - if true, then it causes
      /// an exception to immediately be thrown; this is used for the throw()
      /// methods of generator objects.</para>
      /// <para>Changed in version 3.4: This function now includes a debug
      /// assertion to help ensure that it does not silently discard an active
      /// exception.</para>
      /// </summary>
      class function EvalFrameEx(const f: IPyObject; throwflag: boolean): IPyObject;
      /// <summary>
      /// <para>Detach the attached thread state and return it. The thread will
      /// have no thread state upon returning.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class function SaveThread(): IPyThreadState;
      /// <summary>
      /// <para>Set the attached thread state to tstate. The passed thread
      /// state should not be attached, otherwise deadlock ensues. tstate will
      /// be attached upon returning.</para>
      /// <para>Note Calling this function from a thread when the runtime is
      /// finalizing will hang the thread until the program exits, even if the
      /// thread was not created by Python. Refer to Cautions regarding runtime
      /// finalization for more details.</para>
      /// <para>Changed in version 3.14: Hangs the current thread, rather than
      /// terminating it, if called while the interpreter is finalizing.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure RestoreThread(const tstate: IPyThreadState);
      /// <summary>
      /// <para>Attach tstate to the current thread, which must not be nil or
      /// already attached.</para>
      /// <para>The calling thread must not already have an attached thread
      /// state.</para>
      /// <para>Note Calling this function from a thread when the runtime is
      /// finalizing will hang the thread until the program exits, even if the
      /// thread was not created by Python. Refer to Cautions regarding runtime
      /// finalization for more details.</para>
      /// <para>Changed in version 3.8: Updated to be consistent with
      /// TPyEval.RestoreThread(), Py_END_ALLOW_THREADS(), and
      /// TPyGILState.Ensure(), and terminate the current thread if called
      /// while the interpreter is finalizing.</para>
      /// <para>Changed in version 3.14: Hangs the current thread, rather than
      /// terminating it, if called while the interpreter is finalizing.</para>
      /// <para>TPyEval.RestoreThread() is a higher-level function which is
      /// always available (even when threads have not been initialized).</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure AcquireThread(const tstate: IPyThreadState);
      /// <summary>
      /// <para>Detach the attached thread state. The tstate argument, which
      /// must not be nil, is only used to check that it represents the
      /// attached thread state - if it isn't, a fatal error is reported.</para>
      /// <para>TPyEval.SaveThread() is a higher-level function which is always
      /// available (even when threads have not been initialized).</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure ReleaseThread(const tstate: IPyThreadState);
      /// <summary>
      /// <para>Set the profiler function to func. The obj parameter is passed
      /// to the function as its first parameter, and may be any Python object,
      /// or nilL. If the profile function needs to maintain state, using a
      /// different value for obj for each thread provides a convenient and
      /// thread-safe place to store it. The profile function is called for all
      /// monitored events except PyTrace_LINE PyTrace_OPCODE and
      /// PyTrace_EXCEPTION.</para>
      /// <para>See also the sys.setprofile() function.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure SetProfile(func: Py_tracefunc; const obj: IPyObject);
      /// <summary>
      /// <para>Like TPyEval.SetProfile() but sets the profile function in all
      /// running threads belonging to the current interpreter instead of the
      /// setting it only on the current thread.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>As TPyEval.SetProfile(), this function ignores any exceptions
      /// raised while setting the profile functions in all threads.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure SetProfileAllThreads(func: Py_tracefunc; const obj: IPyObject);
      /// <summary>
      /// <para>Set the tracing function to func. This is similar to
      /// TPyEval.SetProfile(), except the tracing function does receive
      /// line-number events and per-opcode events, but does not receive any
      /// event related to C function objects being called. Any trace function
      /// registered using TPyEval.SetTrace() will not receive
      /// PyTrace_C_CALL, PyTrace_C_EXCEPTION or PyTrace_C_RETURN as a value
      /// for the what parameter.</para>
      /// <para>See also the sys.settrace() function.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure SetTrace(func: Py_tracefunc; const obj: IPyObject);
      /// <summary>
      /// <para>Like TPyEval.SetTrace() but sets the tracing function in all
      /// running threads belonging to the current interpreter instead of the
      /// setting it only on the current thread.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>As TPyEval.SetTrace(), this function ignores any exceptions
      /// raised while setting the trace functions in all threads.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      class procedure SetTraceAllThreads(func: Py_tracefunc; const obj: IPyObject);
      /// <summary>
      /// <para>This function changes the flags of the current evaluation frame,
      /// and returns true on success, false on failure.</para>
      /// </summary>
      class function MergeCompilerFlags(const cf: PyCompilerFlags): boolean;
      /// <summary>
      /// <para>Compiles and evaluates Python code.</para>
      /// </summary>
      class function EvalString(const code: string): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyThreadState, uP4P.PyImport, uP4P.PyModule, uP4P.Py;

class function TPyEval.EvalCode(const co, globals, locals: IPyObject): IPyObject;
var
  TempLocals : PPyObject;
begin
  if assigned(PyEval_EvalCode) and
     TPyObject.IsInitialized(co) and
     TPyObject.IsInitialized(globals) then
    begin
      if TPyObject.IsInitialized(locals) then
        TempLocals := locals.PyObject
       else
        TempLocals := nil;

      Result := TPyObject.Wrap(PyEval_EvalCode(co.PyObject, globals.PyObject, TempLocals));
    end
   else
    Result := nil;
end;

class function TPyEval.EvalCodeEx(const co, globals, locals: IPyObject; const args, kwds, defs: IPyObjectArray; const kwdefs, closure: IPyObject): IPyObject;
var
  TempArgs, TempKwds, TempDefs : PPyObjectArray;
  TempArgsPtr, TempKwdsPtr, TempDefsPtr : PPPyObject;
  TempArgsLen, TempKwdsLen, TempDefsLen, i : integer;
  TempLocals, TempKwdefs, TempClosure : PPyObject;
begin
  Result := nil;

  if assigned(PyEval_EvalCodeEx) and
     TPyObject.IsInitialized(co) and
     TPyObject.IsInitialized(globals) then
    begin
      TempArgsLen := System.length(args);
      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      TempKwdsLen := System.length(kwds);
      if (TempKwdsLen > 0) then
        begin
          SetLength(TempKwds, TempKwdsLen);

          for i := 0 to pred(TempKwdsLen) do
            TempKwds[i] := kwds[i].PyObject;

          TempKwdsPtr := @TempKwds[0];
        end
       else
        TempKwdsPtr := nil;

      TempDefsLen := System.length(defs);
      if (TempDefsLen > 0) then
        begin
          SetLength(TempDefs, TempDefsLen);

          for i := 0 to pred(TempDefsLen) do
            TempDefs[i] := defs[i].PyObject;

          TempDefsPtr := @TempDefs[0];
        end
       else
        TempDefsPtr := nil;

      if TPyObject.IsInitialized(locals) then
        TempLocals := locals.PyObject
       else
        TempLocals := nil;

      if TPyObject.IsInitialized(kwdefs) then
        TempKwdefs := kwdefs.PyObject
       else
        TempKwdefs := nil;

      if TPyObject.IsInitialized(closure) then
        TempClosure := closure.PyObject
       else
        TempClosure := nil;

      Result := TPyObject.Wrap(PyEval_EvalCodeEx(co.PyObject, globals.PyObject, TempLocals,
                                                 TempArgsPtr, TempArgsLen,
                                                 TempKwdsPtr, TempKwdsLen,
                                                 TempDefsPtr, TempDefsLen,
                                                 TempKwdefs, TempClosure));
    end;
end;

class function TPyEval.GetBuiltins: IPyObject;
begin
  if assigned(PyEval_GetBuiltins) then
    Result := TPyObject.Wrap(PyEval_GetBuiltins(), False)
   else
    Result := nil;
end;

class function TPyEval.GetGlobals: IPyObject;
begin
  if assigned(PyEval_GetGlobals) then
    Result := TPyObject.Wrap(PyEval_GetGlobals(), False)
   else
    Result := nil;
end;

class function TPyEval.GetLocals: IPyObject;
begin
  if assigned(PyEval_GetLocals) then
    Result := TPyObject.Wrap(PyEval_GetLocals(), False)
   else
    Result := nil;
end;

class function TPyEval.GetFrame: IPyObject;
begin
  if assigned(PyEval_GetFrame) then
    Result := TPyObject.Wrap(PyEval_GetFrame(), False)
   else
    Result := nil;
end;

class function TPyEval.GetFrameBuiltins: IPyObject;
begin
  if assigned(PyEval_GetFrameBuiltins) then
    Result := TPyObject.Wrap(PyEval_GetFrameBuiltins())
   else
    Result := nil;
end;

class function TPyEval.GetFrameGlobals: IPyObject;
begin
  if assigned(PyEval_GetFrameGlobals) then
    Result := TPyObject.Wrap(PyEval_GetFrameGlobals())
   else
    Result := nil;
end;

class function TPyEval.GetFrameLocals: IPyObject;
begin
  if assigned(PyEval_GetFrameLocals) then
    Result := TPyObject.Wrap(PyEval_GetFrameLocals())
   else
    Result := nil;
end;

class function TPyEval.GetFuncName(const func: IPyObject): string;
begin
  if assigned(PyEval_GetFuncName) and
     TPyObject.IsInitialized(func) then
    Result := PyUTF8ToString(PyEval_GetFuncName(func.PyObject))
   else
    Result := '';
end;

class function TPyEval.GetFuncDesc(const func: IPyObject): string;
begin
  if assigned(PyEval_GetFuncDesc) and
     TPyObject.IsInitialized(func) then
    Result := PyUTF8ToString(PyEval_GetFuncDesc(func.PyObject))
   else
    Result := '';
end;

class function TPyEval.EvalFrame(const f: IPyObject): IPyObject;
begin
  if assigned(PyEval_EvalFrame) and
     TPyObject.IsInitialized(f) then
    Result := TPyObject.Wrap(PyEval_EvalFrame(PPyFrameObject(f.PyObject)))
   else
    Result := nil;
end;

class function TPyEval.EvalFrameEx(const f: IPyObject; throwflag: boolean): IPyObject;
begin
  if assigned(PyEval_EvalFrameEx) and
     TPyObject.IsInitialized(f) then
    Result := TPyObject.Wrap(PyEval_EvalFrameEx(PPyFrameObject(f.PyObject), ord(throwflag)))
   else
    Result := nil;
end;

class function TPyEval.SaveThread(): IPyThreadState;
begin
  if assigned(PyEval_SaveThread) then
    Result := TPyThreadState.Wrap(PyEval_SaveThread())
   else
    Result := nil;
end;

class procedure TPyEval.RestoreThread(const tstate: IPyThreadState);
begin
  if assigned(PyEval_RestoreThread) and
     TPyThreadState.IsInitialized(tstate) then
    PyEval_RestoreThread(tstate.ThreadState);
end;

class procedure TPyEval.AcquireThread(const tstate: IPyThreadState);
begin
  if assigned(PyEval_AcquireThread) and
     TPyThreadState.IsInitialized(tstate) then
    PyEval_AcquireThread(tstate.ThreadState);
end;

class procedure TPyEval.ReleaseThread(const tstate: IPyThreadState);
begin
  if assigned(PyEval_ReleaseThread) and
     TPyThreadState.IsInitialized(tstate) then
    PyEval_ReleaseThread(tstate.ThreadState);
end;

class procedure TPyEval.SetProfile(func: Py_tracefunc; const obj: IPyObject);
begin
  if assigned(PyEval_SetProfile) and
     TPyObject.IsInitialized(obj) then
    PyEval_SetProfile(func, obj.PyObject);
end;

class procedure TPyEval.SetProfileAllThreads(func: Py_tracefunc; const obj: IPyObject);
begin
  if assigned(PyEval_SetProfileAllThreads) and
     TPyObject.IsInitialized(obj) then
    PyEval_SetProfileAllThreads(func, obj.PyObject);
end;

class procedure TPyEval.SetTrace(func: Py_tracefunc; const obj: IPyObject);
begin
  if assigned(PyEval_SetTrace) and
     TPyObject.IsInitialized(obj) then
    PyEval_SetTrace(func, obj.PyObject);
end;

class procedure TPyEval.SetTraceAllThreads(func: Py_tracefunc; const obj: IPyObject);
begin
  if assigned(PyEval_SetTraceAllThreads) and
     TPyObject.IsInitialized(obj) then
    PyEval_SetTraceAllThreads(func, obj.PyObject);
end;

class function TPyEval.MergeCompilerFlags(const cf: PyCompilerFlags): boolean;
begin
  Result := assigned(PyEval_MergeCompilerFlags) and
            (PyEval_MergeCompilerFlags(@cf) = 0);
end;

class function TPyEval.EvalString(const code: string): IPyObject;
var
  TempBytecode, TempGlobals, TempLocals, TempMainModule : IPyObject;
begin
  Result         := nil;
  TempMainModule := TPyImport.AddModule(MAIN_MODULE_NAME);

  if TPyObject.IsInitialized(TempMainModule) then
    try
      TempLocals   := TPyModule.GetDict(TempMainModule);
      TempGlobals  := TempLocals;
      TempBytecode := TPy.CompileString(code);

      if TPyObject.IsInitialized(TempBytecode) then
        Result := TPyEval.EvalCode(TempBytecode, TempGlobals, TempLocals);
    finally
      TempMainModule := nil;
      TempLocals     := nil;
      TempGlobals    := nil;
    end;
end;

end.
