unit uP4P.PyNotImplemented;

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
  /// The NotImplemented singleton, used to signal that an operation is not
  /// implemented for the given type combination. It's immortal since
  /// Python 3.12.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/object.html#object-protocol">See the article about the Object Protocol.</see></para>
  /// </remarks>
  TPyNotImplemented = class
    public
      /// <summary>
      /// <para>Return an IPyObject instance of the Python NotImplemented
      /// object.</para>
      /// </summary>
      class function New: IPyObject;
      /// <summary>
      /// <para>Return a valid Py_NotImplemented pointer.</para>
      /// </summary>
      class function ReturnNotImplemented: PPyObject;
  end;

implementation

uses
  uP4P.Engine, uP4P.Py;

class function TPyNotImplemented.New: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_NotImplemented, False)
   else
    Result := TPyObject.Wrap(Py_NotImplemented, True, True);
end;

class function TPyNotImplemented.ReturnNotImplemented: PPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := Py_NotImplemented
   else
    Result := TPy.NewRef(Py_NotImplemented);
end;

end.
