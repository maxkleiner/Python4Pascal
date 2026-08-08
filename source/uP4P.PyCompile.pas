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
  /// <summary>
  /// Helper class for all PyCompile_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/veryhigh.html#stack-effects">See the article about Stack Effects.</see></para>
  /// </remarks>
  TPyCompile = class
    public
      /// <summary>
      /// <para>Compute the stack effect of opcode with argument oparg.</para>
      /// <para>On success, this function returns the stack effect; on failure,
      /// this returns PY_INVALID_STACK_EFFECT.</para>
      /// </summary>
      class function OpcodeStackEffect(opcode, oparg: integer): integer;
      /// <summary>
      /// <para>Similar to TPyCompile.OpcodeStackEffect(), but don't include
      /// the stack effect of jumping if jump is zero.</para>
      /// <para>If jump is 0, this will not include the stack effect of jumping,
      /// but if jump is 1 or -1, this will include it.</para>
      /// <para>On success, this function returns the stack effect; on failure,
      /// this returns PY_INVALID_STACK_EFFECT.</para>
      /// </summary>
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
