unit uP4P.PyType;

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
  /// <para>Helper class for all PyType_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#type-objects">See the article about Type Objects.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/object.html#object-protocol">See the article about the Object Protocol.</see></para>
  /// </remarks>
  TPyType = class
    public
      /// <summary>
      /// <para>Equivalent to
      /// TPyType.FromMetaclass(nil, nil, spec, nil).</para>
      /// <para>Changed in version 3.12: The function now finds and uses a
      /// metaclass corresponding to the base classes provided in
      /// Py_tp_base[s] slots. Previously, only type instances were
      /// returned.</para>
      /// <para>The tp_new of the metaclass is ignored. which may result in
      /// incomplete initialization. Creating classes whose metaclass overrides
      /// tp_new is deprecated.</para>
      /// <para>Changed in version 3.14: Creating classes whose metaclass
      /// overrides tp_new is no longer allowed.</para>
      /// <para>Soft deprecated since version 3.15: Prefer TPyType.FromSlots()
      /// in new code.</para>
      /// </summary>
      class function FromSpec(spec: PPyType_Spec): IPyObject;
      /// <summary>
      /// <para>Equivalent to
      /// TPyType.FromMetaclass(nil, nil, spec, bases).</para>
      /// <para>Added in version 3.3.</para>
      /// <para>Changed in version 3.12: The function now finds and uses a
      /// metaclass corresponding to the provided base classes. Previously, only
      /// type instances were returned.</para>
      /// <para>The tp_new of the metaclass is ignored. which may result in
      /// incomplete initialization. Creating classes whose metaclass overrides
      /// tp_new is deprecated.</para>
      /// <para>Changed in version 3.14: Creating classes whose metaclass
      /// overrides tp_new is no longer allowed.</para>
      /// <para>Soft deprecated since version 3.15: Prefer TPyType.FromSlots()
      /// in new code.</para>
      /// </summary>
      class function FromSpecWithBases(spec: PPyType_Spec; const bases: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the function pointer stored in the given slot. If the
      /// result is nil, this indicates that either the slot is nil, or that the
      /// function was called with invalid parameters. Callers will typically
      /// cast the result pointer into the appropriate function type.</para>
      /// <para>See PyType_Slot.slot for possible values of the slot
      /// argument.</para>
      /// </summary>
      class function GetSlot(type_: PPyTypeObject; i: integer): Pointer;
      /// <summary>
      /// <para>Equivalent to
      /// TPyType.FromMetaclass(nil, module, spec, bases).</para>
      /// <para>Added in version 3.9.</para>
      /// <para>Changed in version 3.10: The function now accepts a single class
      /// as the bases argument and nil as the tp_doc slot.</para>
      /// <para>Changed in version 3.12: The function now finds and uses a
      /// metaclass corresponding to the provided base classes. Previously, only
      /// type instances were returned.</para>
      /// <para>The tp_new of the metaclass is ignored. which may result in
      /// incomplete initialization. Creating classes whose metaclass overrides
      /// tp_new is deprecated.</para>
      /// <para>Changed in version 3.14: Creating classes whose metaclass
      /// overrides tp_new is no longer allowed.</para>
      /// <para>Soft deprecated since version 3.15: Prefer TPyType.FromSlots()
      /// in new code.</para>
      /// </summary>
      class function FromModuleAndSpec(const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the module object associated with the given type when the
      /// type was created using TPyType.FromModuleAndSpec().</para>
      /// <para>The returned reference is borrowed from type, and will be valid
      /// as long as you hold a reference to type. Do not release it with
      /// TPy.DECREF() or similar.</para>
      /// <para>If no module is associated with the given type, sets TypeError
      /// and returns nil.</para>
      /// <para>This function is usually used to get the module in which a
      /// method is defined. Note that in such a method,
      /// TPyType.GetModule(TPy.TYPE(self)) may not return the intended
      /// result. TPy.TYPE(self) may be a subclass of the intended class, and
      /// subclasses are not necessarily defined in the same module as their
      /// superclass. See PyCMethod to get the class that defines the method.
      /// See TPyType.GetModuleByToken() for cases when PyCMethod cannot
      /// be used.</para>
      /// </summary>
      class function GetModule(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Return the state of the module object associated with the given
      /// type. This is a shortcut for calling TPyModule.GetState() on the
      /// result of TPyType.GetModule().</para>
      /// <para>If no module is associated with the given type, sets TypeError
      /// and returns nil.</para>
      /// <para>If the type has an associated module but its state is nil,
      /// returns nil without setting an exception.</para>
      /// </summary>
      class function GetModuleState(type_: PPyTypeObject): Pointer;
      /// <summary>
      /// <para>Return the type's name. Equivalent to getting the type's
      /// __name__ attribute.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetName(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Return the type's qualified name. Equivalent to getting the
      /// type's __qualname__ attribute.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetQualName(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Return the type's fully qualified name. Equivalent to
      /// f"{type.__module__}.{type.__qualname__}", or type.__qualname__ if
      /// type.__module__ is not a string or is equal to "builtins".</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetFullyQualifiedName(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Return the type's module name. Equivalent to getting the
      /// type.__module__ attribute.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetModuleName(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Create and return a heap type from the spec
      /// (see Py_TPFLAGS_HEAPTYPE).</para>
      /// <para>The metaclass metaclass is used to construct the resulting type
      /// object. When metaclass is nil, the metaclass is derived from bases
      /// (or Py_tp_base[s] slots if bases is nil, see below).</para>
      /// <para>Metaclasses that override tp_new are not supported, except if
      /// tp_new is nil.</para>
      /// <para>The bases argument can be used to specify base classes; it can
      /// either be only one class or a tuple of classes. If bases is nil, the
      /// Py_tp_bases slot is used instead. If that also is nil, the Py_tp_base
      /// slot is used instead. If that also is nil, the new type derives from
      /// object.</para>
      /// <para>The module argument can be used to record the module in which
      /// the new class is defined. It must be a module object or nil.
      /// If not nil, the module is associated with the new type and can later
      /// be retrieved with TPyType.GetModule(). The associated module is
      /// not inherited by subclasses; it must be specified for each class
      /// individually.</para>
      /// <para>This function calls TPyType.Ready() on the new
      /// type.</para>
      /// <para>Note that this function does not fully match the behavior of
      /// calling type() or using the class statement. With user-provided base
      /// types or metaclasses, prefer calling type (or the metaclass) over
      /// TPyType.From* functions. Specifically:</para>
      /// <para>__new__() is not called on the new class (and it must be set to
      /// type.__new__).</para>
      /// <para>__init__() is not called on the new class.</para>
      /// <para>__init_subclass__() is not called on any bases.</para>
      /// <para>__set_name__() is not called on new descriptors.</para>
      /// <para>Added in version 3.12.</para>
      /// <para>Soft deprecated since version 3.15: Prefer TPyType.FromSlots()
      /// in new code.</para>
      /// </summary>
      class function FromMetaclass(metaclass: PPyTypeObject; const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the size of the instance memory space reserved for cls,
      /// i.e. the size of the memory TPyObject.GetTypeData() returns.</para>
      /// <para>This may be larger than requested using -PyType_Spec.basicsize;
      /// it is safe to use this larger size (e.g. with memset()).</para>
      /// <para>The type cls must have been created using negative
      /// PyType_Spec.basicsize. Python does not check this.</para>
      /// <para>On error, set an exception and return a negative value.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function GetTypeDataSize(cls: PPyTypeObject): Py_ssize_t;
      /// <summary>
      /// <para>Find the first superclass in type's method resolution order
      /// whose Py_tp_token tp_token is equal to the given one.</para>
      /// <code>
      /// - If found, set result_ to a new strong reference to it and return 1.
      /// - If not found, set result_ to nil and return 0.
      /// - On error, set result_ to nil and return -1 with an exception set.
      /// </code>
      /// <para>The result_ argument may be nil, in which case result_ is not
      /// set. Use this if you need only the return value.</para>
      /// <para>The tp_token argument may not be nil.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function GetBaseByToken(type_: PPyTypeObject; tp_token: Pointer; var result_: PPyTypeObject): integer;
      /// <summary>
      /// <para>Return true if type1 is a subtype of type2.</para>
      /// <para>This function only checks for actual subtypes, which means that
      /// __subclasscheck__() is not called on type2.
      /// Call TPyObject.IsSubclass() to do the same check that issubclass()
      /// would do.</para>
      /// </summary>
      class function IsSubtype(type1, type2: PPyTypeObject): boolean; overload;
      /// <summary>
      /// <para>Return true if aPyObject is a subtype of type2.</para>
      /// <para>This function only checks for actual subtypes, which means that
      /// __subclasscheck__() is not called on type2.
      /// Call TPyObject.IsSubclass() to do the same check that issubclass()
      /// would do.</para>
      /// </summary>
      class function IsSubtype(const aPyObject: IPyObject; type2: PPyTypeObject): boolean; overload;
      /// <summary>
      /// <para>Return the tp_flags member of type. This function is primarily
      /// meant for use with Py_LIMITED_API; the individual flag bits are
      /// guaranteed to be stable across Python releases, but access to tp_flags
      /// itself is not part of the limited API.</para>
      /// </summary>
      class function GetFlags(aPyTypeObject: PPyTypeObject): C_ULong;
      /// <summary>
      /// <para>Finalize a type object. This should be called on all type
      /// objects to finish their initialization. This function is responsible
      /// for adding inherited slots from a type's base class. Return True on
      /// success, or return False and sets an exception on error.</para>
      /// <para>Note: If some of the base classes implements the GC protocol
      /// and the provided type does not include the Py_TPFLAGS_HAVE_GC in its
      /// flags, then the GC protocol will be automatically implemented from its
      /// parents. On the contrary, if the type being created does include
      /// Py_TPFLAGS_HAVE_GC in its flags then it must implement the GC protocol
      /// itself by at least implementing the tp_traverse handle.</para>
      /// </summary>
      class function Ready(type_: PPyTypeObject): boolean;
      /// <summary>
      /// <para>Generic handler for the tp_alloc slot of a type object. Uses
      /// Python's default memory allocation mechanism to allocate memory for a
      /// new instance, zeros the memory, then initializes the memory as if by
      /// calling TPyObject.Init() or TPyObject.InitVar().</para>
      /// <para>Do not call this directly to allocate memory for an object; call
      /// the type's tp_alloc slot instead.</para>
      /// <para>For types that support garbage collection (i.e., the
      /// Py_TPFLAGS_HAVE_GC flag is set), this function behaves like
      /// TPyObject.GC_New or TPyObject.GC_NewVar (except the memory is
      /// guaranteed to be zeroed before initialization), and should be paired
      /// with TPyObject.GC_Del() in tp_free. Otherwise, it behaves like
      /// TPyObject.New or TPyObject.NewVar (except the memory is guaranteed to
      /// be zeroed before initialization) and should be paired with
      /// TPyObject.Free() in tp_free.</para>
      /// </summary>
      class function GenericAlloc(type_: PPyTypeObject; nitems: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Generic handler for the tp_new slot of a type object. Creates a
      /// new instance using the type's tp_alloc slot and returns the resulting
      /// object.</para>
      /// </summary>
      class function GenericNew(type_: PPyTypeObject; const args, kwds: IPyObject): IPyObject;
      /// <summary>
      /// <para>Clear the internal lookup cache. Return the current version
      /// tag.</para>
      /// </summary>
      class procedure ClearCache;
      /// <summary>
      /// <para>Invalidate the internal lookup cache for the type and all of its
      /// subtypes. This function must be called after any manual modification
      /// of the attributes or base classes of the type.</para>
      /// </summary>
      class procedure Modified(aPyTypeObject: PPyTypeObject);
      /// <summary>
      /// <para>Find the first superclass whose module was created from the
      /// given PyModuleDef def, or whose module token is equal to def, and
      /// return that module.</para>
      /// <para>Note that modules created from a PyModuleDef always have their
      /// token set to the PyModuleDef's address. In other words, this function
      /// is equivalent to TPyType.GetModuleByToken(), except that it:</para>
      /// <code>
      /// - returns a borrowed reference, and
      /// - has a non-void* argument type (which is a cosmetic difference in C).
      /// </code>
      /// <para>The returned reference is borrowed from type, and will be valid
      /// as long as you hold a reference to type. Do not release it with
      /// TPy.DECREF() or similar.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      class function GetModuleByDef(type_: PPyTypeObject; def: PPyModuleDef): IPyObject;
      /// <summary>
      /// <para>Make a type immutable: set the Py_TPFLAGS_IMMUTABLETYPE
      /// flag.</para>
      /// <para>All base classes of type must be immutable.</para>
      /// <para>On success, return True. On error, set an exception and return
      /// False.</para>
      /// <para>The type must not be used before it's made immutable.
      /// For example, type instances must not be created before the type is
      /// made immutable.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function Freeze(type_: PPyTypeObject): boolean;
      /// <summary>
      /// <para>Return the type object's internal namespace, which is otherwise
      /// only exposed via a read-only proxy (cls.__dict__). This is a
      /// replacement for accessing tp_dict directly. The returned dictionary
      /// must be treated as read-only.</para>
      /// <para>This function is meant for specific embedding and
      /// language-binding cases, where direct access to the dict is necessary
      /// and indirect access (e.g. via the proxy or TPyObject.GetAttr()) isn't
      /// adequate.</para>
      /// <para>Extension modules should continue to use tp_dict, directly or
      /// indirectly, when setting up their own types.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function GetDict(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Register callback as a type watcher. Return a non-negative
      /// integer ID which must be passed to future calls to
      /// TPyType.Watch(). In case of error (e.g. no more watcher IDs
      /// available), return -1 and set an exception.</para>
      /// <para>In free-threaded builds, TPyType.AddWatcher() is not
      /// thread-safe, so it must be called at start up (before spawning the
      /// first thread).</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function AddWatcher(callback: PyType_WatchCallback): integer;
      /// <summary>
      /// <para>Clear watcher identified by watcher_id (previously returned from
      /// TPyType.AddWatcher()). Return True on success, False on error
      /// (e.g. if watcher_id was never registered.)</para>
      /// <para>An extension should never call TPyType.ClearWatcher with
      /// a watcher_id that was not returned to it by a previous call to
      /// TPyType.AddWatcher().</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function ClearWatcher(watcher_id: integer): boolean;
      /// <summary>
      /// <para>Mark type as watched. The callback granted watcher_id by
      /// TPyType.AddWatcher() will be called whenever
      /// TPyType.Modified() reports a change to type. (The callback may
      /// be called only once for a series of consecutive modifications to type,
      /// if _PyType_Lookup() is not called on type between the modifications;
      /// this is an implementation detail and subject to change.)</para>
      /// <para>The callback is also invoked when a watched heap type is
      /// deallocated.</para>
      /// <para>An extension should never call TPyType.Watch with a
      /// watcher_id that was not returned to it by a previous call to
      /// TPyType.AddWatcher().</para>
      /// <para>Added in version 3.12.</para>
      /// <para>Changed in version 3.15: The callback is now also invoked when
      /// a watched heap type is deallocated.</para>
      /// </summary>
      class function Watch(watcher_id: integer; const type_: IPyObject): boolean;
      /// <summary>
      /// <para>Mark type as not watched. This undoes a previous call to
      /// TPyType.Watch(). type must not be nil.</para>
      /// <para>An extension should never call this function with a watcher_id
      /// that was not returned to it by a previous call to
      /// TPyType.AddWatcher().</para>
      /// <para>On success, this function returns True. On failure, this function
      /// returns False with an exception set.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function Unwatch(watcher_id: integer; const type_: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if instances of type support creating weak
      /// references, false otherwise. This function always succeeds. type must
      /// not be nil.</para>
      /// <para>See also:</para>
      /// <code>
      /// - Weak Reference Objects
      /// - weakref
      /// </code>
      /// </summary>
      class function SUPPORTS_WEAKREFS(type_: PPyTypeObject): boolean;
      /// <summary>
      /// <para>Return True if the type object o sets the feature feature.
      /// Type features are denoted by single bit flags.</para>
      /// </summary>
      class function HasFeature(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
      /// <summary>
      /// <para>Return True if the type object type sets the subclass flag flag.
      /// Subclass flags are denoted by Py_TPFLAGS_*_SUBCLASS. This function is
      /// used by many _Check functions for common types.</para>
      /// <para>See also TPyObject.TypeCheck(), which is used as a slower
      /// alternative in _Check functions for types that don't come with
      /// subclass flags.</para>
      /// </summary>
      class function FastSubclass(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
      /// <summary>
      /// <para>Return True if aPyObject is a type object, including instances
      /// of types derived from the standard type object. Return False in all
      /// other cases. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return True if aPyObject is a type object, but not a subtype of
      /// the standard type object. Return False in all other cases. This
      /// function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create and return a heap type from a PySlot array. See
      /// Definition slots for general information on slots, and Type slot IDs
      /// for slots specific to type creation.</para>
      /// <para>This function calls TPyType.Ready() on the new type.</para>
      /// <para>Note that this function does not fully match the behavior of
      /// calling type() or using the class statement. With user-provided base
      /// types or metaclasses, prefer calling type (or the metaclass) over
      /// TPyType.From* functions. Specifically:</para>
      /// <code>
      /// - __new__() is not called on the new class (and it must be set to
      ///   type.__new__).
      /// - __init__() is not called on the new class.
      /// - __init_subclass__() is not called on any bases.
      /// - __set_name__() is not called on new descriptors.
      /// </code>
      /// <para>Slots are typically defined as a global static constant arrays.
      /// However, sometimes slot values are not statically known at compile
      /// time. For example, slots like Py_tp_bases, Py_tp_metaclass and
      /// Py_tp_module require live Python objects. In this case, it is
      /// recommended to put such slots on the stack, and use Py_slot_subslots
      /// to refer to an array of static slots. For example:</para>
      /// <code>
      /// static const PySlot my_slots[] = {
      ///    PySlot_STATIC_DATA(Py_tp_name, "MyClass"),
      ///    PySlot_FUNC(Py_tp_repr, my_repr_func),
      ///    ...
      ///    PySlot_END
      /// };
      ///
      /// PyObject *make_my_class(PyObject *module) {
      ///    PySlot all_slots[] = {
      ///       PySlot_STATIC_DATA(Py_slot_subslots, my_slots),
      ///       PySlot_DATA(Py_tp_module, module),
      ///       PySlot_END
      ///    };
      ///    return PyType_FromSlots(all_slots);
      /// }
      /// </code>
      /// </summary>
      class function FromSlots(slots: PPySlot): IPyObject;
      /// <summary>
      /// <para>Find the first superclass whose module has the given module
      /// token, and return that module.</para>
      /// <para>If no module is found, raises a TypeError and returns
      /// nil.</para>
      /// <para>This function is intended to be used together with
      /// TPyModule.GetState() to get module state from slot methods (such as
      /// tp_init or nb_add) and other places where a method's defining class
      /// cannot be passed using the PyCMethod calling convention.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetModuleByToken(type_: PPyTypeObject; const mod_token: Pointer): IPyObject;
      /// <summary>
      /// <para>The following function should only be used in a tp_traverse
      /// handler; calling them in other contexts may have unintended
      /// consequences.</para>
      /// <para>This function act like their counterpart without the _DuringGC
      /// suffix, but it's guaranteed to not have side effects, it doesn't set
      /// an exception on failure, and it returns/sets borrowed references as
      /// detailed in the individual documentation.</para>
      /// <para>Note that this function may fail, but as it doesn't set an
      /// exception, no error information is available. In some cases, failure
      /// is not distinguishable from a successful nil result.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetModuleState_DuringGC(type_: PPyTypeObject): Pointer;
      /// <summary>
      /// <para>The following function should only be used in a tp_traverse
      /// handler; calling them in other contexts may have unintended
      /// consequences.</para>
      /// <para>This function act like their counterpart without the _DuringGC
      /// suffix, but it's guaranteed to not have side effects, it doesn't set
      /// an exception on failure, and it returns/sets borrowed references as
      /// detailed in the individual documentation.</para>
      /// <para>Note that this function may fail, but as it doesn't set an
      /// exception, no error information is available. In some cases, failure
      /// is not distinguishable from a successful nil result.</para>
      /// <para>Sets result_ to a borrowed reference rather than a strong one.
      /// The reference is valid for the duration of the tp_traverse handler
      /// call.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetBaseByToken_DuringGC(type_: PPyTypeObject; token: Pointer; var result_: PPyTypeObject): integer;
      /// <summary>
      /// <para>The following function should only be used in a tp_traverse
      /// handler; calling them in other contexts may have unintended
      /// consequences.</para>
      /// <para>This function act like their counterpart without the _DuringGC
      /// suffix, but it's guaranteed to not have side effects, it doesn't set
      /// an exception on failure, and it returns/sets borrowed references as
      /// detailed in the individual documentation.</para>
      /// <para>Note that this function may fail, but as it doesn't set an
      /// exception, no error information is available. In some cases, failure
      /// is not distinguishable from a successful nil result.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetModule_DuringGC(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>The following function should only be used in a tp_traverse
      /// handler; calling them in other contexts may have unintended
      /// consequences.</para>
      /// <para>This function act like their counterpart without the _DuringGC
      /// suffix, but it's guaranteed to not have side effects, it doesn't set
      /// an exception on failure, and it returns/sets borrowed references as
      /// detailed in the individual documentation.</para>
      /// <para>Note that this function may fail, but as it doesn't set an
      /// exception, no error information is available. In some cases, failure
      /// is not distinguishable from a successful nil result.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function GetModuleByToken_DuringGC(type_: PPyTypeObject; const mod_token: Pointer): IPyObject;
  end;

implementation

class function TPyType.FromSpec(spec: PPyType_Spec): IPyObject;
begin
  if assigned(PyType_FromSpec) then
    Result := TPyObject.Wrap(PyType_FromSpec(spec))
   else
    Result := nil;
end;

class function TPyType.FromSpecWithBases(spec: PPyType_Spec; const bases: IPyObject): IPyObject;
begin
  if assigned(PyType_FromSpecWithBases) and
     TPyObject.IsInitialized(bases) then
    Result := TPyObject.Wrap(PyType_FromSpecWithBases(spec, bases.PyObject))
   else
    Result := nil;
end;

class function TPyType.GetSlot(type_: PPyTypeObject; i: integer): Pointer;
begin
  if assigned(PyType_GetSlot) then
    Result := PyType_GetSlot(type_, i)
   else
    Result := nil;
end;

class function TPyType.FromModuleAndSpec(const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
var
  TempModule, TempBases: Pointer;
begin
  if assigned(PyType_FromModuleAndSpec) then
    begin
      if TPyObject.IsInitialized(module) then
        TempModule := module.PyObject
       else
        TempModule := nil;

      if TPyObject.IsInitialized(bases) then
        TempBases := bases.PyObject
       else
        TempBases := nil;

      Result := TPyObject.Wrap(PyType_FromModuleAndSpec(TempModule, spec, TempBases));
    end
   else
    Result := nil;
end;

class function TPyType.GetModule(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetModule) then
    Result := TPyObject.Wrap(PyType_GetModule(type_), False)
   else
    Result := nil;
end;

class function TPyType.GetModuleState(type_: PPyTypeObject): Pointer;
begin
  if assigned(PyType_GetModuleState) then
    Result := PyType_GetModuleState(type_)
   else
    Result := nil;
end;

class function TPyType.GetName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetName) then
    Result := TPyObject.Wrap(PyType_GetName(type_))
   else
    Result := nil;
end;

class function TPyType.GetQualName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetQualName) then
    Result := TPyObject.Wrap(PyType_GetQualName(type_))
   else
    Result := nil;
end;

class function TPyType.GetFullyQualifiedName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetFullyQualifiedName) then
    Result := TPyObject.Wrap(PyType_GetFullyQualifiedName(type_))
   else
    Result := nil;
end;

class function TPyType.GetModuleName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetModuleName) then
    Result := TPyObject.Wrap(PyType_GetModuleName(type_))
   else
    Result := nil;
end;

class function TPyType.FromMetaclass(metaclass: PPyTypeObject; const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
var
  TempModule, TempBases: Pointer;
begin
  if assigned(PyType_FromMetaclass) then
    begin
      if TPyObject.IsInitialized(module) then
        TempModule := module.PyObject
       else
        TempModule := nil;

      if TPyObject.IsInitialized(bases) then
        TempBases := bases.PyObject
       else
        TempBases := nil;

      Result := TPyObject.Wrap(PyType_FromMetaclass(metaclass, TempModule, spec, TempBases));
    end
   else
    Result := nil;
end;

class function TPyType.GetTypeDataSize(cls: PPyTypeObject): Py_ssize_t;
begin
  if assigned(PyType_GetTypeDataSize) then
    Result := PyType_GetTypeDataSize(cls)
   else
    Result := 0;
end;

class function TPyType.GetBaseByToken(type_: PPyTypeObject; tp_token: Pointer; var result_: PPyTypeObject): integer;
begin
  if assigned(PyType_GetBaseByToken) and
     assigned(tp_token) then
    Result := PyType_GetBaseByToken(type_, tp_token, @result_)
   else
    Result := -1;
end;

class function TPyType.IsSubtype(const aPyObject: IPyObject; type2: PPyTypeObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            IsSubType(aPyObject.PyTypeObject, type2);
end;

class function TPyType.IsSubtype(type1, type2: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_IsSubtype) and
            assigned(type1) and
            assigned(type2) and
            (PyType_IsSubtype(type1, type2) <> 0);
end;

class function TPyType.GetFlags(aPyTypeObject: PPyTypeObject): C_ULong;
begin
  if assigned(PyType_GetFlags) and
     assigned(aPyTypeObject) then
    Result := PyType_GetFlags(aPyTypeObject)
   else
    Result := 0;
end;

class function TPyType.Ready(type_: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_Ready) and
            (PyType_Ready(type_) = 0);
end;

class function TPyType.GenericAlloc(type_: PPyTypeObject; nitems: Py_ssize_t): IPyObject;
begin
  if assigned(PyType_GenericAlloc) then
    Result := TPyObject.Wrap(PyType_GenericAlloc(type_, nitems))
   else
    Result := nil;
end;

class function TPyType.GenericNew(type_: PPyTypeObject; const args, kwds: IPyObject): IPyObject;
begin
  if assigned(PyType_GenericNew) and
     TPyObject.IsInitialized(args) and
     TPyObject.IsInitialized(kwds) then
    Result := TPyObject.Wrap(PyType_GenericNew(type_, args.PyObject, kwds.PyObject))
   else
    Result := nil;
end;

class procedure TPyType.ClearCache;
begin
  if assigned(PyType_ClearCache) then
    PyType_ClearCache();
end;

class procedure TPyType.Modified(aPyTypeObject: PPyTypeObject);
begin
  if assigned(PyType_Modified) and assigned(aPyTypeObject) then
    PyType_Modified(aPyTypeObject);
end;

class function TPyType.GetModuleByDef(type_: PPyTypeObject; def: PPyModuleDef): IPyObject;
begin
  if assigned(PyType_GetModuleByDef) then
    Result := TPyObject.Wrap(PyType_GetModuleByDef(type_, def), False)
   else
    Result := nil;
end;

class function TPyType.Freeze(type_: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_Freeze) and
            (PyType_Freeze(type_) = 0);
end;

class function TPyType.GetDict(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetDict) then
    Result := TPyObject.Wrap(PyType_GetDict(type_))
   else
    Result := nil;
end;

class function TPyType.AddWatcher(callback: PyType_WatchCallback): integer;
begin
  if assigned(PyType_AddWatcher) then
    Result := PyType_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyType.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyType_ClearWatcher) and
            (PyType_ClearWatcher(watcher_id) = 0);
end;

class function TPyType.Watch(watcher_id: integer; const type_: IPyObject): boolean;
begin
  Result := assigned(PyType_Watch) and
            TPyObject.IsInitialized(type_) and
            (PyType_Watch(watcher_id, type_.PyObject) <> 0);
end;

class function TPyType.Unwatch(watcher_id: integer; const type_: IPyObject): boolean;
begin
  Result := assigned(PyType_Unwatch) and
            TPyObject.IsInitialized(type_) and
            (PyType_Unwatch(watcher_id, type_.PyObject) <> 0);
end;

class function TPyType.SUPPORTS_WEAKREFS(type_: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_SUPPORTS_WEAKREFS) and
            assigned(type_) and
            (PyType_SUPPORTS_WEAKREFS(type_) <> 0);
end;

class function TPyType.HasFeature(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
begin
  Result := assigned(aPyTypeObject) and ((GetFlags(aPyTypeObject) and feature) <> 0);
end;

class function TPyType.FastSubclass(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
begin
  Result := assigned(aPyTypeObject) and HasFeature(aPyTypeObject, feature);
end;

class function TPyType.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_TYPE_SUBCLASS));
end;

class function TPyType.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and aPyObject.IsType(PyType_Type);
end;

class function TPyType.FromSlots(slots: PPySlot): IPyObject;
begin
  if assigned(PyType_FromSlots) and assigned(slots) then
    Result := TPyObject.Wrap(PyType_FromSlots(slots))
   else
    Result := nil;
end;

class function TPyType.GetModuleByToken(type_: PPyTypeObject; const mod_token: Pointer): IPyObject;
begin
  if assigned(PyType_GetModuleByToken) and
     assigned(type_) and
     assigned(mod_token) then
    Result := TPyObject.Wrap(PyType_GetModuleByToken(type_, mod_token))
   else
    Result := nil;
end;

class function TPyType.GetModuleState_DuringGC(type_: PPyTypeObject): Pointer;
begin
  if assigned(PyType_GetModuleState_DuringGC) then
    Result := PyType_GetModuleState_DuringGC(type_)
   else
    Result := nil;
end;

class function TPyType.GetBaseByToken_DuringGC(type_: PPyTypeObject; token: Pointer; var result_: PPyTypeObject): integer;
begin
  if assigned(PyType_GetBaseByToken_DuringGC) then
    Result := PyType_GetBaseByToken_DuringGC(type_, token, @result_)
   else
    Result := -1;
end;

class function TPyType.GetModule_DuringGC(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetModule_DuringGC) then
    Result := TPyObject.Wrap(PyType_GetModule_DuringGC(type_), False)
   else
    Result := nil;
end;

class function TPyType.GetModuleByToken_DuringGC(type_: PPyTypeObject; const mod_token: Pointer): IPyObject;
begin
  if assigned(PyType_GetModuleByToken_DuringGC) and
     assigned(type_) and
     assigned(mod_token) then
    Result := TPyObject.Wrap(PyType_GetModuleByToken_DuringGC(type_, mod_token))
   else
    Result := nil;
end;

end.
