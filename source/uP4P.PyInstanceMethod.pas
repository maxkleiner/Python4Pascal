unit uP4P.PyInstanceMethod;

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
  /// Helper class for all PyInstanceMethod_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/method.html#instance-method-objects">See the article about Instance Method Objects.</see></para>
  /// </remarks>
  TPyInstanceMethod = class
    public
      /// <summary>
      /// <para>Return true if o is an instance method object
      /// (has type PyInstanceMethod_Type). The parameter must not be nil.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new instance method object, with func being any
      /// callable object. func is the function that will be called when the
      /// instance method is called.</para>
      /// </summary>
      class function New(const func: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the function object associated with the instance
      /// method im.</para>
      /// </summary>
      class function Function_(const im: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

class function TPyInstanceMethod.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyInstanceMethod_Type);
end;

class function TPyInstanceMethod.New(const func: IPyObject): IPyObject;
begin
  if assigned(PyInstanceMethod_New) and
     TPyObject.IsInitialized(func) then
    Result := TPyObject.Wrap(PyInstanceMethod_New(func.PyObject))
   else
    Result := nil;
end;

class function TPyInstanceMethod.Function_(const im: IPyObject): IPyObject;
begin
  if assigned(PyInstanceMethod_Function) and
     TPyObject.IsInitialized(im) then
    Result := TPyObject.Wrap(PyInstanceMethod_Function(im.PyObject), False)
   else
    Result := nil;
end;

end.
