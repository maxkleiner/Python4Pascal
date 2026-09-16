unit uP4P.PyDictProxy;

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
  /// Helper class for all PyDictProxy_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#dictionary-objects">See the article about the Dictionary Objects.</see></para>
  /// </remarks>
  TPyDictProxy = class
    public
      /// <summary>
      /// <para>Return a types.MappingProxyType object for a mapping which
      /// enforces read-only behavior. This is normally used to create a view
      /// to prevent modification of the dictionary for non-dynamic class
      /// types.</para>
      /// <para>The first argument can be a dict, a frozendict, or a
      /// mapping.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function New(const mapping: IPyObject): IPyObject;
  end;

implementation

class function TPyDictProxy.New(const mapping: IPyObject): IPyObject;
begin
  if assigned(PyDictProxy_New) and
     TPyObject.IsInitialized(mapping) then
    Result := TPyObject.Wrap(PyDictProxy_New(mapping.PyObject))
   else
    Result := nil;
end;

end.
