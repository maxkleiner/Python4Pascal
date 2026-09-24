unit uP4P.PyArg;

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
  /// Helper class for all PyArg_* methods.
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/arg.html#parsing-arguments-and-building-values">See the article about Parsing arguments and building values.</see></para>
  /// </remarks>
  TPyArg = class
    public
      /// <summary>
      /// <para>Ensure that the keys in the keywords argument dictionary are
      /// strings. This is only needed if TPyArg.ParseTupleAndKeywords() is not
      /// used, since the latter already does this check.</para>
      /// <para>Added in version 3.2.</para>
      /// </summary>
      class function ValidateKeywordArguments(const kwargs: IPyObject): boolean;
  end;

implementation

class function TPyArg.ValidateKeywordArguments(const kwargs: IPyObject): boolean;
begin
  Result := assigned(PyArg_ValidateKeywordArguments) and
            TPyObject.IsInitialized(kwargs) and
            (PyArg_ValidateKeywordArguments(kwargs.PyObject) <> 0);
end;

end.
