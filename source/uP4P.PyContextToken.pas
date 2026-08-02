unit uP4P.PyContextToken;

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
  /// Helper class to check PyContextToken_Type objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/contextvars.html#context-variables-objects">See the article about the Context Variables Objects.</see></para>
  /// </remarks>
  TPyContextToken = class
    public
      /// <summary>
      /// Return true if aPyObject is of type PyContextToken_Type.
      /// aPyObject must not be nil. This function always succeeds.
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyContextToken.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyContextToken_Type);
end;

end.
