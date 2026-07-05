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



procedure TPyObjectVariantType.BinaryOp(var Left: TVarData;
  const Right: TVarData; const AOperator: TVarOp);
begin
  inherited;

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
