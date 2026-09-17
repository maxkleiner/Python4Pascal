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
      /// <para>Create a Unicode object from the char buffer str. The buffer is
      /// copied into the new object. The return value might be a shared object,
      /// i.e. modification of the data is not allowed.</para>
      /// <para>This function raises SystemError when:</para>
      /// <code>
      /// - size < 0,
      /// - str is nil and size > 0
      /// </code>
      /// <para>Changed in version 3.12: str = nil with size > 0 is not allowed
      /// anymore.</para>
      /// </summary>
      class function FromStringAndSize(const str: string; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object from a string.</para>
      /// </summary>
      class function FromString(const str: string): IPyObject; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para>Create a Unicode object from a string.</para>
      /// </summary>
      class function FromString(const str: AnsiString): IPyObject; overload;
      {$ENDIF}
      /// <summary>
      /// <para>Create a Unicode object from the buffer. The buffer is
      /// copied into the new object. The return value might be a shared object,
      /// i.e. modification of the data is not allowed.</para>
      /// <para>This function raises SystemError when:</para>
      /// <code>
      /// - size < 0,
      /// - buffer is nil and size > 0
      /// </code>
      /// <para>Changed in version 3.12: buffer = nil with size > 0 is not
      /// allowed anymore.</para>
      /// </summary>
      class function FromBufferAndSize(const buffer: PByte; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object from a byte buffer.</para>
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
      /// <para>Return a substring of unicode, from character index start
      /// (included) to character index end (excluded). Negative indices are
      /// not supported. On error, set an exception and return nil.</para>
      /// </summary>
      class function Substring(const str: IPyObject; start, end_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Copy the string unicode into a UCS4 buffer, including a nil
      /// character, if copy_null is set. Returns nil and sets an exception
      /// on error (in particular, a SystemError if buflen is smaller than
      /// the length of unicode). buffer is returned on success.</para>
      /// </summary>
      class function AsUCS4(const unicode: IPyObject; buffer: PPy_UCS4; buflen: Py_ssize_t; copy_null: boolean): PPy_UCS4;
      /// <summary>
      /// <para>Copy the string unicode into a new UCS4 buffer that is
      /// allocated using TPyMem.Malloc(). If this fails, nil is returned with
      /// a MemoryError set. The returned buffer always has an extra nil code
      /// point appended.</para>
      /// </summary>
      class function AsUCS4Copy(const unicode: IPyObject): PPy_UCS4;
      /// <summary>
      /// <para>Return the length of the Unicode object, in code points.</para>
      /// <para>On error, set an exception and return -1.</para>
      /// </summary>
      class function GetLength(const unicode: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Read a character from a string. This function checks that
      /// unicode is a Unicode object and the index is not out of bounds.</para>
      /// <para>Return character on success, -1 on error with an exception
      /// set.</para>
      /// </summary>
      class function ReadChar(const unicode: IPyObject; index: Py_ssize_t): Py_UCS4;
      /// <summary>
      /// <para>Write a character to the string unicode at the zero-based index.
      /// Return True on success, False on error with an exception set.</para>
      /// <para>This function checks that unicode is a Unicode object, that the
      /// index is not out of bounds, and that the object's reference count is
      /// one.</para>
      /// <para>The string must not have been "used" yet. See TPyUnicode.New()
      /// for details.</para>
      /// </summary>
      class function WriteChar(const unicode: IPyObject; index: Py_ssize_t; character: Py_UCS4): boolean;
      /// <summary>
      /// <para>Resize a Unicode object *unicode to the new length in code
      /// points.</para>
      /// <para>Try to resize the string in place (which is usually faster than
      /// allocating a new string and copying characters), or create a new
      /// string.</para>
      /// <para>*unicode is modified to point to the new (resized) object and
      /// True is returned on success. Otherwise, False is returned and an
      /// exception is set, and *unicode is left untouched.</para>
      /// <para>The function doesn't check string content, the result may not
      /// be a string in canonical representation.</para>
      /// </summary>
      class function Resize(const unicode: IPyObject; length_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Decode an encoded object obj to a Unicode object.</para>
      /// <para>bytes, bytearray and other bytes-like objects are decoded
      /// according to the given encoding and using the error handling defined
      /// by errors. Both can be nil to have the interface use the default
      /// values (see Built-in Codecs for details).</para>
      /// <para>All other objects, including Unicode objects, cause a TypeError
      /// to be set.</para>
      /// <para>The API returns nil if there was an error. The caller is
      /// responsible for decref'ing the returned objects.</para>
      /// </summary>
      class function FromEncodedObject(const obj: IPyObject; const encodging, errors: PAnsiChar): IPyObject;
      /// <summary>
      /// <para>Copy an instance of a Unicode subtype to a new true Unicode
      /// object if necessary. If obj is already a true Unicode object
      /// (not a subtype), return a new strong reference to the object.</para>
      /// <para>Objects other than Unicode or its subtypes will cause a
      /// TypeError.</para>
      /// </summary>
      class function FromObject(const obj: IPyObject): IPyObject;
      /// <summary>
      /// <para>Intern the argument *p_unicode in place. The argument must be a
      /// Python Unicode string object. If there is an existing interned string
      /// that is the same as *p_unicode, it sets *p_unicode to it (releasing
      /// the reference to the old string object and creating a new strong
      /// reference to the interned string object), otherwise it leaves
      /// *p_unicode alone and interns it.</para>
      /// <para>(Clarification: even though there is a lot of talk about
      /// references, think of this function as reference-neutral. You must own
      /// the object you pass in; after the call you no longer own the passed-in
      /// reference, but you newly own the result.)</para>
      /// <para>This function never raises an exception. On error, it leaves
      /// its argument unchanged without interning it.</para>
      /// <para>Instances of subclasses of str may not be interned, that is,
      /// TPyUnicode.CheckExact(*p_unicode) must be true. If it is not, then -
      /// as with any other error - the argument is left unchanged.</para>
      /// <para>Note that interned strings are not "immortal". You must keep a
      /// reference to the result to benefit from interning.</para>
      /// </summary>
      class procedure InternInPlace(const p_unicode: IPyObject);
      /// <summary>
      /// <para>A combination of TPyUnicode.FromString() and
      /// TPyUnicode.InternInPlace(), meant for statically allocated
      /// strings.</para>
      /// <para>Return a new ("owned") reference to either a new Unicode string
      /// object that has been interned, or an earlier interned string object
      /// with the same value.</para>
      /// <para>Python may keep a reference to the result, or make it immortal,
      /// preventing it from being garbage-collected promptly. For interning an
      /// unbounded number of different strings, such as ones coming from user
      /// input, prefer calling TPyUnicode.FromString() and
      /// TPyUnicode.InternInPlace() directly.</para>
      /// </summary>
      class function InternFromString(const str: string): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object from the wchar_t buffer wstr of the
      /// given size. Passing -1 as the size indicates that the function must
      /// itself compute the length, using wcslen().
      /// Return nil on failure.</para>
      /// </summary>
      class function FromWideChar(const w: PWCharT; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Copy the Unicode object contents into the wchar_t buffer wstr.
      /// At most size wchar_t characters are copied (excluding a possibly
      /// trailing nil termination character). Return the number of wchar_t
      /// characters copied or -1 in case of an error.</para>
      /// <para>When wstr is nil, instead return the size that would be required
      /// to store all of unicode including a terminating nil.</para>
      /// <para>Note that the resulting wchar_t* string may or may not be
      /// nil-terminated. It is the responsibility of the caller to make sure
      /// that the wchar_t* string is nil-terminated in case this is required
      /// by the application. Also, note that the wchar_t* string might contain
      /// nil characters, which would cause the string to be truncated when
      /// used with most C functions.</para>
      /// </summary>
      class function AsWideChar(const unicode: IPyObject; w: PWCharT; size_: Py_ssize_t): Py_ssize_t;
      /// <summary>
      /// <para>Convert the Unicode object to a wide character string. The
      /// output string always ends with a nil character. If size is not nil,
      /// write the number of wide characters (excluding the trailing nil
      /// termination character) into *size. Note that the resulting wchar_t
      /// string might contain nil characters, which would cause the string to
      /// be truncated when used with most C functions. If size is nil and the
      /// wchar_t* string contains nil characters a ValueError is
      /// raised.</para>
      /// <para>Returns a buffer allocated by TPyMem.New (use TPyMem.Free() to
      /// free it) on success. On error, returns nil and *size is undefined.
      /// Raises a MemoryError if memory allocation is failed.</para>
      /// </summary>
      class function AsWideCharString(const unicode: IPyObject; var size_: Py_ssize_t): PWCharT;
      /// <summary>
      /// <para>Create a Unicode Object from the given Unicode code point
      /// ordinal.</para>
      /// <para>The ordinal must be in range($110000). A ValueError is raised
      /// in the case it is not.</para>
      /// </summary>
      class function FromOrdinal(ordinal: integer): IPyObject;
      /// <summary>
      /// <para>Return the name of the default string encoding, "utf-8".
      /// See sys.getdefaultencoding().</para>
      /// <para>The returned string does not need to be freed, and is valid
      /// until interpreter shutdown.</para>
      /// </summary>
      class function GetDefaultEncoding(): string;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the encoded
      /// string str. encoding and errors have the same meaning as the
      /// parameters of the same name in the str() built-in function. The codec
      /// to be used is looked up using the Python codec registry. Return nil
      /// if an exception was raised by the codec.</para>
      /// </summary>
      class function Decode(const s: PAnsiChar; size_: Py_ssize_t; const encoding: string; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object and return the result as Python bytes
      /// object. encoding and errors have the same meaning as the parameters
      /// of the same name in the Unicode encode() method. The codec to be used
      /// is looked up using the Python codec registry. Return nil if an
      /// exception was raised by the codec.</para>
      /// </summary>
      class function AsEncodedString(const unicode: IPyObject; const encoding: string; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Return a mapping suitable for decoding a custom single-byte
      /// encoding. Given a Unicode string string of up to 256 characters
      /// representing an encoding table, returns either a compact internal
      /// mapping object or a dictionary mapping character ordinals to byte
      /// values. Raises a TypeError and return nil on invalid input.</para>
      /// </summary>
      class function BuildEncodingMap(const string_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the UTF-7
      /// encoded string str. Return nil if an exception was raised by the
      /// codec.</para>
      /// </summary>
      class function DecodeUTF7(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>If consumed is nil, behave like TPyUnicode.DecodeUTF7().
      /// If consumed is not nil, trailing incomplete UTF-7 base-64 sections
      /// will not be treated as an error. Those bytes will not be decoded and
      /// the number of bytes that have been decoded will be stored in
      /// consumed.</para>
      /// </summary>
      class function DecodeUTF7Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the UTF-8
      /// encoded string str. Return nil if an exception was raised by the
      /// codec.</para>
      /// </summary>
      class function DecodeUTF8(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>If consumed is nil, behave like PyUnicode_DecodeUTF8().
      /// If consumed is not nil, trailing incomplete UTF-8 byte sequences
      /// will not be treated as an error. Those bytes will not be decoded
      /// and the number of bytes that have been decoded will be stored in
      /// consumed.</para>
      /// </summary>
      class function DecodeUTF8Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using UTF-8 and return the result as
      /// Python bytes object. Error handling is "strict". Return nil if an
      /// exception was raised by the codec.</para>
      /// <para>The function fails if the string contains surrogate
      /// code points (U+D800 - U+DFFF).</para>
      /// </summary>
      class function AsUTF8String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a pointer to the UTF-8 encoding of the Unicode object,
      /// and store the size of the encoded representation (in bytes) in size.
      /// The size argument can be nil; in this case no size will be stored.
      /// The returned buffer always has an extra nil byte appended
      /// (not included in size), regardless of whether there are any other
      /// nil code points.</para>
      /// <para>On error, set an exception, set size to -1 (if it's not nil)
      /// and return nil.</para>
      /// <para>The function fails if the string contains surrogate
      /// code points (U+D800 - U+DFFF).</para>
      /// <para>This caches the UTF-8 representation of the string in the
      /// Unicode object, and subsequent calls will return a pointer to the
      /// same buffer. The caller is not responsible for deallocating the
      /// buffer. The buffer is deallocated and pointers to it become invalid
      /// when the Unicode object is garbage collected.</para>
      /// </summary>
      class function AsUTF8AndSize(const unicode: IPyObject; var size_: Py_ssize_t): PAnsiChar;
      /// <summary>
      /// <para>Decode size bytes from a UTF-32 encoded buffer string and
      /// return the corresponding Unicode object. errors (if non-nil) defines
      /// the error handling. It defaults to "strict".
      /// <para>If byteorder is non-nil, the decoder starts decoding using the
      /// given byte order:</para>
      /// <code>
      /// *byteorder == -1: little endian
      /// *byteorder == 0:  native order
      /// *byteorder == 1:  big endian
      /// </code>
      /// <para>If *byteorder is zero, and the first four bytes of the input
      /// data are a byte order mark (BOM), the decoder switches to this byte
      /// order and the BOM is not copied into the resulting Unicode string.
      /// If *byteorder is -1 or 1, any byte order mark is copied to the
      /// output.</para>
      /// <para>After completion, *byteorder is set to the current byte order
      /// at the end of input data.</para>
      /// <para>If byteorder is nil, the codec starts in native order
      /// mode.</para>
      /// <para>Return nil if an exception was raised by the codec.</para>
      /// </summary>
      class function DecodeUTF32(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder): IPyObject;
      /// <summary>
      /// <para>If consumed is nil, behave like TPyUnicode.DecodeUTF32().
      /// If consumed is not nil, TPyUnicode.DecodeUTF32Stateful() will not
      /// treat trailing incomplete UTF-32 byte sequences (such as a number
      /// of bytes not divisible by four) as an error. Those bytes will not
      /// be decoded and the number of bytes that have been decoded will be
      /// stored in consumed.</para>
      /// </summary>
      class function DecodeUTF32Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return a Python byte string using the UTF-32 encoding in native
      /// byte order. The string always starts with a BOM mark. Error handling
      /// is "strict". Return nil if an exception was raised by the codec.</para>
      /// </summary>
      class function AsUTF32String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Decode size bytes from a UTF-16 encoded buffer string and
      /// return the corresponding Unicode object. errors (if non-nil) defines
      /// the error handling. It defaults to "strict".</para>
      /// <para>If byteorder is non-nil, the decoder starts decoding using
      /// the given byte order:</para>
      /// <code>
      /// *byteorder == -1: little endian
      /// *byteorder == 0:  native order
      /// *byteorder == 1:  big endian
      /// </code>
      /// <para>If *byteorder is zero, and the first two bytes of the input
      /// data are a byte order mark (BOM), the decoder switches to this byte
      /// order and the BOM is not copied into the resulting Unicode string.
      /// If *byteorder is -1 or 1, any byte order mark is copied to the
      /// output (where it will result in either a \ufeff or a \ufffe
      /// character).</para>
      /// <para>After completion, *byteorder is set to the current byte order
      /// at the end of input data.</para>
      /// <para>If byteorder is nil, the codec starts in native order
      /// mode.</para>
      /// <para>Return nil if an exception was raised by the codec.</para>
      /// </summary>
      class function DecodeUTF16(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder): IPyObject;
      /// <summary>
      /// <para>If consumed is nil, behave like TPyUnicode.DecodeUTF16().
      /// If consumed is not nil, TPyUnicode.DecodeUTF16Stateful() will not
      /// treat trailing incomplete UTF-16 byte sequences (such as an odd
      /// number of bytes or a split surrogate pair) as an error. Those bytes
      /// will not be decoded and the number of bytes that have been decoded
      /// will be stored in consumed.</para>
      /// </summary>
      class function DecodeUTF16Stateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var byteorder: TPyBiteOrder; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return a Python byte string using the UTF-16 encoding in
      /// native byte order. The string always starts with a BOM mark.
      /// Error handling is "strict". Return nil if an exception was raised
      /// by the codec.</para>
      /// </summary>
      class function AsUTF16String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the
      /// Unicode-Escape encoded string str. Return nil if an exception was
      /// raised by the codec.</para>
      /// </summary>
      class function DecodeUnicodeEscape(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using Unicode-Escape and return the
      /// result as a bytes object. Error handling is "strict". Return nil if
      /// an exception was raised by the codec.</para>
      /// </summary>
      class function AsUnicodeEscapeString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the
      /// Raw-Unicode-Escape encoded string str. Return nil if an exception
      /// was raised by the codec.</para>
      /// </summary>
      class function DecodeRawUnicodeEscape(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using Raw-Unicode-Escape and return
      /// the result as a bytes object. Error handling is "strict". Return nil
      /// if an exception was raised by the codec.</para>
      /// </summary>
      class function AsRawUnicodeEscapeString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the Latin-1
      /// encoded string str. Return nil if an exception was raised by the
      /// codec.</para>
      /// </summary>
      class function DecodeLatin1(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using Latin-1 and return the result as
      /// Python bytes object. Error handling is "strict". Return nil if an
      /// exception was raised by the codec.</para>
      /// </summary>
      class function AsLatin1String(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the ASCII
      /// encoded string str. Return nil if an exception was raised by the
      /// codec.</para>
      /// </summary>
      class function DecodeASCII(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using ASCII and return the result as
      /// Python bytes object. Error handling is "strict". Return nil if an
      /// exception was raised by the codec.</para>
      /// </summary>
      class function AsASCIIString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the encoded
      /// string str using the given mapping object. Return nil if an exception
      /// was raised by the codec.</para>
      /// <para>If mapping is nil, Latin-1 decoding will be applied. Else
      /// mapping must map bytes ordinals (integers in the range from 0 to 255)
      /// to Unicode strings, integers (which are then interpreted as Unicode
      /// ordinals) or None. Unmapped data bytes - ones which cause a
      /// LookupError, as well as ones which get mapped to None, $FFFE or
      /// '\ufffe', are treated as undefined mappings and cause an error.</para>
      /// </summary>
      class function DecodeCharmap(const str: PAnsiChar; length: Py_ssize_t; const mapping: IPyObject; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using the given mapping object and
      /// return the result as a bytes object. Error handling is "strict".
      /// Return nil if an exception was raised by the codec.</para>
      /// <para>The mapping object must map Unicode ordinal integers to bytes
      /// objects, integers in the range from 0 to 255 or None. Unmapped
      /// character ordinals (ones which cause a LookupError) as well as
      /// mapped to None are treated as "undefined mapping" and cause an
      /// error.</para>
      /// </summary>
      class function AsCharmapString(const unicode, mapping: IPyObject): IPyObject;
      {$IFDEF MSWINDOWS}
      /// <summary>
      /// <para>Create a Unicode object by decoding size bytes of the MBCS
      /// encoded string str. Return nil if an exception was raised by the
      /// codec.</para>
      /// </summary>
      class function DecodeMBCS(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>If consumed is nil, behave like TPyUnicode.DecodeMBCS().
      /// If consumed is not nil, TPyUnicode.DecodeMBCSStateful() will not
      /// decode trailing lead byte and the number of bytes that have been
      /// decoded will be stored in consumed.</para>
      /// </summary>
      class function DecodeMBCSStateful(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Similar to TPyUnicode.DecodeMBCSStateful(), except uses the
      /// code page specified by code_page.</para>
      /// </summary>
      class function DecodeCodePageStateful(codepage: integer; const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object using MBCS and return the result as
      /// Python bytes object. Error handling is "strict". Return nil if an
      /// exception was raised by the codec.</para>
      /// </summary>
      class function AsMBCSString(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Encode the Unicode object using the specified code page and
      /// return a Python bytes object. Return nil if an exception was raised
      /// by the codec. Use CP_ACP code page to get the MBCS encoder.</para>
      /// </summary>
      class function EncodeCodePage(codepage: integer; const unicode: IPyObject; errors: TPyCodecErrors): IPyObject;
      {$ENDIF}
      /// <summary>
      /// <para>Decode a string from UTF-8 on Android and VxWorks, or from the
      /// current locale encoding on other platforms. The supported error
      /// handlers are "strict" and "surrogateescape" (PEP 383). The decoder
      /// uses "strict" error handler if errors is nil. str must end with a nil
      /// character but cannot contain embedded nil characters.</para>
      /// <para>Use TPyUnicode.DecodeFSDefaultAndSize() to decode a string from
      /// the filesystem encoding and error handler.</para>
      /// <para>This function ignores the Python UTF-8 Mode.</para>
      /// <para>See also The TPy.DecodeLocale() function.</para>
      /// </summary>
      class function DecodeLocaleAndSize(const str: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Similar to TPyUnicode.DecodeLocaleAndSize(), but compute the
      /// string length using strlen().</para>
      /// </summary>
      class function DecodeLocale(const str: PAnsiChar; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Encode a Unicode object to UTF-8 on Android and VxWorks, or to
      /// the current locale encoding on other platforms. The supported error
      /// handlers are "strict" and "surrogateescape" (PEP 383). The encoder
      /// uses "strict" error handler if errors is nil. Return a bytes object.
      /// unicode cannot contain embedded nil characters.</para>
      /// <para>Use TPyUnicode.EncodeFSDefault() to encode a string to the
      /// filesystem encoding and error handler.</para>
      /// <para>This function ignores the Python UTF-8 Mode.</para>
      /// <para>See also The TPy.EncodeLocale() function.</para>
      /// </summary>
      class function EncodeLocale(const unicode: IPyObject; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>PyArg_Parse* converter: encode str objects - obtained directly
      /// or through the os.PathLike interface - to bytes using
      /// TPyUnicode.EncodeFSDefault(); bytes objects are output as-is.
      /// result_ must be an address of a C variable of type PPyObject
      /// (or PPyBytesObject). On success, set the variable to a new strong
      /// reference to a bytes object which must be released when it is no
      /// longer used and return True (TPy.CLEANUP_SUPPORTED).
      /// Embedded nil bytes are not allowed in the result.
      /// On failure, return False with an exception set.</para>
      /// <para>If obj is nil, the function releases a strong reference stored
      /// in the variable referred by result and returns True.</para>
      /// </summary>
      class function FSConverter(const obj: IPyObject; result_: Pointer): boolean;
      /// <summary>
      /// <para>PyArg_Parse* converter: decode bytes objects - obtained either
      /// directly or indirectly through the os.PathLike interface - to str
      /// using TPyUnicode.DecodeFSDefaultAndSize(); str objects are output
      /// as-is. result must be an address of a C variable of type PyObject*
      /// (or PyUnicodeObject*). On success, set the variable to a new strong
      /// reference to a Unicode object which must be released when it is no
      /// longer used and return True (Py_CLEANUP_SUPPORTED).
      /// Embedded nil characters are not allowed in the result.
      /// On failure, return False with an exception set.</para>
      /// <para>If obj is nil, release the strong reference to the object
      /// referred to by result and return True.</para>
      /// </summary>
      class function FSDecoder(const obj: IPyObject; result_: Pointer): boolean;
      /// <summary>
      /// <para>Decode a nil-terminated string from the filesystem encoding and
      /// error handler.</para>
      /// <para>If the string length is known, use
      /// TPyUnicode.DecodeFSDefaultAndSize().</para>
      /// </summary>
      class function DecodeFSDefault(const str: PAnsiChar): IPyObject; overload;
      /// <summary>
      /// <para>Decode a string from the filesystem encoding and error
      /// handler.</para>
      /// <para>If the string length is known, use
      /// TPyUnicode.DecodeFSDefaultAndSize().</para>
      /// </summary>
      class function DecodeFSDefault(const str: string): IPyObject; overload;
      /// <summary>
      /// <para>Decode a string from the filesystem encoding and error
      /// handler.</para>
      /// <para>If you need to decode a string from the current locale encoding,
      /// use TPyUnicode.DecodeLocaleAndSize().</para>
      /// <para>See also: The TPy.DecodeLocale() function.</para>
      /// </summary>
      class function DecodeFSDefaultAndSize(const str: PAnsiChar; size_: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Decode a string from the filesystem encoding and error
      /// handler.</para>
      /// <para>If you need to decode a string from the current locale encoding,
      /// use TPyUnicode.DecodeLocaleAndSize().</para>
      /// <para>See also: The TPy.DecodeLocale() function.</para>
      /// </summary>
      class function DecodeFSDefaultAndSize(const str: string; size_: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Encode a Unicode object to the filesystem encoding and error
      /// handler, and return bytes. Note that the resulting bytes object can
      /// contain nil bytes.</para>
      /// <para>If you need to encode a string to the current locale encoding,
      /// use TPyUnicode.EncodeLocale().</para>
      /// <para>See also: The TPy.EncodeLocale() function.</para>
      /// </summary>
      class function EncodeFSDefault(const unicode: IPyObject): IPyObject;
      /// <summary>
      /// <para>Concat two strings giving a new Unicode string.</para>
      /// </summary>
      class function Concat(const left, right: IPyObject): IPyObject;
      /// <summary>
      /// <para>Append the string right to the end of p_left. p_left must be a
      /// Unicode object; TPyUnicode.Append() releases ("steals") this
      /// reference.</para>
      /// <para>On error, set *p_left to nil and set an exception.</para>
      /// <para>On success, set *p_left to a new strong reference to the
      /// result.</para>
      /// </summary>
      class procedure Append(const p_left, right: IPyObject);
      /// <summary>
      /// <para>The function is similar to TPyUnicode.Append(), with the only
      /// difference being that it decrements the reference count of right by
      /// one.</para>
      /// </summary>
      class procedure AppendAndDel(const left, right: IPyObject);
      /// <summary>
      /// <para>Split a string giving a list of Unicode strings. If sep is nil,
      /// splitting will be done at all whitespace substrings. Otherwise,
      /// splits occur at the given separator. At most maxsplit splits will be
      /// done. If negative, no limit is set. Separators are not included in
      /// the resulting list.</para>
      /// <para>On error, return nil with an exception set.</para>
      /// <para>Equivalent to str.split().</para>
      /// </summary>
      class function Split(const unicode, sep: IPyObject; maxsplit: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Split a Unicode string at line breaks, returning a list of
      /// Unicode strings. CRLF is considered to be one line break. If keepends
      /// is False, the Line break characters are not included in the resulting
      /// strings.</para>
      /// </summary>
      class function Splitlines(const unicode: IPyObject; keepends: boolean): IPyObject;
      /// <summary>
      /// <para>Split a Unicode string at the first occurrence of sep, and
      /// return a 3-tuple containing the part before the separator, the
      /// separator itself, and the part after the separator. If the separator
      /// is not found, return a 3-tuple containing the string itself,
      /// followed by two empty strings.</para>
      /// <para>sep must not be empty.</para>
      /// <para>On error, return nil with an exception set.</para>
      /// <para>Equivalent to str.partition().</para>
      /// </summary>
      class function Partition(const unicode, sep: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyUnicode.Partition(), but split a Unicode string
      /// at the last occurrence of sep. If the separator is not found, return
      /// a 3-tuple containing two empty strings, followed by the string
      /// itself.</para>
      /// <para>sep must not be empty.</para>
      /// <para>On error, return nil with an exception set.</para>
      /// <para>Equivalent to str.rpartition().</para>
      /// </summary>
      class function RPartition(const unicode, sep: IPyObject): IPyObject;
      /// <summary>
      /// <para>Similar to TPyUnicode.Split(), but splitting will be done
      /// beginning at the end of the string.</para>
      /// <para>On error, return nil with an exception set.</para>
      /// <para>Equivalent to str.rsplit().</para>
      /// </summary>
      class function RSplit(const unicode, sep: IPyObject; maxsplit: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Translate a string by applying a character mapping table to it
      /// and return the resulting Unicode object. Return nil if an exception
      /// was raised by the codec.</para>
      /// <para>The mapping table must map Unicode ordinal integers to Unicode
      /// ordinal integers or None (causing deletion of the character).</para>
      /// <para>Mapping tables need only provide the __getitem__() interface;
      /// dictionaries and sequences work well. Unmapped character ordinals
      /// (ones which cause a LookupError) are left untouched and are copied
      /// as-is.</para>
      /// <para>errors has the usual meaning for codecs. It may be nil which
      /// indicates to use the default error handling.</para>
      /// </summary>
      class function Translate(const unicode, table: IPyObject; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Join a sequence of strings using the given separator and return
      /// the resulting Unicode string.</para>
      /// </summary>
      class function Join(const separator, sep: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return 1 if substr matches unicode[start:end] at the given tail
      /// end (direction == -1 means to do a prefix match, direction == 1 a
      /// suffix match), 0 otherwise. Return -1 if an error occurred.</para>
      /// </summary>
      class function Tailmatch(const unicode, substr: IPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
      /// <summary>
      /// <para>Return the first position of substr in unicode[start:end] using
      /// the given direction (direction == 1 means to do a forward search,
      /// direction == -1 a backward search). The return value is the index of
      /// the first match; a value of -1 indicates that no match was found,
      /// and -2 indicates that an error occurred and an exception has been
      /// set.</para>
      /// </summary>
      class function Find(const unicode, substr: IPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
      /// <summary>
      /// <para>Return the first position of the character ch in
      /// unicode[start:end] using the given direction (direction == 1 means to
      /// do a forward search, direction == -1 a backward search). The return
      /// value is the index of the first match; a value of -1 indicates that
      /// no match was found, and -2 indicates that an error occurred and an
      /// exception has been set.</para>
      /// </summary>
      class function FindChar(const unicode: IPyObject; ch: Py_UCS4; start, end_: Py_ssize_t; direction: integer): Py_ssize_t;
      /// <summary>
      /// <para>Return the number of non-overlapping occurrences of substr in
      /// unicode[start:end]. Return -1 if an error occurred.</para>
      /// </summary>
      class function Count(const unicode, substr: IPyObject; start, end_: Py_ssize_t): Py_ssize_t;
      /// <summary>
      /// <para>Replace at most maxcount occurrences of substr in unicode with
      /// replstr and return the resulting Unicode object. maxcount == -1 means
      /// replace all occurrences.</para>
      /// </summary>
      class function Replace(const str, substr, replstr: IPyObject; maxcount: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Compare two strings and return -1, 0, 1 for less than, equal,
      /// and greater than, respectively.</para>
      /// <para>This function returns -1 upon failure, so one should call
      /// TPyErr.Occurred() to check for errors.</para>
      /// <para>See also The TPyUnicode.Equal() function.</para>
      /// </summary>
      class function Compare(const left, right: IPyObject): integer;
      /// <summary>
      /// <para>Compare a Unicode object, unicode, with string and return
      /// -1, 0, 1 for less than, equal, and greater than, respectively.
      /// It is best to pass only ASCII-encoded strings, but the function
      /// interprets the input string as ISO-8859-1 if it contains non-ASCII
      /// characters.</para>
      /// <para>This function does not raise exceptions.</para>
      /// </summary>
      class function CompareWithASCIIString(const left: IPyObject; const right: PAnsiChar): integer;
      /// <summary>
      /// <para>Similar to TPyUnicode.EqualToUTF8AndSize(), but compute string
      /// length using strlen(). If the Unicode object contains nil characters,
      /// false is returned.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function EqualToUTF8(const unicode: IPyObject; const string_: PAnsiChar): boolean;
      /// <summary>
      /// <para>Compare a Unicode object with a char buffer which is
      /// interpreted as being UTF-8 or ASCII encoded and return true if they
      /// are equal, or false otherwise. If the Unicode object contains
      /// surrogate code points (U+D800 - U+DFFF) or the C string is not valid
      /// UTF-8, false (0) is returned.</para>
      /// <para>This function does not raise exceptions.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function EqualToUTF8AndSize(const unicode: IPyObject; const string_: PAnsiChar; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Test if two strings are equal:</para>
      /// <code>
      /// - Return 1 if a is equal to b.
      /// - Return 0 if a is not equal to b.
      /// - Set a TypeError exception and return -1 if a or b is not a str
      ///   object.
      /// </code>
      /// <para>The function always succeeds if a and b are str objects.</para>
      /// <para>The function works for str subclasses, but does not honor
      /// custom __eq__() method.</para>
      /// <para>See also The TPyUnicode.Compare() function.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function Equal(const a, b: IPyObject): integer;
      /// <summary>
      /// <para>Rich compare two Unicode strings and return one of the
      /// following:</para>
      /// <code>
      /// - nil in case an exception was raised
      /// - Py_True or Py_False for successful comparisons
      /// - Py_NotImplemented in case the type combination is unknown
      /// </code>
      /// <para>Possible values for op are Py_GT, Py_GE, Py_EQ, Py_NE, Py_LT,
      /// and Py_LE.</para>
      /// </summary>
      class function RichCompare(const left, right: IPyObject; op: integer): IPyObject;
      /// <summary>
      /// <para>Return a new string object from format and args; this is
      /// analogous to format % args.</para>
      /// </summary>
      class function Format(const format_, args: IPyObject): IPyObject;
      /// <summary>
      /// <para>Check whether substr is contained in unicode and return true or
      /// false accordingly.</para>
      /// <para>substr has to coerce to a one element Unicode string. -1 is
      /// returned if there was an error.</para>
      /// </summary>
      class function Contains(const unicode, substr: IPyObject): integer;
      /// <summary>
      /// <para>Return True if the string is a valid identifier according to
      /// the language definition, section Names (identifiers and keywords).
      /// Return False otherwise.</para>
      /// </summary>
      class function IsIdentifier(const unicode: IPyObject): boolean;
      /// <summary>
      /// <para>Return one of the PyUnicode kind constants (see above) that
      /// indicate how many bytes per character this Unicode object uses to
      /// store its data. unicode has to be a Unicode object in the "canonical"
      /// representation (not checked).</para>
      /// </summary>
      class function KIND(const unicode: IPyObject): PyUnicode_Kind_Result;
      /// <summary>
      /// <para>Return a void pointer to the raw Unicode buffer. unicode has to
      /// be a Unicode object in the "canonical" representation
      /// (not checked).</para>
      /// </summary>
      class function DATA(const unicode: IPyObject): Pointer;
      /// <summary>
      /// <para>Create a new Unicode object. maxchar should be the true maximum
      /// code point to be placed in the string. As an approximation, it can be
      /// rounded up to the nearest value in the sequence 127, 255, 65535,
      /// 1114111.</para>
      /// <para>On error, set an exception and return nil.</para>
      /// <para>After creation, the string can be filled by
      /// TPyUnicode.WriteChar(), TPyUnicode.CopyCharacters(),
      /// TPyUnicode.Fill(), TPyUnicode.WRITE() or similar. Since strings are
      /// supposed to be immutable, take care to not "use" the result while it
      /// is being modified. In particular, before it's filled with its final
      /// contents, a string:</para>
      /// <code>
      /// - must not be hashed,
      /// - must not be converted to UTF-8, or another non-"canonical" representation,
      /// - must not have its reference count changed,
      /// - must not be shared with code that might do one of the above.
      /// </code>
      /// <para>This list is not exhaustive. Avoiding these uses is your
      /// responsibility; Python does not always check these
      /// requirements.</para>
      /// <para>To avoid accidentally exposing a partially-written string
      /// object, prefer using the PyUnicodeWriter API, or one of the
      /// TPyUnicode.From* functions.</para>
      /// </summary>
      class function New(size_: Py_ssize_t; maxchar: Py_UCS4): IPyObject;
      /// <summary>
      /// <para>Copy characters from one Unicode object into another. This
      /// function performs character conversion when necessary and falls back
      /// to memcpy() if possible. Returns -1 and sets an exception on error,
      /// otherwise returns the number of copied characters.</para>
      /// <para>The string must not have been "used" yet. See TPyUnicode.New()
      /// for details.</para>
      /// </summary>
      class function CopyCharacters(const to_: IPyObject; to_start: Py_ssize_t; const from: IPyObject; from_start, how_many: Py_ssize_t): Py_ssize_t;
      /// <summary>
      /// <para>Fill a string with a character: write fill_char into
      /// unicode[start:start+length].</para>
      /// <para>Fail if fill_char is bigger than the string maximum character,
      /// or if the string has more than 1 reference.</para>
      /// <para>The string must not have been "used" yet. See TPyUnicode.New()
      /// for details.</para>
      /// <para>Return the number of written characters, or return -1 and raise
      /// an exception on error.</para>
      /// </summary>
      class function Fill(const unicode: IPyObject; start, length: Py_ssize_t; fill_char: Py_UCS4): Py_ssize_t;
      /// <summary>
      /// <para>Create a new Unicode object with the given kind (possible
      /// values are PyUnicode_1BYTE_KIND etc., as returned by
      /// TPyUnicode.KIND()). The buffer must point to an array of size units
      /// of 1, 2 or 4 bytes per character, as given by the kind.</para>
      /// <para>If necessary, the input buffer is copied and transformed into
      /// the canonical representation. For example, if the buffer is a UCS4
      /// string (PyUnicode_4BYTE_KIND) and it consists only of codepoints in
      /// the UCS1 range, it will be transformed into
      /// UCS1 (PyUnicode_1BYTE_KIND).</para>
      /// </summary>
      class function FromKindAndData(kind_: integer; buffer: Pointer; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>As TPyUnicode.AsUTF8AndSize(), but does not store the
      /// size.</para>
      /// <para>Warning: This function does not have any special behavior for
      /// nil characters embedded within unicode. As a result, strings
      /// containing nil characters will remain in the returned string, which
      /// some C functions might interpret as the end of the string, leading to
      /// truncation. If truncation is an issue, it is recommended to use
      /// TPyUnicode.AsUTF8AndSize() instead.</para>
      /// </summary>
      class function AsUTF8(const unicode: IPyObject): PAnsiChar;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

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
            TPyType.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_UNICODE_SUBCLASS));
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

class procedure TPyUnicode.InternInPlace(const p_unicode: IPyObject);
var
  TempObj : PPyObject;
begin
  if assigned(PyUnicode_InternInPlace) and
     TPyObject.IsInitialized(p_unicode) then
    begin
      TempObj := p_unicode.PyObject;

      PyUnicode_InternInPlace(@TempObj);

      p_unicode.PyObject    := TempObj;
      p_unicode.ObjRefOwner := True;
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
        Result := (PyUnicode_FSConverter(obj.PyObject, result_) <> 0)
       else
        Result := (PyUnicode_FSConverter(nil, result_) <> 0);
    end;
end;

class function TPyUnicode.FSDecoder(const obj: IPyObject; result_: Pointer): boolean;  
begin
  Result := False;

  if assigned(PyUnicode_FSDecoder) then
    begin
      if TPyObject.IsInitialized(obj) then
        Result := (PyUnicode_FSDecoder(obj.PyObject, result_) <> 0)
       else
        Result := (PyUnicode_FSDecoder(nil, result_) <> 0);
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

class procedure TPyUnicode.Append(const p_left, right: IPyObject);
var
  TempObj : PPyObject;
begin
  if assigned(PyUnicode_Append) and
     TPyObject.IsInitialized(p_left) and
     TPyObject.IsInitialized(right) then
    begin
      TempObj := p_left.Unwrap;

      PyUnicode_Append(@TempObj, right.PyObject);

      p_left.PyObject := TempObj;
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
