unit uP4P.PyDateTimeModule;

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
  TPyDateTimeModule = class
    protected
      FDateType       : Pointer;
      FDateTimeType   : Pointer;
      FDeltaType      : Pointer;
      FTimeType       : Pointer;
      FTZInfoType     : Pointer;
      FTimeTZType     : Pointer;
      FDateTimeTZType : Pointer;

      procedure DecRef(var aPyTypeObject : Pointer);
      procedure Import;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      function    CheckDate(const aPyObject: IPyObject): boolean;
      function    CheckDateTime(const aPyObject: IPyObject): boolean;
      function    CheckDelta(const aPyObject: IPyObject): boolean;
      function    CheckTime(const aPyObject: IPyObject): boolean;
      function    CheckTZInfo(const aPyObject: IPyObject): boolean;
      function    CheckTimeTZ(const aPyObject: IPyObject): boolean;
      function    CheckDateTimeTZ(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PyImport;

constructor TPyDateTimeModule.Create;
begin
  inherited Create;

  FDateType       := nil;
  FDateTimeType   := nil;
  FDeltaType      := nil;
  FTimeType       := nil;
  FTZInfoType     := nil;
  FTimeTZType     := nil;
  FDateTimeTZType := nil;
end;

destructor TPyDateTimeModule.Destroy;
begin
  DecRef(FDateType);
  DecRef(FDateTimeType);
  DecRef(FDeltaType);
  DecRef(FTimeType);
  DecRef(FTZInfoType);
  DecRef(FTimeTZType);
  DecRef(FDateTimeTZType);

  inherited Destroy;
end;

procedure TPyDateTimeModule.AfterConstruction;
begin
  inherited AfterConstruction;

  Import;
end;

procedure TPyDateTimeModule.DecRef(var aPyTypeObject : Pointer);
begin
  if assigned(Py_DecRef) and assigned(aPyTypeObject) then
    begin
      Py_DecRef(PPyObject(aPyTypeObject));
      aPyTypeObject := nil;
    end;
end;

procedure TPyDateTimeModule.Import;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('datetime');

  if TPyObject.IsInitialized(TempModule) then
    begin
      TempModule.GetOptionalAttrString2('date',       FDateType);
      TempModule.GetOptionalAttrString2('datetime',   FDateTimeType);
      TempModule.GetOptionalAttrString2('timedelta',  FDeltaType);
      TempModule.GetOptionalAttrString2('time',       FTimeType);
      TempModule.GetOptionalAttrString2('tzinfo',     FTZInfoType);
      TempModule.GetOptionalAttrString2('timetz',     FTimeTZType);
      TempModule.GetOptionalAttrString2('datetimetz', FDateTimeTZType);
    end;
end;

function TPyDateTimeModule.CheckDate(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateType);
end;

function TPyDateTimeModule.CheckDateTime(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateTimeType);
end;

function TPyDateTimeModule.CheckDelta(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDeltaType);
end;

function TPyDateTimeModule.CheckTime(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeType);
end;

function TPyDateTimeModule.CheckTZInfo(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTZInfoType);
end;

function TPyDateTimeModule.CheckTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeTZType);
end;

function TPyDateTimeModule.CheckDateTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateTimeTZType);
end;


end.
