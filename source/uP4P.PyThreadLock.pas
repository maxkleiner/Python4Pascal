unit uP4P.PyThreadLock;

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
  TPyThreadLock = class(TInterfacedObject, IPyThreadLock)
    protected
      FLock : PyThread_type_lock;

      function GetInitialized: boolean;
      function GetLock: PyThread_type_lock;

      procedure AllocateLock;
      procedure FreeLock;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      function    AcquireLock(waitflag: boolean): PyLockStatus;
      function    AcquireLockTimed(microseconds: PY_TIMEOUT_T; intr_flag: boolean): PyLockStatus;
      procedure   ReleaseLock;

      property Initialized : boolean              read GetInitialized;
      property Lock        : PyThread_type_lock   read GetLock;
  end;

implementation

constructor TPyThreadLock.Create;
begin
  inherited Create;

  FLock := nil;
end;

destructor TPyThreadLock.Destroy;
begin
  FreeLock;

  inherited Destroy;
end;

procedure TPyThreadLock.AfterConstruction;
begin
  inherited AfterConstruction;

  AllocateLock;
end;

function TPyThreadLock.AcquireLock(waitflag: boolean): PyLockStatus;
begin
  if Initialized and assigned(PyThread_acquire_lock) then
    Result := PyLockStatus(PyThread_acquire_lock(Flock, ord(waitflag)))
   else
    Result := PY_LOCK_FAILURE;
end;

function TPyThreadLock.AcquireLockTimed(microseconds: PY_TIMEOUT_T; intr_flag: boolean): PyLockStatus;
begin
  if Initialized and assigned(PyThread_acquire_lock_timed) then
    Result := PyThread_acquire_lock_timed(FLock, microseconds, ord(intr_flag))
   else
    Result := PY_LOCK_FAILURE;
end;

function TPyThreadLock.GetInitialized: boolean;
begin
  Result := (FLock <> nil);
end;

function TPyThreadLock.GetLock: PyThread_type_lock;
begin
  Result := FLock;
end;

procedure TPyThreadLock.AllocateLock;
begin
  if not(Initialized) and assigned(PyThread_allocate_lock) then
    FLock := PyThread_allocate_lock();
end;

procedure TPyThreadLock.FreeLock;
begin
  if Initialized and assigned(PyThread_free_lock) then
    PyThread_free_lock(FLock);
end;

procedure TPyThreadLock.ReleaseLock;
begin
  if Initialized and assigned(PyThread_release_lock) then
    begin
      PyThread_release_lock(Flock);
      Flock := nil;
    end;
end;

end.
