unit uP4P.PyStructSequence;

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
  /// Helper class for all PyStructSequence_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/tuple.html#struct-sequence-objects">See the article about Struct Sequence Objects.</see></para>
  /// </remarks>
  TPyStructSequence = class
    public
      /// <summary>
      /// <para>Initializes a struct sequence type type_ from desc in
      /// place.</para>
      /// </summary>
      class procedure InitType(type_: PPyTypeObject; desc: PPyStructSequence_Desc);
      /// <summary>
      /// <para>Like TPyStructSequence.InitType(), but returns True on success
      /// and False with an exception set on failure.</para>
      /// </summary>
      class function InitType2(type_: PPyTypeObject; desc: PPyStructSequence_Desc): boolean;
      /// <summary>
      /// <para>Create a new struct sequence type from the data in desc,
      /// described below. Instances of the resulting type can be created with
      /// TPyStructSequence.New().</para>
      /// <para>Return nil with an exception set on failure.</para>
      /// </summary>
      class function NewType(desc: PPyStructSequence_Desc): PPyTypeObject;
      /// <summary>
      /// <para>Creates an instance of type_, which must have been created with
      /// TPyStructSequence.NewType().</para>
      /// <para>Return nil with an exception set on failure.</para>
      /// </summary>
      class function New(type_: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Sets the field at index pos of the struct sequence p to value o.
      /// This should only be used to fill in brand new instances.</para>
      /// <para>Bounds checking is performed as an assertion if Python is built
      /// in debug mode or with assertions.</para>
      /// <para>Note This function "steals" a reference to o.</para>
      /// </summary>
      class procedure SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject);
      /// <summary>
      /// <para>Return the object at position pos in the struct sequence pointed
      /// to by p.</para>
      /// <para>Bounds checking is performed as an assertion if Python is built
      /// in debug mode or with assertions.</para>
      /// </summary>
      class function GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
  end;

implementation

class procedure TPyStructSequence.InitType(type_: PPyTypeObject; desc: PPyStructSequence_Desc);
begin
  if assigned(PyStructSequence_InitType) then
    PyStructSequence_InitType(type_, desc);
end;

class function TPyStructSequence.InitType2(type_: PPyTypeObject; desc: PPyStructSequence_Desc): boolean;
begin
  Result := assigned(PyStructSequence_InitType2) and
            (PyStructSequence_InitType2(type_, desc) = 0);
end;

class function TPyStructSequence.NewType(desc: PPyStructSequence_Desc): PPyTypeObject;
begin
  if assigned(PyStructSequence_NewType) then
    Result := PyStructSequence_NewType(desc)
   else
    Result := nil;
end;

class function TPyStructSequence.New(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyStructSequence_New) then
    Result := TPyObject.Wrap(PyStructSequence_New(type_))
   else
    Result := nil;
end;

class procedure TPyStructSequence.SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject);
begin
  if assigned(PyStructSequence_SetItem) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(o) then
    PyStructSequence_SetItem(p.PyObject, pos, o.Unwrap);
end;

class function TPyStructSequence.GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
begin
  if assigned(PyStructSequence_GetItem) and
     TPyObject.IsInitialized(p) then
    TPyObject.Wrap(PyStructSequence_GetItem(p.PyObject, pos), False);
end;

end.
