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
  /// <summary>
  /// Helper class for all PyWideStringList_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pywidestringlist">See the article about PyWideStringList.</see></para>
  /// </remarks>
  TPyWideStringList = class
    public
      /// <summary>
      /// <para>Append item to list. Python must be preinitialized to call this
      /// function.</para>
      /// </summary>
      class function Append(aList: PPyWideStringList; const aItem: string): IPyStatus;
      /// <summary>
      /// <para>Insert item into list at index. If index is greater than or
      /// equal to list length, append item to list. index must be greater than
      /// or equal to 0. Python must be preinitialized to call this
      /// function.</para>
      /// </summary>
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
