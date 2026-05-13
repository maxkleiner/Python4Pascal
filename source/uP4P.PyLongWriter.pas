unit uP4P.PyLongWriter;

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
  TPyLongWriter = class(TInterfacedObject, IPyLongWriter)
    protected
      FPyLongWriter : PPyLongWriter;

      function GetInitialized: boolean;
      procedure Discard;

    public
      constructor Create(writer: PPyLongWriter);
      destructor  Destroy; override;
      function    Finish: IPyObject;

      class function New(negative: boolean; ndigits: Py_ssize_t; var digits: Pointer): IPyLongWriter;

      property Initialized : boolean read GetInitialized;
  end;

implementation

constructor TPyLongWriter.Create(writer: PPyLongWriter);
begin
  inherited Create;
  FPyLongWriter := writer;
end;

destructor TPyLongWriter.Destroy;
begin
  Discard;
  inherited Destroy;
end;

function TPyLongWriter.GetInitialized: boolean;
begin
  Result := (FPyLongWriter <> nil);
end;

function TPyLongWriter.Finish: IPyObject;
var
  TempObject : PPyObject;
begin
  Result := nil;
  if Initialized and assigned(PyLongWriter_Finish) then
    begin
      TempObject := PyLongWriter_Finish(FPyLongWriter);

      if assigned(TempObject) then
        begin
          Result        := TPyObject.Wrap(TempObject);
          FPyLongWriter := nil;
        end;
    end;
end;

procedure TPyLongWriter.Discard;
begin
  if Initialized and assigned(PyLongWriter_Discard) then
    begin
      PyLongWriter_Discard(FPyLongWriter);
      FPyLongWriter := nil;
    end;
end;

class function TPyLongWriter.New(negative: boolean; ndigits: Py_ssize_t; var digits: Pointer): IPyLongWriter;
begin
  if assigned(PyLongWriter_Create) then
    Result := Create(PyLongWriter_Create(ord(negative), ndigits, digits))
   else
    Result := nil;
end;

end.
