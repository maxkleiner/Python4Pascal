unit uP4P.PyFrame;

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
  /// Helper class for all PyFrame_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/frame.html#frame-objects">See the article about Frame objects.</see></para>
  /// </remarks>
  TPyFrame = class
    public
      /// <summary>
      /// <para>Return True if aPyObject is a frame object.</para>
      /// </summary>
      class function  Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create a new frame object. This function returns a strong
      /// reference to the new frame object on success, and returns nil with
      /// an exception set on failure.</para>
      /// </summary>
      class function  New(tstate: PPyThreadState; const code, globals, locals: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the line number that frame is currently executing.</para>
      /// </summary>
      class function  GetLineNumber(const frame: IPyObject): integer;
      /// <summary>
      /// <para>Get the frame code. Return a strong reference.</para>
      /// <para>The result (frame code) cannot be nil.</para>
      /// </summary>
      class function  GetCode(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the frame next outer frame.</para>
      /// <para>Return a strong reference, or nil if frame has no outer frame.
      /// This raises no exceptions.</para>
      /// </summary>
      class function  GetBack(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the frame's f_locals attribute. If the frame refers to an
      /// optimized scope, this returns a write-through proxy object that
      /// allows modifying the locals. In all other cases (classes, modules,
      /// exec(), eval()) it returns the mapping representing the frame locals
      /// directly (as described for locals()).</para>
      /// <para>Return a strong reference.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function  GetLocals(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the frame's f_globals attribute.</para>
      /// <para>Return a strong reference. The result cannot be nil.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function  GetGlobals(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the frame’s f_builtins attribute.</para>
      /// <para>Return a strong reference. The result cannot be nil.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function  GetBuiltins(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the generator, coroutine, or async generator that owns this
      /// frame, or nil if this frame is not owned by a generator.
      /// Does not raise an exception, even if the return value is nil.</para>
      /// <para>Return a strong reference, or nil.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function  GetGenerator(const frame: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns -1 if frame.f_lasti is None.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function  GetLasti(const frame: IPyObject): integer;
      /// <summary>
      /// <para>Get the variable name_ of frame.</para>
      /// <para>Return a strong reference to the variable value on
      /// success.</para>
      /// <para>Raise NameError and return nil if the variable does not
      /// exist.</para>
      /// <para>Raise an exception and return nil on error.</para>
      /// <para>name_ type must be a str.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function  GetVar(const frame, name_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyFrame.GetVar(), but the variable name_ is a
      /// string.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function  GetVarString(const frame: IPyObject; const name_: string): IPyObject;
      /// <summary>
      /// <para>Prior to Python 3.13, this function would copy the f_locals
      /// attribute of f to the internal "fast" array of local variables,
      /// allowing changes in frame objects to be visible to the interpreter.
      /// If clear was true, this function would process variables that were
      /// unset in the locals dictionary.</para>
      /// <para>Soft deprecated since version 3.13: This function now does
      /// nothing.</para>
      /// </summary>
      class procedure LocalsToFast(const frame: IPyObject; clear: boolean);
      /// <summary>
      /// <para>Prior to Python 3.13, this function was similar to
      /// TPyFrame.FastToLocals(), but would return True on success, and False
      /// with an exception set on failure.</para>
      /// <para>Soft deprecated since version 3.13: This function now does
      /// nothing.</para>
      /// </summary>
      class function  FastToLocalsWithError(const frame: IPyObject): boolean;
      /// <summary>
      /// <para>Prior to Python 3.13, this function would copy the internal
      /// "fast" array of local variables (which is used by the interpreter)
      /// to the f_locals attribute of f, allowing changes in local variables
      /// to be visible to frame objects.</para>
      /// <para>Soft deprecated since version 3.13: This function now does
      /// nothing.</para>
      /// </summary>
      class procedure FastToLocals(const frame: IPyObject);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyFrame.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFrame_Type);
end;

class function TPyFrame.New(tstate: PPyThreadState; const code, globals, locals: IPyObject): IPyObject;
begin
  if assigned(PyFrame_New) and
     TPyObject.IsInitialized(code) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    Result := TPyObject.Wrap(PyFrame_New(tstate, PPyCodeObject(code.PyObject), globals.PyObject, locals.PyObject))
   else
    Result := nil;
end;

class function TPyFrame.GetLineNumber(const frame: IPyObject): integer;
begin
  if assigned(PyFrame_GetLineNumber) and
     TPyObject.IsInitialized(frame) then
    Result := PyFrame_GetLineNumber(PPyFrameObject(frame.PyObject))
   else
    Result := -1;
end;

class function TPyFrame.GetCode(const frame: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetCode) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetCode(PPyFrameObject(frame.PyObject)))
   else
    Result := nil;
end;

class function TPyFrame.GetBack(const frame: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetBack) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetBack(PPyFrameObject(frame.PyObject)))
   else
    Result := nil;
end;

class function TPyFrame.GetLocals(const frame: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetLocals) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetLocals(PPyFrameObject(frame.PyObject)))
   else
    Result := nil;
end;

class function TPyFrame.GetGlobals(const frame: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetGlobals) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetGlobals(PPyFrameObject(frame.PyObject)))
   else
    Result := nil;
end;

class function TPyFrame.GetBuiltins(const frame: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetBuiltins) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetBuiltins(PPyFrameObject(frame.PyObject)))
   else
    Result := nil;
end;

class function TPyFrame.GetGenerator(const frame: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetGenerator) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetGenerator(PPyFrameObject(frame.PyObject)))
   else
    Result := nil;
end;

class function TPyFrame.GetLasti(const frame: IPyObject): integer;
begin
  if assigned(PyFrame_GetLasti) and
     TPyObject.IsInitialized(frame) then
    Result := PyFrame_GetLasti(PPyFrameObject(frame.PyObject))
   else
    Result := -1;
end;

class function TPyFrame.GetVar(const frame, name_: IPyObject): IPyObject;
begin
  if assigned(PyFrame_GetVar) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(frame) then
    Result := TPyObject.Wrap(PyFrame_GetVar(PPyFrameObject(frame.PyObject), name_.PyObject))
   else
    Result := nil;
end;

class function TPyFrame.GetVarString(const frame: IPyObject; const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyFrame_GetVarString) and
     TPyObject.IsInitialized(frame) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyFrame_GetVarString(PPyFrameObject(frame.PyObject), PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class procedure TPyFrame.LocalsToFast(const frame: IPyObject; clear: boolean);
begin
  if assigned(PyFrame_LocalsToFast) and
     TPyObject.IsInitialized(frame) then
    PyFrame_LocalsToFast(PPyFrameObject(frame.PyObject), ord(clear));
end;

class function TPyFrame.FastToLocalsWithError(const frame: IPyObject): boolean;
begin
  Result := assigned(PyFrame_FastToLocalsWithError) and
            TPyObject.IsInitialized(frame) and
            (PyFrame_FastToLocalsWithError(PPyFrameObject(frame.PyObject)) = 0);
end;

class procedure TPyFrame.FastToLocals(const frame: IPyObject);
begin
  if assigned(PyFrame_FastToLocals) and
     TPyObject.IsInitialized(frame) then
    PyFrame_FastToLocals(PPyFrameObject(frame.PyObject));
end;

end.
