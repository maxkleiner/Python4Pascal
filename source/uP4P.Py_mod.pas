unit uP4P.Py_mod;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

type
  /// <summary>
  /// Helper class to get the correct values of Py_mod_* constants that
  /// changed in recent Python versions.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/module.html#module-objects">See the article about Module Objects.</see></para>
  /// </remarks>
  TPy_mod = class
    public
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_create</para>
      /// <para>Specifies a function that is called to create the module object
      /// itself. The value pointer of this slot must point to a function of the
      /// signature:</para>
      /// <code>PyObject *create_module(PyObject *spec, PyModuleDef *def)</code>
      /// <para>The function receives a ModuleSpec instance, as defined in PEP 451,
      /// and the module definition. It should return a new module object, or set
      /// an error and return nil.</para>
      /// <para>This function should be kept minimal. In particular, it should not
      /// call arbitrary Python code, as trying to import the same module again may
      /// result in an infinite loop.</para>
      /// <para>Multiple Py_mod_create slots may not be specified in one module
      /// definition.</para>
      /// <para>If Py_mod_create is not specified, the import machinery will create
      /// a normal module object using TPyModule.New(). The name is taken from spec,
      /// not the definition, to allow extension modules to dynamically adjust to
      /// their place in the module hierarchy and be imported under different names
      /// through symlinks, all while sharing a single module definition.</para>
      /// <para>There is no requirement for the returned object to be an instance
      /// of PyModule_Type. Any type can be used, as long as it supports setting
      /// and getting import-related attributes. However, only PyModule_Type
      /// instances may be returned if the PyModuleDef has non-nil m_traverse,
      /// m_clear, m_free; non-zero m_size; or slots other than Py_mod_create.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_create">See the article about Py_mod_create.</see></para>
      /// </remarks>
      class function create: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_exec</para>
      /// <para>Specifies a function that is called to execute the module. This is
      /// equivalent to executing the code of a Python module: typically, this
      /// function adds classes and constants to the module. The signature of the
      /// function is:</para>
      /// <code>int exec_module(PyObject *module)</code>
      /// <para>If multiple Py_mod_exec slots are specified, they are processed in
      /// the order they appear in the m_slots array.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_exec">See the article about Py_mod_exec.</see></para>
      /// </remarks>
      class function exec: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_multiple_interpreters</para>
      /// <para>Specifies one of the following values:</para>
      /// <para>Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED: The module does not
      /// support being imported in subinterpreters.</para>
      /// <para>Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED: The module supports being
      /// imported in subinterpreters, but only when they share the main
      /// interpreter's GIL. (See Isolating Extension Modules.)</para>
      /// <para>Py_MOD_PER_INTERPRETER_GIL_SUPPORTED: The module supports being
      /// imported in subinterpreters, even when they have their own GIL. (See
      /// Isolating Extension Modules.)</para>
      /// <para>This slot determines whether or not importing this module in a
      /// subinterpreter will fail.</para>
      /// <para>Multiple Py_mod_multiple_interpreters slots may not be specified in
      /// one module definition.</para>
      /// <para>If Py_mod_multiple_interpreters is not specified, the import
      /// machinery defaults to Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_multiple_interpreters">See the article about Py_mod_multiple_interpreters.</see></para>
      /// </remarks>
      class function multiple_interpreters: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_gil</para>
      /// <para>Specifies one of the following values:</para>
      /// <para>Py_MOD_GIL_USED: The module depends on the presence of the global
      /// interpreter lock (GIL), and may access global state without
      /// synchronization.</para>
      /// <para>Py_MOD_GIL_NOT_USED: The module is safe to run without an active
      /// GIL.</para>
      /// <para>This slot is ignored by Python builds not configured with
      /// --disable-gil. Otherwise, it determines whether or not importing this
      /// module will cause the GIL to be automatically enabled. See Free-threaded
      /// CPython for more detail.</para>
      /// <para>Multiple Py_mod_gil slots may not be specified in one module
      /// definition.</para>
      /// <para>If Py_mod_gil is not specified, the import machinery defaults to
      /// Py_MOD_GIL_USED.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_gil">See the article about Py_mod_gil.</see></para>
      /// </remarks>
      class function gil: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_slots</para>
      /// <para>Slot ID that works like Py_slot_subslots, except it specifies
      /// an array of PyModuleDef_Slot structures.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_slots">See the article about Py_mod_slots.</see></para>
      /// </remarks>
      class function slots: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_name</para>
      /// <para>Slot ID for the name of the new module, as a NUL-terminated
      /// UTF8-encoded const char *.</para>
      /// <para>Note that modules are typically created using a ModuleSpec,
      /// and when they are, the name from the spec will be used instead of
      /// Py_mod_name. However, it is still recommended to include this slot
      /// for introspection and debugging purposes.</para>
      /// <para>Added in version 3.15: Use PyModuleDef.m_name instead to
      /// support previous versions.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_name">See the article about Py_mod_name.</see></para>
      /// </remarks>
      class function name: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_doc</para>
      /// <para>Slot ID for the docstring of the new module, as a NUL-terminated
      /// UTF8-encoded const char *.</para>
      /// <para>Usually it is set to a variable created with
      /// PyDoc_STRVAR.</para>
      /// <para>Added in version 3.15: Use PyModuleDef.m_doc instead to support
      /// previous versions.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_doc">See the article about Py_mod_doc.</see></para>
      /// </remarks>
      class function doc: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_state_size</para>
      /// <para>Slot ID for the size of the module state, in bytes.</para>
      /// <para>Setting the value to a non-negative value means that the module
      /// can be re-initialized and specifies the additional amount of memory it
      /// requires for its state.</para>
      /// <para>See PEP 3121 for more details.</para>
      /// <para>Use TPyModule.GetStateSize() to retrieve the size of a given
      /// module.</para>
      /// <para>Added in version 3.15: Use PyModuleDef.m_size instead to support
      /// previous versions.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_state_size">See the article about Py_mod_state_size.</see></para>
      /// </remarks>
      class function state_size: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_methods</para>
      /// <para></para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_methods">See the article about Py_mod_methods.</see></para>
      /// </remarks>
      class function methods: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_state_traverse</para>
      /// <para>Slot ID for a traversal function to call during GC traversal of
      /// the module object.</para>
      /// <para>The signature of the function, and meanings of the arguments,
      /// is similar as for PyTypeObject.tp_traverse:</para>
      /// <code>int traverse_module_state(PyObject *module, visitproc visit, void *arg)</code>
      /// <para>This function is not called if the module state was requested
      /// but is not allocated yet. This is the case immediately after the
      /// module is created and before the module is executed
      /// (Py_mod_exec function). More precisely, this function is not called
      /// if the state size (Py_mod_state_size) is greater than 0 and the
      /// module state (as returned by TPyModule.GetState()) is nil.</para>
      /// <para>Added in version 3.15: Use PyModuleDef.m_traverse instead to
      /// support previous versions.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_state_traverse">See the article about Py_mod_state_traverse.</see></para>
      /// </remarks>
      class function state_traverse: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_state_clear</para>
      /// <para>Slot ID for a clear function to call during GC clearing of the
      /// module object.</para>
      /// <para>The signature of the function is:</para>
      /// <code>int clear_module_state(PyObject *module)</code>
      /// <para>This function is not called if the module state was requested
      /// but is not allocated yet. This is the case immediately after the
      /// module is created and before the module is executed
      /// (Py_mod_exec function). More precisely, this function is not called
      /// if the state size (Py_mod_state_size) is greater than 0 and the
      /// module state (as returned by TPyModule.GetState()) is nil.</para>
      /// <para>Like PyTypeObject.tp_clear, this function is not always called
      /// before a module is deallocated. For example, when reference counting
      /// is enough to determine that an object is no longer used, the cyclic
      /// garbage collector is not involved and the Py_mod_state_free function
      /// is called directly.</para>
      /// <para>Added in version 3.15: Use PyModuleDef.m_clear instead to
      /// support previous versions.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_state_clear">See the article about Py_mod_state_clear.</see></para>
      /// </remarks>
      class function state_clear: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_state_free</para>
      /// <para>Slot ID for a function to call during deallocation of the module
      /// object.</para>
      /// <para>The signature of the function is:</para>
      /// <code>int free_module_state(PyObject *module)</code>
      /// <para>This function is not called if the module state was requested
      /// but is not allocated yet. This is the case immediately after the
      /// module is created and before the module is executed
      /// (Py_mod_exec function). More precisely, this function is not called
      /// if the state size (Py_mod_state_size) is greater than 0 and the
      /// module state (as returned by TPyModule.GetState()) is nil.</para>
      /// <para>Added in version 3.15: Use PyModuleDef.m_free instead to
      /// support previous versions.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_state_free">See the article about Py_mod_state_free.</see></para>
      /// </remarks>
      class function state_free: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_abi</para>
      /// <para>Slot ID whose value points to a PyABIInfo structure describing
      /// the ABI that the extension is using.</para>
      /// <para>A suitable PyABIInfo variable can be defined using the
      /// PyABIInfo_VAR macro, as in:</para>
      /// <code>
      /// PyABIInfo_VAR(abi_info);
      ///
      /// static PySlot mymodule_slots[] = {
      ///    PySlot_DATA(Py_mod_abi, &abi_info),
      ///    ...
      /// };
      /// </code>
      /// <para>When creating a module, Python checks the value of this slot
      /// using TPyABIInfo.Check().</para>
      /// <para>This slot is required, except for modules created from
      /// PyModuleDef.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_abi">See the article about Py_mod_abi.</see></para>
      /// </remarks>
      class function abi: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mod_token</para>
      /// <para>Slot ID for the module token.</para>
      /// <para>If you use this slot to set the module token (rather than rely
      /// on the default), you must ensure that:</para>
      /// <code>
      /// - The pointer outlives the class, so it's not reused for something
      ///   else while the class exists.
      /// - It "belongs" to the extension module where the class lives, so it
      ///   will not clash with other extensions.
      /// - If the token points to a PyModuleDef struct, the module should
      ///   behave as if it was created from that PyModuleDef. In particular,
      ///   the module state must have matching layout and semantics.
      /// </code>
      /// <para>Modules created from PyModuleDef always use the address of the
      /// PyModuleDef as the token. This means that Py_mod_token cannot be used
      /// in PyModuleDef.m_slots.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_token">See the article about Py_mod_token.</see></para>
      /// </remarks>
      class function token: integer;
  end;

implementation

uses
  uP4P.Engine;

class function TPy_mod.create: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 84
   else
    Result := 1;
end;

class function TPy_mod.exec: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 85
   else
    Result := 2;
end;

class function TPy_mod.multiple_interpreters: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 86
   else
    Result := 3;
end;

class function TPy_mod.gil: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 87
   else
    Result := 4;
end;

class function TPy_mod.slots: integer;
begin
  Result := 94;
end;

class function TPy_mod.name: integer;
begin
  Result := 100;
end;

class function TPy_mod.doc: integer;
begin
  Result := 101;
end;

class function TPy_mod.state_size: integer;
begin
  Result := 102;
end;

class function TPy_mod.methods: integer;
begin
  Result := 103;
end;

class function TPy_mod.state_traverse: integer;
begin
  Result := 104;
end;

class function TPy_mod.state_clear: integer;
begin
  Result := 105;
end;

class function TPy_mod.state_free: integer;
begin
  Result := 106;
end;

class function TPy_mod.abi: integer;
begin
  Result := 109;
end;

class function TPy_mod.token: integer;
begin
  Result := 110;
end;

end.
