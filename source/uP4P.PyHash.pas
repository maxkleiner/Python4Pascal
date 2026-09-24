unit uP4P.PyHash;

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
  uP4P.LibFunctions, uP4P.Types;

type
  /// <summary>
  /// Helper class for all PyHash_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/hash.html#pyhash-api">See the article about PyHash API.</see></para>
  /// </remarks>
  TPyHash = class
    public
      /// <summary>
      /// <para>Get the hash function definition.</para>
      /// <para>See also PEP 456 "Secure and interchangeable hash
      /// algorithm".</para>
      /// </summary>
      class function GetFuncDef: PPyHash_FuncDef;
  end;

implementation

class function TPyHash.GetFuncDef: PPyHash_FuncDef;
begin
  if assigned(PyHash_GetFuncDef) then
    Result := PyHash_GetFuncDef()
   else
    Result := nil;
end;

end.
