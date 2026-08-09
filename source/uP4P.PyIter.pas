unit uP4P.PyIter;

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
  /// Helper class for all PyIter_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/iter.html#iterator-protocol">See the article about Iterator Protocol.</see></para>
  /// </remarks>
  TPyIter = class
    public
      /// <summary>
      /// <para>Return True if the object o provides the AsyncIterator protocol,
      /// and False otherwise. This function always succeeds.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
      /// <summary>
      /// <para>Return 1 and set item to a strong reference of the next value
      /// of the iterator iter on success. Return 0 and set item to nil if
      /// there are no remaining values. Return -1, set item to nil and set
      /// an exception on error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function NextItem(const iter: IPyObject; out item: IPyObject): integer;
      /// <summary>
      /// <para>This is an older version of TPyIter.NextItem(), which is
      /// retained for backwards compatibility.</para>
      /// <para>Prefer TPyIter.NextItem().</para>
      /// <para>Return the next value from the iterator iter. The object must be
      /// an iterator according to TPyIter.Check() (it is up to the caller to
      /// check this). If there are no remaining values, returns nil with no
      /// exception set. If an error occurs while retrieving the item, returns
      /// nil and passes along the exception.</para>
      /// </summary>
      class function Next(const iter: IPyObject): IPyObject;
      /// <summary>
      /// <para>Sends the arg value into the iterator iter. Returns:</para>
      /// <code>
      /// - PYGEN_RETURN if iterator returns. Return value is returned via
      ///   presult.
      /// - PYGEN_NEXT if iterator yields. Yielded value is returned via
      ///   presult.
      /// - PYGEN_ERROR if iterator has raised and exception. presult is set to
      ///   nil.
      /// </code>
      /// </summary>
      class function Send(const iter, arg: IPyObject; out presult: IPyObject): PySendResult;
  end;

implementation

class function TPyIter.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyIter_Check) and
            TPyObject.IsInitialized(o) and
            (PyIter_Check(o.PyObject) <> 0);
end;

class function TPyIter.NextItem(const iter: IPyObject; out item: IPyObject): integer;
var
  TempItem : PPyObject;
begin
  Result := -1;
  item   := nil;

  if assigned(PyIter_NextItem) and
     TPyObject.IsInitialized(iter) then
    begin
      Result := PyIter_NextItem(iter.PyObject, TempItem);
      if (Result = 1) then
        item := TPyObject.Wrap(TempItem);
    end;
end;

class function TPyIter.Next(const iter: IPyObject): IPyObject;
begin
  if assigned(PyIter_Next) and
     TPyObject.IsInitialized(iter) then
    Result := TPyObject.Wrap(PyIter_Next(iter.PyObject))
   else
    Result := nil;
end;

class function TPyIter.Send(const iter, arg: IPyObject; out presult: IPyObject): PySendResult;
var
  TempPResult : PPyObject;
begin
  Result  := PYGEN_ERROR;
  presult := nil;

  if assigned(PyIter_Send) and
     TPyObject.IsInitialized(iter) and
     TPyObject.IsInitialized(arg) then
    begin
      Result := PyIter_Send(iter.PyObject, arg.PyObject, TempPResult);
      if (Result <> PYGEN_ERROR) then
        presult := TPyObject.Wrap(TempPResult);
    end;
end;

end.
