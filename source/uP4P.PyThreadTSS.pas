unit uP4P.PyThreadTSS;

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
  TPyThreadTSS = class(TInterfacedObject, IPyThreadTSS)
    protected
      FKey : PPy_tss_t;

      function GetInitialized: boolean;
      function GetKey: PPy_tss_t;
      function GetIsCreated: boolean;
      function GetValue: pointer;

      procedure SetValue(value: pointer);

      procedure TSSAlloc;
      procedure TSSFree;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      function    TSSCreate: boolean;
      procedure   TSSDelete;

      property Initialized : boolean     read GetInitialized;
      property Key         : PPy_tss_t   read GetKey;
      property IsCreated   : boolean     read GetIsCreated;
      property Value       : pointer     read GetValue        write SetValue;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

constructor TPyThreadTSS.Create;
begin
  inherited Create;

  FKey := nil;
end;

destructor TPyThreadTSS.Destroy;
begin
  try
    if IsCreated then TSSDelete;

    TSSFree;
  finally
    inherited Destroy;
  end;
end;

procedure TPyThreadTSS.AfterConstruction;
begin
  inherited AfterConstruction;

  TSSAlloc;
end;

procedure TPyThreadTSS.TSSAlloc;
begin
  if not(Initialized) and assigned(PyThread_tss_alloc) then
    FKey := PyThread_tss_alloc();
end;

procedure TPyThreadTSS.TSSFree;
begin
  if Initialized and assigned(PyThread_tss_free) then
    begin
      PyThread_tss_free(FKey);
      FKey := nil;
    end;
end;

function TPyThreadTSS.TSSCreate: boolean;
begin
  Result := Initialized and
            assigned(PyThread_tss_create) and
            (PyThread_tss_create(FKey) = 0);
end;

procedure TPyThreadTSS.TSSDelete;
begin
  if Initialized and
     assigned(PyThread_tss_delete) then
    PyThread_tss_delete(FKey);
end;

function TPyThreadTSS.GetInitialized: boolean;
begin
  Result := (FKey <> nil);
end;

function TPyThreadTSS.GetKey: PPy_tss_t;
begin
  Result := FKey;
end;

function TPyThreadTSS.GetIsCreated: boolean;
begin
  Result := Initialized and
            assigned(PyThread_tss_is_created) and
            (PyThread_tss_is_created(FKey) <> 0);
end;


function TPyThreadTSS.GetValue: pointer;
begin
  if Initialized and assigned(PyThread_tss_get) then
    Result := PyThread_tss_get(FKey)
   else
    Result := nil;
end;

procedure TPyThreadTSS.SetValue(value: pointer);
begin
  if Initialized and assigned(PyThread_tss_set) then
    PyThread_tss_set(FKey, value);
end;

end.
