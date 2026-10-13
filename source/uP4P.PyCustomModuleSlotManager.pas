unit uP4P.PyCustomModuleSlotManager;

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
  TPyCustomModuleSlotManager = class(TPySlotManager)
    protected
      procedure AddAllSlots; override;
  end;

implementation

procedure TPyCustomModuleSlotManager.AddAllSlots;
begin
  AddNameSlot;
  AddDocStringsSlot;
  AddABIInfoSlot;
  AddExecSlot;
  AddMultipleInterpretersSlot;
  AddGILSlot;
  AddTokenSlot;
end;

end.
