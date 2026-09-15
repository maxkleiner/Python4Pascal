unit uP4P.Py_bf;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

type
  /// <summary>
  /// Helper class to get the correct values of Py_bf_* constants that
  /// changed in recent Python versions.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#buffer-object-structures">See the article about Buffer Object Structures.</see></para>
  /// </remarks>
  TPy_bf = class
    public
      /// <summary>
      /// <para>This function returns the correct value for Py_bf_getbuffer</para>
      /// <para>The slot ID Py_bf_getbuffer corresponds to PyBufferProcs.bf_getbuffer.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyBufferProcs.bf_getbuffer">See the article about PyBufferProcs.bf_getbuffer.</see></para>
      /// </remarks>
      class function getbuffer: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_bf_releasebuffer</para>
      /// <para>The slot ID Py_bf_releasebuffer corresponds to PyBufferProcs.bf_releasebuffer.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyBufferProcs.bf_releasebuffer">See the article about PyBufferProcs.bf_releasebuffer.</see></para>
      /// </remarks>
      class function releasebuffer: integer;
  end;

implementation

uses
  uP4P.Engine;

class function TPy_bf.getbuffer: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 88
   else
    Result := 1;
end;

class function TPy_bf.releasebuffer: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 89
   else
    Result := 2;
end;

end.
