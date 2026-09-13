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
  /// <summary>
  /// A Unicode writer instance.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/unicode.html#c.PyUnicodeWriter">See the article about PyUnicodeWriter.</see></para>
  /// </remarks>
  TPyUnicodeWriter = class(TInterfacedObject, IPyUnicodeWriter)
    protected
      FWriter  : PPyUnicodeWriter;

      function  GetWriter: PPyUnicodeWriter;
      function  GetInitialized: boolean;
      /// <summary>
      /// <para>Discard the internal Unicode buffer and destroy the writer
      /// instance.</para>
      /// <para>The writer instance is invalid after this call.</para>
      /// </summary>
      procedure Discard;
      /// <summary>
      /// <para>Return the final Python str object and destroy the writer
      /// instance.</para>
      /// <para>Set an exception and return nil on error.</para>
      /// <para>The writer instance is invalid after this call.</para>
      /// </summary>
      function  Finish: IPyObject;
      /// <summary>
      /// <para>Write the single Unicode character ch into writer.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// </summary>
      function  WriteChar(ch: Py_UCS4): boolean;
      /// <summary>
      /// <para>Decode the string str from UTF-8 in strict mode and write the
      /// output into writer.</para>
      /// <para>size_ is the string length in bytes. If size is equal to -1,
      /// call strlen(str) to get the string length.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// <para>See also DecodeUTF8Stateful().</para>
      /// </summary>
      function  WriteUTF8(const str: PAnsiChar; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Write the ASCII string str into writer.</para>
      /// <para>size_ is the string length in bytes. If size_ is equal to -1,
      /// call strlen(str) to get the string length.</para>
      /// <para>str must only contain ASCII characters. The behavior is
      /// undefined if str contains non-ASCII characters.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// </summary>
      function  WriteASCII(const str: PAnsiChar; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Write the wide string str into writer.</para>
      /// <para>size_ is a number of wide characters. If size_ is equal to -1,
      /// call wcslen(str) to get the string length.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// </summary>
      function  WriteWideChar(const str: PWCharT; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Writer the UCS4 string str into writer.</para>
      /// <para>size_ is a number of UCS4 characters.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// </summary>
      function  WriteUCS4(const str: PPy_UCS4; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Call TPyObject.Str() on obj and write the output into
      /// writer.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// <para>To write a str subclass which overrides the __str__() method,
      /// TPyUnicode.FromObject() can be used to get the original string.</para>
      /// </summary>
      function  WriteStr(const obj: IPyObject): boolean;
      /// <summary>
      /// <para>Call TPyObject.Repr() on obj and write the output into
      /// writer.</para>
      /// <para>If obj is nil, write the string "<NULL>" into writer.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// <para>Changed in version 3.14.4: Added support for nil.</para>
      /// </summary>
      function  WriteRepr(const obj: IPyObject): boolean;
      /// <summary>
      /// <para>Write the substring str[start:end] into writer.</para>
      /// <para>str must be Python str object. start must be greater than or
      /// equal to 0, and less than or equal to end. end must be less than or
      /// equal to str length.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// </summary>
      function  WriteSubstring(str: PPyObject; start, end_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Decode string_ from UTF-8 with errors error handler and
      /// write the output into writer.</para>
      /// <para>size_ is the string length in bytes. If size_ is equal to -1,
      /// call strlen(string_) to get the string length.</para>
      /// <para>errors is an error handler name, such as "replace". If errors is
      /// nil, use the strict error handler.</para>
      /// <para>If consumed is not nil, set *consumed to the number of decoded
      /// bytes on success. If consumed is nil, treat trailing incomplete UTF-8
      /// byte sequences as an error.</para>
      /// <para>On success, return True. On error, set an exception, leave the
      /// writer unchanged, and return False.</para>
      /// <para>See also WriteUTF8().</para>
      /// </summary>
      function  DecodeUTF8Stateful(const string_: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): boolean;

    public
      /// <summary>
      /// <para>Create a Unicode writer instance.</para>
      /// <para>length must be greater than or equal to 0.</para>
      /// <para>If length is greater than 0, preallocate an internal buffer of
      /// length characters.</para>
      /// <para>Set an exception on error.</para>
      /// </summary>
      constructor Create(length: Py_ssize_t);
      destructor  Destroy; override;
      /// <summary>
      /// Returns true if this class is fully initialized.
      /// </summary>
      property Initialized  : boolean           read GetInitialized;
      /// <summary>
      /// Pointer to the PyUnicodeWriter record.
      /// </summary>
      property Writer       : PPyUnicodeWriter  read GetWriter;
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

function TPyUnicodeWriter.GetWriter: PPyUnicodeWriter;
begin
  Result := FWriter;
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

function TPyUnicodeWriter.WriteUCS4(const str: PPy_UCS4; size_: Py_ssize_t): boolean;
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
