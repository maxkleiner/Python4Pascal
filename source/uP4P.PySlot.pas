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
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPySlot = class
    public
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
  end;

implementation

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
