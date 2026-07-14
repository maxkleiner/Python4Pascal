unit uP4P.PyObjectVariantType;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Variants, System.SysUtils, System.StrUtils,
  {$ELSE}
    Classes, Variants, SysUtils, StrUtils,
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
      fNamedParams : TNamedParamArray;

      // IVarInstanceReference
      function  GetInstance(const V: TVarData): TObject;

      // TCustomVariantType
      function  LeftPromotion(const V: TVarData; const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean; override;
      function  RightPromotion(const V: TVarData; const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean; override;

      // Custom
      function  CallObject(const V: TVarData; const AName: string; const Arguments: TVarDataArray): IPyObject;
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
      procedure DoNegate(var Right: TVarData);
      procedure DoNot(var Right: TVarData);

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
      {$IFDEF FPC}
      procedure VarDataClear(var Dest: TVarData);
      procedure VarDataCopyNoInd(var Dest: TVarData; const Source: TVarData);
      procedure VarDataCastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); overload;
      {$ENDIF}

      // TInvokeableVariantType
      {$IFNDEF FPC}
      function  FixupIdent(const AText: string): string; override;
      {$ENDIF}
      procedure DispInvoke(Dest: PVarData; {$IFDEF DELPHI21_UP}[Ref] const{$ELSE}var{$ENDIF} Source: TVarData; CallDesc: PCallDesc; Params: Pointer); override;

      // Custom
      procedure PyObjectVarDataCreate(var Dest: TVarData; const aObject: IPyObject);
      procedure PyObjectVariantCreate(var Dest: Variant; const aObject: IPyObject);
  end;

var
  ///<summary>
  /// PyObject custom variant type helper instance.
  ///</summary>
  PyObjectVariantType : TPyObjectVariantType = nil;

implementation

uses
  uP4P.PyNumber, uP4P.PyTuple, uP4P.PyNone, uP4P.PyLong, uP4P.PyList,
  uP4P.PySequence, uP4P.PyDict;

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

procedure TPyObjectVariantType.DoNegate(var Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Negative(TPyObjectVarData(Right).VPyObject);
  AssignResult(Right, TempResult);
end;

procedure TPyObjectVariantType.DoNot(var Right: TVarData);
var
  TempResult : IPyObject;
begin
  TempResult := TPyNumber.Invert(TPyObjectVarData(Right).VPyObject);
  AssignResult(Right, TempResult);
end;

procedure TPyObjectVariantType.BinaryOp(var Left: TVarData; const Right: TVarData; const AOperator: TVarOp);
begin
  if (Right.VType = VarType) then
    case Left.VType of
      varOleStr,
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
var
  TempObj : IPyObject;
begin
  try
    TempObj := TPyObject.FromVarData(Source);
    PyObjectVarDataCreate(Dest, TempObj);
  finally
    TempObj := nil;
  end;
end;

procedure TPyObjectVariantType.CastTo(var Dest: TVarData;
  const Source: TVarData; const AVarType: TVarType);
var
  TempVariant : Variant;
begin
  if (Source.VType <> VarType) then
    begin
      inherited;
      exit;
    end;

  case AVarType of
    varOleStr    : VarDataFromOleStr(Dest, TPyObjectVarData(Source).VPyObject.AsWideString);
    varUString   :
      begin
        {$IFDEF FPC}
        VarDataFromOleStr(Dest, TPyObjectVarData(Source).VPyObject.AsWideString);
        {$ELSE}
        VarDataFromStr(Dest, TPyObjectVarData(Source).VPyObject.AsWideString);
        {$ENDIF}
      end;

    varString    :
      begin
        {$IFDEF FPC}
        Variant(Dest) := TPyObjectVarData(Source).VPyObject.AsWideString;
        {$ELSE}
        VarDataFromLStr(Dest, TPyObjectVarData(Source).VPyObject.AsAnsiString);
        {$ENDIF}
      end;

    varBoolean   :
      begin
        Dest.VType    := AVarType;
        Dest.VBoolean := (TPyObjectVarData(Source).VPyObject.IsTrue = 1);
      end;

    varSmallint  :
      begin
        Dest.VType     := AVarType;
        Dest.VSmallInt := TPyObjectVarData(Source).VPyObject.AsInteger;
      end;

    varShortInt  :
      begin
        Dest.VType     := AVarType;
        Dest.VShortInt := TPyObjectVarData(Source).VPyObject.AsInteger;
      end;

    varByte      :
      begin
        Dest.VType := AVarType;
        Dest.VByte := TPyObjectVarData(Source).VPyObject.AsCardinal;
      end;

    varWord      :
      begin
        Dest.VType := AVarType;
        Dest.VWord := TPyObjectVarData(Source).VPyObject.AsCardinal;
      end;

    varInteger   :
      begin
        Dest.VType    := AVarType;
        Dest.VInteger := TPyObjectVarData(Source).VPyObject.AsInteger;
      end;

    varLongWord  :
      begin
        Dest.VType     := AVarType;
        Dest.VLongWord := TPyObjectVarData(Source).VPyObject.AsCardinal;
      end;

    varInt64    :
      begin
        Dest.VType  := AVarType;
        Dest.VInt64 := TPyObjectVarData(Source).VPyObject.AsInt64;
      end;

    {$IFNDEF FPC}
    varUInt64   :
      begin
        Dest.VType   := AVarType;
        Dest.VUInt64 := TPyObjectVarData(Source).VPyObject.AsUInt64;
      end;
    {$ENDIF}

    varSingle   :
      begin
        Dest.VType   := AVarType;
        Dest.VSingle := TPyObjectVarData(Source).VPyObject.AsDouble;
      end;

    varDouble   :
      begin
        Dest.VType   := AVarType;
        Dest.VDouble := TPyObjectVarData(Source).VPyObject.AsDouble;
      end;

    varCurrency :
      begin
        Dest.VType     := AVarType;
        Dest.VCurrency := TPyObjectVarData(Source).VPyObject.AsDouble;
      end;

    else
      begin
        TempVariant := TPyObjectVarData(Source).VPyObject.CastValueAsVariant;
        VarDataCastTo(Dest, TVarData(TempVariant), AVarType);
      end;
  end;
end;

procedure TPyObjectVariantType.Clear(var V: TVarData);
begin
  V.VType := varEmpty;
  FreeAndNil(TPyObjectVarData(V).VPyObject);
end;

function TPyObjectVariantType.CompareOp(const Left, Right: TVarData; const AOperator: TVarOp): Boolean;
begin
  Result := False;

  if (Left.VType = VarType) and (Right.VType = VarType) then
    case AOperator of
      opCmpEQ : Result := (TPyObjectVarData(Left).VPyObject.RichCompareBool(TPyObjectVarData(Right).VPyObject, Py_EQ) = 1);
      opCmpNE : Result := (TPyObjectVarData(Left).VPyObject.RichCompareBool(TPyObjectVarData(Right).VPyObject, Py_EQ) = 0);
      opCmpLT : Result := (TPyObjectVarData(Left).VPyObject.RichCompareBool(TPyObjectVarData(Right).VPyObject, Py_LT) = 1);
      opCmpLE : Result := (TPyObjectVarData(Left).VPyObject.RichCompareBool(TPyObjectVarData(Right).VPyObject, Py_LE) = 1);
      opCmpGT : Result := (TPyObjectVarData(Left).VPyObject.RichCompareBool(TPyObjectVarData(Right).VPyObject, Py_GT) = 1);
      opCmpGE : Result := (TPyObjectVarData(Left).VPyObject.RichCompareBool(TPyObjectVarData(Right).VPyObject, Py_GE) = 1);
      else      RaiseInvalidOp;
    end
   else
    RaiseInvalidOp;
end;

procedure TPyObjectVariantType.Copy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean);
begin
  if Indirect and VarDataIsByRef(Source) then
    VarDataCopyNoInd(Dest, Source)
   else
    PyObjectVarDataCreate(Dest, TPyObjectVarData(Source).VPyObject);
end;

procedure TPyObjectVariantType.DispInvoke(Dest: PVarData; {$IFDEF DELPHI21_UP}[Ref] const{$ELSE}var{$ENDIF} Source: TVarData; CallDesc: PCallDesc; Params: Pointer);
const
  CDoMethod    = $01;
  CPropertyGet = $02;
Var
  TempCallDesc : TCallDesc;
  LNamePtr : PAnsiChar;
  LNamedArgStart : Integer;
  I : integer;
begin
  if (CallDesc^.CallType = CPropertyGet) and (CallDesc^.ArgCount = 1) then
    begin
      SetLength(fNamedParams, 0);

      TempCallDesc          := CallDesc^;
      TempCallDesc.CallType := CDoMethod;

      inherited DispInvoke(Dest, Source, @TempCallDesc, Params);
    end
   else
    begin
      if (CallDesc^.CallType = CDoMethod) then
        begin
          SetLength(fNamedParams, CallDesc^.NamedArgCount);

          if (CallDesc^.NamedArgCount > 0) then
            begin
              LNamePtr       := PAnsiChar(@CallDesc^.ArgTypes[CallDesc^.ArgCount]);
              LNamedArgStart := CallDesc^.ArgCount - CallDesc^.NamedArgCount;

              // Skip function Name
              for I := 0 to CallDesc^.NamedArgCount - 1 do
                begin
                  LNamePtr := LNamePtr + Succ(Length(LNamePtr));

                  fNamedParams[I].Index := I + LNamedArgStart;
                  fNamedParams[I].Name  := LNamePtr;
                end;
            end;
        end
       else
        SetLength(fNamedParams, 0);

      inherited DispInvoke(Dest, Source, CallDesc, Params);
    end;
end;

function TPyObjectVariantType.CallObject(const V: TVarData; const AName: string; const Arguments: TVarDataArray): IPyObject;
var
  TempContainer : TPyObject;
  TempAttrib, TempArgs, TempKWs : IPyObject;
  TempNamedParams : TNamedParamArray;
  TempMaxLength : integer;
begin
  TempNamedParams := System.Copy(fNamedParams);
  SetLength(fNamedParams, 0);

  Result        := nil;
  TempContainer := TPyObjectVarData(V).VPyObject;

  if TempContainer.GetOptionalAttrString(AName, TempAttrib) then
    begin
      if TempAttrib.IsCallable then
        begin
          if (Length(Arguments) = 1) and VarIsEmptyParam(Variant(Arguments[0])) then
            TempMaxLength := 0
           else
            TempMaxLength := Length(Arguments);

          if (length(TempNamedParams) > 0) then
            TempMaxLength := TempNamedParams[0].Index;

          TempKWs  := TPyDict.FromNamedParamArray(TempNamedParams, Arguments);
          TempArgs := TPyTuple.FromVarDataArray(Arguments, TempMaxLength);

          if TPyObject.IsInitialized(TempArgs) then
            Result := TempAttrib.Call(TempArgs, TempKWs)
           else
            Result := TempAttrib.CallNoArgs;
        end
       else
        if (Length(Arguments) = 1) and
           (TempAttrib.IsSequence or TempAttrib.IsMapping) then
          Result := TempAttrib.GetItem(Arguments[0]);
    end
   else
    case AnsiIndexStr(AName, ['GetItem', 'SetItem', 'DeleteItem', 'GetSlice', 'SetSlice', 'DelSlice', 'Contains', 'Length']) of
      0 : // GetItem
        if (Length(Arguments) = 1) then
          Result := TempAttrib.GetItem(Arguments[0]);

      1 : // SetItem
        if (Length(Arguments) = 2) then
          begin
            if TempAttrib.IsList then
              TPyLong.FromLong(ord(TPyList.SetItem(TempAttrib, Arguments[0], Arguments[1])) - 1)
             else
              if TempAttrib.IsTuple then
                TPyLong.FromLong(ord(TPyTuple.SetItem(TempAttrib, Arguments[0], Arguments[1])) - 1)
               else
                if TempAttrib.IsSequence then
                  TPyLong.FromLong(ord(TPySequence.SetItem(TempAttrib, Arguments[0], Arguments[1])) - 1)
                 else
                  TPyLong.FromLong(ord(TempAttrib.SetItem(Arguments[0], Arguments[1])) - 1);
          end;

      2 : // DeleteItem
        if (Length(Arguments) = 1) then
          begin
            TempAttrib.DelItem(Arguments[0]);
            Result := TPyNone.New;
          end;

      3 : // GetSlice
        if TempAttrib.IsSequence and (Length(Arguments) = 2) then
          Result := TPySequence.GetSlice(TempAttrib, Arguments[0], Arguments[1]);

      4 : // SetSlice
        if TempAttrib.IsSequence and (Length(Arguments) = 3) then
          Result := TPyLong.FromLong(ord(TPySequence.SetSlice(TempAttrib, Arguments[0], Arguments[1], Arguments[2])) - 1);

      5 : // DelSlice
        if TempAttrib.IsSequence and (Length(Arguments) = 2) then
          Result := TPyLong.FromLong(ord(TPySequence.DelSlice(TempAttrib, Arguments[0], Arguments[1])) - 1);

      6 : // Contains
        if TempAttrib.IsSequence and (Length(Arguments) = 1) then
          Result := TPyLong.FromLong(TPySequence.Contains(TempAttrib, Arguments[0]));

      7 : Result := TPyLong.FromLong(TempAttrib.Length); // Length
    end;
end;

function TPyObjectVariantType.DoFunction(var Dest: TVarData; const V: TVarData; const AName: string; const Arguments: TVarDataArray): Boolean;
var
  TempObjResult : IPyObject;
begin
  Result        := False;
  TempObjResult := CallObject(V, AName, Arguments);

  if TPyObject.IsInitialized(TempObjResult) then
    begin
      PyObjectVarDataCreate(Dest, TempObjResult);
      Result := True;
    end;
end;

function TPyObjectVariantType.DoProcedure(const V: TVarData; const AName: string; const Arguments: TVarDataArray): Boolean;
var
  TempObjResult : IPyObject;
begin
  TempObjResult := CallObject(V, AName, Arguments);
  Result        := TPyObject.IsInitialized(TempObjResult);
end;

{$IFDEF FPC}
procedure TPyObjectVariantType.VarDataClear(var Dest: TVarData);
begin
  VarClear(Variant(Dest));
end;

procedure TPyObjectVariantType.VarDataCopyNoInd(var Dest: TVarData; const Source: TVarData);
begin
  VarCopyNoInd(Variant(Dest), Variant(Source));
end;

procedure TPyObjectVariantType.VarDataCastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); overload;
begin
  VarCast(Variant(Dest), Variant(Source), AVarType);
end;
{$ELSE}
function TPyObjectVariantType.FixupIdent(const AText: string): string;
begin
  Result := AText;
end;
{$ENDIF}

function TPyObjectVariantType.GetInstance(const V: TVarData): TObject;
begin
  Result := TPyObjectVarData(V).VPyObject;
end;

function TPyObjectVariantType.GetProperty(var Dest: TVarData; const V: TVarData; const AName: string): Boolean;
var
  TempContainer : TPyObject;
  TempAttrib    : IPyObject;
begin
  Result        := False;
  TempContainer := TPyObjectVarData(V).VPyObject;

  if TempContainer.GetOptionalAttrString(AName, TempAttrib) then
    begin
      PyObjectVarDataCreate(Dest, TempAttrib);
      Result := True;
    end
   else
    if SameText(AName, 'Length') and (TempAttrib.IsSequence or TempAttrib.IsMapping) then
      begin
        PyObjectVarDataCreate(Dest, TPyLong.FromLong(TempAttrib.Length));
        Result := True;
      end;
end;

function TPyObjectVariantType.IsClear(const V: TVarData): Boolean;
begin
  Result := not(assigned(TPyObjectVarData(V).VPyObject)) or
            TPyObjectVarData(V).VPyObject.IsNoneSingleton;
end;

function TPyObjectVariantType.LeftPromotion(const V: TVarData; const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin
  if (AOperator = opAdd) and VarDataIsStr(V) then
    RequiredVarType := varUString
   else
    RequiredVarType := VarType;

  Result := True;
end;

function TPyObjectVariantType.RightPromotion(const V: TVarData;
  const AOperator: TVarOp; out RequiredVarType: TVarType): Boolean;
begin
  if (V.VType <> varInt64) then
    begin
      RequiredVarType := VarType;
      Result          := True;
    end
   else
    Result := False;
end;

function TPyObjectVariantType.SetProperty({$IFDEF FPC}var{$ELSE}const{$ENDIF} V: TVarData;
  const AName: string; const Value: TVarData): Boolean;
begin
  TPyObjectVarData(V).VPyObject.SetAttrString(AName, TPyObject.FromVarData(Value));
  Result := True;
end;

procedure TPyObjectVariantType.UnaryOp(var Right: TVarData; const AOperator: TVarOp);
begin
  if (Right.VType = VarType) then
    case AOperator of
      opNegate : DoNegate(Right);
      opNot    : DoNot(Right);
      else       RaiseInvalidOp;
    end
   else
    RaiseInvalidOp;
end;

procedure TPyObjectVariantType.PyObjectVarDataCreate(var Dest: TVarData; const aObject: IPyObject);
begin
  VarDataClear(Dest);

  if TPyObject.IsInitialized(aObject) then
    begin
      aObject.IncRef;
      TPyObjectVarData(Dest).VType     := VarType;
      TPyObjectVarData(Dest).VPyObject := TPyObject.Create(aObject.PyObject, True, False);
    end;
end;

procedure TPyObjectVariantType.PyObjectVariantCreate(var Dest: Variant; const aObject: IPyObject);
var
  TempDest : TVarData;
begin
  PyObjectVarDataCreate(TempDest, aObject);
  Dest := Variant(TempDest);
end;

initialization
  PyObjectVariantType := TPyObjectVariantType.Create;

finalization
  FreeAndNil(PyObjectVariantType);

end.
