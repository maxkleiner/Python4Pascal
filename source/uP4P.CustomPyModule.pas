unit uP4P.CustomPyModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.AnsiStrings,
  {$ELSE}
    Classes, SysUtils, {$IFDEF DELPHI12_UP}AnsiStrings,{$ENDIF}
  {$ENDIF}
  uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>TCustomPyModule is the base class for all the modules created with
  /// the Python API methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-objects">See the article about Module Objects.</see></para>
  /// </remarks>
  TCustomPyModule = class
    protected
      FName                  : string;
      FDocStrings            : string;
      FModule                : IPyObject;
      FModuleDef             : IPyModuleDef;
      FSlotManager           : IPySlotManager;
      FIsExtension           : boolean;
      FOnAfterInitialization : TNotifyEvent;
      FMultIntprSupport      : TMultIntprSupport;
      FGILUsed               : boolean;
      FUseLegacyAPI          : boolean;
      FID                    : cardinal;
      FExecFunction          : exec_modulefunc;

      function  GetName: AnsiString;
      function  GetModuleDef: PPyModuleDef;
      function  GetSlots: PPySlot;
      function  GetToken: Pointer;

      procedure SetUseLegacyAPI(aValue: boolean);
      /// <summary>
      /// <para>Internal function used to trigger the OnAfterInitialization
      /// event.</para>
      /// </summary>
      function  doOnAfterInitialization(module: PPyObject): integer; virtual;
      /// <summary>
      /// Override this procedure to create your custom IPyModuleDef instance.
      /// </summary>
      procedure CreateModuleDef; virtual;
      /// <summary>
      /// Override this procedure to create your custom IPySlotManager instance.
      /// </summary>
      procedure CreateSlotManager; virtual;
      /// <summary>
      /// Initialize the module in Python 3.14 or older. It uses an
      /// IPyModuleDef instance.
      /// </summary>
      function  LegacyInitialization: boolean;
      /// <summary>
      /// Initialize the module in Python 3.15 or newer. It uses an
      /// IPySlotManager instance.
      /// </summary>
      function  UnifiedSlotInitialization: boolean;
      /// <summary>
      /// <para>Add the module to the internal module list.</para>
      /// </summary>
      procedure AddModule; virtual;
      /// <summary>
      /// <para>Remove the module from the internal module list.</para>
      /// </summary>
      procedure RemoveModule; virtual;
      /// <summary>
      /// <para>Add the module to sys.modules.</para>
      /// </summary>
      function  AddToSysModules: boolean;
      /// <summary>
      /// <para>Remove the module from sys.modules.</para>
      /// </summary>
      function  RemoveFromSysModules: boolean;

    public
      constructor Create(const aName: string; aIsExtension: boolean = False);
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      /// <summary>
      /// <para>Test if this module is the same as the "other" module.</para>
      /// </summary>
      function    SameAs(const other: PPyObject): boolean;
      /// <summary>
      /// <para>Create the module and all the slots and methods.</para>
      /// </summary>
      function    Initialize: boolean;
      /// <summary>
      /// <para>Destroy the module and remove it from sys.modules and the
      /// internal modules list in GlobalP4PEngine.</para>
      /// <para>This is necessary before calling TPy.EndInterpreter.</para>
      /// </summary>
      /// <remarks>
      /// <para>See the TP4PThread class.</para>
      /// </remarks>
      procedure   Finalize;

      /// <summary>
      /// <para>PyObject instance of this module.</para>
      /// </summary>
      property Module                        : IPyObject           read FModule;
      /// <summary>
      /// Return a poiter to PyModuleDef.
      /// </summary>
      property ModuleDef                     : PPyModuleDef        read GetModuleDef;
      /// <summary>
      /// Return a pointer to the first slot.
      /// </summary>
      property Slots                         : PPySlot             read GetSlots;
      /// <summary>
      /// <para>Module name.</para>
      /// </summary>
      property Name_                         : AnsiString          read GetName;
      /// <summary>
      /// <para>True when this instance is an extension module.</para>
      /// </summary>
      property IsExtension                   : boolean             read FIsExtension;
      /// <summary>
      /// <para>the docstring of the new module.</para>
      /// </summary>
      property DocStrings                    : string              read FDocStrings               write FDocStrings;
      /// <summary>
      /// <para>Use the legacy API to initialize the module.</para>
      /// </summary>
      property UseLegacyAPI                  : boolean             read FUseLegacyAPI             write SetUseLegacyAPI;
      /// <summary>
      /// <para>Multiple interpreter support in a module.</para>
      /// </summary>
      property MultIntprSupport              : TMultIntprSupport   read FMultIntprSupport         write FMultIntprSupport;
      /// <summary>
      /// <para>The module depends on the presence of the global interpreter
      /// lock (GIL)</para>
      /// </summary>
      property GILUsed                       : boolean             read FGILUsed                  write FGILUsed;
      /// <summary>
      /// <para>Unique module ID.</para>
      /// </summary>
      property ID                            : cardinal            read FID;
      /// <summary>
      /// <para>The module Token.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#ext-module-token">See the article about Module token.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      property Token                         : Pointer             read GetToken;
      /// <summary>
      /// <para>The function that will execute, or initialize, the module.</para>
      /// </summary>
      property ExecFunction                  : exec_modulefunc     read FExecFunction             write FExecFunction;
      /// <summary>
      /// <para>Event triggered after the module has been initialized.</para>
      /// </summary>
      property OnAfterInitialization         : TNotifyEvent        read FOnAfterInitialization    write FOnAfterInitialization;
  end;

implementation

uses
  uP4P.PyModuleSpecHelper, uP4P.PyModule, uP4P.Engine,
  uP4P.PyModuleDef, uP4P.PySlotManager;

function Exec_Module(module: PPyObject): integer; cdecl;
var
  TempModule : TCustomPyModule;
begin
  Result     := 0;
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(module, TempModule) then
    Result := TempModule.doOnAfterInitialization(module);
end;

constructor TCustomPyModule.Create(const aName: string; aIsExtension: boolean);
begin
  inherited Create;

  FName                  := aName;
  FDocStrings            := '';
  FModule                := nil;
  FModuleDef             := nil;
  FSlotManager           := nil;
  FOnAfterInitialization := nil;
  FMultIntprSupport      := miSupported;
  FGILUsed               := True;
  FIsExtension           := aIsExtension;
  FExecFunction          := {$IFDEF FPC}@{$ENDIF}Exec_Module;

  if (GlobalP4PEngine <> nil) then
    begin
      FID           := GlobalP4PEngine.NextID;
      FUseLegacyAPI := not(GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0));
    end
   else
    begin
      FID           := 0;
      FUseLegacyAPI := True;
    end;
end;

destructor TCustomPyModule.Destroy;
begin
  try
    FModuleDef   := nil;
    FSlotManager := nil;
  finally
    inherited Destroy;
  end;
end;

procedure TCustomPyModule.AfterConstruction;
begin
  inherited AfterConstruction;

  AddModule;
end;

procedure TCustomPyModule.BeforeDestruction;
begin
  try
    Finalize;
  finally
    inherited BeforeDestruction;
  end;
end;

procedure TCustomPyModule.Finalize;
begin
  RemoveFromSysModules;
  RemoveModule;
  FModule := nil;
end;

function TCustomPyModule.GetName: AnsiString;
begin
  if assigned(FModuleDef) then
    Result := FModuleDef.Name_
   else
    if assigned(FSlotManager) then
      Result := FSlotManager.Name_
     else
      Result := '';
end;

function TCustomPyModule.GetModuleDef: PPyModuleDef;
begin
  if assigned(FModuleDef) then
    Result := FModuleDef.ModuleDef
   else
    Result := nil;
end;

function TCustomPyModule.GetSlots: PPySlot;
begin
  if assigned(FSlotManager) then
    Result := FSlotManager.Slots
   else
    Result := nil;
end;

function TCustomPyModule.GetToken: Pointer;
var
  TempToken : pointer;
begin
  Result := nil;

  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    begin
      TempToken := nil;

      if TPyObject.IsInitialized(FModule) and
         TPyModule.GetToken(FModule, TempToken) and
         (TempToken <> nil) then
        Result := TempToken
       else
        if FUseLegacyAPI and
           TPyModuleDef.IsInitialized(FModuleDef) then
          Result := pointer(FModuleDef.ModuleDef)
         else
          Result := {%H-}pointer(FID);
    end;
end;

procedure TCustomPyModule.SetUseLegacyAPI(aValue: boolean);
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    FUseLegacyAPI := aValue
   else
    FUseLegacyAPI := True;
end;

procedure TCustomPyModule.CreateModuleDef;
begin
  FModuleDef := TPyModuleDef.Create(FName, FDocStrings);
end;

procedure TCustomPyModule.CreateSlotManager;
begin
  FSlotManager := TPySlotManager.Create(FName, FDocStrings);
end;

function TCustomPyModule.doOnAfterInitialization(module: PPyObject): integer;
begin
  Result := 0;

  if assigned(FOnAfterInitialization) then
    FOnAfterInitialization(self);
end;

function TCustomPyModule.SameAs(const other: PPyObject): boolean;
var
  TempToken : pointer;
begin
  Result := False;
  if not(assigned(other)) then exit;

  if assigned(FModule) then
    Result := FModule.SameAs(other)
   else
    begin
      TempToken := nil;

      if TPyModule.GetToken(other, TempToken) and
         (TempToken <> nil) then
        Result := (TempToken = self.Token)
       else
        Result := (Trim(Name_) = TPyModule.GetName(other));
    end;
end;

function TCustomPyModule.LegacyInitialization: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FModule) then exit;

  CreateModuleDef;

  if not(FModuleDef.Initialized) then exit;

  FModuleDef.BuildMethodsAndSlots(FExecFunction, FMultIntprSupport, FGILUsed);

  if FIsExtension then
    Result := True
   else
    try
      TempSpec := TPyModuleSpecHelper.FromModuleName(FModuleDef.Name_);
      FModule  := TPyModule.FromDefAndSpec(FModuleDef.ModuleDef, TempSpec);

      if AddToSysModules and
         TPyModule.ExecDef(FModule, FModuleDef.ModuleDef) then
        Result := True
       else
        GlobalP4PEngine.GetRaisedException;
    finally
      TempSpec := nil;
    end;
end;

function TCustomPyModule.UnifiedSlotInitialization: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FModule) then exit;

  CreateSlotManager;

  FSlotManager.BuildMethodsAndSlots(FExecFunction, FMultIntprSupport, FGILUsed, {%H-}pointer(FID));

  if FIsExtension then
    Result := True
   else
    try
      TempSpec := TPyModuleSpecHelper.FromModuleName(FSlotManager.Name_);
      FModule  := TPyModule.FromSlotsAndSpec(FSlotManager.Slots, TempSpec);

      if AddToSysModules and
         TPyModule.Exec(FModule) then
        Result := True
       else
        GlobalP4PEngine.GetRaisedException;
    finally
      TempSpec := nil;
    end;
end;

function TCustomPyModule.Initialize: boolean;
begin
  if FUseLegacyAPI then
    Result := LegacyInitialization
   else
    Result := UnifiedSlotInitialization;
end;

procedure TCustomPyModule.AddModule;
begin
  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.AddModule(self);
end;

procedure TCustomPyModule.RemoveModule;
begin
  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.RemoveModule(self);
end;

function TCustomPyModule.AddToSysModules: boolean;
begin
  Result := not(FIsExtension) and
            (GlobalP4PEngine <> nil) and
            TPyObject.IsInitialized(FModule) and
            GlobalP4PEngine.AddToSysModules(self);
end;

function TCustomPyModule.RemoveFromSysModules: boolean;
begin
  Result := not(FIsExtension) and
            (GlobalP4PEngine <> nil) and
            TPyObject.IsInitialized(FModule) and
            GlobalP4PEngine.RemoveFromSysModules(self);
end;

end.
