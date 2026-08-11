unit uP4P.PyStaticMethod;

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
  /// Helper class for all PyStaticMethod_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/descriptor.html#built-in-descriptors">See the article about Built-in descriptors.</see></para>
  /// </remarks>
  TPyStaticMethod = class
    public
      /// <summary>
      /// <para>Create a new staticmethod object wrapping callable. callable
      /// must be a callable object and must not be nil.</para>
      /// <para>On success, this function returns a strong reference to a new
      /// static method descriptor. On failure, this function returns nil with
      /// an exception set.</para>
      /// </summary>
      class function New(const callable: IPyObject): IPyObject;
  end;

implementation

class function TPyStaticMethod.New(const callable: IPyObject): IPyObject;
begin
  if assigned(PyStaticMethod_New) and
     TPyObject.IsInitialized(callable) then
    Result := TPyObject.Wrap(PyStaticMethod_New(callable.PyObject))
   else
    Result := nil;
end;

end.
