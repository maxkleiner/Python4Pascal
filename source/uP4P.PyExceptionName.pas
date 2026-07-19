unit uP4P.PyExceptionName;

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
  TPyExceptionName = class
    public
      class function Name_(const ob: IPyObject): string;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyExceptionName.Name_(const ob: IPyObject): string;
begin
  if assigned(PyExceptionClass_Name) and
     TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToString(PyExceptionClass_Name(ob.PyObject))
   else
    Result := '';
end;

end.
