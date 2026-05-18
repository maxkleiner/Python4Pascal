unit uP4P.Py;

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
  TPy = class
    public
      class procedure FatalError(const message_: string);
      class function UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
      class function GetArgcArgv(var argc: integer; var argv: TStringList): boolean;
      class function InitializeFromInitConfig(config: PPyInitConfig): boolean;
      class function InitializeFromConfig(config: PPyConfig): IPyStatus;
      class function IsIntialized: boolean;
      class function GenericAlias(const origin, args: IPyObject): IPyObject;
      class function IsTrue(const aPyObject: IPyObject): boolean;
      class function IsFalse(const aPyObject: IPyObject): boolean;
      class function IsNone(const aPyObject: IPyObject): boolean;
      class function Type_(const aPyObject: IPyObject): PPyTypeObject;
      class function RefCnt(const aPyObject: IPyObject): integer;
      class procedure IncRef(const aPyObject: IPyObject);
      class procedure DecRef(const aPyObject: IPyObject);
      class function NewRef(const aPyObject: IPyObject): PPyConfig; overload;
      class function NewRef(aPyObject: PPyConfig): PPyConfig; overload;
      class function XNewRef(const aPyObject: IPyObject): PPyConfig;
      class function Is_(const x, y: IPyObject): boolean;
      class function GetConstant(constant_id: cardinal): PPyConfig;
      class function GetConstantBorrowed(constant_id: cardinal): PPyConfig;
      class function ReprEnter(const aPyObject: IPyObject): boolean;
      class procedure ReprLeave(const aPyObject: IPyObject);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyStatus;

class procedure TPy.FatalError(const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(Py_FatalError) then
    begin
      TempMessage := StringToPyUTF8(message_);
      Py_FatalError(PAnsiChar(TempMessage));
    end;
end;

class function TPy.UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
begin
  // The fobj parameter exists solely for legacy reasons and must be NULL.
  if assigned(Py_UniversalNewlineFgets) then
    Result := PByte(Py_UniversalNewlineFgets(PAnsiChar(buf), n, stream, nil))
   else
    Result := nil;
end;

class function TPy.GetArgcArgv(var argc: integer; var argv: TStringList): boolean;
var
  TempArgv : PPWCharT;
begin
  Result := False;

  if assigned(Py_GetArgcArgv) then
    begin
      Py_GetArgcArgv(argc, TempArgv);
      Result := WCharTArrayToStringList(TempArgv, argc, argv);
    end;
end;

class function TPy.InitializeFromInitConfig(config: PPyInitConfig): boolean;
begin
  Result := assigned(Py_InitializeFromInitConfig) and
            (Py_InitializeFromInitConfig(config) = 0);
end;

class function TPy.InitializeFromConfig(config: PPyConfig): IPyStatus;
begin
  if assigned(Py_InitializeFromConfig) then
    Result := TPyStatus.Create(Py_InitializeFromConfig(config))
   else
    Result := nil;
end;

class function TPy.IsIntialized: boolean;
begin
  Result := assigned(Py_IsInitialized) and
            (Py_IsInitialized() <> 0);
end;

class function TPy.GenericAlias(const origin, args: IPyObject): IPyObject;
begin
  if assigned(Py_GenericAlias) and
     TPyObject.IsInitialized(origin) and
     TPyObject.IsInitialized(args) then
    Result := TPyObject.Wrap(Py_GenericAlias(origin.PyObject, args.PyObject))
   else
    Result := nil;
end;

class function TPy.IsTrue(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsTrue) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsTrue(aPyObject.PyObject) <> 0);
end;

class function TPy.IsFalse(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsFalse) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsFalse(aPyObject.PyObject) <> 0);
end;

class function TPy.IsNone(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsNone) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsNone(aPyObject.PyObject) <> 0);
end;

class function TPy.Type_(const aPyObject: IPyObject): PPyTypeObject;
begin
  if assigned(Py_TYPE) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_TYPE(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.RefCnt(const aPyObject: IPyObject): integer;
begin
  if assigned(Py_REFCNT) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_REFCNT(aPyObject.PyObject)
   else
    Result := 0;
end;

class procedure TPy.IncRef(const aPyObject: IPyObject);
begin
  if assigned(Py_IncRef) and
     TPyObject.IsInitialized(aPyObject) then
    Py_IncRef(aPyObject.PyObject);
end;

class procedure TPy.DecRef(const aPyObject: IPyObject);
begin
  if assigned(Py_DecRef) and
     TPyObject.IsInitialized(aPyObject) then
    Py_DecRef(aPyObject.PyObject);
end;

class function TPy.NewRef(aPyObject: PPyConfig): PPyConfig;
begin
  if assigned(Py_NewRef) then
    Result := Py_NewRef(aPyObject)
   else
    Result := nil;
end;

class function TPy.NewRef(const aPyObject: IPyObject): PPyConfig;
begin
  if TPyObject.IsInitialized(aPyObject) then
    Result := NewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.XNewRef(const aPyObject: IPyObject): PPyConfig;
begin
  if assigned(Py_XNewRef) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_XNewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.Is_(const x, y: IPyObject): boolean;
begin
  Result := assigned(Py_Is) and
            TPyObject.IsInitialized(x) and
            TPyObject.IsInitialized(y) and
            (Py_Is(x.PyObject, y.PyObject) <> 0);
end;

class function TPy.GetConstant(constant_id: cardinal): PPyConfig;
begin
  if assigned(Py_GetConstant) and
     (constant_id in [Py_CONSTANT_NONE..Py_CONSTANT_EMPTY_TUPLE]) then
    Result := Py_GetConstant(constant_id)
   else
    Result := nil;
end;

class function TPy.GetConstantBorrowed(constant_id: cardinal): PPyConfig;
begin
  if assigned(Py_GetConstantBorrowed) and
     (constant_id in [Py_CONSTANT_NONE..Py_CONSTANT_EMPTY_TUPLE]) then
    Result := Py_GetConstantBorrowed(constant_id)
   else
    Result := nil;
end;

class function TPy.ReprEnter(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_ReprEnter) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_ReprEnter(aPyObject.PyObject) = 0);
end;

class procedure TPy.ReprLeave(const aPyObject: IPyObject);
begin
  if assigned(Py_ReprLeave) and
     TPyObject.IsInitialized(aPyObject) then
    Py_ReprLeave(aPyObject.PyObject);
end;

end.
