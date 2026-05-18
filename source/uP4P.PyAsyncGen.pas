unit uP4P.PyAsyncGen;

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
  TPyAsyncGen = class
    public
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const frame, name_, qualname: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyFrame, uP4P.PyCode;

class function TPyAsyncGen.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyAsyncGen_Type);
end;

class function TPyAsyncGen.New(const frame, name_, qualname: IPyObject): IPyObject;
begin
  if assigned(PyAsyncGen_New) and
     TPyObject.IsInitialized(frame) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(qualname) then
    Result := TPyObject.Wrap(PyAsyncGen_New(PPyFrameObject(frame.PyObject), name_.PyObject, qualname.PyObject))
   else
    Result := nil;
end;

end.
