unit uP4P.PyUnicodeWriter;

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
  TPyUnicodeWriter = class(TInterfacedObject, IPyUnicodeWriter)
    protected
      FWriter  : PPyUnicodeWriter;

      function  GetInitialized: boolean;
      procedure Discard;
      function  Finish: IPyObject;
      function  WriteChar(ch: Py_UCS4): boolean;
      function  WriteUTF8(const str: PAnsiChar; size_: Py_ssize_t): boolean;
      function  WriteASCII(const str: PAnsiChar; size_: Py_ssize_t): boolean;
      function  WriteWideChar(const str: PWCharT; size_: Py_ssize_t): boolean;
      function  WriteUCS4(str: PPy_UCS4; size_: Py_ssize_t): boolean;
      function  WriteStr(const obj: IPyObject): boolean;
      function  WriteRepr(const obj: IPyObject): boolean;
      function  WriteSubstring(str: PPyObject; start, end_: Py_ssize_t): boolean;
      function  DecodeUTF8Stateful(const string_: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): boolean;

    public
      constructor Create(length: Py_ssize_t);
      destructor  Destroy; override;

      property Initialized  : boolean           read GetInitialized;
      property Writer       : PPyUnicodeWriter  read FWriter;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

constructor TPyUnicodeWriter.Create(length: Py_ssize_t);
begin
  inherited Create;

  if assigned(PyUnicodeWriter_Create) then
    FWriter := PyUnicodeWriter_Create(length)
   else
    FWriter := nil;
end;

destructor TPyUnicodeWriter.Destroy;
begin
  Discard;

  inherited Destroy;
end;

function TPyUnicodeWriter.GetInitialized: boolean;
begin
  Result := (FWriter <> nil);
end;

procedure TPyUnicodeWriter.Discard;
begin
  if Initialized and assigned(PyUnicodeWriter_Discard) then
    try
      PyUnicodeWriter_Discard(FWriter);
    finally
      FWriter := nil;
    end;
end;

function TPyUnicodeWriter.Finish: IPyObject;
begin
  if Initialized and assigned(PyUnicodeWriter_Finish) then
    begin
      Result  := TPyObject.Wrap(PyUnicodeWriter_Finish(FWriter));
      FWriter := nil;
    end
   else
    Result := nil;
end;

function TPyUnicodeWriter.WriteChar(ch: Py_UCS4): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteChar) and
            (PyUnicodeWriter_WriteChar(FWriter, ch) = 0);
end;

function TPyUnicodeWriter.WriteUTF8(const str: PAnsiChar; size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteUTF8) and
            (PyUnicodeWriter_WriteUTF8(FWriter, str, size_) = 0);
end;

function TPyUnicodeWriter.WriteASCII(const str: PAnsiChar; size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteASCII) and
            (PyUnicodeWriter_WriteASCII(FWriter, str, size_) = 0);
end;

function TPyUnicodeWriter.WriteWideChar(const str: PWCharT; size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteWideChar) and
            (PyUnicodeWriter_WriteWideChar(FWriter, str, size_) = 0);
end;

function TPyUnicodeWriter.WriteUCS4(str: PPy_UCS4; size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteUCS4) and
            (PyUnicodeWriter_WriteUCS4(FWriter, str, size_) = 0);
end;

function TPyUnicodeWriter.WriteStr(const obj: IPyObject): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteStr) and
            TPyObject.IsInitialized(obj) and
            (PyUnicodeWriter_WriteStr(FWriter, obj.PyObject) = 0);
end;

function TPyUnicodeWriter.WriteRepr(const obj: IPyObject): boolean;
begin
  if Initialized and assigned(PyUnicodeWriter_WriteRepr) then
    begin
      if TPyObject.IsInitialized(obj) then
        Result := (PyUnicodeWriter_WriteRepr(FWriter, obj.PyObject) = 0)
       else
        Result := (PyUnicodeWriter_WriteRepr(FWriter, nil) = 0);
    end
   else
    Result := False;
end;

function TPyUnicodeWriter.WriteSubstring(str: PPyObject; start, end_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyUnicodeWriter_WriteSubstring) and
            (PyUnicodeWriter_WriteSubstring(FWriter, str, start, end_) = 0);
end;

function TPyUnicodeWriter.DecodeUTF8Stateful(const string_: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): boolean;
var
  TempErrors : AnsiString;
begin
  if Initialized and assigned(PyUnicodeWriter_DecodeUTF8Stateful) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      Result     := (PyUnicodeWriter_DecodeUTF8Stateful(FWriter, string_, length, PAnsiChar(TempErrors), @consumed) = 0);
    end
   else
    Result := False;
end;

end.
