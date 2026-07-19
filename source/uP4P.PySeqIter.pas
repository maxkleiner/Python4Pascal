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
  TPySeqIter = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
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
