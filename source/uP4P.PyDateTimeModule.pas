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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.ImportedPyModule;

type
  TPyDateTimeModule = class(TImportedPyModule)
    protected
      FDateType       : Pointer;
      FDateTimeType   : Pointer;
      FDeltaType      : Pointer;
      FTimeType       : Pointer;
      FTZInfoType     : Pointer;
      FTimeTZType     : Pointer;
      FDateTimeTZType : Pointer;

      procedure Import; override;
      procedure Initialize; override;
      procedure Finalize; override;

    public
      function CheckExactDate(const aPyObject: IPyObject): boolean;
      function CheckExactDateTime(const aPyObject: IPyObject): boolean;
      function CheckExactDelta(const aPyObject: IPyObject): boolean;
      function CheckExactTime(const aPyObject: IPyObject): boolean;
      function CheckExactTZInfo(const aPyObject: IPyObject): boolean;
      function CheckExactTimeTZ(const aPyObject: IPyObject): boolean;
      function CheckExactDateTimeTZ(const aPyObject: IPyObject): boolean;
      function CheckDate(const aPyObject: IPyObject): boolean;
      function CheckDateTime(const aPyObject: IPyObject): boolean;
      function CheckDelta(const aPyObject: IPyObject): boolean;
      function CheckTime(const aPyObject: IPyObject): boolean;
      function CheckTZInfo(const aPyObject: IPyObject): boolean;
      function CheckTimeTZ(const aPyObject: IPyObject): boolean;
      function CheckDateTimeTZ(const aPyObject: IPyObject): boolean;

      property DateTimeType   : Pointer  read FDateTimeType;
  end;

implementation

uses
  uP4P.PyImport, uP4P.PyTypeObject;

procedure TPyDateTimeModule.Initialize;
begin
  FDateType       := nil;
  FDateTimeType   := nil;
  FDeltaType      := nil;
  FTimeType       := nil;
  FTZInfoType     := nil;
  FTimeTZType     := nil;
  FDateTimeTZType := nil;
end;

procedure TPyDateTimeModule.Finalize;
begin
  DecRef(FDateType);
  DecRef(FDateTimeType);
  DecRef(FDeltaType);
  DecRef(FTimeType);
  DecRef(FTZInfoType);
  DecRef(FTimeTZType);
  DecRef(FDateTimeTZType);
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

function TPyDateTimeModule.CheckExactDate(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateType);
end;

function TPyDateTimeModule.CheckExactDateTime(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateTimeType);
end;

function TPyDateTimeModule.CheckExactDelta(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDeltaType);
end;

function TPyDateTimeModule.CheckExactTime(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeType);
end;

function TPyDateTimeModule.CheckExactTZInfo(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTZInfoType);
end;

function TPyDateTimeModule.CheckExactTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeTZType);
end;

function TPyDateTimeModule.CheckExactDateTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateTimeTZType);
end;

function TPyDateTimeModule.CheckDate(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDate(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FDateType);
end;

function TPyDateTimeModule.CheckDateTime(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDateTime(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FDateTimeType);
end;

function TPyDateTimeModule.CheckDelta(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDelta(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FDeltaType);
end;

function TPyDateTimeModule.CheckTime(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactTime(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FTimeType);
end;

function TPyDateTimeModule.CheckTZInfo(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactTZInfo(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FTZInfoType);
end;

function TPyDateTimeModule.CheckTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactTimeTZ(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FTimeTZType);
end;

function TPyDateTimeModule.CheckDateTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDateTimeTZ(aPyObject) or
            TPyTypeObject.IsSubtype(aPyObject, FDateTimeTZType);
end;

end.
