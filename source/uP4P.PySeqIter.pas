unit uP4P.PySeqIter;

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
  /// Helper class for all PySeqIter_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/iterator.html#iterator-objects">See the article about Iterator Objects.</see></para>
  /// </remarks>
  TPySeqIter = class
    public
      /// <summary>
      /// <para>Return true if the type of aPyObject is PySeqIter_Type.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return an iterator that works with a general sequence object,
      /// seq. The iteration ends when the sequence raises IndexError for the
      /// subscripting operation.</para>
      /// </summary>
      class function New(const seq: IPyObject): IPyObject;
  end;

implementation

class function TPySeqIter.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PySeqIter_Type);
end;

class function TPySeqIter.New(const seq: IPyObject): IPyObject;
begin
  if assigned(PySeqIter_New) and
     TPyObject.IsInitialized(seq) then
    Result := TPyObject.Wrap(PySeqIter_New(seq.PyObject))
   else
    Result := nil;
end;

end.
