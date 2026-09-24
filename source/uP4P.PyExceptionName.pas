unit uP4P.PyExceptionName;

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
  uP4P.LibFunctions, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyExceptionClass_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#exception-classes">See the article about Exception Classes.</see></para>
  /// </remarks>
  TPyExceptionName = class
    public
      /// <summary>
      /// <para>Return tp_name of the exception class ob.</para>
      /// </summary>
      class function Name_(const ob: IPyObject): string;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyExceptionName.Name_(const ob: IPyObject): string;
begin
  if assigned(PyExceptionClass_Name) and
     TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToString(PyExceptionClass_Name(ob.PyObject))
   else
    Result := '';
end;

end.
