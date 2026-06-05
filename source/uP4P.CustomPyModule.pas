unit uP4P.CustomPyModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TCustomPyModule = class(TInterfacedObject, ICustomPyModule)
    protected
      FModule      : IPyObject;
      FModuleDef   : PyModuleDef;
      FName        : AnsiString;
      FDocStrings  : AnsiString;
      FSlots       : PyModuleDefSlotArray;
      FMethods     : PyMethodDefArray;

      function GetName: string;
      function GetDocStrings: string;

      procedure SetName(const aValue: string);
      procedure SetDocStrings(const aValue: string);

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;

      property Name        : string       read GetName               write SetName;
      property DocStrings  : string       read GetDocStrings         write SetDocStrings;
  end;

implementation

uses
  uP4P.MiscFunctions;

constructor TCustomPyModule.Create;
begin
  inherited Create;

  FModule      := nil;
  FName        := '';
  FDocStrings  := '';
end;

destructor TCustomPyModule.Destroy;
begin

  inherited Destroy;
end;

procedure TCustomPyModule.AfterConstruction;
begin
  inherited AfterConstruction;

end;

function TCustomPyModule.GetName : string;
begin
  Result := PyUTF8ToString(PAnsiChar(FName));
end;

function TCustomPyModule.GetDocStrings: string;
begin
  Result := PyUTF8ToString(PAnsiChar(FDocStrings));
end;

procedure TCustomPyModule.SetName(const aValue: string);
begin
  FName := StringToPyUTF8(aValue);
end;

procedure TCustomPyModule.SetDocStrings(const aValue: string);
begin
  FDocStrings := StringToPyUTF8(aValue);
end;

end.
