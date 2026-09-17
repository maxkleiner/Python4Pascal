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
  /// <summary>
  /// <para>This class represents the state of a thread key, the
  /// definition of which may depend on the underlying TLS implementation,
  /// and it has an internal field representing the key's initialization
  /// state.</para>
  /// <para>When Py_LIMITED_API is not defined, static allocation of this type
  /// by Py_tss_NEEDS_INIT is allowed.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/tls.html#c.Py_tss_t">See the article about Py_tss_t.</see></para>
  /// </remarks>
  TPyThreadTSS = class(TInterfacedObject, IPyThreadTSS)
    protected
      FKey : PPy_tss_t;

      function GetInitialized: boolean;
      function GetKey: PPy_tss_t;
      function GetIsCreated: boolean;
      function GetValue: pointer;

      procedure SetValue(value: pointer);

      /// <summary>
      /// <para>Return a value which is the same state as a value initialized
      /// with Py_tss_NEEDS_INIT, or nil in the case of dynamic allocation
      /// failure.</para>
      /// </summary>
      procedure TSSAlloc;
      /// <summary>
      /// <para>Free the given key allocated by TSSAlloc(), after first calling
      /// TSSDelete() to ensure any associated thread locals have been
      /// unassigned. This is a no-op if the key argument is nil.</para>
      /// <para>Note A freed key becomes a dangling pointer. You should reset
      /// the key to nil.</para>
      /// </summary>
      procedure TSSFree;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// <para>Return True on successful initialization of a TSS key.</para>
      /// <para>The behavior is undefined if the value pointed to by the key
      /// argument is not initialized by Py_tss_NEEDS_INIT. This function can
      /// be called repeatedly on the same key - calling it on an already
      /// initialized key is a no-op and immediately returns success.</para>
      /// </summary>
      function    TSSCreate: boolean;
      /// <summary>
      /// <para>Destroy a TSS key to forget the values associated with the key
      /// across all threads, and change the key's initialization state to
      /// uninitialized. A destroyed key is able to be initialized again by
      /// TSSCreate(). This function can be called repeatedly on the same
      /// key - calling it on an already destroyed key is a no-op.</para>
      /// </summary>
      procedure   TSSDelete;

      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized : boolean     read GetInitialized;
      /// <summary>
      /// <para>The state of a thread key</para>
      /// </summary>
      property Key         : PPy_tss_t   read GetKey;
      /// <summary>
      /// <para>Return True if the given Py_tss_t has been initialized by
      /// TSSCreate().</para>
      /// </summary>
      property IsCreated   : boolean     read GetIsCreated;
      /// <summary>
      /// <para>Return the pointer value associated with a TSS key in the
      /// current thread. This returns nil if no value is associated with the
      /// key in the current thread.</para>
      /// </summary>
      property Value       : pointer     read GetValue        write SetValue;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

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
