unit uP4P.PyFrame;

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
  TPyFrame = class(TPyObject, IPyFrameObject)
    protected
      FPyFrameObject : PPyFrameObject;

    public

  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

end.
