unit uP4P.PyModuleSlotManager;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  uP4P.PySlotManager;

type
  /// <summary>
  /// <para>TPyCustomModuleSlotManager is used to store the information about
  /// the module and to manage the method and slot lists.</para>
  /// </summary>
  TPyModuleSlotManager = class(TPySlotManager)
    protected
      procedure AddAllSlots; override;
  end;

implementation

procedure TPyModuleSlotManager.AddAllSlots;
begin
  inherited AddAllSlots;

  AddNameSlot;
  AddDocStringsSlot;
  AddABIInfoSlot;
  AddExecSlot;
  AddMultipleInterpretersSlot;
  AddGILSlot;
  AddTokenSlot;
end;

end.
