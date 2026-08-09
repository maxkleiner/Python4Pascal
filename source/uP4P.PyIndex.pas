unit uP4P.PyIndex;

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
  /// Helper class for all PyIndex_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/hash.html#pyhash-api">See the article about PyHash API.</see></para>
  /// </remarks>
  TPyIndex = class
    public
      /// <summary>
      /// <para>Returns True if o is an index integer (has the nb_index slot
      /// of the tp_as_number structure filled in), and False otherwise.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
  end;

implementation

class function TPyIndex.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyIndex_Check) and
            TPyObject.IsInitialized(o) and
            (PyIndex_Check(o.PyObject) <> 0);
end;

end.
