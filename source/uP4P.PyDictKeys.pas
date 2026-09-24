unit uP4P.PyDictKeys;

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
  uP4P.LibFunctions, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class to check dictionary keys.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#dictionary-objects">See the article about the Dictionary Objects.</see></para>
  /// </remarks>
  TPyDictKeys = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is an instance of a dictionary keys
      /// view. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyDictKeys.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyDictKeys_Type);
end;

end.
