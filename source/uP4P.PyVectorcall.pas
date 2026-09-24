unit uP4P.PyVectorcall;

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
  /// Helper class for all PyVectorcall_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/call.html#vectorcall-support-api">See the article about Vectorcall Support API.</see></para>
  /// </remarks>
  TPyVectorcall = class
    public
      /// <summary>
      /// <para>Given a vectorcall nargsf argument, return the actual number of
      /// arguments. Currently equivalent to:</para>
      /// <code>(Py_ssize_t)(nargsf & ~PY_VECTORCALL_ARGUMENTS_OFFSET)</code>
      /// <para>However, the function PyVectorcall_NARGS should be used to allow
      /// for future extensions.</para>
      /// </summary>
      class function NARGS(nargsf: NativeUInt): Py_ssize_t;
      /// <summary>
      /// <para>Call callable's vectorcallfunc with positional and keyword
      /// arguments given in a tuple and dict, respectively.</para>
      /// <para>This is a specialized function, intended to be put in the
      /// tp_call slot or be used in an implementation of tp_call. It does not
      /// check the Py_TPFLAGS_HAVE_VECTORCALL flag and it does not fall back
      /// to tp_call.</para>
      /// </summary>
      class function Call(const callable, tuple, dict: IPyObject): IPyObject;
      /// <summary>
      /// <para>If op does not support the vectorcall protocol (either because
      /// the type does not or because the specific instance does not), return
      /// nil. Otherwise, return the vectorcall function pointer stored in op.
      /// This function never raises an exception.</para>
      /// <para>This is mostly useful to check whether or not op supports
      /// vectorcall, which can be done by checking
      /// TPyVectorcall.Function(op) <> nil.</para>
      /// </summary>
      class function Function_(const op: IPyObject): vectorcallfunc;
  end;

implementation

class function TPyVectorcall.NARGS(nargsf: NativeUInt): Py_ssize_t;
begin
  if assigned(PyVectorcall_NARGS) then
    Result := PyVectorcall_NARGS(nargsf)
   else
    Result := 0;
end;

class function TPyVectorcall.Call(const callable, tuple, dict: IPyObject): IPyObject;
begin
  if assigned(PyVectorcall_Call) and
     TPyObject.IsInitialized(callable) and
     TPyObject.IsInitialized(tuple) then
    begin
      if TPyObject.IsInitialized(dict) then
        Result := TPyObject.Wrap(PyVectorcall_Call(callable.PyObject, tuple.PyObject, dict.PyObject))
       else
        Result := TPyObject.Wrap(PyVectorcall_Call(callable.PyObject, tuple.PyObject, nil));
    end
   else
    Result := nil;
end;

class function TPyVectorcall.Function_(const op: IPyObject): vectorcallfunc;
begin
  if assigned(PyVectorcall_Function) and
     TPyObject.IsInitialized(op) then
    Result := PyVectorcall_Function(op.PyObject)
   else
    Result := nil;
end;

end.
