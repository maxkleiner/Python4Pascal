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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyImport = class
    public
      class function GetMagicNumber: C_Long;
      class function GetMagicTag: string;
      class function ExecCodeModule(const name_: string; const co: IPyObject): IPyObject;
      class function ExecCodeModuleEx(const name_: string; const co: IPyObject; const pathname: string): IPyObject;
      class function ExecCodeModuleWithPathnames(const name_: string; const co: IPyObject; const pathname, cpathname: string): IPyObject;
      class function ExecCodeModuleObject(const name_, co, pathname, cpathname: IPyObject): IPyObject;
      class function GetModuleDict: IPyObject;
      class function GetModule(const name_: IPyObject): IPyObject;
      class function AddModuleObject(const name_: IPyObject): IPyObject;
      class function AddModule(const name_: string): IPyObject;
      class function AddModuleRef(const name_: string): IPyObject;
      class function ImportModule(const name_: string): IPyObject;
      class function ImportModuleLevel(const name_: string; const globals, locals, fromlist: IPyObject; level: integer): IPyObject;
      class function ImportModuleLevelObject(const name_, globals, locals, fromlist: IPyObject; level: integer): IPyObject;
      class function GetImporter(const path: IPyObject): IPyObject;
      class function Import(const name_: IPyObject): IPyObject;
      class function ReloadModule(const m: IPyObject): IPyObject;
      class function ImportFrozenModuleObject(const name_: IPyObject): integer;
      class function ImportFrozenModule(const name_: string): integer;
      class function AppendInittab(const name_: string; initfunc_: initfunc): boolean;
      class function ExtendInittab(newtab: P_inittab): boolean;
      class function ImportModuleAttr(const mod_name, attr_name: IPyObject): IPyObject;
      class function ImportModuleAttrString(const mod_name, attr_name: string): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyImport.GetMagicNumber: C_Long;
begin
  if assigned(PyImport_GetMagicNumber) then
    Result := PyImport_GetMagicNumber()
   else
    Result := 0;
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

end.
