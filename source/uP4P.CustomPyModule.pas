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
  /// <summary>
  /// <para>TCustomPyModule is the base class for all the modules created with
  /// the Python API methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-objects">See the article about Module Objects.</see></para>
  /// </remarks>
  TCustomPyModule = class
    protected
      FModule                : IPyObject;
      FModuleDef             : IPyModuleDef;
      FIsExtension           : boolean;
      FOnAfterInitialization : TNotifyEvent;
      FMultIntprSupport      : TMultIntprSupport;

      function  GetName: AnsiString;
      /// <summary>
      /// <para>Internal function used to trigger the OnAfterInitialization
      /// event.</para>
      /// </summary>
      function  doOnAfterInitialization: integer;
      /// <summary>
      /// Override this procedure to create your custom IPyModuleDef instance.
      /// </summary>
      procedure CreateModuleDef(const aName, aDocStrings: string); virtual;

    public
      constructor Create(const aName: string; const aDocStrings: string = ''; aIsExtension : boolean = False);
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
      /// <para>PyObject instance of this module.</para>
      /// </summary>
      property Module                        : IPyObject           read FModule;
      /// <summary>
      /// <para>Module name.</para>
      /// </summary>
      property Name_                         : AnsiString          read GetName;
      /// <summary>
      /// Multiple interpreter support in a module.
      /// </summary>
      property MultIntprSupport              : TMultIntprSupport   read FMultIntprSupport         write FMultIntprSupport;
      /// <summary>
      /// <para>Event triggered after the module has been initialized.</para>
      /// </summary>
      property OnAfterInitialization         : TNotifyEvent        read FOnAfterInitialization    write FOnAfterInitialization;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyModuleSpecHelper, uP4P.PyModule, uP4P.Engine,
  uP4P.PyImport, uP4P.PyDict, uP4P.PyModuleDef, uP4P.Py_mod;

function Exec_Module(module: PPyObject): integer; cdecl;
var
  TempModule : TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(module, TempModule) then
    TempModule.doOnAfterInitialization;

  Result := 0;
end;

constructor TCustomPyModule.Create(const aName, aDocStrings: string; aIsExtension : boolean);
begin
  inherited Create;

  FModule                := nil;
  FModuleDef             := nil;
  FOnAfterInitialization := nil;
  FMultIntprSupport      := miSupported;
  FIsExtension           := aIsExtension;

  CreateModuleDef(aName, aDocStrings);
end;

destructor TCustomPyModule.Destroy;
begin
  FModule    := nil;
  FModuleDef := nil;
  inherited Destroy;
end;

procedure TCustomPyModule.AfterConstruction;
begin
  inherited AfterConstruction;

  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.AddModule(self);
end;

procedure TCustomPyModule.BeforeDestruction;
begin
  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.RemoveModule(self);

  inherited BeforeDestruction;
end;

function TCustomPyModule.GetName: AnsiString;
begin
  if assigned(FModuleDef) then
    Result := FModuleDef.Name_
   else
    Result := '';
end;

procedure TCustomPyModule.CreateModuleDef(const aName, aDocStrings: string);
begin
  FModuleDef := TPyModuleDef.Create(aName, aDocStrings);
end;

function TCustomPyModule.doOnAfterInitialization: integer;
begin
  Result := 0;

  if assigned(FOnAfterInitialization) then
    FOnAfterInitialization(self);
end;

function TCustomPyModule.SameAs(const other: PPyObject): boolean;
begin
  Result := assigned(FModule) and
            assigned(other) and
            FModule.SameAs(other);
end;

function TCustomPyModule.Initialize: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FModule) or not(assigned(FModuleDef)) then exit;

  FModuleDef.CreateMethodsAndSlots(@Exec_Module, FMultIntprSupport);

  if FIsExtension then
    Result := True
   else
    try
      TempSpec := TPyModuleSpecHelper.FromModuleName(FModuleDef.Name_);

      // Create the module from the definition and spec
      FModule  := TPyModule.FromDefAndSpec(FModuleDef.ModuleDef, TempSpec);

      if assigned(FModule) then
        begin
          // TPyModule.ExecDef executes the module.
          // It triggers Py_mod_exec slot, which triggers
          // the TCustomPyModule.OnAfterInitialization event.
          if TPyModule.ExecDef(FModule, FModuleDef.ModuleDef) then
            Result := GlobalP4PEngine.AddModuleToSys(self);
        end
       else
        GlobalP4PEngine.GetRaisedException;
    finally
      TempSpec := nil;
    end;
end;

end.
