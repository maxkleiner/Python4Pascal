unit uP4P.PyTimeModule;

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
  TPyTimeModule = class
    protected
      FTimeStructType : Pointer;

      procedure DecRef(var aPyTypeObject : Pointer);
      procedure Import;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      function    CheckTimeStruct(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PyImport;

constructor TPyTimeModule.Create;
begin
  inherited Create;

  FTimeStructType := nil;
end;

destructor TPyTimeModule.Destroy;
begin
  DecRef(FTimeStructType);

  inherited Destroy;
end;

procedure TPyTimeModule.AfterConstruction;
begin
  inherited AfterConstruction;

  Import;
end;

procedure TPyTimeModule.DecRef(var aPyTypeObject : Pointer);
begin
  if assigned(Py_DecRef) and assigned(aPyTypeObject) then
    begin
      Py_DecRef(PPyObject(aPyTypeObject));
      aPyTypeObject := nil;
    end;
end;

procedure TPyTimeModule.Import;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('time');

  if TPyObject.IsInitialized(TempModule) then
    TempModule.GetOptionalAttrString2('struct_time', FTimeStructType);
end;

function TPyTimeModule.CheckTimeStruct(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeStructType);
end;

end.
