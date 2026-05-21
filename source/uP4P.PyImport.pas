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
      class function ImportModuleLevel(const name_: string; globals, locals, fromlist: IPyObject; level: integer): IPyObject;
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
begin

end;

class function TPyImport.ImportModuleLevel(const name_: string; globals, locals, fromlist: IPyObject; level: integer): IPyObject;
begin

end;

class function TPyImport.ImportModuleLevelObject(const name_, globals, locals, fromlist: IPyObject; level: integer): IPyObject;
begin

end;

class function TPyImport.GetImporter(const path: IPyObject): IPyObject;
begin

end;

class function TPyImport.Import(const name_: IPyObject): IPyObject;
begin

end;

class function TPyImport.ReloadModule(const m: IPyObject): IPyObject;
begin

end;

  PyImport_ImportModule                          : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyImport_ImportModuleLevel                     : function(const name_: PAnsiChar; globals, locals, fromlist: PPyObject; level: integer): PPyObject; cdecl;
  PyImport_ImportModuleLevelObject               : function(name_, globals, locals, fromlist: PPyObject; level: integer): PPyObject; cdecl;
  PyImport_GetImporter                           : function(path: PPyObject): PPyObject; cdecl;
  PyImport_Import                                : function(name_: PPyObject): PPyObject; cdecl;
  PyImport_ReloadModule                          : function(m: PPyObject): PPyObject; cdecl;

class function TPyImport.ImportFrozenModuleObject(const name_: IPyObject): integer;
begin

end;

class function TPyImport.ImportFrozenModule(const name_: string): integer;
begin

end;

class function TPyImport.AppendInittab(const name_: string; initfunc_: initfunc): boolean;
begin

end;

class function TPyImport.ExtendInittab(newtab: P_inittab): boolean;
begin

end;

class function TPyImport.ImportModuleAttr(const mod_name, attr_name: IPyObject): IPyObject;
begin

end;

class function TPyImport.ImportModuleAttrString(const mod_name, attr_name: string): IPyObject;
begin

end;

  PyImport_ImportFrozenModuleObject              : function(name_: PPyObject): integer; cdecl;
  PyImport_ImportFrozenModule                    : function(const name_: PAnsiChar): integer; cdecl;
  PyImport_AppendInittab                         : function(const name_: PAnsiChar; initfunc_: initfunc): integer; cdecl;
  PyImport_Inittab                               : P_inittab;
  PyImport_ExtendInittab                         : function(newtab: P_inittab): integer; cdecl;
  PyImport_FrozenModules                         : P_frozen;
  PyImport_ImportModuleAttr                      : function(mod_name, attr_name: PPyObject): PPyObject; cdecl;
  PyImport_ImportModuleAttrString                : function(const mod_name, attr_name: PAnsiChar): PPyObject; cdecl;

end.
