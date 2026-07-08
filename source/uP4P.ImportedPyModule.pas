unit uP4P.ImportedPyModule;

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
  uP4P.LibFunctions, uP4P.Types;

type
  TImportedPyModule = class
    protected
      procedure DecRef(var aObject : Pointer);
      procedure Import; virtual; abstract;
      procedure Initialize; virtual; abstract;
      procedure Finalize; virtual; abstract;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
  end;

implementation

constructor TImportedPyModule.Create;
begin
  inherited Create;

  Initialize;
end;

destructor TImportedPyModule.Destroy;
begin
  try
    Finalize;
  finally
    inherited Destroy;
  end;
end;

procedure TImportedPyModule.AfterConstruction;
begin
  inherited AfterConstruction;

  Import;
end;

procedure TImportedPyModule.DecRef(var aObject : Pointer);
begin
  if assigned(Py_DecRef) and assigned(aObject) then
    try
      Py_DecRef(PPyObject(aObject));
    finally
      aObject := nil;
    end;
end;

end.
