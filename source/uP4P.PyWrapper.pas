unit uP4P.PyWrapper;

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
  /// Helper class for all PyWrapper_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/descriptor.html#descriptor-objects">See the article about the Descriptor Objects.</see></para>
  /// </remarks>
  TPyWrapper = class
    public
      /// <summary>
      /// <para>Create a new bound wrapper object from the wrapper descriptor d
      /// and the instance self_.</para>
      /// <para>This is the bound form of a wrapper descriptor created by
      /// TPyDescr.NewWrapper(). CPython creates these objects when a slot
      /// wrapper is accessed through an instance, and they appear in Python as
      /// types.MethodWrapperType objects.</para>
      /// <para>On success, return a strong reference to the wrapper object.
      /// Return nil with an exception set on failure.</para>
      /// </summary>
      class function New(const d, self_: IPyObject): IPyObject;
  end;

implementation

class function TPyWrapper.New(const d, self_: IPyObject): IPyObject;
begin
  if assigned(PyWrapper_New) and
     TPyObject.IsInitialized(d) and
     TPyObject.IsInitialized(self_) then
    Result := TPyObject.Wrap(PyWrapper_New(d.PyObject, self_.PyObject))
   else
    Result := nil;
end;

end.
