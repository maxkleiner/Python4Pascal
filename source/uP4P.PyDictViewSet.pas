unit uP4P.PyDictViewSet;

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
  uP4P.Interfaces;

type
  /// <summary>
  /// Helper class to check dictionary view sets.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#dictionary-objects">See the article about the Dictionary Objects.</see></para>
  /// </remarks>
  TPyDictViewSet = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a view of a set inside a dictionary.
      /// This is currently equivalent to TPyDictKeys.Check(aPyObject) or
      /// TPyDictItems.Check(aPyObject). This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PyDictKeys, uP4P.PyDictItems;

class function TPyDictViewSet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyDictKeys.Check(aPyObject) or
            TPyDictItems.Check(aPyObject);
end;

end.
