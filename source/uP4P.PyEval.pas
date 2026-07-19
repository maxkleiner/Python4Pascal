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
  TPyEval = class
    public
      class function EvalCode(const co, globals, locals: IPyObject): IPyObject;
      class function EvalCodeEx(const co, globals, locals: IPyObject; const args, kwds, defs: IPyObjectArray; const kwdefs, closure: IPyObject): IPyObject;
      class function GetBuiltins: IPyObject;
      class function GetGlobals: IPyObject;
      class function GetLocals: IPyObject;
      class function GetFrame: IPyObject;
      class function GetFrameBuiltins: IPyObject;
      class function GetFrameGlobals: IPyObject;
      class function GetFrameLocals: IPyObject;
      class function GetFuncName(const func: IPyObject): string;
      class function GetFuncDesc(const func: IPyObject): string;
      class function EvalFrame(const f: IPyObject): IPyObject;
      class function EvalFrameEx(const f: IPyObject; throwflag: boolean): IPyObject;
      class function SaveThread(): IPyThreadState;
      class procedure RestoreThread(const tstate: IPyThreadState);
      class procedure AcquireThread(const tstate: IPyThreadState);
      class procedure ReleaseThread(const tstate: IPyThreadState);
      class procedure SetProfile(func: Py_tracefunc; const obj: IPyObject);
      class procedure SetProfileAllThreads(func: Py_tracefunc; const obj: IPyObject);
      class procedure SetTrace(func: Py_tracefunc; const obj: IPyObject);
      class procedure SetTraceAllThreads(func: Py_tracefunc; const obj: IPyObject);
      class function MergeCompilerFlags(const cf: PyCompilerFlags): boolean;
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
