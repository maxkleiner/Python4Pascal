unit uP4P.PyImport;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>Helper class for all the PyImport_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/import.html#importing-modules">See the article about Importing Modules.</see></para>
  /// </remarks>
  TPyImport = class
    public
      /// <summary>
      /// <para>Return the magic number for Python bytecode files
      /// (a.k.a. .pyc file). The magic number should be present in the first
      /// four bytes of the bytecode file, in little-endian byte order.
      /// Returns -1 on error.</para>
      /// <para>Changed in version 3.3: Return value of -1 upon failure.</para>
      /// </summary>
      class function GetMagicNumber: C_Long;
      /// <summary>
      /// <para>Return the magic tag string for PEP 3147 format Python bytecode
      /// file names. Keep in mind that the value at
      /// sys.implementation.cache_tag is authoritative and should be used
      /// instead of this function.</para>
      /// </summary>
      class function GetMagicTag: string;
      /// <summary>
      /// <para>Given a module name_ (possibly of the form package.module) and a
      /// code object read from a Python bytecode file or obtained from the
      /// built-in function compile(), load the module. Return a new reference
      /// to the module object, or nil with an exception set if an error
      /// occurred. name_ is removed from sys.modules in error cases, even if
      /// name_ was already in sys.modules on entry to
      /// TPyImport.ExecCodeModule(). Leaving incompletely initialized modules
      /// in sys.modules is dangerous, as imports of such modules have no way to
      /// know that the module object is an unknown (and probably damaged with
      /// respect to the module author's intents) state.</para>
      /// <para>The module's __spec__ and __loader__ will be set, if not set
      /// already, with the appropriate values. The spec's loader will be set
      /// to the module's __loader__ (if set) and to an instance of
      /// SourceFileLoader otherwise.</para>
      /// <para>The module's __file__ attribute will be set to the code
      /// object's co_filename.</para>
      /// <para>This function will reload the module if it was already imported.
      /// See TPyImport.ReloadModule() for the intended way to reload a
      /// module.</para>
      /// <para>If name_ points to a dotted name of the form package.module,
      /// any package structures not already created will still not be
      /// created.</para>
      /// <para>See also TPyImport.ExecCodeModuleEx() and
      /// TPyImport.ExecCodeModuleWithPathnames().</para>
      /// <para>Changed in version 3.12: The setting of __cached__ and
      /// __loader__ is deprecated. See ModuleSpec for alternatives.</para>
      /// <para>Changed in version 3.15: The __cached__ attribute is no longer
      /// set.</para>
      /// </summary>
      class function ExecCodeModule(const name_: string; const co: IPyObject): IPyObject;
      /// <summary>
      /// <para>Like TPyImport.ExecCodeModule(), but the __file__ attribute of
      /// the module object is set to pathname if it is non-nil.</para>
      /// <para>See also TPyImport.ExecCodeModuleWithPathnames().</para>
      /// </summary>
      class function ExecCodeModuleEx(const name_: string; const co: IPyObject; const pathname: string): IPyObject;
      /// <summary>
      /// <para>Like TPyImport.ExecCodeModuleObject(), but name_, pathname and
      /// cpathname are strings. Attempts are also made to figure
      /// out what the value for pathname should be from cpathname if the former
      /// is set to nil.</para>
      /// <para>Added in version 3.2.</para>
      /// <para>Changed in version 3.3: Uses imp.source_from_cache() in
      /// calculating the source path if only the bytecode path is
      /// provided.</para>
      /// <para>Changed in version 3.12: No longer uses the removed imp
      /// module.</para>
      /// <para>Changed in version 3.15: The __cached__ attribute no longer
      /// set.</para>
      /// </summary>
      class function ExecCodeModuleWithPathnames(const name_: string; const co: IPyObject; const pathname, cpathname: string): IPyObject;
      /// <summary>
      /// <para>Like TPyImport.ExecCodeModuleEx(), but the path to any compiled
      /// file via cpathname is used appropriately when non-nil. Of the three
      /// functions, this is the preferred one to use.</para>
      /// <para>Added in version 3.3.</para>
      /// <para>Changed in version 3.12: Setting __cached__ is deprecated.
      /// See ModuleSpec for alternatives.</para>
      /// </summary>
      class function ExecCodeModuleObject(const name_, co, pathname, cpathname: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the dictionary used for the module administration
      /// (a.k.a. sys.modules). Note that this is a per-interpreter
      /// variable.</para>
      /// </summary>
      class function GetModuleDict: IPyObject;
      /// <summary>
      /// <para>Return the already imported module with the given name. If the
      /// module has not been imported yet then returns nil but does not set
      /// an error. Returns nil and sets an error if the lookup failed.</para>
      /// </summary>
      class function GetModule(const name_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyImport.AddModuleRef(), but return a borrowed
      /// reference and name_ is a Python str object.</para>
      /// </summary>
      class function AddModuleObject(const name_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyImport.AddModuleRef(), but return a borrowed
      /// reference.</para>
      /// </summary>
      class function AddModule(const name_: string): IPyObject;
      /// <summary>
      /// <para>Return the module object corresponding to a module name.</para>
      /// <para>The name argument may be of the form package.module. First check
      /// the modules dictionary if there's one there, and if not, create a new
      /// one and insert it in the modules dictionary.</para>
      /// <para>Return a strong reference to the module on success. Return nil
      /// with an exception set on failure.</para>
      /// <para>This function does not load or import the module; if the module
      /// wasn't already loaded, you will get an empty module object.
      /// Use TPyImport.ImportModule() or one of its variants to import a
      /// module. Package structures implied by a dotted name for name are not
      /// created if not already present.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function AddModuleRef(const name_: string): IPyObject;
      /// <summary>
      /// <para>This is a wrapper around TPyImport.Import() which takes a string
      /// as an argument instead of a IPyObject.</para>
      /// </summary>
      class function ImportModule(const name_: string): IPyObject;
      /// <summary>
      /// <para>Similar to TPyImport.ImportModuleLevelObject(), but the name is
      /// a string instead of a Unicode object.</para>
      /// <para>Changed in version 3.3: Negative values for level are no longer
      /// accepted.</para>
      /// </summary>
      class function ImportModuleLevel(const name_: string; const globals, locals, fromlist: IPyObject; level: integer): IPyObject;
      /// <summary>
      /// <para>Import a module. This is best described by referring to the
      /// built-in Python function __import__(), as the standard __import__()
      /// function calls this function directly.</para>
      /// <para>The return value is a new reference to the imported module or
      /// top-level package, or nil with an exception set on failure. Like for
      /// __import__(), the return value when a submodule of a package was
      /// requested is normally the top-level package, unless a non-empty
      /// fromlist was given.</para>
      /// </summary>
      class function ImportModuleLevelObject(const name_, globals, locals, fromlist: IPyObject; level: integer): IPyObject;
      /// <summary>
      /// <para>Return a finder object for a sys.path/pkg.__path__ item path,
      /// possibly by fetching it from the sys.path_importer_cache dict.
      /// If it wasn't yet cached, traverse sys.path_hooks until a hook is
      /// found that can handle the path item. Return None if no hook could;
      /// this tells our caller that the path based finder could not find a
      /// finder for this path item. Cache the result in
      /// sys.path_importer_cache. Return a new reference to the finder
      /// object.</para>
      /// </summary>
      class function GetImporter(const path: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is a higher-level interface that calls the current
      /// "import hook function" (with an explicit level of 0, meaning absolute
      /// import). It invokes the __import__() function from the __builtins__
      /// of the current globals. This means that the import is done using
      /// whatever import hooks are installed in the current environment.</para>
      /// <para>This function always uses absolute imports.</para>
      /// </summary>
      class function Import(const name_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Reload a module. Return a new reference to the reloaded module,
      /// or nil with an exception set on failure (the module still exists in
      /// this case).</para>
      /// </summary>
      class function ReloadModule(const m: IPyObject): IPyObject;
      /// <summary>
      /// <para>Load a frozen module named name. Return 1 for success, 0 if the
      /// module is not found, and -1 with an exception set if the
      /// initialization failed. To access the imported module on a successful
      /// load, use TPyImport.ImportModule(). (Note the misnomer - this function
      /// would reload the module if it was already imported.)</para>
      /// </summary>
      class function ImportFrozenModuleObject(const name_: IPyObject): integer;
      /// <summary>
      /// <para>Similar to TPyImport.ImportFrozenModuleObject(), but the name is
      /// a string instead of a Unicode object.</para>
      /// </summary>
      class function ImportFrozenModule(const name_: string): integer;
      /// <summary>
      /// <para>Add a single module to the existing table of built-in modules.
      /// This is a convenience wrapper around TPyImport.ExtendInittab(),
      /// returning False if the table could not be extended. The new module
      /// can be imported by the name name, and uses the function initfunc as
      /// the initialization function called on the first attempted import.
      /// This should be called before TPy.Initialize().</para>
      /// </summary>
      class function AppendInittab(const name_: string; initfunc_: initfunc): boolean;
      /// <summary>
      /// <para>Add a collection of modules to the table of built-in modules.
      /// The newtab array must end with a sentinel entry which contains nil for
      /// the name field; failure to provide the sentinel value can result in a
      /// memory fault. Returns True on success or False if insufficient memory
      /// could be allocated to extend the internal table. In the event of
      /// failure, no modules are added to the internal table. This must be
      /// called before TPy.Initialize().</para>
      /// <para>If Python is initialized multiple times,
      /// TPyImport.AppendInittab() or TPyImport.ExtendInittab() must be called
      /// before each Python initialization.</para>
      /// </summary>
      class function ExtendInittab(newtab: P_inittab): boolean;
      /// <summary>
      /// <para>Import the module mod_name and get its attribute
      /// attr_name.</para>
      /// <para>Names must be Python str objects.</para>
      /// <para>Helper function combining TPyImport.Import() and
      /// TPyObject.GetAttr(). For example, it can raise ImportError if the
      /// module is not found, and AttributeError if the attribute doesn't
      /// exist.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function ImportModuleAttr(const mod_name, attr_name: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyImport.ImportModuleAttr(), but names are strings
      /// instead of Python str objects.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function ImportModuleAttrString(const mod_name, attr_name: string): IPyObject;
      /// <summary>
      /// <para>Set the lazy imports mode.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class procedure SetLazyImportsMode(mode: PyImport_LazyImportsMode);
      /// <summary>
      /// <para>Sets the current lazy imports filter. The filter should be
      /// a callable that will receive (importing_module_name,
      /// imported_module_name, [fromlist]) when an import can potentially
      /// be lazy. The imported_module_name value is the resolved module name,
      /// so lazy from .spam import eggs passes package.spam. The callable
      /// must return True if the import should be lazy and False otherwise.
      /// <para>Return True on success and False with an exception set
      /// otherwise.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function SetLazyImportsFilter(const filter: IPyObject): boolean;
      /// <summary>
      /// <para>Gets the current lazy imports mode.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetLazyImportsMode(): PyImport_LazyImportsMode;
      /// <summary>
      /// <para>Return a strong reference to the current lazy imports filter,
      /// or nil if none exists. This function always succeeds.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetLazyImportsFilter(): IPyObject;
      /// <summary>
      /// <para>This function is a building block that enables embedders to
      /// implement the create_module() step of custom static extension
      /// importers (e.g. of statically-linked extensions).</para>
      /// <para>spec must be a ModuleSpec object.</para>
      /// <para>initfunc must be an initialization function, the same as
      /// for TPyImport.AppendInittab().</para>
      /// <para>On success, create and return a module object. This module
      /// will not be initialized; call TPyModule.Exec() to initialize it.
      /// (Custom importers should do this in their exec_module()
      /// method.)</para>
      /// <para>On error, return nil with an exception set.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function CreateModuleFromInitfunc(const spec: IPyObject; initfunc_: initfunc): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyImport.GetMagicNumber: C_Long;
begin
  if assigned(PyImport_GetMagicNumber) then
    Result := PyImport_GetMagicNumber()
   else
    Result := C_Long(-1);
end;

class function TPyImport.GetMagicTag: string;
begin
  if assigned(PyImport_GetMagicTag) then
    Result := PyUTF8ToString(PyImport_GetMagicTag())
   else
    Result := '';
end;

class function TPyImport.ExecCodeModule(const name_: string; const co: IPyObject): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_ExecCodeModule) and
     TPyObject.IsInitialized(co) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyImport_ExecCodeModule(PAnsiChar(TempName), co.PyObject));
    end
   else
    Result := nil;
end;

class function TPyImport.ExecCodeModuleEx(const name_: string; const co: IPyObject; const pathname: string): IPyObject;
var
  TempName, TempPathname : AnsiString;
  TempPathnamePtr : PAnsiChar;
begin
  if assigned(PyImport_ExecCodeModuleEx) and
     TPyObject.IsInitialized(co) then
    begin
      if (length(pathname) > 0) then
        begin
          TempPathname    := StringToPyUTF8(pathname);
          TempPathnamePtr := PAnsiChar(TempPathname);
        end
       else
        TempPathnamePtr := nil;

      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyImport_ExecCodeModuleEx(PAnsiChar(TempName), co.PyObject, TempPathnamePtr));
    end
   else
    Result := nil;
end;

class function TPyImport.ExecCodeModuleWithPathnames(const name_: string; const co: IPyObject; const pathname, cpathname: string): IPyObject;
var
  TempName, TempPathname, TempCPathname : AnsiString;
  TempPathnamePtr : PAnsiChar;
begin
  if assigned(PyImport_ExecCodeModuleWithPathnames) and
     TPyObject.IsInitialized(co) then
    begin
      if (length(pathname) > 0) then
        begin
          TempPathname    := StringToPyUTF8(pathname);
          TempPathnamePtr := PAnsiChar(TempPathname);
        end
       else
        TempPathnamePtr := nil;

      TempName      := StringToPyUTF8(name_);
      TempCPathname := StringToPyUTF8(cpathname);
      Result        := TPyObject.Wrap(PyImport_ExecCodeModuleWithPathnames(PAnsiChar(TempName), co.PyObject, TempPathnamePtr, PAnsiChar(TempCPathname)));
    end
   else
    Result := nil;
end;

class function TPyImport.ExecCodeModuleObject(const name_, co, pathname, cpathname: IPyObject): IPyObject;
var
  TempName, TempPathname, TempCPathname : PPyObject;
begin
  if assigned(PyImport_ExecCodeModuleObject) and
     TPyObject.IsInitialized(co) then
    begin
      TempName      := nil;
      TempPathname  := nil;
      TempCPathname := nil;

      if TPyObject.IsInitialized(name_) then
        TempName := name_.PyObject;

      if TPyObject.IsInitialized(pathname) then
        TempPathname := pathname.PyObject;

      if TPyObject.IsInitialized(cpathname) then
        TempCPathname := cpathname.PyObject;

      Result := TPyObject.Wrap(PyImport_ExecCodeModuleObject(TempName, co.PyObject, TempPathname, TempCPathname));
    end
   else
    Result := nil;
end;

class function TPyImport.GetModuleDict: IPyObject;
begin
  if assigned(PyImport_GetModuleDict) then
    Result := TPyObject.Wrap(PyImport_GetModuleDict(), False)
   else
    Result := nil;
end;

class function TPyImport.GetModule(const name_: IPyObject): IPyObject;
begin
  if assigned(PyImport_GetModule) and
     TPyObject.IsInitialized(name_) then
    Result := TPyObject.Wrap(PyImport_GetModule(name_.PyObject))
   else
    Result := nil;
end;

class function TPyImport.AddModuleObject(const name_: IPyObject): IPyObject;
begin
  if assigned(PyImport_AddModuleObject) and
     TPyObject.IsInitialized(name_) then
    Result := TPyObject.Wrap(PyImport_AddModuleObject(name_.PyObject), False)
   else
    Result := nil;
end;

class function TPyImport.AddModule(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_AddModule) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyImport_AddModule(PAnsiChar(TempName)), False);
    end
   else
    Result := nil;
end;

class function TPyImport.AddModuleRef(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_AddModuleRef) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyImport_AddModuleRef(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPyImport.ImportModule(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_ImportModule) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyImport_ImportModule(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPyImport.ImportModuleLevel(const name_: string; const globals, locals, fromlist: IPyObject; level: integer): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_ImportModuleLevel) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) and
     TPyObject.IsInitialized(fromlist) and
     (level >= 0) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyImport_ImportModuleLevel(PAnsiChar(TempName), globals.PyObject, locals.PyObject, fromlist.PyObject, level));
    end
   else
    Result := nil;
end;

class function TPyImport.ImportModuleLevelObject(const name_, globals, locals, fromlist: IPyObject; level: integer): IPyObject;
begin
  if assigned(PyImport_ImportModuleLevelObject) and
     TPyObject.IsInitialized(name_) and
     TPyObject.IsInitialized(globals) and
     TPyObject.IsInitialized(locals) and
     TPyObject.IsInitialized(fromlist) then
    Result := TPyObject.Wrap(PyImport_ImportModuleLevelObject(name_.PyObject, globals.PyObject, locals.PyObject, fromlist.PyObject, level))
   else
    Result := nil;
end;

class function TPyImport.GetImporter(const path: IPyObject): IPyObject;
begin
  if assigned(PyImport_GetImporter) and
     TPyObject.IsInitialized(path) then
    Result := TPyObject.Wrap(PyImport_GetImporter(path.PyObject))
   else
    Result := nil;
end;

class function TPyImport.Import(const name_: IPyObject): IPyObject;
begin
  if assigned(PyImport_Import) and
     TPyObject.IsInitialized(name_) then
    Result := TPyObject.Wrap(PyImport_Import(name_.PyObject))
   else
    Result := nil;
end;

class function TPyImport.ReloadModule(const m: IPyObject): IPyObject;
begin
  if assigned(PyImport_ReloadModule) and
     TPyObject.IsInitialized(m) then
    Result := TPyObject.Wrap(PyImport_ReloadModule(m.PyObject))
   else
    Result := nil;
end;

class function TPyImport.ImportFrozenModuleObject(const name_: IPyObject): integer;
begin
  if assigned(PyImport_ImportFrozenModuleObject) and
     TPyObject.IsInitialized(name_) then
    Result := PyImport_ImportFrozenModuleObject(name_.PyObject)
   else
    Result := -1;
end;

class function TPyImport.ImportFrozenModule(const name_: string): integer;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_ImportFrozenModule) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := PyImport_ImportFrozenModule(PAnsiChar(TempName));
    end
   else
    Result := -1;
end;

class function TPyImport.AppendInittab(const name_: string; initfunc_: initfunc): boolean;
var
  TempName : AnsiString;
begin
  if assigned(PyImport_AppendInittab) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyImport_AppendInittab(PAnsiChar(TempName), initfunc_) = 0);
    end
   else
    Result := False;
end;

class function TPyImport.ExtendInittab(newtab: P_inittab): boolean;
begin
  if assigned(PyImport_ExtendInittab) and assigned(newtab) then
    Result := (PyImport_ExtendInittab(newtab) = 0)
   else
    Result := False;
end;

class function TPyImport.ImportModuleAttr(const mod_name, attr_name: IPyObject): IPyObject;
begin
  if assigned(PyImport_ImportModuleAttr) and
     TPyObject.IsInitialized(mod_name) and
     TPyObject.IsInitialized(attr_name) then
    Result := TPyObject.Wrap(PyImport_ImportModuleAttr(mod_name.PyObject, attr_name.PyObject))
   else
    Result := nil;
end;

class function TPyImport.ImportModuleAttrString(const mod_name, attr_name: string): IPyObject;
var
  TempModName, TempAttrName : AnsiString;
begin
  if assigned(PyImport_ImportModuleAttrString) then
    begin
      TempModName  := StringToPyUTF8(mod_name);
      TempAttrName := StringToPyUTF8(attr_name);
      Result       := TPyObject.Wrap(PyImport_ImportModuleAttrString(PAnsiChar(TempModName), PAnsiChar(TempAttrName)));
    end
   else
    Result := nil;
end;

class procedure TPyImport.SetLazyImportsMode(mode: PyImport_LazyImportsMode);
begin
  if assigned(PyImport_SetLazyImportsMode) then
    PyImport_SetLazyImportsMode(mode);
end;

class function TPyImport.SetLazyImportsFilter(const filter: IPyObject): boolean;
begin
  Result := assigned(PyImport_SetLazyImportsFilter) and
            TPyObject.IsInitialized(filter) and
            (PyImport_SetLazyImportsFilter(filter.PyObject) = 0);
end;

class function TPyImport.GetLazyImportsMode(): PyImport_LazyImportsMode;
begin
  if assigned(PyImport_GetLazyImportsMode) then
    Result := PyImport_GetLazyImportsMode()
   else
    Result := PyImport_LAZY_NORMAL;
end;

class function TPyImport.GetLazyImportsFilter(): IPyObject;
begin
  if assigned(PyImport_GetLazyImportsFilter) then
    Result := TPyObject.Wrap(PyImport_GetLazyImportsFilter())
   else
    Result := nil;
end;

class function TPyImport.CreateModuleFromInitfunc(const spec: IPyObject; initfunc_: initfunc): IPyObject;
begin
  if assigned(PyImport_CreateModuleFromInitfunc) and
     TPyObject.IsInitialized(spec) then
    Result := TPyObject.Wrap(PyImport_CreateModuleFromInitfunc(spec.PyObject, initfunc_))
   else
    Result := nil;
end;

end.
