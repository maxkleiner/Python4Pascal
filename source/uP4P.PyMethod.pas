unit uP4P.PyMethod;

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
  /// Helper class for all PyMethod_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/method.html#method-objects">See the article about Method Objects.</see></para>
  /// </remarks>
  TPyMethod = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a method object (has type
      /// PyMethod_Type). The parameter must not be nil. This function always
      /// succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new method object, with func being any callable object
      /// and self the instance the method should be bound. func is the function
      /// that will be called when the method is called. self must not be
      /// nil.</para>
      /// </summary>
      class function New(const func, selfobj: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the function object associated with the method
      /// meth.</para>
      /// </summary>
      class function Function_(const meth: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the instance associated with the method meth.</para>
      /// </summary>
      class function Self_(const meth: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyMethod.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyMethod_Type);
end;

class function TPyMethod.New(const func, selfobj: IPyObject): IPyObject;
begin
  if assigned(PyMethod_New) and
     TPyObject.IsInitialized(func) and
     TPyObject.IsInitialized(selfobj) then
    Result := TPyObject.Wrap(PyMethod_New(func.PyObject, selfobj.PyObject))
   else
    Result := nil;
end;

class function TPyMethod.Function_(const meth: IPyObject): IPyObject;
begin
  if assigned(PyMethod_Function) and
     TPyObject.IsInitialized(meth) then
    Result := TPyObject.Wrap(PyMethod_Function(meth.PyObject), False)
   else
    Result := nil;
end;

class function TPyMethod.Self_(const meth: IPyObject): IPyObject;
begin
  if assigned(PyMethod_Self) and
     TPyObject.IsInitialized(meth) then
    Result := TPyObject.Wrap(PyMethod_Self(meth.PyObject), False)
   else
    Result := nil;
end;

end.
