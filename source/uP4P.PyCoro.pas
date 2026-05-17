unit uP4P.PyCoro;

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
  TPyCoro = class
    public
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const frame: IPyFrameObject; const name_, qualname: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyFrame, uP4P.PyCode;

class function TPyCoro.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCoro_Type);
end;

class function TPyCoro.New(const frame: IPyFrameObject; const name_, qualname: IPyObject): IPyObject;
begin
  if assigned(PyCoro_New) and
     TPyFrame.IsInitialized(frame) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(qualname) then
    Result := TPyObject.Wrap(PyCoro_New(frame.PyFrameObject, name_.PyObject, qualname.PyObject))
   else
    Result := nil;
end;

end.
