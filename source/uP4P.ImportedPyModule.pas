unit uP4P.ImportedPyModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes;
  {$ELSE}
    Classes;
  {$ENDIF}

type
  /// <summary>
  /// <para>TImportedPyModule is the base class for imported modules.</para>
  /// </summary>
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

uses
  uP4P.Py;

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
  TPy.DecRef(aObject);
  aObject := nil;
end;

end.
