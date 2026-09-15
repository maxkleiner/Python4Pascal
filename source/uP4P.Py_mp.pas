unit uP4P.Py_mp;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

type
  /// <summary>
  /// Helper class to get the correct values of Py_mp_* constants that
  /// changed in recent Python versions.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#mapping-object-structures">See the article about Mapping Object Structures.</see></para>
  /// </remarks>
  TPy_mp = class
    public
      /// <summary>
      /// <para>This function returns the correct value for Py_mp_subscript</para>
      /// <para>The slot ID Py_mp_subscript corresponds to PyMappingMethods.mp_subscript.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyMappingMethods.mp_subscript">See the article about PyMappingMethods.mp_subscript.</see></para>
      /// </remarks>
      class function subscript: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mp_ass_subscript</para>
      /// <para>The slot ID Py_mp_ass_subscript corresponds to PyMappingMethods.mp_ass_subscript.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyMappingMethods.mp_ass_subscript">See the article about PyMappingMethods.mp_ass_subscript.</see></para>
      /// </remarks>
      class function ass_subscript: integer;
      /// <summary>
      /// <para>This function returns the correct value for Py_mp_length</para>
      /// <para>The slot ID Py_mp_length corresponds to PyMappingMethods.mp_length.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyMappingMethods.mp_length">See the article about PyMappingMethods.mp_length.</see></para>
      /// </remarks>
      class function length: integer;
  end;

implementation

uses
  uP4P.Engine;

class function TPy_mp.ass_subscript: integer;
begin
  Result := 5;
end;

class function TPy_mp.length: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 91
   else
    Result := 4;
end;

class function TPy_mp.subscript: integer;
begin
  if assigned(GlobalP4PEngine) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := 90
   else
    Result := 3;
end;

end.
