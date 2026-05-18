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

end.
