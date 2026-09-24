unit uP4P.PyOS;

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
  /// Helper class for all PyOS_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/sys.html#operating-system-utilities">See the article about Operating System Utilities.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/veryhigh.html#the-very-high-level-layer">See the article about The Very High Level Layer.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/conversion.html#string-conversion-and-formatting">See the article about String conversion and formatting.</see></para>
  /// </remarks>
  TPyOS = class
    public
      /// <summary>
      /// <para>Convert the initial part of the string in str to a C_ULong value
      /// according to the given base, which must be between 2 and 36 inclusive,
      /// or be the special value 0.</para>
      /// <para>Leading white space and case of characters are ignored. If base
      /// is zero it looks for a leading 0b, 0o or 0x to tell which base. If
      /// these are absent it defaults to 10. Base must be 0 or between 2 and 36
      /// (inclusive). If ptr is non-nil it will contain a pointer to the end of
      /// the scan.</para>
      /// <para>If the converted value falls out of range of corresponding
      /// return type, range error occurs (errno is set to ERANGE) and ULONG_MAX
      /// is returned. If no conversion can be performed, 0 is returned.</para>
      /// <para>See also the Unix man page strtoul(3).</para>
      /// </summary>
      class function strtoul(const str: string; base: integer): C_ULong;
      /// <summary>
      /// <para>Convert the initial part of the string in str to an long value
      /// according to the given base, which must be between 2 and 36 inclusive,
      /// or be the special value 0.</para>
      /// <para>Same as TPyOS.strtoul(), but return a long value instead and
      /// LONG_MAX on overflows.</para>
      /// <para>See also the Unix man page strtol(3).</para>
      /// </summary>
      class function strtol(const str: string; base: integer): C_Long;
      /// <summary>
      /// <para>Return true when the interpreter runs out of stack space. This
      /// is a reliable check, but is only available when USE_STACKCHECK is
      /// defined (currently on certain versions of Windows using the Microsoft
      /// Visual C++ compiler). USE_STACKCHECK will be defined automatically;
      /// you should never change the definition in your own code.</para>
      /// </summary>
      class function CheckStack: boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function Readline(sys_stdin, sys_stdout: PFILE; const prompt: string): string;
      /// <summary>
      /// <para>Return the current signal handler for signal i. This is a thin
      /// wrapper around either sigaction() or signal(). Do not call those
      /// functions directly!</para>
      /// </summary>
      class function getsig(i: integer): PyOS_sighandler_t;
      /// <summary>
      /// <para>Set the signal handler for signal i to be h; return the old
      /// signal handler. This is a thin wrapper around either sigaction() or
      /// signal(). Do not call those functions directly!</para>
      /// </summary>
      class function setsig(i: integer; s: PyOS_sighandler_t): PyOS_sighandler_t;
      /// <summary>
      /// <para>Return true when the interpreter runs out of stack space. This
      /// is a reliable check, but is only available when USE_STACKCHECK is
      /// defined (currently on certain versions of Windows using the Microsoft
      /// Visual C++ compiler). USE_STACKCHECK will be defined automatically;
      /// you should never change the definition in your own code.</para>
      /// </summary>
      class function FSPath(const path: IPyObject): IPyObject;
      /// <summary>
      /// <para>Check if a SIGINT signal has been received.</para>
      /// <para>Returns True if a SIGINT has occurred and clears the signal
      /// flag, or False otherwise.</para>
      /// <para>In most cases, you should prefer TPyErr.CheckSignals() over this
      /// function. TPyErr.CheckSignals() invokes the appropriate signal
      /// handlers for all pending signals, allowing Python code to handle the
      /// signal properly. This function only detects SIGINT and does not invoke
      /// any Python signal handlers.</para>
      /// <para>This function is async-signal-safe and this function cannot
      /// fail. The caller must hold an attached thread state.</para>
      /// </summary>
      class function InterruptOccurred: boolean;
      /// <summary>
      /// <para>Convert a string s to a double, raising a Python exception on
      /// failure. The set of accepted strings corresponds to the set of strings
      /// accepted by Python's float() constructor, except that s must not have
      /// leading or trailing whitespace. The conversion is independent of the
      /// current locale.</para>
      /// <para>If endptr is nil, convert the whole string. Raise ValueError and
      /// return -1.0 if the string is not a valid representation of a
      /// floating-point number.</para>
      /// <para>If s represents a value that is too large to store in a float
      /// (for example, "1e500" is such a string on many platforms) then if
      /// overflow_exception is nil return Py_INFINITY (with an appropriate
      /// sign) and don't set any exception. Otherwise, overflow_exception must
      /// point to a Python exception object; raise that exception and return
      /// -1.0. In both cases, set *endptr to point to the first character after
      /// the converted value.</para>
      /// <para>If any other error occurs during the conversion (for example an
      /// out-of-memory error), set the appropriate Python exception and return
      /// -1.0.</para>
      /// </summary>
      class function string_to_double(const str: string; const overflow_exception: IPyObject): double;
      /// <summary>
      /// <para>Convert a double val to a string using supplied format_code,
      /// precision, and flags.</para>
      /// <para>format_code must be one of 'e', 'E', 'f', 'F', 'g', 'G' or 'r'.
      /// For 'r', the supplied precision must be 0 and is ignored.
      /// The 'r' format code specifies the standard repr() format.</para>
      /// <para>flags can be zero or more of the Py_DTSF_* constants.</para>
      /// <para>ptype will be set to one of the Py_DTST_* constants.</para>
      /// </summary>
      class function double_to_string(val: double; format_code: TPyDoubleToStringFormatCode; flags: integer; out ptype: integer): string;
      /// <summary>
      /// <para>Case insensitive comparison of strings. These functions work
      /// almost identically to strcmp() and strncmp() (respectively), except
      /// that they ignore the case of ASCII characters.</para>
      /// <para>Return 0 if the strings are equal, a negative value if str1
      /// sorts lexicographically before str2, or a positive value if it sorts
      /// after.</para>
      /// <para>In the str1 or str2 arguments, a NUL byte marks the end of the
      /// string. For TPyOS.mystrnicmp(), the size argument gives the maximum
      /// size of the string, as if NUL was present at the index given by
      /// size.</para>
      /// <para>These functions do not use the locale.</para>
      /// </summary>
      class function mystrnicmp(const str1, str2: PAnsiChar; size_: Py_ssize_t): integer; overload;
      /// <summary>
      /// <para>Case insensitive comparison of strings. These functions work
      /// almost identically to strcmp() and strncmp() (respectively), except
      /// that they ignore the case of ASCII characters.</para>
      /// <para>Return 0 if the strings are equal, a negative value if str1
      /// sorts lexicographically before str2, or a positive value if it sorts
      /// after.</para>
      /// <para>In the str1 or str2 arguments, a NUL byte marks the end of the
      /// string. For TPyOS.mystrnicmp(), the size argument gives the maximum
      /// size of the string, as if NUL was present at the index given by
      /// size.</para>
      /// <para>These functions do not use the locale.</para>
      /// </summary>
      class function mystrnicmp(const str1, str2: string; size_: Py_ssize_t): integer; overload;
      /// <summary>
      /// <para>Case insensitive comparison of strings. These functions work
      /// almost identically to strcmp() and strncmp() (respectively), except
      /// that they ignore the case of ASCII characters.</para>
      /// <para>Return 0 if the strings are equal, a negative value if str1
      /// sorts lexicographically before str2, or a positive value if it sorts
      /// after.</para>
      /// <para>In the str1 or str2 arguments, a NUL byte marks the end of the
      /// string.</para>
      /// <para>These functions do not use the locale.</para>
      /// </summary>
      class function mystricmp(const str1, str2: PAnsiChar): integer; overload;
      /// <summary>
      /// <para>Case insensitive comparison of strings. These functions work
      /// almost identically to strcmp() and strncmp() (respectively), except
      /// that they ignore the case of ASCII characters.</para>
      /// <para>Return 0 if the strings are equal, a negative value if str1
      /// sorts lexicographically before str2, or a positive value if it sorts
      /// after.</para>
      /// <para>In the str1 or str2 arguments, a NUL byte marks the end of the
      /// string.</para>
      /// <para>These functions do not use the locale.</para>
      /// </summary>
      class function mystricmp(const str1, str2: string): integer; overload;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyOS.strtoul(const str: string; base: integer): C_ULong;
var
  TempStr: AnsiString;
begin
  if assigned(PyOS_strtoul) and (base in [0, 2..36]) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := PyOS_strtoul(PAnsiChar(TempStr), nil, base);
    end
   else
    Result := 0;
end;

class function TPyOS.strtol(const str: string; base: integer): C_Long;
var
  TempStr: AnsiString;
begin
  if assigned(PyOS_strtol) and (base in [0, 2..36]) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := PyOS_strtol(PAnsiChar(TempStr), nil, base);
    end
   else
    Result := 0;
end;

class function TPyOS.CheckStack: boolean;
begin
  Result := assigned(PyOS_CheckStack) and
            (PyOS_CheckStack() <> 0);
end;

class function TPyOS.Readline(sys_stdin, sys_stdout: PFILE; const prompt: string): string;
var
  TempPrompt : AnsiString;
begin
  Result := '';

  if assigned(PyOS_Readline) then
    begin
      TempPrompt := StringToPyUTF8(prompt);
      Result     := PyUTF8ToString(PyOS_Readline(sys_stdin, sys_stdout, PAnsiChar(TempPrompt)));
    end;
end;

class function TPyOS.getsig(i: integer): PyOS_sighandler_t;
begin
  if assigned(PyOS_getsig) then
    Result := PyOS_getsig(i)
   else
    Result := nil;
end;

class function TPyOS.setsig(i: integer; s: PyOS_sighandler_t): PyOS_sighandler_t;
begin
  if assigned(PyOS_setsig) then
    Result := PyOS_setsig(i, s)
   else
    Result := nil;
end;

class function TPyOS.FSPath(const path: IPyObject): IPyObject;
begin
  if assigned(PyOS_FSPath) and
     TPyObject.IsInitialized(path) then
    Result := TPyObject.Wrap(PyOS_FSPath(path.PyObject))
   else
    Result := nil;
end;

class function TPyOS.InterruptOccurred: boolean;
begin
  Result := assigned(PyOS_InterruptOccurred) and
            (PyOS_InterruptOccurred() <> 0);
end;

class function TPyOS.string_to_double(const str: string; const overflow_exception: IPyObject): double;
var
  TempStr : AnsiString;
  TempExc : PPyObject;
begin
  Result := -1;

  if (length(str) > 0) and assigned(PyOS_string_to_double) then
    begin
      TempStr := StringToPyUTF8(str);

      if TPyObject.IsInitialized(overflow_exception) then
        TempExc := overflow_exception.PyObject
       else
        TempExc := nil;

      Result := PyOS_string_to_double(PAnsiChar(TempStr), nil, TempExc);
    end;
end;

class function TPyOS.double_to_string(val: double; format_code: TPyDoubleToStringFormatCode; flags: integer; out ptype: integer): string;
var
  TempFormat : AnsiChar;
begin
  Result := '';

  if assigned(PyOS_double_to_string) then
    begin
      case format_code of
        fc_lowercase_e : TempFormat := 'e';
        fc_E           : TempFormat := 'E';
        fc_lowercase_f : TempFormat := 'f';
        fc_F           : TempFormat := 'F';
        fc_lowercase_g : TempFormat := 'g';
        fc_G           : TempFormat := 'G';
        else             TempFormat := 'r'; // fc_r
      end;

      Result := PyUTF8ToString(PyOS_double_to_string(val, TempFormat, 0, flags, ptype), True);
    end;
end;

class function TPyOS.mystrnicmp(const str1, str2: PAnsiChar; size_: Py_ssize_t): integer;
begin
  if assigned(PyOS_mystrnicmp) then
    Result := PyOS_mystrnicmp(str1, str2, size_)
   else
    Result := 0;
end;

class function TPyOS.mystrnicmp(const str1, str2: string; size_: Py_ssize_t): integer;
var
  TempStr1, TempStr2 : AnsiString;
begin
  TempStr1 := StringToPyUTF8(str1);
  TempStr2 := StringToPyUTF8(str2);
  Result   := mystrnicmp(PAnsiChar(TempStr1), PAnsiChar(TempStr2), size_);
end;

class function TPyOS.mystricmp(const str1, str2: PAnsiChar): integer;
begin
  if assigned(PyOS_mystricmp) then
    Result := PyOS_mystricmp(str1, str2)
   else
    Result := 0;
end;

class function TPyOS.mystricmp(const str1, str2: string): integer;
var
  TempStr1, TempStr2 : AnsiString;
begin
  TempStr1 := StringToPyUTF8(str1);
  TempStr2 := StringToPyUTF8(str2);
  Result   := mystricmp(PAnsiChar(TempStr1), PAnsiChar(TempStr2));
end;

end.
