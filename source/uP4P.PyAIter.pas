unit uP4P.PyAIter;

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
  /// Helper class to check AsyncIterator objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/iter.html#iterator-protocol">See the Iterator Protocol article.</see></para>
  /// </remarks>
  TPyAIter = class
    public
      /// <summary>
      /// <para>Return True if the object o provides the AsyncIterator
      /// protocol, and False otherwise. This function always succeeds.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
  end;

implementation

class function TPyAIter.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyAIter_Check) and
            TPyObject.IsInitialized(o) and
            (PyAIter_Check(o.PyObject) <> 0);
end;

end.
