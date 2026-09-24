unit uP4P.PyUnicodeEncodeError;

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
  /// Helper class for all PyUnicodeEncodeError_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#unicode-exception-objects">See the article about Unicode Exception Objects.</see></para>
  /// </remarks>
  TPyUnicodeEncodeError = class
    public
      /// <summary>
      /// <para>Return the encoding attribute of the given exception object.</para>
      /// </summary>
      class function GetEncoding(const exc: IPyObject): IPyObject;
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

class function TPyUnicodeEncodeError.GetEncoding(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeEncodeError_GetEncoding) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeEncodeError_GetEncoding(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeEncodeError.GetObject(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeEncodeError_GetObject) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeEncodeError_GetObject(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeEncodeError.GetStart(const exc: IPyObject; out start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_GetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_GetStart(exc.PyObject, @start) = 0);
end;

class function TPyUnicodeEncodeError.SetStart(const exc: IPyObject; start: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_SetStart) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_SetStart(exc.PyObject, start) = 0);
end;

class function TPyUnicodeEncodeError.GetEnd(const exc: IPyObject; out end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_GetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_GetEnd(exc.PyObject, @end_) = 0);
end;

class function TPyUnicodeEncodeError.SetEnd(const exc: IPyObject; end_: Py_ssize_t): boolean;
begin
  Result := assigned(PyUnicodeEncodeError_SetEnd) and
            TPyObject.IsInitialized(exc) and
            (PyUnicodeEncodeError_SetEnd(exc.PyObject, end_) = 0);
end;

class function TPyUnicodeEncodeError.GetReason(const exc: IPyObject): IPyObject;
begin
  if assigned(PyUnicodeEncodeError_GetReason) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyUnicodeEncodeError_GetReason(exc.PyObject))
   else
    Result := nil;
end;

class function TPyUnicodeEncodeError.SetReason(const exc: IPyObject; const reason: string): boolean;
var
  TempReason : AnsiString;
begin
  if assigned(PyUnicodeEncodeError_SetReason) and
     TPyObject.IsInitialized(exc) then
    begin
      TempReason := StringToPyUTF8(reason);
      Result     := (PyUnicodeEncodeError_SetReason(exc.PyObject, PAnsiChar(TempReason)) = 0);
    end
   else
    Result := False;
end;

end.
