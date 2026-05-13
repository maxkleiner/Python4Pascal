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
      class function IsNan(const AValue: Single): Boolean; overload;
      class function IsNan(const AValue: Double): Boolean; overload;
      class function IsNan(const AValue: Extended): Boolean; overload;
      class function IsInfinite(const AValue: Single): Boolean; overload;
      class function IsInfinite(const AValue: Double): Boolean; overload;
      class function IsInfinite(const AValue: Extended): Boolean; overload;
      class function IsFinite(const AValue: Single): Boolean; overload;
      class function IsFinite(const AValue: Double): Boolean; overload;
      class function IsFinite(const AValue: Extended): Boolean; overload;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
    System.Math;
  {$ELSE}
    Math;
  {$ENDIF}

class function TPyMath.IsNan(const AValue: Single): Boolean;
begin
  Result := IsNan(AValue);
end;

class function TPyMath.IsNan(const AValue: Double): Boolean;
begin
  Result := IsNan(AValue);
end;

class function TPyMath.IsNan(const AValue: Extended): Boolean;
begin
  Result := IsNan(AValue);
end;

class function TPyMath.IsInfinite(const AValue: Single): Boolean;
begin
  Result := IsInfinite(AValue);
end;

class function TPyMath.IsInfinite(const AValue: Double): Boolean;
begin
  Result := IsInfinite(AValue);
end;

class function TPyMath.IsInfinite(const AValue: Extended): Boolean;
begin
  Result := IsInfinite(AValue);
end;

class function TPyMath.IsFinite(const AValue: Single): Boolean;
begin
  Result := not(IsNan(AValue)) and not(IsInfinite(AValue));
end;

class function TPyMath.IsFinite(const AValue: Double): Boolean;
begin
  Result := not(IsNan(AValue)) and not(IsInfinite(AValue));
end;

class function TPyMath.IsFinite(const AValue: Extended): Boolean;
begin
  Result := not(IsNan(AValue)) and not(IsInfinite(AValue));
end;

end.
