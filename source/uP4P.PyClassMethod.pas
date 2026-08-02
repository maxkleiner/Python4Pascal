unit uP4P.PyClassMethod;

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
  /// Helper class for all PyClassMethod* methods.
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/call.html#call-support-api">See the article about the Built-in descriptors.</see></para>
  /// </remarks>
  TPyClassMethod = class
    public
      /// <summary>
      /// <para>Create a new classmethod object wrapping callable. callable must
      /// be a callable object and must not be nil.</para>
      /// <para>On success, this function returns a strong reference to a new
      /// class method descriptor. On failure, this function returns nil with an
      /// exception set.</para>
      /// </summary>
      class function New(const callable: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return true if the object aPyObject is a classmethod object,
      /// but not an instance of a subtype of the classmethod type.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyClassMethod.New(const callable: IPyObject): IPyObject;
begin
  if assigned(PyClassMethod_New) and
     TPyObject.IsInitialized(callable) then
    Result := TPyObject.Wrap(PyClassMethod_New(callable.PyObject))
   else
    Result := nil;
end;

class function TPyClassMethod.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyClassMethod_Type);
end;

end.
