unit uP4P.PyTraceBack;

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
  TPyTraceBack = class
    public
      class function Here(const f: IPyFrameObject): boolean;
      class function Print(const tb, f: IPyObject): boolean;
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyFrame;

class function TPyTraceBack.Here(const f: IPyFrameObject): boolean;
begin
  Result := TPyFrame.IsInitialized(f) and
            assigned(PyTraceBack_Here) and
            (PyTraceBack_Here(f.PyFrameObject) = 0);
end;

class function TPyTraceBack.Print(const tb, f: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(tb) and
            TPyObject.IsInitialized(f) and
            assigned(PyTraceBack_Print) and
            (PyTraceBack_Print(tb.PyObject, f.PyObject) = 0);
end;

class function TPyTraceBack.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyTraceBack_Type);
end;

end.
