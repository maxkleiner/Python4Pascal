unit uP4P.PyDateTime;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants,
  {$ELSE}
    Classes, SysUtils, Variants,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyDateTime = class
    public
      class function AsDate(const aPyObject: IPyObject; var year, month, day: integer): boolean;
      class function AsTime(const aPyObject: IPyObject; var hour, minute, second, microsecond: integer): boolean;
      class function AsDelta(const aPyObject: IPyObject; var days, seconds, microseconds: integer): boolean;
      class function AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, microsecond: integer): boolean; overload;
      class function AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean; overload;
      class function FromDateTime(aDateTime: TDateTime): IPyObject; overload;
      class function FromDateTime(year, month, day, hour, minute, second, msecond: integer): IPyObject; overload;
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
  end;

implementation

uses
  uP4P.Engine, uP4P.PyTuple, uP4P.PyLong;

class function TPyDateTime.AsDate(const aPyObject: IPyObject; var year, month, day: integer): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckDate(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('year',  year);
      aPyObject.GetAttrAsInteger('month', month);
      aPyObject.GetAttrAsInteger('day',   day);

      Result := True;
    end;
end;

class function TPyDateTime.AsTime(const aPyObject: IPyObject; var hour, minute, second, microsecond: integer): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckTime(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('hour',        hour);
      aPyObject.GetAttrAsInteger('minute',      minute);
      aPyObject.GetAttrAsInteger('second',      second);
      aPyObject.GetAttrAsInteger('microsecond', microsecond);

      Result := True;
    end;
end;

class function TPyDateTime.AsDelta(const aPyObject: IPyObject; var days, seconds, microseconds: integer): boolean;
var
  TempDelta : PyDateTime_Delta;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckDelta(aPyObject) then
    begin
      TempDelta    := PPyDateTime_Delta(aPyObject.PyObject)^;
      days         := TempDelta.days;
      seconds      := TempDelta.seconds;
      microseconds := TempDelta.microseconds;
      Result       := True;
    end;
end;

class function TPyDateTime.AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, microsecond: integer): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckDateTime(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('year',        year);
      aPyObject.GetAttrAsInteger('month',       month);
      aPyObject.GetAttrAsInteger('day',         day);
      aPyObject.GetAttrAsInteger('hour',        hour);
      aPyObject.GetAttrAsInteger('minute',      minute);
      aPyObject.GetAttrAsInteger('second',      second);
      aPyObject.GetAttrAsInteger('microsecond', microsecond);

      Result := True;
    end;
end;

class function TPyDateTime.AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean;
var
  year, month, day, hour, minute, second, microsecond : integer;
begin
  if AsDateTime(aPyObject, year, month, day, hour, minute, second, microsecond) then
    begin
      aDateTime := EncodeDate(year, month, day) + EncodeTime(hour, minute, second, microsecond div 1000);
      Result    := True;
    end
   else
    if AsDate(aPyObject, year, month, day) then
      begin
        aDateTime := EncodeDate(year, month, day);
        Result    := True;
      end
     else
      if AsTime(aPyObject, hour, minute, second, microsecond) then
        begin
          aDateTime := EncodeTime(hour, minute, second, microsecond div 1000);
          Result    := True;
        end
       else
        if AsDelta(aPyObject, day, second, microsecond) then
          begin
            aDateTime := day + (second / SECONDS_IN_A_DAY) + ((microsecond div 1000) / MILLISECONDS_IN_A_DAY);
            Result    := True;
          end
         else
          Result := TPyTuple.AsDateTime(aPyObject, aDateTime);
end;

class function TPyDateTime.FromDateTime(aDateTime: TDateTime): IPyObject;
var
  year, month, day, hour, minute, second, msecond: word;
begin
  DecodeDate(aDateTime, year, month, day);
  DecodeTime(aDateTime, hour, minute, second, msecond);

  Result := FromDateTime(year, month, day, hour, minute, second, msecond);
end;

class function TPyDateTime.FromDateTime(year, month, day, hour, minute, second, msecond: integer): IPyObject;
var
  TempArgs : IPyObject;
begin
  Result := nil;

  if (month   in [1..12]) and
     (day     in [1..31]) and
     (hour    in [0..23]) and
     (minute  in [0..59]) and
     (second  in [0..59]) and
     assigned(GlobalP4PEngine) and
     assigned(GlobalP4PEngine.DateTimeModule) and
     assigned(GlobalP4PEngine.DateTimeModule.DateTimeType) and
     assigned(PyObject_Call) then
    begin
      TempArgs := TPyTuple.FromArray([year, month, day, hour, minute, second, msecond * 1000]);
      Result   := TPyObject.Wrap(PyObject_Call(PPyObject(GlobalP4PEngine.DateTimeModule), TempArgs.PyObject, nil));
    end;
end;

class function TPyDateTime.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  if (aVarType = varDate) then
    Result := FromDateTime(TDateTime(aVariant))
   else
    Result := nil;
end;

class function TPyDateTime.FromVariant(const aVariant: Variant): IPyObject;
var
  TempType    : TVarType;
  TempVariant : Variant;
begin
  TempVariant := aVariant;
  TempType    := varByRef or varVariant;

  while VarType(TempVariant) = TempType do
    TempVariant := Variant(PVarData(TVarData(TempVariant).VPointer)^);

  Result := FromVariant(TempVariant, VarType(TempVariant) and (VarTypeMask or VarArray));
end;

end.
