unit uP4P.PyState;

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
  /// Helper class for all PyState_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-lookup-single-phase-initialization">See the article about Module lookup (single-phase initialization).</see></para>
  /// </remarks>
  TPyState = class
    public
      /// <summary>
      /// <para>Attaches the module object passed to the function to the
      /// interpreter state. This allows the module object to be accessible via
      /// TPyState.FindModule().</para>
      /// <para>Only effective on modules created using single-phase
      /// initialization.</para>
      /// <para>Python calls TPyState.AddModule automatically after importing a
      /// module that uses single-phase initialization, so it is unnecessary
      /// (but harmless) to call it from module initialization code. An explicit
      /// call is needed only if the module's own init code subsequently calls
      /// TPyState.FindModule. The function is mainly intended for implementing
      /// alternative import mechanisms (either by calling it directly, or by
      /// referring to its implementation for details of the required state
      /// updates).</para>
      /// <para>If a module was attached previously using the same def, it is
      /// replaced by the new module.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>Return False with an exception set on error, True on
      /// success.</para>
      /// </summary>
      class function AddModule(const module: IPyObject; def: PPyModuleDef): boolean;
      /// <summary>
      /// <para>Removes the module object created from def from the interpreter
      /// state. Return False with an exception set on error, True on
      /// success.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// </summary>
      class function RemoveModule(def: PPyModuleDef): boolean;
      /// <summary>
      /// <para>Returns the module object that was created from def for the
      /// current interpreter. This method requires that the module object has
      /// been attached to the interpreter state with TPyState.AddModule()
      /// beforehand. In case the corresponding module object is not found or
      /// has not been attached to the interpreter state yet, it returns
      /// nil.</para>
      /// </summary>
      class function FindModule(def: PPyModuleDef): IPyObject;
  end;

implementation

class function TPyState.AddModule(const module: IPyObject; def: PPyModuleDef): boolean;
begin
  Result := assigned(PyState_AddModule) and
            TPyObject.IsInitialized(module) and
            assigned(def) and
            (PyState_AddModule(module.PyObject, def) = 0);
end;

class function TPyState.RemoveModule(def: PPyModuleDef): boolean;
begin
  Result := assigned(PyState_RemoveModule) and
            assigned(def) and
            (PyState_RemoveModule(def) = 0);
end;

class function TPyState.FindModule(def: PPyModuleDef): IPyObject;
begin
  if assigned(PyState_FindModule) and assigned(def) then
    Result := TPyObject.Wrap(PyState_FindModule(def), False)
   else
    Result := nil;
end;

end.
