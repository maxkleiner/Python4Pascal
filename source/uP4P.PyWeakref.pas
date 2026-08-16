unit uP4P.PyWeakref;

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
  /// Helper class for all PyWeakref_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/weakref.html#weak-reference-objects">See the article about Weak Reference Objects.</see></para>
  /// </remarks>
  TPyWeakref = class
    public
      /// <summary>
      /// <para>Return True if aPyObject is a reference object or a subclass of
      /// the reference type. This function always succeeds.</para>
      /// </summary>
      class function CheckRef(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return True if aPyObject is a reference object, but not a
      /// subclass of the reference type. This function always succeeds.</para>
      /// </summary>
      class function CheckRefExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return True if aPyObject is a proxy object. This function
      /// always succeeds.</para>
      /// </summary>
      class function CheckProxy(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return True if aPyObject is either a reference or proxy object.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a weak reference object for the object ob. This will
      /// always return a new reference, but is not guaranteed to create a
      /// new object; an existing reference object may be returned. The second
      /// parameter, callback, can be a callable object that receives
      /// notification when ob is garbage collected; it should accept a single
      /// parameter, which will be the weak reference object itself. callback
      /// may also be None or nil. If ob is not a weakly referenceable object,
      /// this will raise TypeError and return nil.</para>
      /// <para>See also TPyTypeObject.SUPPORTS_WEAKREFS() for checking if ob
      /// is weakly referenceable.</para>
      /// </summary>
      class function NewRef(const ob, callback: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a weak reference proxy object for the object ob. This
      /// will always return a new reference, but is not guaranteed to create
      /// a new object; an existing proxy object may be returned. The second
      /// parameter, callback, can be a callable object that receives
      /// notification when ob is garbage collected; it should accept a single
      /// parameter, which will be the weak reference object itself. callback
      /// may also be None or nil. If ob weakly referenceable object, this will
      /// raise TypeError and return nil.</para>
      /// <para>See also TPyTypeObject.SUPPORTS_WEAKREFS() for checking if ob
      /// is weakly referenceable.</para>
      /// </summary>
      class function NewProxy(const ob, callback: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get a strong reference to the referenced object from a weak
      /// reference, ref, into *pobj.</para>
      /// <code>
      /// - On success, set *pobj to a new strong reference to the referenced
      ///   object and return 1.
      /// - If the reference is dead, set *pobj to nil and return 0.
      /// - On error, raise an exception and return -1.
      /// </code>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetRef(const ref: IPyObject; var pobj: IPyObject): integer;
      /// <summary>
      /// <para>Test if the weak reference ref is dead. Returns 1 if the
      /// reference is dead, 0 if it is alive, and -1 with an error set if ref
      /// is not a weak reference object.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function IsDead(const ref: IPyObject): integer;
  end;

implementation

class function TPyWeakref.CheckRef(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(_PyWeakref_RefType);
end;

class function TPyWeakref.CheckRefExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            (aPyObject.IsType(_PyWeakref_ProxyType) or (aPyObject.IsType(_PyWeakref_CallableProxyType)));
end;

class function TPyWeakref.CheckProxy(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(_PyWeakref_RefType);
end;

class function TPyWeakref.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyWeakref.CheckRef(aPyObject) or
            TPyWeakref.CheckProxy(aPyObject);
end;

class function TPyWeakref.NewRef(const ob, callback: IPyObject): IPyObject;
var
  TempCallback : PPyObject;
begin
  Result := nil;

  if assigned(PyWeakref_NewRef) and
     TPyObject.IsInitialized(ob) then
    begin
      if TPyObject.IsInitialized(callback) then
        TempCallback := callback.PyObject
       else
        TempCallback := nil;

      Result := TPyObject.Wrap(PyWeakref_NewRef(ob.PyObject, TempCallback));
    end;
end;

class function TPyWeakref.NewProxy(const ob, callback: IPyObject): IPyObject;
var
  TempCallback : PPyObject;
begin
  Result := nil;

  if assigned(PyWeakref_NewProxy) and
     TPyObject.IsInitialized(ob) then
    begin
      if TPyObject.IsInitialized(callback) then
        TempCallback := callback.PyObject
       else
        TempCallback := nil;

      Result := TPyObject.Wrap(PyWeakref_NewProxy(ob.PyObject, TempCallback));
    end;
end;

class function TPyWeakref.GetRef(const ref: IPyObject; var pobj: IPyObject): integer;
var
  TempPObj : PPyObject;
begin
  Result := -1;
  pobj   := nil;

  if assigned(PyWeakref_GetRef) and
     TPyObject.IsInitialized(ref) then
    begin
      Result := PyWeakref_GetRef(ref.PyObject, TempPObj);

      if (Result = 1) then
        pobj := TPyObject.Wrap(TempPObj);
    end;
end;

class function TPyWeakref.IsDead(const ref: IPyObject): integer;
begin
  if assigned(PyWeakref_IsDead) and
     TPyObject.IsInitialized(ref) then
    Result := PyWeakref_IsDead(ref.PyObject)
   else
    Result := -1;
end;

end.
