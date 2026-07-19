unit uP4P.PyRefTracer;

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
  TPyRefTracer = class
    public
      class function SetTracer(tracer: PyRefTracer; data: Pointer): integer;
      class function GetTracer(var data: Pointer): PyRefTracer;
  end;

implementation

class function TPyRefTracer.SetTracer(tracer: PyRefTracer; data: Pointer): integer;
begin
  if assigned(PyRefTracer_SetTracer) then
    Result := PyRefTracer_SetTracer(tracer, data)
   else
    Result := 0;
end;

class function TPyRefTracer.GetTracer(var data: Pointer): PyRefTracer;
begin
  if assigned(PyRefTracer_GetTracer) then
    Result := PyRefTracer_GetTracer(data)
   else
    Result := nil;
end;

end.
