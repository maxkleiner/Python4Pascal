unit uP4P.PyTimeStruct;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyTimeStruct = class
    public
      class function AsDateTime(const aPyObject: IPyObject; var tm_year, tm_mon, tm_mday, tm_hour, tm_min, tm_sec, tm_wday, tm_yday, tm_isdst, tm_gmtoff: integer; var tm_zone: string): boolean; overload;
      class function AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean; overload;
  end;

implementation

uses
  uP4P.Engine;

class function TPyTimeStruct.AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean;
var
  tm_year, tm_mon, tm_mday, tm_hour, tm_min, tm_sec, tm_wday, tm_yday, tm_isdst, tm_gmtoff: integer;
  tm_zone: string;
begin
  Result := False;

  if AsDateTime(aPyObject, tm_year, tm_mon, tm_mday, tm_hour, tm_min, tm_sec, tm_wday, tm_yday, tm_isdst, tm_gmtoff, tm_zone) then
    begin
      aDateTime := EncodeDate(tm_year, tm_mon, tm_mday) + EncodeTime(tm_hour, tm_min, tm_sec, 0);
      Result    := True;
    end;
end;

class function TPyTimeStruct.AsDateTime(const aPyObject: IPyObject;
                                        var tm_year, tm_mon, tm_mday: integer;
                                        var tm_hour, tm_min, tm_sec: integer;
                                        var tm_wday, tm_yday, tm_isdst, tm_gmtoff: integer;
                                        var tm_zone: string): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.TimeModule.CheckTimeStruct(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('tm_year',   tm_year);
      aPyObject.GetAttrAsInteger('tm_mon',    tm_mon);
      aPyObject.GetAttrAsInteger('tm_mday',   tm_mday);
      aPyObject.GetAttrAsInteger('tm_hour',   tm_hour);
      aPyObject.GetAttrAsInteger('tm_min',    tm_min);
      aPyObject.GetAttrAsInteger('tm_sec',    tm_sec);
      aPyObject.GetAttrAsInteger('tm_wday',   tm_wday);
      aPyObject.GetAttrAsInteger('tm_yday',   tm_yday);
      aPyObject.GetAttrAsInteger('tm_isdst',  tm_isdst);
      aPyObject.GetAttrAsInteger('tm_gmtoff', tm_gmtoff);
      aPyObject.GetAttrAsString('tm_zone',    tm_zone);

      Result := True;
    end;
end;

end.
