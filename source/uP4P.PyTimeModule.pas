unit uP4P.PyTimeModule;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.ImportedPyModule;

type
  /// <summary>
  /// <para>TPyTimeModule imports the "time" module and gets the
  /// "struct_time" type.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/time.html">See the article about time — Time access and conversions.</see></para>
  /// </remarks>
  TPyTimeModule = class(TImportedPyModule)
    protected
      FTimeStructType : Pointer;

      procedure Import; override;
      procedure Initialize; override;
      procedure Finalize; override;

    public
      /// <summary>
      /// <para>Return true if aPyObject is an instance of the "struct_time"
      /// type.</para>
      /// </summary>
      function CheckTimeStruct(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PyImport;

procedure TPyTimeModule.Initialize;
begin
  FTimeStructType := nil;
end;

procedure TPyTimeModule.Finalize;
begin
  DecRef(FTimeStructType);
end;

procedure TPyTimeModule.Import;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('time');

  if TPyObject.IsInitialized(TempModule) then
    TempModule.GetOptionalAttrString2('struct_time', FTimeStructType);
end;

function TPyTimeModule.CheckTimeStruct(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeStructType);
end;

end.
