unit uP4P.PyModuleSpecHelper;

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
  TPyModuleSpecHelper = class
    public
      /// <summary>
      /// Helper function to create a ModuleSpec object used by TPyModule.FromDefAndSpec
      /// </summary>
      /// <remarks>
      /// <para><see href="https://peps.python.org/pep-0451/">See PEP 451 – A ModuleSpec Type for the Import.</see></para>
      /// </remarks>
      class function FromModuleName(const name_: string): IPyObject; overload;
      {$IFDEF DELPHI12_UP}
      class function FromModuleName(const name_: AnsiString): IPyObject; overload;
      {$ENDIF}
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyUnicode, uP4P.PyTuple, uP4P.PyImport, uP4P.PyNone;

{$IFDEF DELPHI12_UP}
class function TPyModuleSpecHelper.FromModuleName(const name_: AnsiString): IPyObject;
var
  TempImportLib, TempSpecFromLoaderFunc, TempName, TempArgs, TempNone : IPyObject;
begin
  Result := nil;

  try
    TempImportLib := TPyImport.ImportModule('importlib.util');

    if TPyObject.IsInitialized(TempImportLib) then
      begin
        TempSpecFromLoaderFunc := TempImportLib.GetAttrString('spec_from_loader');
        TempName               := TPyUnicode.FromString(name_);
        TempNone               := TPyNone.New;

        if TPyObject.IsInitialized(TempSpecFromLoaderFunc) and
           TPyObject.IsInitialized(TempName) and
           TPyObject.IsInitialized(TempNone) then
          begin
            TempArgs := TPyTuple.Pack([TempName, TempNone]);
            Result   := TempSpecFromLoaderFunc.CallObject(TempArgs);
          end;
      end;
  finally
    TempNone               := nil;
    TempName               := nil;
    TempImportLib          := nil;
    TempArgs               := nil;
    TempSpecFromLoaderFunc := nil;
  end;
end;
{$ENDIF}

class function TPyModuleSpecHelper.FromModuleName(const name_: string): IPyObject;
var
  TempImportLib, TempSpecFromLoaderFunc, TempName, TempArgs, TempNone : IPyObject;
  TempArray : IPyObjectArray;
begin
  Result := nil;

  try
    TempImportLib := TPyImport.ImportModule('importlib.util');

    if TPyObject.IsInitialized(TempImportLib) then
      begin
        TempSpecFromLoaderFunc := TempImportLib.GetAttrString('spec_from_loader');
        TempName               := TPyUnicode.FromString(name_);
        TempNone               := TPyNone.New;

        if TPyObject.IsInitialized(TempSpecFromLoaderFunc) and
           TPyObject.IsInitialized(TempName) and
           TPyObject.IsInitialized(TempNone) then
          begin
            SetLength(TempArray, 2);
            TempArray[0] := TempName;
            TempArray[1] := TempNone;
            TempArgs     := TPyTuple.Pack(TempArray);
            Result       := TempSpecFromLoaderFunc.CallObject(TempArgs);
          end;
      end;
  finally
    TempNone               := nil;
    TempName               := nil;
    TempImportLib          := nil;
    TempArgs               := nil;
    TempSpecFromLoaderFunc := nil;
  end;
end;

end.
