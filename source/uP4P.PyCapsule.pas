unit uP4P.PyCapsule;

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
  /// Helper class for all PyCapsule_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/capsule.html#capsules">See the article about Capsules.</see></para>
  /// </remarks>
  TPyCapsule = class
    public
      /// <summary>
      /// <para>Return true if its argument is a PyCapsule. This function always
      /// succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create a PyCapsule encapsulating the pointer. The pointer_
      /// argument may not be nil.</para>
      /// <para>On failure, set an exception and return nil.</para>
      /// <para>The name_ string may either be nil or a pointer to a valid
      /// C string. If non-nil, this string must outlive the capsule.
      /// (Though it is permitted to free it inside the destructor.)</para>
      /// <para>If the destructor_ argument is not nil, it will be called with
      /// the capsule as its argument when it is destroyed.</para>
      /// <para>If this capsule will be stored as an attribute of a module, the
      /// name should be specified as modulename.attributename. This will enable
      /// other modules to import the capsule using TPyCapsule.Import().</para>
      /// </summary>
      class function New(pointer_: Pointer; const name_: PAnsiChar; destructor_: PyCapsule_Destructor): IPyObject;
      /// <summary>
      /// <para>Retrieve the pointer stored in the capsule. On failure, set an
      /// exception and return nil.</para>
      /// <para>The name parameter must compare exactly to the name stored in
      /// the capsule. If the name stored in the capsule is nil, the name
      /// passed in must also be nil. Python uses the C function strcmp() to
      /// compare capsule names.</para>
      /// </summary>
      class function GetPointer(const capsule: IPyObject; const name_: string): Pointer;
      /// <summary>
      /// <para>Return the current destructor stored in the capsule. On failure,
      /// set an exception and return nil.</para>
      /// <para>It is legal for a capsule to have a nil destructor. This makes
      /// a nil return code somewhat ambiguous; use TPyCapsule.IsValid() or
      /// TPyErr.Occurred() to disambiguate.</para>
      /// </summary>
      class function GetDestructor(const capsule: IPyObject): PyCapsule_Destructor;
      /// <summary>
      /// <para>Return the current name stored in the capsule. On failure, set
      /// an exception and return nil.</para>
      /// <para>It is legal for a capsule to have a nil name. This makes a nil
      /// return code somewhat ambiguous; use TPyCapsule.IsValid() or
      /// TPyErr.Occurred() to disambiguate.</para>
      /// </summary>
      class function GetName(const capsule: IPyObject): string;
      /// <summary>
      /// <para>Return the current context stored in the capsule. On failure,
      /// set an exception and return nil.</para>
      /// <para>It is legal for a capsule to have a nil context. This makes a
      /// nil return code somewhat ambiguous; use TPyCapsule.IsValid() or
      /// TPyErr.Occurred() to disambiguate.</para>
      /// </summary>
      class function GetContext(const capsule: IPyObject): Pointer;
      /// <summary>
      /// <para>Determines whether or not capsule is a valid capsule. A valid
      /// capsule is non-nil, passes TPyCapsule.CheckExact(), has a non-nil
      /// pointer stored in it, and its internal name matches the name
      /// parameter. (See TPyCapsule.GetPointer() for information on how capsule
      /// names are compared.)</para>
      /// <para>In other words, if TPyCapsule.IsValid() returns a true value,
      /// calls to any of the accessors (any function starting with
      /// TPyCapsule.Get) are guaranteed to succeed.</para>
      /// <para>Return True if the object is valid and matches the
      /// name passed in. Return False otherwise. This function will not
      /// fail.</para>
      /// </summary>
      class function IsValid(const capsule: IPyObject; const name_: string): boolean;
      /// <summary>
      /// <para>Set the void pointer inside capsule to pointer. The pointer may
      /// not be nil.</para>
      /// <para>Return True on success. Return False and set an exception on
      /// failure.</para>
      /// </summary>
      class function SetPointer(const capsule: IPyObject; pointer_: Pointer): boolean;
      /// <summary>
      /// <para>Set the destructor inside capsule to destructor.</para>
      /// <para>Return True on success. Return False and set an exception on
      /// failure.</para>
      /// </summary>
      class function SetDestructor(const capsule: IPyObject; destructor_: PyCapsule_Destructor): boolean;
      /// <summary>
      /// <para>Set the name inside capsule to name. If non-nil, the name must
      /// outlive the capsule. If the previous name stored in the capsule was
      /// not nil, no attempt is made to free it.</para>
      /// <para>Return True on success. Return False and set an exception on
      /// failure.</para>
      /// </summary>
      class function SetName(const capsule: IPyObject; const name_: PAnsiChar): boolean;
      /// <summary>
      /// <para>Set the context pointer inside capsule to context.</para>
      /// <para>Return True on success. Return False and set an exception on
      /// failure.</para>
      /// </summary>
      class function SetContext(const capsule: IPyObject; context: Pointer): boolean;
      /// <summary>
      /// <para>Import a pointer to a C object from a capsule attribute in a
      /// module. The name parameter should specify the full name to the
      /// attribute, as in module.attribute. The name stored in the capsule must
      /// match this string exactly.</para>
      /// <para>This function splits name on the . character, and imports the
      /// first element. It then processes further elements using attribute
      /// lookups.</para>
      /// <para>Return the capsule's internal pointer on success. On failure,
      /// set an exception and return nil.</para>
      /// <para>Note: If name points to an attribute of some submodule or
      /// subpackage, this submodule or subpackage must be previously imported
      /// using other means (for example, by using TPyImport.ImportModule())
      /// for the attribute lookups to succeed.</para>
      /// </summary>
      class function Import(const name_: string): Pointer;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCapsule.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCapsule_Type);
end;

class function TPyCapsule.New(pointer_: Pointer; const name_: PAnsiChar; destructor_: PyCapsule_Destructor): IPyObject;
begin
  if assigned(PyCapsule_New) and assigned(pointer_) then
    Result := TPyObject.Wrap(PyCapsule_New(pointer_, name_, destructor_))
   else
    Result := nil;
end;

class function TPyCapsule.GetPointer(const capsule: IPyObject; const name_: string): Pointer;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_GetPointer) and
     TPyObject.IsInitialized(capsule) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := PyCapsule_GetPointer(capsule.PyObject, TempNamePtr);
    end
   else
    Result := nil;
end;

class function TPyCapsule.GetDestructor(const capsule: IPyObject): PyCapsule_Destructor;
begin
  if assigned(PyCapsule_GetDestructor) and
     TPyObject.IsInitialized(capsule) then
    Result := PyCapsule_GetDestructor(capsule.PyObject)
   else
    Result := nil;
end;

class function TPyCapsule.GetName(const capsule: IPyObject): string;
begin
  if assigned(PyCapsule_GetName) and
     TPyObject.IsInitialized(capsule) then
    Result := PyUTF8ToString(PyCapsule_GetName(capsule.PyObject))
   else
    Result := '';
end;

class function TPyCapsule.GetContext(const capsule: IPyObject): Pointer;
begin
  if assigned(PyCapsule_GetContext) and
     TPyObject.IsInitialized(capsule) then
    Result := PyCapsule_GetContext(capsule.PyObject)
   else
    Result := nil;
end;

class function TPyCapsule.IsValid(const capsule: IPyObject; const name_: string): boolean;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_IsValid) and
     TPyObject.IsInitialized(capsule) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := (PyCapsule_IsValid(capsule.PyObject, TempNamePtr) <> 0);
    end
   else
    Result := False;
end;

class function TPyCapsule.SetPointer(const capsule: IPyObject; pointer_: Pointer): boolean;
begin
  Result := assigned(PyCapsule_SetPointer) and
            TPyObject.IsInitialized(capsule) and
            assigned(pointer_) and
            (PyCapsule_SetPointer(capsule.PyObject, pointer_) = 0);
end;

class function TPyCapsule.SetDestructor(const capsule: IPyObject; destructor_: PyCapsule_Destructor): boolean;
begin
  Result := assigned(PyCapsule_SetDestructor) and
            TPyObject.IsInitialized(capsule) and
            (PyCapsule_SetDestructor(capsule.PyObject, destructor_) = 0);
end;

class function TPyCapsule.SetName(const capsule: IPyObject; const name_: PAnsiChar): boolean;
begin
  if assigned(PyCapsule_SetName) and
     TPyObject.IsInitialized(capsule) then
    Result := (PyCapsule_SetName(capsule.PyObject, name_) = 0)
   else
    Result := False;
end;

class function TPyCapsule.SetContext(const capsule: IPyObject; context: Pointer): boolean;
begin
  Result := assigned(PyCapsule_SetContext) and
            TPyObject.IsInitialized(capsule) and
            (PyCapsule_SetContext(capsule.PyObject, context) = 0);
end;

class function TPyCapsule.Import(const name_: string): Pointer;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_Import) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      // Changed in version 3.3: no_block has no effect anymore.
      Result := PyCapsule_Import(TempNamePtr, 0);
    end
   else
    Result := nil;
end;

end.
