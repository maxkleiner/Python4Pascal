unit uP4P.PyRange;

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
  /// <summary>
  /// Helper class for all PyRange_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/iterator.html#range-objects">See the article about Range Objects.</see></para>
  /// </remarks>
  TPyRange = class
    public
      /// <summary>
      /// <para>Return true if the object aPyObject is an instance of a range
      /// object. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyRange.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyRange_Type);
end;

end.
