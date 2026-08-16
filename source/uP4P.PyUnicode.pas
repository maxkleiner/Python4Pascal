unit uP4P.PyUnicode;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants,
  {$ELSE}
    Classes, SysUtils, Variants,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyUnicode_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/unicode.html#unicode-objects-and-codecs">See the article about the Unicode Objects and Codecs.</see></para>
  /// </remarks>
  TPyUnicode = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a Unicode object or an instance of
      /// a Unicode subtype. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if the object aPyObject is a Unicode object, but not
      /// an instance of a subtype. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromStringAndSize(const str: string; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromString(const str: string): IPyObject; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromString(const str: AnsiString): IPyObject; overload;
      {$ENDIF}
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromBufferAndSize(const buffer: PByte; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromBuffer(const buffer: PByte): IPyObject;
      /// <summary>
      /// <para>Wrap a Variant with a python unicode object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a python unicode object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Substring(const str: IPyObject; start, end_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUCS4(const unicode: IPyObject; buffer: PPy_UCS4; buflen: Py_ssize_t; copy_null: boolean): PPy_UCS4;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUCS4Copy(const unicode: IPyObject): PPy_UCS4;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function GetLength(const unicode: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function ReadChar(const unicode: IPyObject; index: Py_ssize_t): Py_UCS4;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function WriteChar(const unicode: IPyObject; index: Py_ssize_t; character: Py_UCS4): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Resize(const unicode: IPyObject; length_: Py_ssize_t): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromEncodedObject(const obj: IPyObject; const encodging, errors: PAnsiChar): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromObject(const obj: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class procedure InternInPlace(const unicode: IPyObject);
      /// <summary>
      /// <para></para>
      /// </summary>
      class function InternFromString(const str: string): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromWideChar(const w: PWCharT; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsWideChar(const unicode: IPyObject; w: PWCharT; size_: Py_ssize_t): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsWideCharString(const unicode: IPyObject; var size_: Py_ssize_t): PWCharT;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromOrdinal(ordinal: integer): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function GetDefaultEncoding(): string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Decode(const s: PAnsiChar; size_: Py_ssize_t; const encoding: string; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsEncodedString(const unicode: IPyObject; const encoding: string; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function BuildEncodingMap(const string_: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF7(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF7Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF8(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF8Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUTF8String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUTF8AndSize(const unicode: IPyObject; var size_: Py_ssize_t): PAnsiChar;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF32(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF32Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUTF32String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF16(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUTF16Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUTF16String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeUnicodeEscape(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUnicodeEscapeString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeRawUnicodeEscape(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsRawUnicodeEscapeString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeLatin1(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsLatin1String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeASCII(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsASCIIString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeCharmap(const str: PAnsiChar; length: Py_ssize_t; const mapping: IPyObject; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsCharmapString(const unicode, mapping: IPyObject): IPyObject;
      {$IFDEF MSWINDOWS}
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeMBCS(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeMBCSStateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeCodePageStateful(codepage: integer; const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsMBCSString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function EncodeCodePage(codepage: integer; const unicode: IPyObject; errors: TPyCodecErrors): IPyObject;
      {$ENDIF}
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeLocaleAndSize(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeLocale(const str: PAnsiChar; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function EncodeLocale(const unicode: IPyObject; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FSConverter(const obj: IPyObject; result_: Pointer): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FSDecoder(const obj: IPyObject; result_: Pointer): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeFSDefault(const str: PAnsiChar): IPyObject; overload;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeFSDefault(const str: string): IPyObject; overload;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeFSDefaultAndSize(const str: PAnsiChar; size_: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DecodeFSDefaultAndSize(const str: string; size_: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function EncodeFSDefault(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Concat(const left, right: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class procedure Append(const left, right: IPyObject);
      /// <summary>
      /// <para></para>
      /// </summary>
      class procedure AppendAndDel(const left, right: IPyObject);
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Split(const unicode, sep: IPyObject; maxsplit: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Splitlines(const unicode: IPyObject; keepends: boolean): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Partition(const unicode, sep: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function RPartition(const unicode, sep: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function RSplit(const unicode, sep: IPyObject; maxsplit: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Translate(const unicode, table: IPyObject; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Join(const separator, sep: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Tailmatch(const unicode, substr: IPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Find(const unicode, substr: IPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FindChar(const unicode: IPyObject; ch: Py_UCS4; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Count(const unicode, substr: IPyObject; start, end_: Py_ssize_t): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Replace(const str, substr, replstr: IPyObject; maxcount: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Compare(const left, right: IPyObject): integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function CompareWithASCIIString(const left: IPyObject; const right: PAnsiChar): integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function EqualToUTF8(const unicode: IPyObject; const string_: PAnsiChar): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function EqualToUTF8AndSize(const unicode: IPyObject; const string_: PAnsiChar; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Equal(const a, b: IPyObject): integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function RichCompare(const left, right: IPyObject; op: integer): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Format(const format_, args: IPyObject): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Contains(const unicode, substr: IPyObject): integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function IsIdentifier(const unicode: IPyObject): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function KIND(const unicode: IPyObject): PyUnicode_Kind_Result;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function DATA(const unicode: IPyObject): Pointer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function New(size_: Py_ssize_t; maxchar: Py_UCS4): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function CopyCharacters(const to_: IPyObject; to_start: Py_ssize_t; const from: IPyObject; from_start, how_many: Py_ssize_t): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Fill(const unicode: IPyObject; start, length: Py_ssize_t; fill_char: Py_UCS4): Py_ssize_t;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function FromKindAndData(kind_: integer; buffer: Pointer; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function AsUTF8(const unicode: IPyObject): PAnsiChar;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyUnicode.FromStringAndSize(const str: string; size_: Py_ssize_t): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyUnicode_FromStringAndSize) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(PyUnicode_FromStringAndSize(PAnsiChar(TempString), size_))
    end
   else
    Result := nil;
end;

class function TPyUnicode.FromString(const str: string): IPyObject;
var
  TempStr : AnsiString;
begin
  if assigned(PyUnicode_FromString) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := TPyObject.Wrap(PyUnicode_FromString(PAnsiChar(TempStr)));
    end
   else
    Result := nil;
end;

{$IFDEF DELPHI12_UP}
class function TPyUnicode.FromString(const str: AnsiString): IPyObject;
begin
  if assigned(PyUnicode_FromString) then
    Result := TPyObject.Wrap(PyUnicode_FromString(PAnsiChar(str)))
   else
    Result := nil;
end;
{$ENDIF}

class function TPyUnicode.FromBufferAndSize(const buffer: PByte; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_FromStringAndSize) then
    Result := TPyObject.Wrap(PyUnicode_FromStringAndSize(PAnsiChar(buffer), size_))
   else
    Result := nil;
end;

class function TPyUnicode.FromBuffer(const buffer: PByte): IPyObject;
begin
  if assigned(PyUnicode_FromString) then
    Result := TPyObject.Wrap(PyUnicode_FromString(PAnsiChar(buffer)))
   else
    Result := nil;
end;

class function TPyUnicode.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  case aVarType of
    varOleStr,
    {$IFDEF SUPPORTS_VARUSTRING}
    varUString,
    {$ENDIF}
    varString  : Result := FromString(string(aVariant))
    else         Result := nil;
  end;
end;

class function TPyUnicode.FromVariant(const aVariant: Variant): IPyObject;
var
  TempType    : TVarType;
  TempVariant : Variant;
begin
  TempVariant := aVariant;
  TempType    := varByRef or varVariant;

  while VarType(TempVariant) = TempType do
    TempVariant := Variant(PVarData(TVarData(TempVariant).VPointer)^);

  Result := FromVariant(TempVariant, VarType(TempVariant) and (VarTypeMask or VarArray));
end;

class function TPyUnicode.Substring(const str: IPyObject; start, end_: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_Substring) and
     TPyObject.IsInitialized(str) then
    Result := TPyObject.Wrap(PyUnicode_Substring(str.PyObject, start, end_))
   else
    Result := nil;
end;

class function TPyUnicode.AsUCS4(const unicode: IPyObject; buffer: PPy_UCS4; buflen: Py_ssize_t; copy_null: boolean): PPy_UCS4;
begin
  if assigned(PyUnicode_AsUCS4) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_AsUCS4(unicode.PyObject, buffer, buflen, ord(copy_null))
   else
    Result := nil;
end;

class function TPyUnicode.AsUCS4Copy(const unicode: IPyObject): PPy_UCS4;
begin
  if assigned(PyUnicode_AsUCS4Copy) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_AsUCS4Copy(unicode.PyObject)
   else
    Result := nil;
end;

class function TPyUnicode.GetLength(const unicode: IPyObject): Py_ssize_t;
begin
  if assigned(PyUnicode_GetLength) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_GetLength(unicode.PyObject)
   else
    Result := -1;
end;

class function TPyUnicode.ReadChar(const unicode: IPyObject; index: Py_ssize_t): Py_UCS4;
begin
  if assigned(PyUnicode_ReadChar) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_ReadChar(unicode.PyObject, index)
   else
    Result := Py_UCS4(-1);
end;

class function TPyUnicode.WriteChar(const unicode: IPyObject; index: Py_ssize_t; character: Py_UCS4): boolean;
begin
  Result := assigned(PyUnicode_WriteChar) and
            TPyObject.IsInitialized(unicode) and
            (PyUnicode_WriteChar(unicode.PyObject, index, character) = 0);
end;

class function TPyUnicode.Resize(const unicode: IPyObject; length_: Py_ssize_t): boolean;
var
  TempObj : PPyObject;
begin
  Result := False; 
  
  if assigned(PyUnicode_Resize) and
     TPyObject.IsInitialized(unicode) then
    begin  
      TempObj := unicode.PyObject;
      
      if (PyUnicode_Resize(@TempObj, length_) = 0) then
        begin
          Result := True;         
          unicode.PyObject := TempObj;
        end;
    end;
end;

class function TPyUnicode.FromEncodedObject(const obj: IPyObject; const encodging, errors: PAnsiChar): IPyObject;
begin
  if assigned(PyUnicode_FromEncodedObject) and
     TPyObject.IsInitialized(obj) then
    Result := TPyObject.Wrap(PyUnicode_FromEncodedObject(obj.PyObject, encodging, errors))
   else
    Result := nil;
end;

class function TPyUnicode.FromObject(const obj: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_FromObject) and
     TPyObject.IsInitialized(obj) then
    Result := TPyObject.Wrap(PyUnicode_FromObject(obj.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.InternFromString(const str: string): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyUnicode_InternFromString) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(PyUnicode_InternFromString(PAnsiChar(TempString)))
    end
   else
    Result := nil;
end;

class function TPyUnicode.FromWideChar(const w: PWCharT; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_FromWideChar) then
    Result := TPyObject.Wrap(PyUnicode_FromWideChar(w, size_))
   else
    Result := nil;
end;

class function TPyUnicode.FromOrdinal(ordinal: integer): IPyObject;
begin
  if assigned(PyUnicode_FromOrdinal) then
    Result := TPyObject.Wrap(PyUnicode_FromOrdinal(ordinal))
   else
    Result := nil;
end;

class function TPyUnicode.Decode(const s: PAnsiChar; size_: Py_ssize_t; const encoding: string; errors: TPyCodecErrors): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
begin
  if assigned(PyUnicode_Decode) then
    begin                 
      TempEncoding := StringToPyUTF8(encoding);             
      TempErrors   := ErrorToAnsiString(errors);
      Result       := TPyObject.Wrap(PyUnicode_Decode(s, size_, PAnsiChar(TempEncoding), PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF7(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF7) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF7(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF7Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF7Stateful) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF7Stateful(str, length, PAnsiChar(TempErrors), @consumed));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF8(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF8) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF8(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF8Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF8Stateful) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF8Stateful(str, length, PAnsiChar(TempErrors), @consumed));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF32(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder): IPyObject;
var
  TempErrors : AnsiString;
begin           
  if assigned(PyUnicode_DecodeUTF32) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF32(str, length, PAnsiChar(TempErrors), @byteorder));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF32Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder; var consumed: Py_ssize_t): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF32Stateful) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF32Stateful(str, length, PAnsiChar(TempErrors), @byteorder, @consumed));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF16(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF16) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF16(str, length, PAnsiChar(TempErrors), @byteorder));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUTF16Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder; var consumed: Py_ssize_t): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUTF16Stateful) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUTF16Stateful(str, length, PAnsiChar(TempErrors), @byteorder, @consumed));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeUnicodeEscape(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeUnicodeEscape) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeUnicodeEscape(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeRawUnicodeEscape(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeRawUnicodeEscape) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeRawUnicodeEscape(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeLatin1(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeLatin1) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeLatin1(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeASCII(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeASCII) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeASCII(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeCharmap(const str: PAnsiChar; length: Py_ssize_t; const mapping: IPyObject; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeCharmap) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      
      if TPyObject.IsInitialized(mapping) then
        Result := TPyObject.Wrap(PyUnicode_DecodeCharmap(str, length, mapping.PyObject, PAnsiChar(TempErrors)))
       else
        Result := TPyObject.Wrap(PyUnicode_DecodeCharmap(str, length, nil, PAnsiChar(TempErrors))); 
    end
   else
    Result := nil;
end;

{$IFDEF MSWINDOWS}
class function TPyUnicode.DecodeMBCS(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeMBCS) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeMBCS(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeMBCSStateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeMBCSStateful) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeMBCSStateful(str, length, PAnsiChar(TempErrors), @consumed));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeCodePageStateful(codepage: integer; const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeCodePageStateful) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeCodePageStateful(codepage, str, length, PAnsiChar(TempErrors), @consumed));
    end
   else
    Result := nil;
end;

class function TPyUnicode.AsMBCSString(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsMBCSString) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsMBCSString(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.EncodeCodePage(codepage: integer; const unicode: IPyObject; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_EncodeCodePage) and
     TPyObject.IsInitialized(unicode) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_EncodeCodePage(codepage, unicode.PyObject, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;
{$ENDIF}

class function TPyUnicode.DecodeLocaleAndSize(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeLocaleAndSize) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeLocaleAndSize(str, length, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.DecodeLocale(const str: PAnsiChar; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_DecodeLocale) then
    begin                 
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_DecodeLocale(str, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.Concat(const left, right: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_Concat) and
     TPyObject.IsInitialized(left) and
     TPyObject.IsInitialized(right) then 
    Result := TPyObject.Wrap(PyUnicode_Concat(left.PyObject, right.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_UNICODE_SUBCLASS));
end;

class function TPyUnicode.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyUnicode_Type);
end;

class function TPyUnicode.GetDefaultEncoding(): string;
begin
  if assigned(PyUnicode_GetDefaultEncoding) then
    Result := PyUTF8ToString(PyUnicode_GetDefaultEncoding())
   else
    Result := '';
end;

class procedure TPyUnicode.InternInPlace(const unicode: IPyObject);
var
  TempObj : PPyObject;
begin
  if assigned(PyUnicode_InternInPlace) and
     TPyObject.IsInitialized(unicode) then
    begin
      TempObj := unicode.PyObject;

      PyUnicode_InternInPlace(@TempObj);

      unicode.PyObject    := TempObj;
      unicode.ObjRefOwner := True;
    end;
end;

class function TPyUnicode.AsWideChar(const unicode: IPyObject; w: PWCharT; size_: Py_ssize_t): Py_ssize_t;
begin
  if assigned(PyUnicode_AsWideChar) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_AsWideChar(unicode.PyObject, w, size_)
   else
    Result := -1;
end;

class function TPyUnicode.AsWideCharString(const unicode: IPyObject; var size_: Py_ssize_t): PWCharT;
begin
  if assigned(PyUnicode_AsWideCharString) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_AsWideCharString(unicode.PyObject, @size_)
   else
    Result := nil;
end;

class function TPyUnicode.AsEncodedString(const unicode: IPyObject; const encoding: string; errors: TPyCodecErrors): IPyObject;
var
  TempErrors, TempEncoding : AnsiString;
begin
  if assigned(PyUnicode_AsEncodedString) and
     TPyObject.IsInitialized(unicode) then
    begin 
      TempErrors   := ErrorToAnsiString(errors);
      TempEncoding := StringToPyUTF8(encoding);    
      Result       := TPyObject.Wrap(PyUnicode_AsEncodedString(unicode.PyObject, PAnsiChar(TempEncoding), PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.BuildEncodingMap(const string_: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_BuildEncodingMap) and
     TPyObject.IsInitialized(string_) then
    Result := TPyObject.Wrap(PyUnicode_BuildEncodingMap(string_.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsUTF8String(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsUTF8String) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsUTF8String(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsUTF8AndSize(const unicode: IPyObject; var size_: Py_ssize_t): PAnsiChar;
begin
  size_   := -1;
  Result := nil;

  if assigned(PyUnicode_AsUTF8AndSize) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_AsUTF8AndSize(unicode.PyObject, @size_);
end;

class function TPyUnicode.AsUTF32String(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsUTF32String) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsUTF32String(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsUTF16String(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsUTF16String) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsUTF16String(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsUnicodeEscapeString(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsUnicodeEscapeString) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsUnicodeEscapeString(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsRawUnicodeEscapeString(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsRawUnicodeEscapeString) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsRawUnicodeEscapeString(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsLatin1String(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsLatin1String) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsLatin1String(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsASCIIString(const unicode: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsASCIIString) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_AsASCIIString(unicode.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.AsCharmapString(const unicode, mapping: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_AsCharmapString) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(mapping) then
    Result := TPyObject.Wrap(PyUnicode_AsCharmapString(unicode.PyObject, mapping.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.EncodeLocale(const unicode: IPyObject; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_EncodeLocale) and
     TPyObject.IsInitialized(unicode) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_EncodeLocale(unicode.PyObject, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.FSConverter(const obj: IPyObject; result_: Pointer): boolean;
begin
  Result := False;

  if assigned(PyUnicode_FSConverter) then
    begin
      if TPyObject.IsInitialized(obj) then
        Result := (PyUnicode_FSConverter(obj.PyObject, result_) = 0)
       else
        Result := (PyUnicode_FSConverter(nil, result_) = 0);
    end;
end;

class function TPyUnicode.FSDecoder(const obj: IPyObject; result_: Pointer): boolean;  
begin
  Result := False;

  if assigned(PyUnicode_FSDecoder) then
    begin
      if TPyObject.IsInitialized(obj) then
        Result := (PyUnicode_FSDecoder(obj.PyObject, result_) = 0)
       else
        Result := (PyUnicode_FSDecoder(nil, result_) = 0);
    end;
end; 

class function TPyUnicode.DecodeFSDefault(const str: PAnsiChar): IPyObject; 
begin
  if assigned(PyUnicode_DecodeFSDefault) then
    Result := TPyObject.Wrap(PyUnicode_DecodeFSDefault(str))
   else
    Result := nil; 
end;

class function TPyUnicode.DecodeFSDefault(const str: string): IPyObject;
var
  TempString : AnsiString;
begin
  TempString := StringToPyUTF8(str);  
  Result     := DecodeFSDefault(PAnsiChar(TempString));
end;

class function TPyUnicode.DecodeFSDefaultAndSize(const str: PAnsiChar; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_DecodeFSDefaultAndSize) then
    Result := TPyObject.Wrap(PyUnicode_DecodeFSDefaultAndSize(str, size_))
   else
    Result := nil; 
end;

class function TPyUnicode.DecodeFSDefaultAndSize(const str: string; size_: Py_ssize_t): IPyObject;
var
  TempString : AnsiString;
begin
  TempString := StringToPyUTF8(str);  
  Result     := DecodeFSDefaultAndSize(PAnsiChar(TempString), size_);
end;

class function TPyUnicode.EncodeFSDefault(const unicode: IPyObject): IPyObject;    
begin
  if assigned(PyUnicode_EncodeFSDefault) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_EncodeFSDefault(unicode.PyObject))
   else
    Result := nil; 
end;

class procedure TPyUnicode.Append(const left, right: IPyObject);
var
  TempObj : PPyObject;
begin
  if assigned(PyUnicode_Append) and
     TPyObject.IsInitialized(left) and
     TPyObject.IsInitialized(right) then
    begin
      TempObj := left.Unwrap;

      PyUnicode_Append(@TempObj, right.PyObject);

      left.PyObject := TempObj;
    end;
end;

class procedure TPyUnicode.AppendAndDel(const left, right: IPyObject);
var
  TempRefCnt : integer;
  TempObj    : PPyObject;
begin
  if assigned(PyUnicode_AppendAndDel) and
     TPyObject.IsInitialized(left) and
     TPyObject.IsInitialized(right) then
    begin
      TempObj    := left.Unwrap;
      TempRefCnt := right.RefCnt;

      PyUnicode_AppendAndDel(@TempObj, right.PyObject);

      left.PyObject := TempObj;

      if (TempRefCnt = 1) then
        right.InitPyObject;
    end;
end;

class function TPyUnicode.Split(const unicode, sep: IPyObject; maxsplit: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_Split) and
     TPyObject.IsInitialized(unicode) then
    begin
      if TPyObject.IsInitialized(sep) then
        Result := TPyObject.Wrap(PyUnicode_Split(unicode.PyObject, sep.PyObject, maxsplit))
       else
        Result := TPyObject.Wrap(PyUnicode_Split(unicode.PyObject, nil, maxsplit));
    end
   else
    Result := nil;
end;

class function TPyUnicode.Splitlines(const unicode: IPyObject; keepends: boolean): IPyObject;
begin
  if assigned(PyUnicode_Splitlines) and
     TPyObject.IsInitialized(unicode) then
    Result := TPyObject.Wrap(PyUnicode_Splitlines(unicode.PyObject, ord(keepends)))
   else
    Result := nil;
end;

class function TPyUnicode.Partition(const unicode, sep: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_Partition) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(sep) then
    Result := TPyObject.Wrap(PyUnicode_Partition(unicode.PyObject, sep.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.RPartition(const unicode, sep: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_RPartition) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(sep) then
    Result := TPyObject.Wrap(PyUnicode_RPartition(unicode.PyObject, sep.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.RSplit(const unicode, sep: IPyObject; maxsplit: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_RSplit) and
     TPyObject.IsInitialized(unicode) then
    begin
      if TPyObject.IsInitialized(sep) then
        Result := TPyObject.Wrap(PyUnicode_RSplit(unicode.PyObject, sep.PyObject, maxsplit))
       else
        Result := TPyObject.Wrap(PyUnicode_RSplit(unicode.PyObject, nil, maxsplit));
    end
   else
    Result := nil;
end;

class function TPyUnicode.Translate(const unicode, table: IPyObject; errors: TPyCodecErrors): IPyObject;
var
  TempErrors : AnsiString;
begin
  if assigned(PyUnicode_Translate) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(table) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      Result     := TPyObject.Wrap(PyUnicode_Translate(unicode.PyObject, table.PyObject, PAnsiChar(TempErrors)));
    end
   else
    Result := nil;
end;

class function TPyUnicode.Join(const separator, sep: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_Join) and
     TPyObject.IsInitialized(separator) and
     TPyObject.IsInitialized(sep) then
    Result := TPyObject.Wrap(PyUnicode_Join(separator.PyObject, sep.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.Tailmatch(const unicode, substr: IPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
begin
  if assigned(PyUnicode_Tailmatch) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(substr) then
    Result := PyUnicode_Tailmatch(unicode.PyObject, substr.PyObject, start, end_, direction)
   else
    Result := -1;
end;

class function TPyUnicode.Find(const unicode, substr: IPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
begin
  if assigned(PyUnicode_Find) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(substr) then
    Result := PyUnicode_Find(unicode.PyObject, substr.PyObject, start, end_, direction)
   else
    Result := -2;
end;

class function TPyUnicode.FindChar(const unicode: IPyObject; ch: Py_UCS4; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
begin
  if assigned(PyUnicode_FindChar) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_FindChar(unicode.PyObject, ch, start, end_, direction)
   else
    Result := -2;
end;

class function TPyUnicode.Count(const unicode, substr: IPyObject; start, end_: Py_ssize_t): Py_ssize_t;
begin
  if assigned(PyUnicode_Count) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(substr) then
    Result := PyUnicode_Count(unicode.PyObject, substr.PyObject, start, end_)
   else
    Result := -1;
end;

class function TPyUnicode.Replace(const str, substr, replstr: IPyObject; maxcount: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_Replace) and
     TPyObject.IsInitialized(str) and
     TPyObject.IsInitialized(substr) and
     TPyObject.IsInitialized(replstr) then
    Result := TPyObject.Wrap(PyUnicode_Replace(str.PyObject, substr.PyObject, replstr.PyObject, maxcount))
   else
    Result := nil;
end;

class function TPyUnicode.Compare(const left, right: IPyObject): integer;
begin
  if assigned(PyUnicode_Compare) and
     TPyObject.IsInitialized(left) and
     TPyObject.IsInitialized(right) then
    Result := PyUnicode_Compare(left.PyObject, right.PyObject)
   else
    Result := -1;
end;

class function TPyUnicode.CompareWithASCIIString(const left: IPyObject; const right: PAnsiChar): integer;
begin
  if assigned(PyUnicode_CompareWithASCIIString) and
     TPyObject.IsInitialized(left) then
    Result := PyUnicode_CompareWithASCIIString(left.PyObject, right)
   else
    Result := -1;
end;

class function TPyUnicode.EqualToUTF8(const unicode: IPyObject; const string_: PAnsiChar): boolean;
begin
  Result := assigned(PyUnicode_EqualToUTF8) and
            TPyObject.IsInitialized(unicode) and
            (PyUnicode_EqualToUTF8(unicode.PyObject, string_) <> 0);
end;

class function TPyUnicode.EqualToUTF8AndSize(const unicode: IPyObject; const string_: PAnsiChar; size_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicode_EqualToUTF8AndSize) and
            TPyObject.IsInitialized(unicode) and
            (PyUnicode_EqualToUTF8AndSize(unicode.PyObject, string_, size_) <> 0);
end;

class function TPyUnicode.Equal(const a, b: IPyObject): integer;
begin
  if assigned(PyUnicode_Equal) and
     TPyObject.IsInitialized(a) and
     TPyObject.IsInitialized(b) then
    Result := PyUnicode_Equal(a.PyObject, b.PyObject)
   else
    Result := -1;
end;

class function TPyUnicode.RichCompare(const left, right: IPyObject; op: integer): IPyObject;
begin
  if assigned(PyUnicode_RichCompare) and
     TPyObject.IsInitialized(left) and
     TPyObject.IsInitialized(right) and
     (op in [Py_LT..Py_GE]) then
    Result := TPyObject.Wrap(PyUnicode_RichCompare(left.PyObject, right.PyObject, op))
   else
    Result := nil;
end;

class function TPyUnicode.Format(const format_, args: IPyObject): IPyObject;
begin
  if assigned(PyUnicode_Format) and
     TPyObject.IsInitialized(format_) and
     TPyObject.IsInitialized(args) then
    Result := TPyObject.Wrap(PyUnicode_Format(format_.PyObject, args.PyObject))
   else
    Result := nil;
end;

class function TPyUnicode.Contains(const unicode, substr: IPyObject): integer;
begin
  if assigned(PyUnicode_Contains) and
     TPyObject.IsInitialized(unicode) and
     TPyObject.IsInitialized(substr) then
    Result := PyUnicode_Contains(unicode.PyObject, substr.PyObject)
   else
    Result := -1;
end;

class function TPyUnicode.IsIdentifier(const unicode: IPyObject): boolean;
begin
  Result := assigned(PyUnicode_IsIdentifier) and
            TPyObject.IsInitialized(unicode) and
            (PyUnicode_IsIdentifier(unicode.PyObject) <> 0);
end;

class function TPyUnicode.KIND(const unicode: IPyObject): PyUnicode_Kind_Result;
begin
  if assigned(PyUnicode_KIND) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_KIND(unicode.PyObject)
   else
    Result := PyUnicode_1BYTE_KIND;
end;

class function TPyUnicode.DATA(const unicode: IPyObject): Pointer;
begin
  if assigned(PyUnicode_DATA) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_DATA(unicode.PyObject)
   else
    Result := nil;
end;

class function TPyUnicode.New(size_: Py_ssize_t; maxchar: Py_UCS4): IPyObject;
begin
  if assigned(PyUnicode_New) then
    Result := TPyObject.Wrap(PyUnicode_New(size_, maxchar))
   else
    Result := nil;
end;

class function TPyUnicode.CopyCharacters(const to_: IPyObject; to_start: Py_ssize_t; const from: IPyObject; from_start, how_many: Py_ssize_t): Py_ssize_t;
begin
  if assigned(PyUnicode_CopyCharacters) and
     TPyObject.IsInitialized(to_) and
     TPyObject.IsInitialized(from) then
    Result := PyUnicode_CopyCharacters(to_.PyObject, to_start, from.PyObject, from_start, how_many)
   else
    Result := -1;
end;

class function TPyUnicode.Fill(const unicode: IPyObject; start, length: Py_ssize_t; fill_char: Py_UCS4): Py_ssize_t;
begin
  if assigned(PyUnicode_Fill) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_Fill(unicode.PyObject, start, length, fill_char)
   else
    Result := -1;
end;

class function TPyUnicode.FromKindAndData(kind_: integer; buffer: Pointer; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyUnicode_FromKindAndData) then
    Result := TPyObject.Wrap(PyUnicode_FromKindAndData(kind_, buffer, size_))
   else
    Result := nil;
end;

class function TPyUnicode.AsUTF8(const unicode: IPyObject): PAnsiChar;
begin
  if assigned(PyUnicode_AsUTF8) and
     TPyObject.IsInitialized(unicode) then
    Result := PyUnicode_AsUTF8(unicode.PyObject)
   else
    Result := nil;
end;

end.
