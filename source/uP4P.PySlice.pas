unit uP4P.PySlice;

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
  /// Helper class for all PySlice_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/slice.html#slice-objects">See the article about Slice Objects.</see></para>
  /// </remarks>
  TPySlice = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a slice object; aPyObject must not
      /// be nil. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new slice object with the given values. The start,
      /// stop, and step parameters are used as the values of the slice object
      /// attributes of the same names. Any of the values may be nil, in which
      /// case the None will be used for the corresponding attribute.</para>
      /// <para>Return nil with an exception set if the new object could not be
      /// allocated.</para>
      /// </summary>
      class function New(const start, stop, step: IPyObject): IPyObject;
      /// <summary>
      /// <para>Retrieve the start, stop and step indices from the slice object
      /// slice, assuming a sequence of length length. Treats indices greater
      /// than length as errors.</para>
      /// <para>Returns True on success and False on error with no exception set
      /// (unless one of the indices was not None and failed to be converted to
      /// an integer, in which case False is returned with an exception
      /// set).</para>
      /// <para>You probably do not want to use this function.</para>
      /// </summary>
      class function GetIndices(const slice: IPyObject; length: Py_ssize_t; var start, stop, step: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Usable replacement for TPySlice.GetIndices(). Retrieve the
      /// start, stop, and step indices from the slice object slice assuming a
      /// sequence of length length, and store the length of the slice in
      /// slicelength. Out of bounds indices are clipped in a manner consistent
      /// with the handling of normal slices.</para>
      /// <para>Return True on success and False on error with an exception
      /// set.</para>
      /// <para>Note: This function is considered not safe for resizable
      /// sequences. Its invocation should be replaced by a combination of
      /// TPySlice.Unpack() and TPySlice.AdjustIndices() where</para>
      /// <code>
      /// if (PySlice_GetIndicesEx(slice, length, &start, &stop, &step, &slicelength) < 0) {
      ///     // return error
      /// }
      /// </code>
      /// <para>is replaced by</para>
      /// <code>
      /// if (PySlice_Unpack(slice, &start, &stop, &step) < 0) {
      ///     // return error
      /// }
      /// slicelength = PySlice_AdjustIndices(length, &start, &stop, step);
      /// </code>
      /// </summary>
      class function GetIndicesEx(const slice: IPyObject; length: Py_ssize_t; var start, stop, step, slicelength: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Extract the start, stop and step data members from a slice
      /// object as C integers. Silently reduce values larger than
      /// PY_SSIZE_T_MAX to PY_SSIZE_T_MAX, silently boost the start and stop
      /// values less than PY_SSIZE_T_MIN to PY_SSIZE_T_MIN, and silently boost
      /// the step values less than -PY_SSIZE_T_MAX to -PY_SSIZE_T_MAX.</para>
      /// <para>Return False with an exception set on error, True on
      /// success.</para>
      /// </summary>
      class function Unpack(const slice: IPyObject; var start, stop, step: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Adjust start/end slice indices assuming a sequence of the
      /// specified length. Out of bounds indices are clipped in a manner
      /// consistent with the handling of normal slices.</para>
      /// <para>Return the length of the slice. Always successful. Doesn't call
      /// Python code.</para>
      /// </summary>
      class function AdjustIndices(length: Py_ssize_t; var start, stop: Py_ssize_t; step: Py_ssize_t): Py_ssize_t;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPySlice.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PySlice_Type);
end;

class function TPySlice.New(const start, stop, step: IPyObject): IPyObject;
begin
  if assigned(PySlice_New) and
     TPyObject.IsInitialized(start) and
     TPyObject.IsInitialized(stop) and
     TPyObject.IsInitialized(step) then
    Result := TPyObject.Wrap(PySlice_New(start.PyObject, stop.PyObject, step.PyObject))
   else
    Result := nil;
end;

class function TPySlice.GetIndices(const slice: IPyObject; length: Py_ssize_t; var start, stop, step: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(slice) and
            assigned(PySlice_GetIndices) and
            (PySlice_GetIndices(slice.PyObject, length, @start, @stop, @step) = 0);
end;

class function TPySlice.GetIndicesEx(const slice: IPyObject; length: Py_ssize_t; var start, stop, step, slicelength: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(slice) and
            assigned(PySlice_GetIndicesEx) and
            (PySlice_GetIndicesEx(slice.PyObject, length, @start, @stop, @step, @slicelength) = 0);
end;

class function TPySlice.Unpack(const slice: IPyObject; var start, stop, step: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(slice) and
            assigned(PySlice_Unpack) and
            (PySlice_Unpack(slice.PyObject, @start, @stop, @step) = 0);
end;

class function TPySlice.AdjustIndices(length: Py_ssize_t; var start, stop: Py_ssize_t; step: Py_ssize_t): Py_ssize_t;
begin
  if assigned(PySlice_AdjustIndices) then
    Result := PySlice_AdjustIndices(length, @start, @stop, step)
   else
    REsult := -1;
end;

end.
