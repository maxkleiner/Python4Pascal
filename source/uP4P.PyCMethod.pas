unit uP4P.PyCMethod;

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
  /// Helper class for all PyCMethod_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#common-object-structures">See the article about Common Object Structures.</see></para>
  /// </remarks>
  TPyCMethod = class
    public
      /// <summary>
      /// <para>Return true if op is an instance of the PyCMethod_Type type or
      /// a subtype of it. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>This is the same as TPyCMethod.Check(), but does not account for
      /// subtypes.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Turn ml into a Python callable object. The caller must ensure
      /// that ml outlives the callable. Typically, ml is defined as a static
      /// variable.</para>
      /// <para>The self_ parameter will be passed as the self_ argument to the
      /// function in ml->ml_meth when invoked. self_ can be nil.</para>
      /// <para>The callable object's __module__ attribute can be set from the
      /// given module argument. module should be a Python string, which will
      /// be used as name of the module the function is defined in.
      /// If unavailable, it can be set to None or nil.</para>
      /// <para>See also function.__module__</para>
      /// <para>The cls parameter will be passed as the defining_class argument
      /// to the C function. Must be set if METH_METHOD is set on
      /// ml->ml_flags.</para>
      /// </summary>
      class function New(const ml: PyMethodDef; const self_, module: IPyObject; const cls: PyTypeObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCMethod.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyCMethod_Type);
end;

class function TPyCMethod.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCMethod_Type);
end;

class function TPyCMethod.New(const ml: PyMethodDef; const self_, module: IPyObject; const cls: PyTypeObject): IPyObject;
begin
  if assigned(PyCMethod_New) and
     TPyObject.IsInitialized(self_) and
     TPyObject.IsInitialized(module) then
    Result := TPyObject.Wrap(PyCMethod_New(@ml, self_.PyObject, module.PyObject, @cls))
   else
    Result := nil;
end;

end.
