unit uP4P.PyCallIter;

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
  /// Helper class for all PyCallIter_* methods.
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/iterator.html#iterator-objects">See the article about Iterator Objects.</see></para>
  /// </remarks>
  TPyCallIter = class
    public
      /// <summary>
      /// <para>Return true if the type of aPyObject is PyCallIter_Type.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new iterator. The first parameter, callable, can be any
      /// Python callable object that can be called with no parameters; each
      /// call to it should return the next item in the iteration. When callable
      /// returns a value equal to sentinel, the iteration will be
      /// terminated.</para>
      /// </summary>
      class function New(const callable, sentinel: IPyObject): IPyObject;
  end;

implementation

class function TPyCallIter.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCallIter_Type);
end;

class function TPyCallIter.New(const callable, sentinel: IPyObject): IPyObject;
begin
  if assigned(PyCallIter_New) and
     TPyObject.IsInitialized(callable) and
     TPyObject.IsInitialized(sentinel) then
    Result := TPyObject.Wrap(PyCallIter_New(callable.PyObject, sentinel.PyObject))
   else
    Result := nil;
end;

end.
