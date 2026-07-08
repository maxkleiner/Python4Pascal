unit uP4P.PyDateTime;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.Engine;

type
  TPyDateTime = class
    public
      class function AsDate(const aPyObject: IPyObject; var year, month, day: integer): boolean;
      class function AsTime(const aPyObject: IPyObject; var hour, minute, second, microsecond: integer): boolean;
      class function AsDelta(const aPyObject: IPyObject; var days, seconds, microseconds: integer): boolean;
      class function AsTupleDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, weekday, yearday, isdst: integer): boolean;
      class function AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, microsecond: integer): boolean; overload;
      class function AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean; overload;
  end;

implementation

uses
  uP4P.PyTuple, uP4P.PyLong;

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

class function TPyDateTime.AsTupleDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, weekday, yearday, isdst: integer): boolean;
var
  TempYear, TempMonth, TempDay, TempHour, TempMinute, TempSecond, TempWeekDay, TempYearDay, TempDST : IPyObject;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     TPyTuple.Check(aPyObject) and
     (TPyTuple.Size(aPyObject) = 9) then
    begin
      TempYear    := TPyTuple.GetItem(aPyObject, 0);
      TempMonth   := TPyTuple.GetItem(aPyObject, 1);
      TempDay     := TPyTuple.GetItem(aPyObject, 2);
      TempHour    := TPyTuple.GetItem(aPyObject, 3);
      TempMinute  := TPyTuple.GetItem(aPyObject, 4);
      TempSecond  := TPyTuple.GetItem(aPyObject, 5);
      TempWeekDay := TPyTuple.GetItem(aPyObject, 6);
      TempYearDay := TPyTuple.GetItem(aPyObject, 7);
      TempDST     := TPyTuple.GetItem(aPyObject, 8);

      if TPyLong.Check(TempYear) and
         TPyLong.Check(TempMonth) and
         TPyLong.Check(TempDay) and
         TPyLong.Check(TempHour) and
         TPyLong.Check(TempMinute) and
         TPyLong.Check(TempSecond) and
         TPyLong.Check(TempWeekDay) and
         TPyLong.Check(TempYearDay) and
         TPyLong.Check(TempDST) then
        begin
          year    := TempYear.AsInteger;
          month   := TempMonth.AsInteger;
          day     := TempDay.AsInteger;
          hour    := TempHour.AsInteger;
          minute  := TempMinute.AsInteger;
          second  := TempSecond.AsInteger;
          weekday := TempWeekDay.AsInteger;
          yearday := TempYearDay.AsInteger;
          isdst   := TempDST.AsInteger;

          Result := (month   in [1..12]) and
                    (day     in [1..31]) and
                    (hour    in [0..23]) and
                    (minute  in [0..59]) and
                    (second  in [0..59]) and
                    (weekday in [0..6])  and
                    (yearday >= 0)  and (year  <= 366) and
                    (isdst   >= -1) and (isdst <= 1);
        end;
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
  year, month, day, hour, minute, second, microsecond, weekday, yearday, isdst: integer;
begin
  Result := False;

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
          if AsTupleDateTime(aPyObject, year, month, day, hour, minute, second, weekday, yearday, isdst) then
            begin
              aDateTime := EncodeDate(year, month, day) + EncodeTime(hour, minute, second, 0);
              Result    := True;
            end;
end;

end.
