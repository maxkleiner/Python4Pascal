unit uP4P.PyCompile;

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
  TPyCompile = class
    public
      class function OpcodeStackEffect(opcode, oparg: integer): integer;
      class function OpcodeStackEffectWithJump(opcode, oparg, jump: integer): integer;
  end;

implementation

class function TPyCompile.OpcodeStackEffect(opcode, oparg: integer): integer;
begin
  if assigned(PyCompile_OpcodeStackEffect) then
    Result := PyCompile_OpcodeStackEffect(opcode, oparg)
   else
    Result := PY_INVALID_STACK_EFFECT;
end;

class function TPyCompile.OpcodeStackEffectWithJump(opcode, oparg, jump: integer): integer;
begin
  if assigned(PyCompile_OpcodeStackEffectWithJump) then
    Result := PyCompile_OpcodeStackEffectWithJump(opcode, oparg, jump)
   else
    Result := PY_INVALID_STACK_EFFECT;
end;

end.
