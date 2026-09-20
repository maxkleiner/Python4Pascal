unit uP4P.PySlot;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>Helper for all the PySlot_* convenience macros.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/slots.html#convenience-macros">See the article about the Convenience macros.</see></para>
  /// <para><see href="https://docs.python.org/3.15/c-api/slots.html#definition-slots">See the article about Definition slots.</see></para>
  /// <para><see href="https://peps.python.org/pep-0820/">See the article for PEP 820.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPySlot = class
    protected
      FPySlot       : PySlot;
      FStringValue  : AnsiString;

      function GetID : word;
      function GetFlags : word;
      function GetIsEnd : boolean;
      function GetIsMethods : boolean;

      procedure SetID(aValue: word);
      procedure SetFlags(aValue: word);

    public
      constructor Create;
      procedure   Set_DATA(name_: word; value_: Pointer);
      procedure   Set_FUNC(name_: word; value_: _Py_funcptr_t);
      procedure   Set_SIZE(name_: word; value_: Py_ssize_t);
      procedure   Set_INT64(name_: word; value_: int64);
      procedure   Set_UINT64(name_: word; value_: uint64);
      procedure   Set_STATIC_DATA(name_: word; value_: Pointer);
      procedure   Set_PTR(name_: word; value_: Pointer);
      procedure   Set_PTR_STATIC(name_: word; value_: Pointer);
      procedure   Set_END;
      procedure   Set_STRING(name_: word; const value_: string);
      procedure   Set_STATIC_STRING(name_: word; const value_: string);

      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_ptr. It also sets the PySlot_INTPTR flag.</para>
      /// </summary>
      class function DATA(name_: word; value_: Pointer): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_func.</para>
      /// </summary>
      class function FUNC(name_: word; value_: _Py_funcptr_t): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_size.</para>
      /// </summary>
      class function SIZE(name_: word; value_: Py_ssize_t): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_int64.</para>
      /// </summary>
      class function INT64_(name_: word; value_: int64): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_uint64.</para>
      /// </summary>
      class function UINT64_(name_: word; value_: uint64): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_ptr. It also sets the PySlot_STATIC flag.</para>
      /// </summary>
      class function STATIC_DATA(name_: word; value_: Pointer): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_ptr. It also sets the PySlot_INTPTR flag.</para>
      /// </summary>
      class function PTR(name_: word; value_: Pointer): PySlot;
      /// <summary>
      /// <para>Convenience function to define a PySlot structure with sl_id and
      /// sl_ptr. It also sets the PySlot_INTPTR and PySlot_STATIC flags.</para>
      /// </summary>
      class function PTR_STATIC(name_: word; value_: Pointer): PySlot;
      /// <summary>
      /// <para>Convenience function to mark the end of a PySlot array.</para>
      /// </summary>
      class function END_: PySlot;

      /// <summary>
      /// Returns the PySlot record.
      /// </summary>
      property Slot      : PySlot    read FPySlot;
      /// <summary>
      /// Returns the sl_id value.
      /// </summary>
      property ID        : word      read GetID          write SetID;
      /// <summary>
      /// Returns the sl_flags value.
      /// </summary>
      property Flags     : word      read GetFlags       write SetFlags;
      /// <summary>
      /// Return True if the slot has a Py_slot_end value in the sl_id field.
      /// </summary>
      property IsEnd     : boolean   read GetIsEnd;
      /// <summary>
      /// Return True if the slot has a TPy_mod.methods value in the sl_id field.
      /// </summary>
      property IsMethods : boolean   read GetIsMethods;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Py_mod;

constructor TPySlot.Create;
begin
  inherited Create;

  FillChar(FPySlot, SizeOf(FPySlot), 0);

  FStringValue := '';
end;

procedure TPySlot.Set_DATA(name_: word; value_: Pointer);
begin
  FPySlot := TPySlot.DATA(name_, value_);
end;

procedure TPySlot.Set_FUNC(name_: word; value_: _Py_funcptr_t);
begin
  FPySlot := TPySlot.FUNC(name_, value_);
end;

procedure TPySlot.Set_SIZE(name_: word; value_: Py_ssize_t);
begin
  FPySlot := TPySlot.SIZE(name_, value_);
end;

procedure TPySlot.Set_INT64(name_: word; value_: int64);
begin
  FPySlot := TPySlot.INT64_(name_, value_);
end;

procedure TPySlot.Set_UINT64(name_: word; value_: uint64);
begin
  FPySlot := TPySlot.UINT64_(name_, value_);
end;

procedure TPySlot.Set_STATIC_DATA(name_: word; value_: Pointer);
begin
  FPySlot := TPySlot.STATIC_DATA(name_, value_);
end;

procedure TPySlot.Set_PTR(name_: word; value_: Pointer);
begin
  FPySlot := TPySlot.PTR(name_, value_);
end;

procedure TPySlot.Set_PTR_STATIC(name_: word; value_: Pointer);
begin
  FPySlot := TPySlot.PTR_STATIC(name_, value_);
end;

procedure TPySlot.Set_END;
begin
  FPySlot := TPySlot.END_();
end;

procedure TPySlot.Set_STRING(name_: word; const value_: string);
var
  TempValue : AnsiString;
begin
  TempValue := StringToPyUTF8(value_);
  FPySlot   := TPySlot.DATA(name_, PAnsiChar(TempValue));
end;

procedure TPySlot.Set_STATIC_STRING(name_: word; const value_: string);
begin
  FStringValue := StringToPyUTF8(value_);
  FPySlot      := TPySlot.STATIC_DATA(name_, PAnsiChar(FStringValue));
end;

function TPySlot.GetID : word;
begin
  Result := FPySlot.sl_id;
end;

function TPySlot.GetFlags : word;
begin
  Result := FPySlot.sl_flags;
end;

function TPySlot.GetIsEnd : boolean;
begin
  Result := (FPySlot.sl_id = Py_slot_end);
end;

function TPySlot.GetIsMethods : boolean;
begin
  Result := (FPySlot.sl_id = TPy_mod.methods);
end;

procedure TPySlot.SetID(aValue: word);
begin
  FPySlot.sl_id := aValue;
end;

procedure TPySlot.SetFlags(aValue: word);
begin
  FPySlot.sl_flags := aValue;
end;

class function TPySlot.DATA(name_: word; value_: Pointer): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := PySlot_INTPTR;
  Result.sl_reserved := 0;
  Result.sl_ptr      := value_;
end;

class function TPySlot.FUNC(name_: word; value_: _Py_funcptr_t): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := 0;
  Result.sl_reserved := 0;
  Result.sl_func     := value_;
end;

class function TPySlot.SIZE(name_: word; value_: Py_ssize_t): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := 0;
  Result.sl_reserved := 0;
  Result.sl_size     := value_;
end;

class function TPySlot.INT64_(name_: word; value_: int64): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := 0;
  Result.sl_reserved := 0;
  Result.sl_int64    := value_;
end;

class function TPySlot.UINT64_(name_: word; value_: uint64): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := 0;
  Result.sl_reserved := 0;
  Result.sl_uint64   := value_;
end;

class function TPySlot.STATIC_DATA(name_: word; value_: Pointer): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := PySlot_STATIC;
  Result.sl_reserved := 0;
  Result.sl_ptr      := value_;
end;

class function TPySlot.PTR(name_: word; value_: Pointer): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := PySlot_INTPTR;
  Result.sl_reserved := 0;
  Result.sl_ptr      := value_;
end;

class function TPySlot.PTR_STATIC(name_: word; value_: Pointer): PySlot;
begin
  Result.sl_id       := name_;
  Result.sl_flags    := PySlot_INTPTR or PySlot_STATIC;
  Result.sl_reserved := 0;
  Result.sl_ptr      := value_;
end;

class function TPySlot.END_: PySlot;
begin
  Result.sl_id       := Py_slot_end;
  Result.sl_flags    := 0;
  Result.sl_reserved := 0;
  Result.sl_ptr      := nil;
end;

end.
