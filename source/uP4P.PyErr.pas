unit uP4P.PyErr;

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
  TPyErr = class
    public
      class procedure SetNone(const type_: IPyObject);
      class procedure SetObject(const type_, value: IPyObject);
      class procedure SetMessage(const type_: IPyObject; const message_: string);
      class function Occurred(): IPyObject;
      class procedure Clear();
      class procedure Fetch(out ptype, pvalue, ptraceback: IPyObject);
      class procedure Restore(const type_, value, traceback: IPyObject);
      class function GetRaisedException(): IPyObject;
      class procedure SetRaisedException(const exc: IPyObject);
      class function GetHandledException(): IPyObject;
      class procedure SetHandledException(const exc: IPyObject);
      class procedure GetExcInfo(out ptype, pvalue, ptraceback: IPyObject);
      class procedure SetExcInfo(const type_, value, traceback: IPyObject);
      class function GivenExceptionMatches(const given, exc: IPyObject): boolean;
      class function ExceptionMatches(const exc: IPyObject): boolean;
      class procedure NormalizeException(out exc, val, tb: IPyObject);
      class function BadArgument(): boolean;
      class function NoMemory(): IPyObject;
      class function SetFromErrno(const type_: IPyObject): IPyObject;
      class function SetFromErrnoWithFilenameObject(const type_, filenameObject: IPyObject): IPyObject;
      class function SetFromErrnoWithFilenameObjects(const type_, filenameObject, filenameObject2: IPyObject): IPyObject;
      class function SetFromErrnoWithFilename(const type_: IPyObject; const filename: string): IPyObject;
      class function SetFromWindowsErrWithFilename(ierr: integer; const filename: string): IPyObject;
      class function SetFromWindowsErr(ierr: integer): IPyObject;
      class function SetExcFromWindowsErrWithFilenameObject(const type_: IPyObject; ierr: integer; const filename: IPyObject): IPyObject;
      class function SetExcFromWindowsErrWithFilenameObjects(const type_: IPyObject; ierr: integer; const filename, filename2: IPyObject): IPyObject;
      class function SetExcFromWindowsErrWithFilename(const type_: IPyObject; ierr: integer; const filename: string): IPyObject;
      class function SetExcFromWindowsErr(const type_: IPyObject; ierr: integer): IPyObject;
      class function SetImportErrorSubclass(const exception, msg, name_, path: IPyObject): IPyObject;
      class function SetImportError(const msg, name_, path: IPyObject): IPyObject;
      class procedure BadInternalCall;
      class function NewException(const name_: string; const base, dict: IPyObject): IPyObject;
      class function NewExceptionWithDoc(const name_, doc: string; base, dict: IPyObject): IPyObject;
      class procedure WriteUnraisable(const obj: IPyObject);
      class function CheckSignals(): boolean;
      class procedure SetInterrupt();
      class function SetInterruptEx(signum: integer): boolean;
      class procedure SyntaxLocation(const filename: string; lineno: integer);
      class procedure SyntaxLocationEx(const filename: string; lineno, col_offset: integer);
      class function ProgramText(const filename: string; lineno: integer): IPyObject;
      class procedure SyntaxLocationObject(const filename: IPyObject; lineno, col_offset: integer);
      class procedure RangedSyntaxLocationObject(const filename: IPyObject; lineno, col_offset, end_lineno, end_col_offset: integer);
      class function ProgramTextObject(const filename: IPyObject; lineno: integer): IPyObject;
      class function WarnEx(const category: IPyObject; const message_: string; stack_level: Py_ssize_t): boolean;
      class function WarnExplicit(const category: IPyObject; const message_, filename: string; lineno: integer; const module_: string; const registry_: IPyObject): boolean;
      class function WarnExplicitObject(const category, message_, filename: IPyObject; lineno: integer; const module_, registry_: IPyObject): boolean;
      class procedure Print;
      class procedure PrintEx(set_sys_last_vars: integer);
      class procedure Display(const unused, value, tb: IPyObject);
      class procedure DisplayException(const exc: IPyObject);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyUnicode;

class procedure TPyErr.SetNone(const type_: IPyObject);
begin
  if assigned(PyErr_SetNone) and
     TPyObject.IsInitialized(type_) then
    PyErr_SetNone(type_.PyObject);
end;

class procedure TPyErr.SetObject(const type_, value: IPyObject);
begin
  if assigned(PyErr_SetObject) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(value) then
    PyErr_SetObject(type_.PyObject, value.PyObject);
end;

class procedure TPyErr.SetMessage(const type_: IPyObject; const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(PyErr_SetString) and
     TPyObject.IsInitialized(type_) then
    begin
      TempMessage := StringToPyUTF8(message_);
      PyErr_SetString(type_.PyObject, PAnsiChar(TempMessage));
    end;
end;

class function TPyErr.Occurred(): IPyObject;
begin
  if assigned(PyErr_Occurred) then
    Result := TPyObject.Wrap(PyErr_Occurred(), False, False)
   else
    Result := nil;
end;

class procedure TPyErr.Clear();
begin
  if assigned(PyErr_Clear) then
    PyErr_Clear();
end;

class procedure TPyErr.Fetch(out ptype, pvalue, ptraceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_Fetch) then
    begin
      PyErr_Fetch(TempType, TempValue, TempTraceback);
      ptype      := TPyObject.Wrap(TempType);
      pvalue     := TPyObject.Wrap(TempValue);
      ptraceback := TPyObject.Wrap(TempTraceback);
    end
   else
    begin
      ptype      := nil;
      pvalue     := nil;
      ptraceback := nil;
    end;
end;

class procedure TPyErr.Restore(const type_, value, traceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_Restore) then
    begin
      if TPyObject.IsInitialized(type_) then
        TempType := type_.PyObject
       else
        TempType := nil;

      if TPyObject.IsInitialized(value) then
        TempValue := value.PyObject
       else
        TempValue := nil;

      if TPyObject.IsInitialized(traceback) then
        TempTraceback := traceback.PyObject
       else
        TempTraceback := nil;

      PyErr_Restore(TempType, TempValue, TempTraceback);
    end;
end;

class function TPyErr.GetRaisedException(): IPyObject;
begin
  if assigned(PyErr_GetRaisedException) then
    Result := TPyObject.Wrap(PyErr_GetRaisedException())
   else
    Result := nil;
end;

class procedure TPyErr.SetRaisedException(const exc: IPyObject);
begin
  if assigned(PyErr_SetRaisedException) and
     TPyObject.IsInitialized(exc) then
    PyErr_SetRaisedException(exc.UnWrap);
end;

class function TPyErr.GetHandledException(): IPyObject;
begin
  if assigned(PyErr_GetHandledException) then
    Result := TPyObject.Wrap(PyErr_GetHandledException())
   else
    Result := nil;
end;

class procedure TPyErr.SetHandledException(const exc: IPyObject);
begin
  if assigned(PyErr_SetHandledException) then
    begin
      if TPyObject.IsInitialized(exc) then
        PyErr_SetHandledException(exc.PyObject)
       else
        PyErr_SetHandledException(nil);
    end;
end;

class procedure TPyErr.GetExcInfo(out ptype, pvalue, ptraceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_GetExcInfo) then
    begin
      PyErr_GetExcInfo(TempType, TempValue, TempTraceback);

      ptype      := TPyObject.Wrap(TempType);
      pvalue     := TPyObject.Wrap(TempValue);
      ptraceback := TPyObject.Wrap(TempTraceback);
    end
   else
    begin
      ptype      := nil;
      pvalue     := nil;
      ptraceback := nil;
    end;
end;

class procedure TPyErr.SetExcInfo(const type_, value, traceback: IPyObject);
var
  TempType, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_SetExcInfo) then
    begin
      if TPyObject.IsInitialized(type_) then
        TempType := type_.PyObject
       else
        TempType := nil;

      if TPyObject.IsInitialized(value) then
        TempValue := value.PyObject
       else
        TempValue := nil;

      if TPyObject.IsInitialized(traceback) then
        TempTraceback := traceback.PyObject
       else
        TempTraceback := nil;

      PyErr_SetExcInfo(TempType, TempValue, TempTraceback);
    end;
end;

class function TPyErr.GivenExceptionMatches(const given, exc: IPyObject): boolean;
begin
  Result := assigned(PyErr_GivenExceptionMatches) and
            TPyObject.IsInitialized(given) and
            TPyObject.IsInitialized(exc) and
            (PyErr_GivenExceptionMatches(given.PyObject, exc.PyObject) <> 0);
end;

class function TPyErr.ExceptionMatches(const exc: IPyObject): boolean;
begin
  Result := assigned(PyErr_ExceptionMatches) and
            TPyObject.IsInitialized(exc) and
            (PyErr_ExceptionMatches(exc.PyObject) <> 0);
end;

class procedure TPyErr.NormalizeException(out exc, val, tb: IPyObject);
var
  TempExc, TempValue, TempTraceback: PPyObject;
begin
  if assigned(PyErr_NormalizeException) then
    begin
      PyErr_NormalizeException(TempExc, TempValue, TempTraceback);

      exc := TPyObject.Wrap(TempExc);
      val := TPyObject.Wrap(TempValue);
      tb  := TPyObject.Wrap(TempTraceback);
    end
   else
    begin
      exc := nil;
      val := nil;
      tb  := nil;
    end;
end;

class function TPyErr.BadArgument(): boolean;
begin
  Result := assigned(PyErr_BadArgument) and
            (PyErr_BadArgument() <> 0);
end;

class function TPyErr.NoMemory(): IPyObject;
begin
  if assigned(PyErr_NoMemory) then
    Result := TPyObject.Wrap(PyErr_NoMemory())
   else
    Result := nil;
end;

class function TPyErr.SetFromErrno(const type_: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetFromErrno) and
     TPyObject.IsInitialized(type_) then
    Result := TPyObject.Wrap(PyErr_SetFromErrno(type_.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetFromErrnoWithFilenameObject(const type_, filenameObject: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetFromErrnoWithFilenameObject) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filenameObject) then
    Result := TPyObject.Wrap(PyErr_SetFromErrnoWithFilenameObject(type_.PyObject, filenameObject.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetFromErrnoWithFilenameObjects(const type_, filenameObject, filenameObject2: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetFromErrnoWithFilenameObjects) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filenameObject) and
     TPyObject.IsInitialized(filenameObject2) then
    Result := TPyObject.Wrap(PyErr_SetFromErrnoWithFilenameObjects(type_.PyObject, filenameObject.PyObject, filenameObject2.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetFromErrnoWithFilename(const type_: IPyObject; const filename: string): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SetFromErrnoWithFilename) and
     TPyObject.IsInitialized(type_) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyErr_SetFromErrnoWithFilename(type_.PyObject, PAnsiChar(TempFilename)))
    end
   else
    Result := nil;
end;

class function TPyErr.SetFromWindowsErrWithFilename(ierr: integer; const filename: string): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SetFromWindowsErrWithFilename) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyErr_SetFromWindowsErrWithFilename(ierr, PAnsiChar(TempFilename)))
    end
   else
    Result := nil;
end;

class function TPyErr.SetFromWindowsErr(ierr: integer): IPyObject;
begin
  if assigned(PyErr_SetFromWindowsErr) then
    Result := TPyObject.Wrap(PyErr_SetFromWindowsErr(ierr))
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErrWithFilenameObject(const type_: IPyObject; ierr: integer; const filename: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetExcFromWindowsErrWithFilenameObject) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filename) then
    Result := TPyObject.Wrap(PyErr_SetExcFromWindowsErrWithFilenameObject(type_.PyObject, ierr, filename.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErrWithFilenameObjects(const type_: IPyObject; ierr: integer; const filename, filename2: IPyObject): IPyObject;
begin
  if assigned(PyErr_SetExcFromWindowsErrWithFilenameObjects) and
     TPyObject.IsInitialized(type_) and
     TPyObject.IsInitialized(filename) and
     TPyObject.IsInitialized(filename2) then
    Result := TPyObject.Wrap(PyErr_SetExcFromWindowsErrWithFilenameObjects(type_.PyObject, ierr, filename.PyObject, filename2.PyObject))
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErrWithFilename(const type_: IPyObject; ierr: integer; const filename: string): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SetExcFromWindowsErrWithFilename) and
     TPyObject.IsInitialized(type_) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(PyErr_SetExcFromWindowsErrWithFilename(type_.PyObject, ierr, PAnsiChar(TempFilename)));
    end
   else
    Result := nil;
end;

class function TPyErr.SetExcFromWindowsErr(const type_: IPyObject; ierr: integer): IPyObject;
begin
  if assigned(PyErr_SetExcFromWindowsErr) and
     TPyObject.IsInitialized(type_) then
    Result := TPyObject.Wrap(PyErr_SetExcFromWindowsErr(type_.PyObject, ierr))
   else
    Result := nil;
end;

class function TPyErr.SetImportErrorSubclass(const exception, msg, name_, path: IPyObject): IPyObject;
var
  TempName, TempPath : PPyObject;
begin
  if assigned(PyErr_SetImportErrorSubclass) and
     TPyObject.IsInitialized(exception) and
     TPyObject.IsInitialized(msg) then
    begin
      if TPyObject.IsInitialized(name_) then
        TempName := name_.PyObject
       else
        TempName := nil;

      if TPyObject.IsInitialized(path) then
        TempPath := path.PyObject
       else
        TempPath := nil;

      Result := TPyObject.Wrap(PyErr_SetImportErrorSubclass(exception.PyObject, msg.PyObject, TempName, TempPath));
    end
   else
    Result := nil;
end;

class function TPyErr.SetImportError(const msg, name_, path: IPyObject): IPyObject;
var
  TempName, TempPath : PPyObject;
begin
  if assigned(PyErr_SetImportError) and
     TPyObject.IsInitialized(msg) then
    begin
      if TPyObject.IsInitialized(name_) then
        TempName := name_.PyObject
       else
        TempName := nil;

      if TPyObject.IsInitialized(path) then
        TempPath := path.PyObject
       else
        TempPath := nil;

      Result := TPyObject.Wrap(PyErr_SetImportError(msg.PyObject, TempName, TempPath));
    end
   else
    Result := nil;
end;

class procedure TPyErr.BadInternalCall;
begin
  if assigned(PyErr_BadInternalCall) then
    PyErr_BadInternalCall();
end;

class function TPyErr.NewException(const name_: string; const base, dict: IPyObject): IPyObject;
var
  TempName : AnsiString;
  TempBase, TempDict : PPyObject;
begin
  if assigned(PyErr_NewException) then
    begin
      TempName := StringToPyUTF8(name_);

      if TPyObject.IsInitialized(base) then
        TempBase := base.PyObject
       else
        TempBase := nil;

      if TPyObject.IsInitialized(dict) then
        TempDict := dict.PyObject
       else
        TempDict := nil;

      Result := TPyObject.Wrap(PyErr_NewException(PAnsiChar(TempName), TempBase, TempDict));
    end
   else
    Result := nil;
end;

class function TPyErr.NewExceptionWithDoc(const name_, doc: string; base, dict: IPyObject): IPyObject;
var
  TempName, TempDoc : AnsiString;
  TempBase, TempDict : PPyObject;
begin
  if assigned(PyErr_NewExceptionWithDoc) then
    begin
      TempName := StringToPyUTF8(name_);
      TempDoc  := StringToPyUTF8(doc);

      if TPyObject.IsInitialized(base) then
        TempBase := base.PyObject
       else
        TempBase := nil;

      if TPyObject.IsInitialized(dict) then
        TempDict := dict.PyObject
       else
        TempDict := nil;

      Result := TPyObject.Wrap(PyErr_NewExceptionWithDoc(PAnsiChar(TempName), PAnsiChar(TempDoc), TempBase, TempDict));
    end
   else
    Result := nil;
end;

class procedure TPyErr.WriteUnraisable(const obj: IPyObject);
begin
  if assigned(PyErr_WriteUnraisable) then
    begin
      if TPyObject.IsInitialized(obj) then
        PyErr_WriteUnraisable(obj.PyObject)
       else
        PyErr_WriteUnraisable(nil);
    end
end;

class function TPyErr.CheckSignals(): boolean;
begin
  Result := assigned(PyErr_CheckSignals) and
            (PyErr_CheckSignals() = 0);
end;

class procedure TPyErr.SetInterrupt();
begin
  if assigned(PyErr_SetInterrupt) then
    PyErr_SetInterrupt();
end;

class function TPyErr.SetInterruptEx(signum: integer): boolean;
begin
  Result := assigned(PyErr_SetInterruptEx) and
            (PyErr_SetInterruptEx(signum) = 0);
end;

class procedure TPyErr.SyntaxLocation(const filename: string; lineno: integer);
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SyntaxLocation) then
    begin
      TempFilename := StringToPyUTF8(filename);
      PyErr_SyntaxLocation(PAnsiChar(TempFilename), lineno);
    end;
end;

class procedure TPyErr.SyntaxLocationEx(const filename: string; lineno, col_offset: integer);
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_SyntaxLocationEx) then
    begin
      TempFilename := StringToPyUTF8(filename);
      PyErr_SyntaxLocationEx(PAnsiChar(TempFilename), lineno, col_offset);
    end;
end;

class function TPyErr.ProgramText(const filename: string; lineno: integer): IPyObject;
var
  TempFilename : AnsiString;
begin
  if assigned(PyErr_ProgramText) then
    begin
      TempFilename := StringToPyUTF8(filename);
      Result := TPyObject.Wrap(PyErr_ProgramText(PAnsiChar(TempFilename), lineno));
    end
   else
    Result := nil;
end;

class procedure TPyErr.SyntaxLocationObject(const filename: IPyObject; lineno, col_offset: integer);
begin
  if assigned(PyErr_SyntaxLocationObject) and
     TPyObject.IsInitialized(filename) then
    PyErr_SyntaxLocationObject(filename.PyObject, lineno, col_offset);
end;

class procedure TPyErr.RangedSyntaxLocationObject(const filename: IPyObject; lineno, col_offset, end_lineno, end_col_offset: integer);
begin
  if assigned(PyErr_RangedSyntaxLocationObject) and
     TPyObject.IsInitialized(filename) then
    PyErr_RangedSyntaxLocationObject(filename.PyObject, lineno, col_offset, end_lineno, end_col_offset);
end;

class function TPyErr.ProgramTextObject(const filename: IPyObject; lineno: integer): IPyObject;
begin
  if assigned(PyErr_ProgramTextObject) and
     TPyObject.IsInitialized(filename) then
    Result := TPyObject.Wrap(PyErr_ProgramTextObject(filename.PyObject, lineno))
   else
    Result := nil;
end;

class function TPyErr.WarnEx(const category: IPyObject; const message_: string; stack_level: Py_ssize_t): boolean;
var
  TempMessage : AnsiString;
begin
  Result := False;

  if assigned(PyErr_WarnEx) then
    begin
      TempMessage := StringToPyUTF8(message_);

      if TPyObject.IsInitialized(category) then
        Result := (PyErr_WarnEx(category.PyObject, PAnsiChar(TempMessage), stack_level) = 0)
       else
        Result := (PyErr_WarnEx(nil, PAnsiChar(TempMessage), stack_level) = 0);
    end;
end;

class function TPyErr.WarnExplicit(const category: IPyObject; const message_, filename: string; lineno: integer; const module_: string; const registry_: IPyObject): boolean;
var
  TempMessage, TempFilename, TempModule : AnsiString;
  TempCategory, TempRegistry : PPyObject;
begin
  Result := False;

  if assigned(PyErr_WarnExplicit) then
    begin
      TempMessage  := StringToPyUTF8(message_);
      TempFilename := StringToPyUTF8(filename);
      TempModule   := StringToPyUTF8(module_);

      if TPyObject.IsInitialized(category) then
        TempCategory := category.PyObject
       else
        TempCategory := nil;

      if TPyObject.IsInitialized(registry_) then
        TempRegistry := registry_.PyObject
       else
        TempRegistry := nil;

      Result := (PyErr_WarnExplicit(TempCategory, PAnsiChar(TempMessage), PAnsiChar(TempFilename), lineno, PAnsiChar(TempModule), TempRegistry) = 0);
    end;
end;

class function TPyErr.WarnExplicitObject(const category, message_, filename: IPyObject; lineno: integer; const module_, registry_: IPyObject): boolean;
var
  TempCategory, TempMessage, TempFilename, TempModule, TempRegistry : PPyObject;
begin
  Result := False;

  if assigned(PyErr_WarnExplicitObject) then
    begin
      if TPyObject.IsInitialized(category) then
        TempCategory := category.PyObject
       else
        TempCategory := nil;

      if TPyObject.IsInitialized(message_) then
        TempMessage := message_.PyObject
       else
        TempMessage := nil;

      if TPyObject.IsInitialized(filename) then
        TempFilename := filename.PyObject
       else
        TempFilename := nil;

      if TPyObject.IsInitialized(module_) then
        TempModule := module_.PyObject
       else
        TempModule := nil;

      if TPyObject.IsInitialized(registry_) then
        TempRegistry := registry_.PyObject
       else
        TempRegistry := nil;

      Result := (PyErr_WarnExplicitObject(TempCategory, TempMessage, TempFilename, lineno, TempModule, TempRegistry) = 0);
    end;
end;

class procedure TPyErr.Print;
begin
  if assigned(PyErr_Print) then
    PyErr_Print();
end;

class procedure TPyErr.PrintEx(set_sys_last_vars: integer);
begin
  if assigned(PyErr_PrintEx) then
    PyErr_PrintEx(set_sys_last_vars);
end;

class procedure TPyErr.Display(const unused, value, tb: IPyObject);
begin
  if assigned(PyErr_Display) and
     TPyObject.IsInitialized(unused) and
     TPyObject.IsInitialized(value) and
     TPyObject.IsInitialized(tb) then
    PyErr_Display(unused.PyObject, value.PyObject, tb.PyObject);
end;

class procedure TPyErr.DisplayException(const exc: IPyObject);
begin
  if assigned(PyErr_DisplayException) and
     TPyObject.IsInitialized(exc) then
    PyErr_DisplayException(exc.PyObject);
end;

end.
