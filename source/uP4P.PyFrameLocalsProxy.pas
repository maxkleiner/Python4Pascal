unit uP4P.PyFrameLocalsProxy;

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
  /// Helper class for all PyFrameLocalsProxy_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/frame.html#frame-locals-proxies">See the article about Frame locals proxies.</see></para>
  /// </remarks>
  TPyFrameLocalsProxy = class
    public
      /// <summary>
      /// <para>Return True if obj is a frame locals() proxy.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyFrameLocalsProxy.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFrameLocalsProxy_Type);
end;

end.
