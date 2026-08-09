unit uP4P.PyNone;

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
  /// The Python None object, denoting lack of value. This object has no methods
  /// and it's immortal since Python 3.12.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/none.html#the-none-object">See the article about The None Object.</see></para>
  /// </remarks>
  TPyNone = class
    public
      /// <summary>
      /// <para>Return an IPyObject instance of the Python None object.</para>
      /// </summary>
      class function New: IPyObject;
  end;

implementation

uses
  uP4P.Engine;

class function TPyNone.New: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_None, False)
   else
    Result := TPyObject.Wrap(Py_None, True, True);
end;

end.
