unit uP4P.PyCallable;

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
  /// Helper class for all PyCallable_* methods.
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/call.html#call-support-api">See the article about the Call Support API.</see></para>
  /// </remarks>
  TPyCallable = class
    public
      /// <summary>
      /// <para>Determine if the object obj is callable.</para>
      /// <para>Return True if the object is callable and False otherwise.</para>
      /// <para>This function always succeeds.</para>
      /// </summary>
      class function Check(const obj: IPyObject): boolean;
  end;

implementation

class function TPyCallable.Check(const obj: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(obj) and
            assigned(PyCallable_Check) and
            (PyCallable_Check(obj.PyObject) > 0);
end;

end.
