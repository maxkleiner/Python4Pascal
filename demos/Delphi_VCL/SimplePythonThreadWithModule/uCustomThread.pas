unit uCustomThread;

interface

uses
  System.SysUtils,
  uP4P.Thread, uP4P.PyModule, uTestModule, uTestHeapType;

type
  TCustomThread = class(TP4PThread)
    protected
      FCode        : string;
      FTestModule  : TTestModule;
      FTestType    : TTestHeapType;

      procedure doOnExecutePython; override;
      procedure doOnFinalizeModules; override;
      procedure doOnDestroyModules; override;

      function  CreateModule: boolean;
      function  CreateType: boolean;

    public
      property Code : string read FCode write FCode;
  end;

implementation

uses
  uP4P.PyRun, uP4P.Types;

procedure TCustomThread.doOnExecutePython;
begin
  if CreateModule and CreateType then
    TPyRun.SimpleString(FCode);
end;

procedure TCustomThread.doOnFinalizeModules;
begin
  if assigned(FTestType) then
    FTestType.Finalize;

  if assigned(FTestModule) then
    FTestModule.Finalize;
end;

procedure TCustomThread.doOnDestroyModules;
begin
  if assigned(FTestType) then
    FreeAndNil(FTestType);

  if assigned(FTestModule) then
    FreeAndnil(FTestModule);
end;

function TCustomThread.CreateModule: boolean;
begin
  FTestModule                  := TTestModule.Create(TEST_MODULE_NAME);
  FTestModule.MultIntprSupport := piGilSupported;
  Result                       := FTestModule.Initialize;
end;

function TCustomThread.CreateType: boolean;
begin
  FTestType            := TTestHeapType.Create(TEST_TYPE_NAME);
  FTestType.DocStrings := 'test docstring';

  Result := FTestType.Initialize and
            TPyModule.AddObjectRef(FTestModule.Module, TEST_TYPE_NAME, FTestType.HeapType);
end;

end.
