unit uP4P.PyIter;

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
  TPyIter = class
    public
      class function Check(const o: IPyObject): boolean;
      class function NextItem(const iter: IPyObject; out item: IPyObject): integer;
      class function Next(const iter: IPyObject): IPyObject;
      class function Send(const iter, arg: IPyObject; out presult: IPyObject): PySendResult;
  end;

implementation

class function TPyIter.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyIter_Check) and
            TPyObject.IsInitialized(o) and
            (PyIter_Check(o.PyObject) <> 0);
end;

class function TPyIter.NextItem(const iter: IPyObject; out item: IPyObject): integer;
var
  TempItem : PPyObject;
begin
  Result := -1;
  item   := nil;

  if assigned(PyIter_NextItem) and
     TPyObject.IsInitialized(iter) then
    begin
      Result := PyIter_NextItem(iter.PyObject, TempItem);
      if (Result = 1) then
        item := TPyObject.Wrap(TempItem);
    end;
end;

class function TPyIter.Next(const iter: IPyObject): IPyObject;
begin
  if assigned(PyIter_Next) and
     TPyObject.IsInitialized(iter) then
    Result := TPyObject.Wrap(PyIter_Next(iter.PyObject))
   else
    Result := nil;
end;

class function TPyIter.Send(const iter, arg: IPyObject; out presult: IPyObject): PySendResult;
var
  TempPResult : PPyObject;
begin
  Result  := PYGEN_ERROR;
  presult := nil;

  if assigned(PyIter_Send) and
     TPyObject.IsInitialized(iter) and
     TPyObject.IsInitialized(arg) then
    begin
      Result := PyIter_Send(iter.PyObject, arg.PyObject, TempPResult);
      if (Result <> PYGEN_ERROR) then
        presult := TPyObject.Wrap(TempPResult);
    end;
end;

end.
