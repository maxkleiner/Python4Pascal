unit uP4P.PyObjectVariantType;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Variants, System.SysUtils,
  {$ELSE}
    Classes, Variants, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  ///<summary>
  ///<para>Custom TVarData record used by TPyObjectVariantType.</para>
  ///<para>The size of TVarData is 16 bytes on 32-bit (x86) systems and 24 bytes on 64-bit (x64) systems.</para>
  ///<para>The size difference is primarily caused by pointer size changes and stricter data alignment rules on 64-bit architectures.</para>
  ///</summary>
  TPyObjectVarData = packed record
    VType      : TVarType;
    Reserved1  : Word;
    Reserved2  : Word;
    Reserved3  : Word;
    VPyObject  : TPyObject;
    Reserved4  : Integer;
    {$IFDEF TARGET_64BITS}
    Reserved5  : Integer;
    {$ENDIF TARGET_64BITS}
  end;

  ///<summary>
  /// PyObject custom variant type helper class.
  ///</summary>
  TPyObjectVariantType = class(TInvokeableVariantType, IVarInstanceReference)
    protected
      // IVarInstanceReference
      function  GetInstance(const V: TVarData): TObject;

      // TCustomVariantType
      function  LeftPromotion(const V: TVarData; const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean; override;
      function  RightPromotion(const V: TVarData; const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean; override;

      // Custom
      procedure AssignResult(var Left: TVarData; const aResult: IPyObject);
      procedure DoAddString(var Left: TVarData; const Right: TVarData);
      procedure DoAdd(var Left: TVarData; const Right: TVarData);
      procedure DoSubtract(var Left: TVarData; const Right: TVarData);
      procedure DoMultiply(var Left: TVarData; const Right: TVarData);
      procedure DoDivide(var Left: TVarData; const Right: TVarData);
      procedure DoIntDivide(var Left: TVarData; const Right: TVarData);
      procedure DoModulus(var Left: TVarData; const Right: TVarData);
      procedure DoShiftLeft(var Left: TVarData; const Right: TVarData);
      procedure DoShiftRight(var Left: TVarData; const Right: TVarData);
      procedure DoAnd(var Left: TVarData; const Right: TVarData);
      procedure DoOr(var Left: TVarData; const Right: TVarData);
      procedure DoXor(var Left: TVarData; const Right: TVarData);

    public
      // TCustomVariantType
      procedure Clear(var V: TVarData); override;
      function  IsClear(const V: TVarData): Boolean; override;
      procedure Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean); override;
      procedure Cast(var Dest: TVarData; const Source: TVarData); override;
      procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); override;
      procedure BinaryOp(var Left: TVarData; const Right: TVarData; const AOperator: TVarOp); override;
      procedure UnaryOp(var Right: TVarData; const AOperator: TVarOp); override;
      function  CompareOp(const Left: TVarData; const Right: TVarData; const AOperator: TVarOp): Boolean; override;
      function  DoFunction(var Dest: TVarData; const V: TVarData; const AName: string; const Arguments: TVarDataArray): Boolean; override;
      function  DoProcedure(const V: TVarData; const AName: string; const Arguments: TVarDataArray): Boolean; override;
      function  GetProperty(var Dest: TVarData; const V: TVarData; const AName: string): Boolean; override;
      function  SetProperty({$IFDEF FPC}var{$ELSE}const{$ENDIF} V: TVarData; const AName: string; const Value: TVarData): Boolean; override;

      // TInvokeableVariantType
      function  FixupIdent(const AText: string): string; override;
      procedure DispInvoke(Dest: PVarData; {$IFDEF DELPHI21_UP}[Ref] const{$ELSE}var{$ENDIF} Source: TVarData; CallDesc: PCallDesc; Params: Pointer); override;
  end;

var
  ///<summary>
  /// PyObject custom variant type helper instance.
  ///</summary>
  PyObjectVariantType : TPyObjectVariantType = nil;

implementation

uses
  uP4P.PyNumber;

procedure TPyObjectVariantType.AssignResult(var Left: TVarData; const aResult: IPyObject);
begin
  if TPyObject.IsInitialized(aResult) then
    begin
      FreeAndNil(TPyObjectVarData(Left).VPyObject);
      TPyObjectVarData(Left).VPyObject := TPyObject.Create(aResult.PyObject, True, True);
    end;
end;

procedure TPyObjectVariantType.DoAddString(var Left: TVarData; const Right: TVarData);
begin
  Variant(Left) := Variant(Left) + TPyObjectVarData(Right).VPyObject.AsString;
end;

procedure TPyObjectVariantType.DoAdd(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Add(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoSubtract(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Subtract(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoMultiply(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Multiply(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoDivide(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.TrueDivide(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoIntDivide(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.FloorDivide(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoModulus(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Divmod(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoShiftLeft(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Lshift(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoShiftRight(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Rshift(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoAnd(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.And_(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoOr(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Or_(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.DoXor(var Left: TVarData; const Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Xor_(TPyObjectVarData(Left).VPyObject, TPyObjectVarData(Right).VPyObject);
  AssignResult(Left, TempResult);
end;

procedure TPyObjectVariantType.BinaryOp(var Left: TVarData; const Right: TVarData; const AOperator: TVarOp);
begin
  if (Right.VType = VarType) then
    case Left.VType of
      varString,
      varUString :
        case AOperator of
          opAdd : DoAddString(Left, Right);
          else    RaiseInvalidOp;
        end;

      else
        if (Left.VType = VarType) then
          case AOperator of
            opAdd         : DoAdd(Left, Right);
            opSubtract    : DoSubtract(Left, Right);
            opMultiply    : DoMultiply(Left, Right);
            opDivide      : DoDivide(Left, Right);
            opIntDivide   : DoIntDivide(Left, Right);
            opModulus     : DoModulus(Left, Right);
            opShiftLeft   : DoShiftLeft(Left, Right);
            opShiftRight  : DoShiftRight(Left, Right);
            opAnd         : DoAnd(Left, Right);
            opOr          : DoOr(Left, Right);
            opXor         : DoXor(Left, Right);
            else            RaiseInvalidOp;
          end
         else
          RaiseInvalidOp;
    end
   else
    RaiseInvalidOp;
end;

procedure TPyObjectVariantType.Cast(var Dest: TVarData; const Source: TVarData);
begin
  inherited;

end;

procedure TPyObjectVariantType.CastTo(var Dest: TVarData;
  const Source: TVarData; const AVarType: TVarType);
begin
  inherited;

end;

procedure TPyObjectVariantType.Clear(var V: TVarData);
begin
  V.VType := varEmpty;
  FreeAndNil(TPyObjectVarData(V).VPyObject);
end;

function TPyObjectVariantType.CompareOp(const Left, Right: TVarData;
  const AOperator: TVarOp): Boolean;
begin

end;

procedure TPyObjectVariantType.Copy(var Dest: TVarData; const Source: TVarData;
  const Indirect: Boolean);
begin
  inherited;

end;

procedure TPyObjectVariantType.DispInvoke(Dest: PVarData;
  {$IFDEF DELPHI21_UP}[Ref] const{$ELSE}var{$ENDIF} Source: TVarData;
  CallDesc: PCallDesc; Params: Pointer);
begin
  inherited;

end;

function TPyObjectVariantType.DoFunction(var Dest: TVarData; const V: TVarData;
  const AName: string; const Arguments: TVarDataArray): Boolean;
begin

end;

function TPyObjectVariantType.DoProcedure(const V: TVarData;
  const AName: string; const Arguments: TVarDataArray): Boolean;
begin

end;

function TPyObjectVariantType.FixupIdent(const AText: string): string;
begin
  Result := AText;
end;

function TPyObjectVariantType.GetInstance(const V: TVarData): TObject;
begin
  Result := TPyObjectVarData(V).VPyObject;
end;

function TPyObjectVariantType.GetProperty(var Dest: TVarData; const V: TVarData;
  const AName: string): Boolean;
begin

end;

function TPyObjectVariantType.IsClear(const V: TVarData): Boolean;
begin

end;

function TPyObjectVariantType.LeftPromotion(const V: TVarData;
  const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin

end;

function TPyObjectVariantType.RightPromotion(const V: TVarData;
  const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin

end;

function TPyObjectVariantType.SetProperty(const V: TVarData;
  const AName: string; const Value: TVarData): Boolean;
begin

end;

procedure TPyObjectVariantType.UnaryOp(var Right: TVarData;
  const AOperator: TVarOp);
begin
  inherited;

end;

initialization
  PyObjectVariantType := TPyObjectVariantType.Create;

finalization
  FreeAndNil(PyObjectVariantType);

end.
