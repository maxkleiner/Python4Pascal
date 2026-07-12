unit uP4P.PyTuple;

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
  TPyTuple = class
    public
      class function Size(const p: IPyObject): Py_ssize_t;
      class function GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject; overload;
      class function GetItem(const p: IPyObject; const pos: TVarData): IPyObject; overload;
      class function SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject): boolean; overload;
      class function SetItem(const p: IPyObject; const pos, o: TVarData): boolean; overload;
      class function GetSlice(const p: IPyObject; low, high: Py_ssize_t): IPyObject;
      class function New(len: Py_ssize_t): IPyObject;
      class function Pack(const objects: IPyObjectArray): IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function FromArray(const aItems: array of const): IPyObject;
      class function FromStrings(const aStringList: TStringList): IPyObject;
      class function FromDateTime(year, month, day, hour, minute, second, weekday, yearday: integer; DST: TPyDaylightSavingTime): IPyObject; overload;
      class function FromDateTime(aDateTime : TDateTime; DST: TPyDaylightSavingTime = dstUnknown): IPyObject; overload;
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      class function FromVarDataArray(const Arguments: TVarDataArray): IPyObject;
      class function AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, weekday, yearday: integer; var DST: TPyDaylightSavingTime): boolean; overload;
      class function AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean; overload;
      class function AsStrings(const aPyObject: IPyObject; var aStringList: TStringList): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyUnicode, uP4P.PyLong;

class function TPyTuple.New(len: Py_ssize_t): IPyObject;
begin
  if assigned(PyTuple_New) then
    Result := TPyObject.Wrap(PyTuple_New(len))
   else
    Result := nil;
end;

class function TPyTuple.Pack(const objects: IPyObjectArray): IPyObject;
var
  TempObject: PPyObject;
  n: Py_ssize_t;
begin
  Result := nil;
  if not(assigned(PyTuple_Pack)) then exit;

  //TODO: Find a way to call PyTuple_Pack with a variable number of arguments using an open array with an arbitrary length.

  n := length(objects);
  case n of
    10 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject, objects[7].PyObject, objects[8].PyObject, objects[9].PyObject);
    09 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject, objects[7].PyObject, objects[8].PyObject);
    08 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject, objects[7].PyObject);
    07 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject);
    06 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject);
    05 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject);
    04 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject);
    03 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject);
    02 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject);
    01 : TempObject := PyTuple_Pack(n, objects[0].PyObject);
    else TempObject := nil;
  end;

  Result := TPyObject.Wrap(TempObject);
end;

class function TPyTuple.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_TUPLE_SUBCLASS));
end;

class function TPyTuple.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyTuple_Type);
end;

class function TPyTuple.FromArray(const aItems: array of const): IPyObject;
var
  i, TempLen : integer;
begin
  Result  := nil;
  TempLen := length(aItems);

  if (TempLen > 0) then
    begin
      Result := TPyTuple.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyTuple.SetItem(Result, i, TPyObject.FromVarRec(aItems[i]));
    end;
end;

class function TPyTuple.FromStrings(const aStringList: TStringList): IPyObject;
var
  i, TempLen : integer;
begin
  Result  := nil;
  TempLen := aStringList.Count;

  if (TempLen > 0) then
    begin
      Result := TPyTuple.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyTuple.SetItem(Result, i, TPyUnicode.FromString(aStringList[i]));
    end;
end;

class function TPyTuple.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  if (aVarType = varDate) then
    Result := FromDateTime(TDateTime(aVariant))
   else
    Result := nil;
end;

class function TPyTuple.FromVarDataArray(const Arguments: TVarDataArray): IPyObject;
var
  i, TempLen : integer;
begin
  Result := nil;

  if (Length(Arguments) = 1) and VarIsEmptyParam(Variant(Arguments[0])) then
    TempLen := 0
   else
    TempLen := Length(Arguments);

  if (TempLen > 0) then
    begin
      Result := TPyTuple.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyTuple.SetItem(Result, i, TPyObject.FromVarData(Arguments[i]));
    end;
end;

class function TPyTuple.FromVariant(const aVariant: Variant): IPyObject;
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

class function TPyTuple.FromDateTime(aDateTime : TDateTime; DST: TPyDaylightSavingTime): IPyObject;
var
  year, month, day, hour, minute, second, msecond: word;
  weekday, yearday: integer;
begin
  DecodeDate(aDateTime, year, month, day);
  DecodeTime(aDateTime, hour, minute, second, msecond);

  // In Python, Monday is the first day (=0)
  weekday := (DayOfWeek(aDateTime) + 7 - 2) mod 7;
  yearday := Round(EncodeDate(year, month, day) - EncodeDate(year, 1, 1)) + 1;
  Result  := FromDateTime(year, month, day, hour, minute, second, weekday, yearday, DST);
end;

class function TPyTuple.FromDateTime(year, month, day, hour, minute, second, weekday, yearday: integer; DST: TPyDaylightSavingTime): IPyObject;
begin
  Result := nil;

  if (month   in [1..12]) and
     (day     in [1..31]) and
     (hour    in [0..23]) and
     (minute  in [0..59]) and
     (second  in [0..59]) and
     (weekday in [0..6])  and
     (yearday >= 0) and (yearday <= 366) then
    begin
      Result := TPyTuple.New(9);

      TPyTuple.SetItem(Result, 0, TPyLong.FromLong(year));
      TPyTuple.SetItem(Result, 1, TPyLong.FromLong(month));
      TPyTuple.SetItem(Result, 2, TPyLong.FromLong(day));
      TPyTuple.SetItem(Result, 3, TPyLong.FromLong(hour));
      TPyTuple.SetItem(Result, 4, TPyLong.FromLong(minute));
      TPyTuple.SetItem(Result, 5, TPyLong.FromLong(second));
      TPyTuple.SetItem(Result, 6, TPyLong.FromLong(weekday));
      TPyTuple.SetItem(Result, 7, TPyLong.FromLong(yearday));
      TPyTuple.SetItem(Result, 8, TPyLong.FromLong(integer(DST)));
    end;
end;

class function TPyTuple.AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean;
var
  year, month, day, hour, minute, second, weekday, yearday : integer;
  DST : TPyDaylightSavingTime;
begin
  Result := False;

  if AsDateTime(aPyObject, year, month, day, hour, minute, second, weekday, yearday, DST) then
    begin
      aDateTime := EncodeDate(year, month, day) + EncodeTime(hour, minute, second, 0);
      Result    := True;
    end;
end;

class function TPyTuple.AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, weekday, yearday: integer; var DST: TPyDaylightSavingTime): boolean;
var
  TempYear, TempMonth, TempDay, TempHour, TempMinute, TempSecond, TempWeekDay, TempYearDay, TempDST : IPyObject;
  TempDSTInt : integer;
begin
  Result := False;

  if Check(aPyObject) and
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

      if TPyLong.Check(TempYear)    and
         TPyLong.Check(TempMonth)   and
         TPyLong.Check(TempDay)     and
         TPyLong.Check(TempHour)    and
         TPyLong.Check(TempMinute)  and
         TPyLong.Check(TempSecond)  and
         TPyLong.Check(TempWeekDay) and
         TPyLong.Check(TempYearDay) and
         TPyLong.Check(TempDST)     then
        begin
          year       := TempYear.AsInteger;
          month      := TempMonth.AsInteger;
          day        := TempDay.AsInteger;
          hour       := TempHour.AsInteger;
          minute     := TempMinute.AsInteger;
          second     := TempSecond.AsInteger;
          weekday    := TempWeekDay.AsInteger;
          yearday    := TempYearDay.AsInteger;
          TempDSTInt := TempDST.AsInteger;

          if (month   in [1..12]) and
             (day     in [1..31]) and
             (hour    in [0..23]) and
             (minute  in [0..59]) and
             (second  in [0..59]) and
             (weekday in [0..6])  and
             (yearday >= 0)  and (yearday <= 366) and
             (TempDSTInt >= -1) and (TempDSTInt <= 1) then
            begin
              DST    := TPyDaylightSavingTime(TempDSTInt);
              Result := True;
            end;
        end;
    end;
end;

class function TPyTuple.AsStrings(const aPyObject: IPyObject; var aStringList: TStringList): boolean;
var
  i, TempLen : integer;
  TempItem : IPyObject;
begin
  Result  := False;
  TempLen := TPyTuple.Size(aPyObject);

  if (TempLen > 0) then
    begin
      if not(assigned(aStringList)) then
        aStringList := TStringList.Create
       else
        aStringList.Clear;

      for i := 0 to pred(TempLen) do
        begin
          TempItem := TPyTuple.GetItem(aPyObject, i);

          if TPyObject.IsInitialized(TempItem) then
            aStringList.Add(TempItem.AsString);
        end;

      Result := (aStringList.Count > 0);
    end;
end;

class function TPyTuple.Size(const p: IPyObject): Py_ssize_t;
begin
  if assigned(PyTuple_Size) and
     TPyObject.IsInitialized(p) then
    Result := PyTuple_Size(p.PyObject)
   else
    Result := -1;
end;

class function TPyTuple.GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
begin
  if assigned(PyTuple_GetItem) then
    Result := TPyObject.Wrap(PyTuple_GetItem(p.PyObject, pos), False)
   else
    Result := nil;
end;

class function TPyTuple.GetItem(const p: IPyObject; const pos: TVarData): IPyObject;
var
  TempPos : integer;
begin
  TempPos := Variant(pos);
  Result  := GetItem(p, TempPos);
end;

class function TPyTuple.SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject): boolean;
begin
  Result := assigned(PyTuple_SetItem) and
            TPyObject.IsInitialized(p) and
            TPyObject.IsInitialized(o) and
            (PyTuple_SetItem(p.PyObject, pos, o.UnWrap) = 0);
end;

class function TPyTuple.SetItem(const p: IPyObject; const pos, o: TVarData): boolean;
var
  TempPos : integer;
  TempObj : IPyObject;
begin
  try
    TempPos := Variant(pos);
    TempObj := TPyObject.FromVarData(o);
    Result  := SetItem(p, TempPos, TempObj);
  finally
    TempObj := nil;
  end;
end;

class function TPyTuple.GetSlice(const p: IPyObject; low, high: Py_ssize_t): IPyObject;
begin
  if assigned(PyTuple_GetSlice) then
    Result := TPyObject.Wrap(PyTuple_GetSlice(p.PyObject, low, high))
   else
    Result := nil;
end;

end.
