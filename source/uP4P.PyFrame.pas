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
  TPyFrame = class
    public
      class function  Check(const aPyObject: IPyObject): boolean;
      class function  New(tstate: PPyThreadState; const code, globals, locals: IPyObject): IPyObject;
      class function  GetLineNumber(const frame: IPyObject): integer;
      class function  GetCode(const frame: IPyObject): IPyObject;
      class function  GetBack(const frame: IPyObject): IPyObject;
      class function  GetLocals(const frame: IPyObject): IPyObject;
      class function  GetGlobals(const frame: IPyObject): IPyObject;
      class function  GetBuiltins(const frame: IPyObject): IPyObject;
      class function  GetGenerator(const frame: IPyObject): IPyObject;
      class function  GetLasti(const frame: IPyObject): integer;
      class function  GetVar(const frame, name_: IPyObject): IPyObject;
      class function  GetVarString(const frame: IPyObject; const name_: string): IPyObject;
      class procedure LocalsToFast(const frame: IPyObject; clear: boolean);
      class function  FastToLocalsWithError(const frame: IPyObject): boolean;
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
