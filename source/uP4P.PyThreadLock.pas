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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces;

type
  /// <summary>
  /// A mutual exclusion lock.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#c.PyThread_type_lock">See the article about PyThread_type_lock.</see></para>
  /// </remarks>
  TPyThreadLock = class(TInterfacedObject, IPyThreadLock)
    protected
      FLock : PyThread_type_lock;

      function GetInitialized: boolean;
      function GetLock: PyThread_type_lock;

      /// <summary>
      /// <para>Allocate a new lock.</para>
      /// <para>On success, this function returns a lock; on failure, this
      /// function returns nil without an exception set.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// </summary>
      procedure AllocateLock;
      /// <summary>
      /// <para>Destroy lock. The lock should not be held by any thread when
      /// calling this.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// </summary>
      procedure FreeLock;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// <para>Acquire lock.</para>
      /// <para>If waitflag is True and another thread currently holds the lock,
      /// this function will wait until the lock can be acquired and will always
      /// return PY_LOCK_ACQUIRED.</para>
      /// <para>If waitflag is False and another thread holds the lock, this
      /// function will not wait and instead return PY_LOCK_FAILURE. If the
      /// lock is not held by any other thread, then this function will acquire
      /// it and return PY_LOCK_ACQUIRED.</para>
      /// <para>Unlike AcquireLockTimed(), acquiring the lock cannot
      /// be interrupted by a signal.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// </summary>
      function    AcquireLock(waitflag: boolean): PyLockStatus;
      /// <summary>
      /// <para>Acquire lock with a timeout.</para>
      /// <para>This will wait for microseconds microseconds to acquire the
      /// lock. If the timeout expires, this function returns PY_LOCK_FAILURE.
      /// If microseconds is -1, this will wait indefinitely until the lock has
      /// been released.</para>
      /// <para>If intr_flag is True, acquiring the lock may be interrupted by a
      /// signal, in which case this function returns PY_LOCK_INTR. Upon
      /// interruption, it's generally expected that the caller makes a call to
      /// TPy.MakePendingCalls() to propagate an exception to Python code.</para>
      /// <para>If the lock is successfully acquired, this function returns
      /// PY_LOCK_ACQUIRED.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// </summary>
      function    AcquireLockTimed(microseconds: PY_TIMEOUT_T; intr_flag: boolean): PyLockStatus;
      /// <summary>
      /// <para>Release lock. If lock is not held, then this function issues a
      /// fatal error.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// </summary>
      procedure   ReleaseLock;

      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized : boolean              read GetInitialized;
      /// <summary>
      /// <para>The mutual exclusion lock</para>
      /// </summary>
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
