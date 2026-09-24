unit uP4P.PyUnicodeTranslateError;

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
  /// Helper class for all PyUnicodeTranslateError_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#unicode-exception-objects">See the article about Unicode Exception Objects.</see></para>
  /// </remarks>
  TPyUnicodeTranslateError = class
    public
      /// <summary>
      /// <para>Return the object attribute of the given exception object.</para>
      /// </summary>
      class function GetObject(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get the start attribute of the given exception object and place
      /// it into *start. start must not be nil. Return True on success, False
      /// on failure.</para>
      /// <para>If the UnicodeError.object is an empty sequence, the resulting
      /// start is 0. Otherwise, it is clipped to
      /// [0, len(object) - 1].</para>
      /// <para>See also UnicodeError.start</para>
      /// </summary>
      class function GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Set the start attribute of the given exception object to start.
      /// Return True on success, False on failure.</para>
      /// <para>Note While passing a negative start does not raise an exception,
      /// the corresponding getters will not consider it as a relative
      /// offset.</para>
      /// </summary>
      class function SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Get the end attribute of the given exception object and place it
      /// into end_. end must not be nil. Return True on success, False on
      /// failure.</para>
      /// <para>If the UnicodeError.object is an empty sequence, the resulting
      /// end is 0. Otherwise, it is clipped to [1, len(object)].</para>
      /// </summary>
      class function GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Set the end_ attribute of the given exception object to end.
      /// Return True on success, False on failure.</para>
      /// <para>See also UnicodeError.end</para>
      /// </summary>
      class function SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Return the reason attribute of the given exception
      /// object.</para>
      /// </summary>
      class function GetReason(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the reason attribute of the given exception object to
      /// reason. Return True on success, False on failure.</para>
      /// </summary>
      class function SetReason(const exc: IPyObject; const reason: string): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyUnicodeTranslateError.GetObject(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeTranslateError_GetObject) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeTranslateError_GetObject(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeTranslateError.GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_GetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_GetStart(exc.PyObject, @start) = 0);
end;

class function TPyUnicodeTranslateError.SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_SetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_SetStart(exc.PyObject, start) = 0);
end;

class function TPyUnicodeTranslateError.GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_GetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_GetEnd(exc.PyObject, @end_) = 0);
end;

class function TPyUnicodeTranslateError.SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeTranslateError_SetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeTranslateError_SetEnd(exc.PyObject, end_) = 0);
end;

class function TPyUnicodeTranslateError.GetReason(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeTranslateError_GetReason) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeTranslateError_GetReason(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeTranslateError.SetReason(const exc: IPyObject; const reason: string): boolean;
var
  TempReason : AnsiString;
begin
  if assigned(PyUnicodeTranslateError_SetReason) and
     TPyObject.IsInitialized(exc) then
    begin
      TempReason := StringToPyUTF8(reason);
      Result     := (PyUnicodeTranslateError_SetReason(exc.PyObject, PAnsiChar(TempReason)) = 0);
    end
   else
    Result := False;
end;

end.
