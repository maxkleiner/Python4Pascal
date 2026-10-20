unit uP4P.PyType_Slot;

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
  uP4P.Types;

type
  /// <summary>
  /// TPyType_Slot is used to store the information about type slots.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyType_Slot">See the article about PyType_Slot.</see></para>
  /// </remarks>
  TPyType_Slot = class
    protected
      FSlot : PyType_Slot;

      function  GetIsSentinel: boolean;

    public
      constructor Create(aSlot: integer; aPfunc: Pointer);
      /// <summary>
      /// Type slot record.
      /// </summary>
      property Slot        : PyType_Slot       read FSlot;
      /// <summary>
      /// Return True if this is item has 0 as ID and nil as pfunc.
      /// </summary>
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

implementation

constructor TPyType_Slot.Create(aSlot: integer; aPfunc: Pointer);
begin
  inherited Create;

  FSlot.slot  := aSlot;
  FSlot.pfunc := aPfunc;
end;

function TPyType_Slot.GetIsSentinel: boolean;
begin
  Result := (FSlot.slot = 0) and (FSlot.pfunc = nil);
end;

end.
