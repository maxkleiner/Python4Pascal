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
  uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>Helper functions for the "struct_time" type, which was imported by
  /// the "time" module (See TPyTimeModule)</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/time.html">See the article about time - Time access and conversions.</see></para>
  /// </remarks>
  TPyTimeStruct = class
    public
      /// <summary>
      /// <para>Return the attributes values of the "struct_time" that represent
      /// a time.</para>
      /// </summary>
      class function AsDateTime(const aPyObject: IPyObject; var tm_year, tm_mon, tm_mday, tm_hour, tm_min, tm_sec, tm_wday, tm_yday, tm_isdst, tm_gmtoff: integer; var tm_zone: string): boolean; overload;
      /// <summary>
      /// <para>Convert a "struct_time" object to a TDateTime.</para>
      /// </summary>
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
  Result    := False;
  tm_year   := 0;
  tm_mon    := 0;
  tm_mday   := 0;
  tm_hour   := 0;
  tm_min    := 0;
  tm_sec    := 0;
  tm_wday   := 0;
  tm_yday   := 0;
  tm_isdst  := 0;
  tm_gmtoff := 0;
  tm_zone   := '';

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
