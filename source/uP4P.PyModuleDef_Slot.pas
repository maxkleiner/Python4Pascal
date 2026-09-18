unit uP4P.PyModuleDef_Slot;

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
  /// <para>TPyModuleDef_Slot is used to store the information about module
  /// slots.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-slots">See the article about Module slots.</see></para>
  /// </remarks>
  TPyModuleDef_Slot = class
    protected
      FSlot : PyModuleDef_Slot;

      function  GetIsSentinel: boolean;

    public
      constructor Create(aSlot: integer; aValue: Pointer);
      /// <summary>
      /// Module slot record.
      /// </summary>
      property Slot        : PyModuleDef_Slot  read FSlot;
      /// <summary>
      /// Return True if this is the last slot in the list. The sentinel
      /// slot has 0 as ID and nil as value.
      /// </summary>
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

implementation

constructor TPyModuleDef_Slot.Create(aSlot: integer; aValue: Pointer);
begin
  inherited Create;

  FSlot.slot  := aSlot;
  FSlot.value := aValue;
end;

function TPyModuleDef_Slot.GetIsSentinel: boolean;
begin
  Result := (FSlot.slot = 0) and (FSlot.value = nil);
end;

end.
