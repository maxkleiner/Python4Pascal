unit uP4P.PyDescr;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyDescr_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/descriptor.html#descriptor-objects">See the article about the Descriptor Objects.</see></para>
  /// </remarks>
  TPyDescr = class
    public
      /// <summary>
      /// <para>Create a new method descriptor for extension type type from the
      /// PyMethodDef structure meth.</para>
      /// <para>Method descriptors expose functions as methods on a type.
      /// This is the same kind of descriptor created for entries in tp_methods,
      /// and it appears in Python as a types.MethodDescriptorType
      /// object.</para>
      /// <para>On success, return a strong reference to the descriptor.
      /// Return nil with an exception set on failure.</para>
      /// </summary>
      class function NewMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
      /// <summary>
      /// <para>Create a new class method descriptor for extension type type
      /// from the PyMethodDef structure method.</para>
      /// <para>Class method descriptors expose methods that receive the
      /// class rather than an instance when accessed. This is the same kind
      /// of descriptor created for METH_CLASS entries in tp_methods, and it
      /// appears in Python as a types.ClassMethodDescriptorType object.</para>
      /// <para>On success, return a strong reference to the descriptor.
      /// Return nil with an exception set on failure.</para>
      /// </summary>
      class function NewClassMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
      /// <summary>
      /// <para>Create a new member descriptor for extension type type from the
      /// PyMemberDef structure member.</para>
      /// <para>Member descriptors expose fields in the type's record as Python
      /// attributes. This is the same kind of descriptor created for entries
      /// in tp_members, and it appears in Python as a
      /// types.MemberDescriptorType object.</para>
      /// <para>On success, return a strong reference to the descriptor.
      /// Return nil with an exception set on failure.</para>
      /// </summary>
      class function NewMember(type_: PPyTypeObject; meth: PPyMemberDef): IPyObject;
      /// <summary>
      /// <para>Create a new get-set descriptor for extension type type from
      /// the PyGetSetDef structure getset.</para>
      /// <para>Get-set descriptors expose attributes implemented by getter
      /// and setter functions rather than stored directly in the instance.
      /// This is the same kind of descriptor created for entries in tp_getset,
      /// and it appears in Python as a types.GetSetDescriptorType object.</para>
      /// <para>On success, return a strong reference to the descriptor.
      /// Return nil with an exception set on failure.</para>
      /// </summary>
      class function NewGetSet(type_: PPyTypeObject; getset: PPyGetSetDef): IPyObject;
      /// <summary>
      /// <para>Create a new wrapper descriptor for extension type type from
      /// the wrapperbase structure base and the wrapped slot function pointer
      /// wrapped.</para>
      /// <para>Wrapper descriptors expose special methods implemented by type
      /// slots. This is the same kind of descriptor that CPython creates for
      /// slot-based special methods such as __repr__ or __add__, and it
      /// appears in Python as a types.WrapperDescriptorType object.</para>
      /// <para>On success, return a strong reference to the descriptor.
      /// Return nil with an exception set on failure.</para>
      /// </summary>
      class function NewWrapper(type_: PPyTypeObject; const wrapper: wrapperbase; wrapped: Pointer): IPyObject;
      /// <summary>
      /// <para>Return True if the descriptor object descr describes a data
      /// attribute, or False if it describes a method. descr must be a
      /// descriptor object; there is no error checking.</para>
      /// </summary>
      class function IsData(const descr: IPyObject): boolean;
  end;

implementation

class function TPyDescr.NewMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
begin
  if assigned(PyDescr_NewMethod) then
    Result := TPyObject.Wrap(PyDescr_NewMethod(type_, meth))
   else
    Result := nil;
end;

class function TPyDescr.NewClassMethod(type_: PPyTypeObject; meth: PPyMethodDef): IPyObject;
begin
  if assigned(PyDescr_NewClassMethod) then
    Result := TPyObject.Wrap(PyDescr_NewClassMethod(type_, meth))
   else
    Result := nil;
end;

class function TPyDescr.NewMember(type_: PPyTypeObject; meth: PPyMemberDef): IPyObject;
begin
  if assigned(PyDescr_NewMember) then
    Result := TPyObject.Wrap(PyDescr_NewMember(type_, meth))
   else
    Result := nil;
end;

class function TPyDescr.NewGetSet(type_: PPyTypeObject; getset: PPyGetSetDef): IPyObject;
begin
  if assigned(PyDescr_NewGetSet) then
    Result := TPyObject.Wrap(PyDescr_NewGetSet(type_, getset))
   else
    Result := nil;
end;

class function TPyDescr.NewWrapper(type_: PPyTypeObject; const wrapper: wrapperbase; wrapped: Pointer): IPyObject;
begin
  if assigned(PyDescr_NewWrapper) then
    Result := TPyObject.Wrap(PyDescr_NewWrapper(type_, @wrapper, wrapped))
   else
    Result := nil;
end;

class function TPyDescr.IsData(const descr: IPyObject): boolean;
begin
  Result := assigned(PyDescr_IsData) and
            TPyObject.IsInitialized(descr) and
            (PyDescr_IsData(descr.PyObject) <> 0);
end;


end.
