unit uP4P.PyCriticalSection;

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
  TPyCriticalSection = class(TInterfacedObject, IPyCriticalSection)
    protected
      FPyCriticalSection : PyCriticalSection;

      function GetPyCriticalSection: Pointer;

    public
      constructor Create; overload;
      constructor Create(const aCriticalSection: PyCriticalSection); overload;

      procedure Begin_(const op: IPyObject);
      procedure BeginMutex(const m: IPyMutex);
      procedure End_;

      property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

  TPyCriticalSection2 = class(TInterfacedObject, IPyCriticalSection2)
    protected
      FPyCriticalSection : PyCriticalSection2;

      function GetPyCriticalSection: Pointer;

    public
      constructor Create; overload;
      constructor Create(const aCriticalSection: PyCriticalSection2); overload;

      procedure Begin_(const a, b: IPyObject);
      procedure BeginMutex(const m1, m2: IPyMutex);
      procedure End_;

      property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

implementation

// TPyCriticalSection

constructor TPyCriticalSection.Create;
begin
  inherited Create;

  FillChar(FPyCriticalSection, SizeOf(FPyCriticalSection), #0);
end;

constructor TPyCriticalSection.Create(const aCriticalSection: PyCriticalSection);
begin
  inherited Create;

  FPyCriticalSection := aCriticalSection;
end;

procedure TPyCriticalSection.Begin_(const op: IPyObject);
begin
  if assigned(PyCriticalSection_Begin) then
    PyCriticalSection_Begin(PyCriticalSection, op.PyObject);
end;

procedure TPyCriticalSection.BeginMutex(const m: IPyMutex);
begin
  if assigned(PyCriticalSection_BeginMutex) then
    PyCriticalSection_BeginMutex(PyCriticalSection, m.PyMutex);
end;

procedure TPyCriticalSection.End_;
begin
  if assigned(PyCriticalSection_End) then
    PyCriticalSection_End(PyCriticalSection);
end;

function TPyCriticalSection.GetPyCriticalSection: Pointer;
begin
  Result := @FPyCriticalSection;
end;

// TPyCriticalSection2

constructor TPyCriticalSection2.Create;
begin
  inherited Create;

  FillChar(FPyCriticalSection, SizeOf(FPyCriticalSection), #0);
end;

constructor TPyCriticalSection2.Create(const aCriticalSection: PyCriticalSection2);
begin
  inherited Create;

  FPyCriticalSection := aCriticalSection;
end;

procedure TPyCriticalSection2.Begin_(const a, b: IPyObject);
begin
  if assigned(PyCriticalSection2_Begin) then
    PyCriticalSection2_Begin(PyCriticalSection, a.PyObject, b.PyObject);
end;

procedure TPyCriticalSection2.BeginMutex(const m1, m2: IPyMutex);
begin
  if assigned(PyCriticalSection2_BeginMutex) then
    PyCriticalSection2_BeginMutex(PyCriticalSection, m1.PyMutex, m2.PyMutex);
end;

procedure TPyCriticalSection2.End_;
begin
  if assigned(PyCriticalSection2_End) then
    PyCriticalSection2_End(PyCriticalSection);
end;

function TPyCriticalSection2.GetPyCriticalSection: Pointer;
begin
  Result := @FPyCriticalSection;
end;

end.
