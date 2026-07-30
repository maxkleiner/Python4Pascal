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
  TPyCallable = class
    public
      /// <summary>
      /// <para>Return true if obj is callable.</para>
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
