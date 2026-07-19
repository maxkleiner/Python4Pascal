unit uP4P.PyWideStringList;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces;

type
  TPyWideStringList = class
    public
      class function Append(aList: PPyWideStringList; const aItem: string): IPyStatus;
      class function Insert(aList: PPyWideStringList; aIndex: integer; const aItem: string): IPyStatus;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyStatus;

class function TPyWideStringList.Append(aList: PPyWideStringList; const aItem: string): IPyStatus;
var
  TempItem : WCharTString;
begin
  if assigned(aList) and assigned(PyWideStringList_Append) then
    begin
      TempItem := StringToPyWCharTString(aItem);
      Result   := TPyStatus.Create(PyWideStringList_Append(aList, PWCharT(TempItem)));
    end
   else
    Result := nil;
end;

class function TPyWideStringList.Insert(aList: PPyWideStringList; aIndex: integer; const aItem: string): IPyStatus;
var
  TempItem : WCharTString;
begin
  if assigned(aList) and assigned(PyWideStringList_Insert) then
    begin
      TempItem := StringToPyWCharTString(aItem);
      Result   := TPyStatus.Create(PyWideStringList_Insert(aList, aIndex, PWCharT(TempItem)));
    end
   else
    Result := nil;
end;

end.
