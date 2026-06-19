unit uP4P.PyMath;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes;
  {$ELSE}
    Classes;
  {$ENDIF}

type
  TPyMath = class
    public
      class function IsNan_(const AValue: Single): Boolean; overload;
      class function IsNan_(const AValue: Double): Boolean; overload;
      {$IFNDEF FPC}
      class function IsNan_(const AValue: Extended): Boolean; overload;
      {$ENDIF}
      class function IsInfinite_(const AValue: Single): Boolean; overload;
      class function IsInfinite_(const AValue: Double): Boolean; overload;
      {$IFNDEF FPC}
      class function IsInfinite_(const AValue: Extended): Boolean; overload;
      {$ENDIF}
      class function IsFinite_(const AValue: Single): Boolean; overload;
      class function IsFinite_(const AValue: Double): Boolean; overload;
      {$IFNDEF FPC}
      class function IsFinite_(const AValue: Extended): Boolean; overload;
      {$ENDIF}
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
    System.Math;
  {$ELSE}
    Math;
  {$ENDIF}

class function TPyMath.IsNan_(const AValue: Single): Boolean;
begin
  Result := IsNan(AValue);
end;

class function TPyMath.IsNan_(const AValue: Double): Boolean;
begin
  Result := IsNan(AValue);
end;

{$IFNDEF FPC}
class function TPyMath.IsNan_(const AValue: Extended): Boolean;
begin
  Result := IsNan(AValue);
end;
{$ENDIF}

class function TPyMath.IsInfinite_(const AValue: Single): Boolean;
begin
  Result := IsInfinite(AValue);
end;

class function TPyMath.IsInfinite_(const AValue: Double): Boolean;
begin
  Result := IsInfinite(AValue);
end;

{$IFNDEF FPC}
class function TPyMath.IsInfinite_(const AValue: Extended): Boolean;
begin
  Result := IsInfinite(AValue);
end;
{$ENDIF}

class function TPyMath.IsFinite_(const AValue: Single): Boolean;
begin
  Result := not(IsNan(AValue)) and not(IsInfinite(AValue));
end;

class function TPyMath.IsFinite_(const AValue: Double): Boolean;
begin
  Result := not(IsNan(AValue)) and not(IsInfinite(AValue));
end;

{$IFNDEF FPC}
class function TPyMath.IsFinite_(const AValue: Extended): Boolean;
begin
  Result := not(IsNan(AValue)) and not(IsInfinite(AValue));
end;
{$ENDIF}

end.
