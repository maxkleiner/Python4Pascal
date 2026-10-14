unit uP4P.PyHeapTypeSlotManager;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  uP4P.PySlotManager;

type
  /// <summary>
  /// <para>TPyCustomHeapTypeSlotManager is used to store the information about
  /// the heap type and to manage the method and slot lists.</para>
  /// </summary>
  TPyHeapTypeSlotManager = class(TPySlotManager)
    protected
      procedure AddAllSlots; override;
  end;

implementation

procedure TPyHeapTypeSlotManager.AddAllSlots;
begin
  inherited AddAllSlots;

  AddNameSlot;
  AddDocStringsSlot;
  AddMetaclassSlot;
  AddModuleSlot;
  AddBasesSlot;
  AddTokenSlot;
end;

end.
