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
  /// <summary>
  /// <para>A critical section protected by one mutex. You *CANNOT* use nested
  /// critical sections to lock more than one object at once.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#python-critical-section-api">See the Python critical section API article.</see></para>
  /// </remarks>
  TPyCriticalSection = class(TInterfacedObject, IPyCriticalSection)
    protected
      FPyCriticalSection : PyCriticalSection;

      function GetPyCriticalSection: Pointer;

    public
      constructor Create; overload;
      /// <summary>
      /// <para>Overloaded constructor using an existing PyCriticalSection.</para>
      /// </summary>
      constructor Create(const aCriticalSection: PyCriticalSection); overload;

      /// <summary>
      /// <para>Acquires the per-object lock for the object op and begins a
      /// critical section.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      procedure Begin_(const op: IPyObject);
      /// <summary>
      /// <para>Locks the mutex m and begins a critical section.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      procedure BeginMutex(const m: IPyMutex);
      /// <summary>
      /// <para>Ends the critical section and releases the per-object lock.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      procedure End_;
      /// <summary>
      /// <para>Pointer to the PyCriticalSection record.</para>
      /// </summary>
      property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

  /// <summary>
  /// <para>A critical section protected by two mutexes. You *CANNOT* use nested
  /// critical sections to lock more than one object at once.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#python-critical-section-api">See the Python critical section API article.</see></para>
  /// </remarks>
  TPyCriticalSection2 = class(TInterfacedObject, IPyCriticalSection2)
    protected
      FPyCriticalSection : PyCriticalSection2;

      function GetPyCriticalSection: Pointer;

    public
      constructor Create; overload;
      /// <summary>
      /// <para>Overloaded constructor using an existing PyCriticalSection2.</para>
      /// </summary>
      constructor Create(const aCriticalSection: PyCriticalSection2); overload;

      /// <summary>
      /// <para>Acquires the per-object locks for the objects a and b and begins
      /// a critical section. The locks are acquired in a consistent order
      /// (lowest address first) to avoid lock ordering deadlocks.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      procedure Begin_(const a, b: IPyObject);
      /// <summary>
      /// <para>Locks the mutexes m1 and m2 and begins a critical section.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      procedure BeginMutex(const m1, m2: IPyMutex);
      /// <summary>
      /// <para>Ends the critical section and releases the per-object locks.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      procedure End_;
      /// <summary>
      /// <para>Pointer to the PyCriticalSection2 record.</para>
      /// </summary>
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
