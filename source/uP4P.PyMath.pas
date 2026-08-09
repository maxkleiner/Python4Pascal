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
  /// <summary>
  /// Helper class for math methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/float.html#floating-point-objects">See the article about Floating-Point Objects.</see></para>
  /// </remarks>
  TPyMath = class
    public
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is a
      /// not-a-number (NaN) value. Return False otherwise.</para>
      /// </summary>
      class function IsNan_(const AValue: Single): Boolean; overload;
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is a
      /// not-a-number (NaN) value. Return False otherwise.</para>
      /// </summary>
      class function IsNan_(const AValue: Double): Boolean; overload;
      {$IFNDEF FPC}
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is a
      /// not-a-number (NaN) value. Return False otherwise.</para>
      /// </summary>
      class function IsNan_(const AValue: Extended): Boolean; overload;
      {$ENDIF}
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is
      /// positive or negative infinity. Return False otherwise.</para>
      /// </summary>
      class function IsInfinite_(const AValue: Single): Boolean; overload;
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is
      /// positive or negative infinity. Return False otherwise.</para>
      /// </summary>
      class function IsInfinite_(const AValue: Double): Boolean; overload;
      {$IFNDEF FPC}
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is
      /// positive or negative infinity. Return False otherwise.</para>
      /// </summary>
      class function IsInfinite_(const AValue: Extended): Boolean; overload;
      {$ENDIF}
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is finite,
      /// that is, it is normal, subnormal or zero, but not infinite or NaN.
      /// Return False otherwise.</para>
      /// </summary>
      class function IsFinite_(const AValue: Single): Boolean; overload;
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is finite,
      /// that is, it is normal, subnormal or zero, but not infinite or NaN.
      /// Return False otherwise.</para>
      /// </summary>
      class function IsFinite_(const AValue: Double): Boolean; overload;
      {$IFNDEF FPC}
      /// <summary>
      /// <para>Return True if the given floating-point number AValue is finite,
      /// that is, it is normal, subnormal or zero, but not infinite or NaN.
      /// Return False otherwise.</para>
      /// </summary>
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
