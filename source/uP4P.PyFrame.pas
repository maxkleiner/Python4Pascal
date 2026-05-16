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
  TPyFrame = class(TPyObject, IPyFrameObject)
    protected
      FPyFrameObject : PPyFrameObject;

      function  GetInitialized: boolean; override;
      function  GetPyObject: PPyObject; override;
      function  GetPyFrameObject: PPyFrameObject;
      procedure SetPyObject(aValue: PPyObject); override;
      function  GetLineNumber: integer;
      function  GetCode: IPyCodeObject;
      function  GetBack: IPyFrameObject;
      function  GetLocals: IPyObject;
      function  GetGlobals: IPyObject;
      function  GetBuiltins: IPyObject;
      function  GetGenerator: IPyObject;
      function  GetLasti: integer;
      function  GetVar(const name_: IPyObject): IPyObject;
      function  GetVarString(const name_: string): IPyObject;
      procedure LocalsToFast(clear: boolean);
      function  FastToLocalsWithError: boolean;
      procedure FastToLocals;

    public
      constructor Create(aPyFrameObject: PPyFrameObject); reintroduce;

      class function Check(const aPyObject: IPyObject): boolean;
      class function WrapFrameObj(aPyFrameObject: Pointer): IPyFrameObject; inline;
      class function IsInitialized(const aPyFrameObject: IPyFrameObject): boolean; inline;
      class function New(tstate: PPyThreadState; const code: IPyCodeObject; const globals, locals: IPyObject): IPyFrameObject;

      property PyFrameObject : PPyFrameObject read GetPyFrameObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyCode;

constructor TPyFrame.Create(aPyFrameObject: PPyFrameObject);
begin
  inherited Create;

  FPyObject      := nil;
  FPyFrameObject := aPyFrameObject;
  FObjRefOwner   := True;
end;

class function TPyFrame.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFrame_Type);
end;

class function TPyFrame.WrapFrameObj(aPyFrameObject: Pointer): IPyFrameObject;
begin
  if assigned(aPyFrameObject) then
    Result := TPyFrame.Create(aPyFrameObject)
   else
    Result := nil;
end;

class function TPyFrame.IsInitialized(const aPyFrameObject: IPyFrameObject): boolean;
begin
  Result := (aPyFrameObject <> nil) and aPyFrameObject.Initialized;
end;

class function TPyFrame.New(tstate: PPyThreadState; const code: IPyCodeObject; const globals, locals: IPyObject): IPyFrameObject;
begin
  if assigned(PyFrame_New) and
     TPyCode.IsInitialized(code) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) then
    Result := TPyFrame.WrapFrameObj(PyFrame_New(tstate, code.PyCodeObject, globals.PyObject, locals.PyObject))
   else
    Result := nil;
end;

function TPyFrame.GetInitialized: boolean;
begin
  Result := assigned(FPyFrameObject);
end;

function TPyFrame.GetPyObject: PPyObject;
begin
  Result := @FPyFrameObject.ob_base;
end;

function TPyFrame.GetPyFrameObject: PPyFrameObject;
begin
  Result := @FPyFrameObject;
end;

procedure TPyFrame.SetPyObject(aValue: PPyObject);
begin
  FPyFrameObject.ob_base := aValue^;
end;

function TPyFrame.GetLineNumber: integer;
begin
  if Initialized and assigned(PyFrame_GetLineNumber) then
    Result := PyFrame_GetLineNumber(PyFrameObject)
   else
    Result := -1;
end;

function TPyFrame.GetCode: IPyCodeObject;
begin
  if Initialized and assigned(PyFrame_GetCode) then
    Result := TPyCode.WrapCodeObj(PyFrame_GetCode(PyFrameObject))
   else
    Result := nil;
end;

function TPyFrame.GetBack: IPyFrameObject;
begin
  if Initialized and assigned(PyFrame_GetBack) then
    Result := TPyFrame.WrapFrameObj(PyFrame_GetBack(PyFrameObject))
   else
    Result := nil;
end;

function TPyFrame.GetLocals: IPyObject;
begin
  if Initialized and assigned(PyFrame_GetLocals) then
    Result := TPyObject.Wrap(PyFrame_GetLocals(PyFrameObject))
   else
    Result := nil;
end;

function TPyFrame.GetGlobals: IPyObject;
begin
  if Initialized and assigned(PyFrame_GetGlobals) then
    Result := TPyObject.Wrap(PyFrame_GetGlobals(PyFrameObject))
   else
    Result := nil;
end;

function TPyFrame.GetBuiltins: IPyObject;
begin
  if Initialized and assigned(PyFrame_GetBuiltins) then
    Result := TPyObject.Wrap(PyFrame_GetBuiltins(PyFrameObject))
   else
    Result := nil;
end;

function TPyFrame.GetGenerator: IPyObject;
begin
  if Initialized and assigned(PyFrame_GetGenerator) then
    Result := TPyObject.Wrap(PyFrame_GetGenerator(PyFrameObject))
   else
    Result := nil;
end;

function TPyFrame.GetLasti: integer;
begin
  if Initialized and assigned(PyFrame_GetLasti) then
    Result := PyFrame_GetLasti(PyFrameObject)
   else
    Result := -1;
end;

function TPyFrame.GetVar(const name_: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyFrame_GetVar) and
     TPyObject.IsInitialized(name_) then
    Result := TPyObject.Wrap(PyFrame_GetVar(PyFrameObject, name_.PyObject))
   else
    Result := nil;
end;

function TPyFrame.GetVarString(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyFrame_GetVarString) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyFrame_GetVarString(PyFrameObject, PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

procedure TPyFrame.LocalsToFast(clear: boolean);
begin
  if Initialized and assigned(PyFrame_LocalsToFast) then
    PyFrame_LocalsToFast(PyFrameObject, ord(clear));
end;

function TPyFrame.FastToLocalsWithError: boolean;
begin
  Result := Initialized and
            assigned(PyFrame_FastToLocalsWithError) and
            (PyFrame_FastToLocalsWithError(PyFrameObject) = 0);
end;

procedure TPyFrame.FastToLocals;
begin
  if Initialized and assigned(PyFrame_FastToLocals) then
    PyFrame_FastToLocals(PyFrameObject);
end;

end.
