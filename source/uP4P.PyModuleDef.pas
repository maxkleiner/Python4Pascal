unit uP4P.PyModuleDef;

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
  /// <summary>
  /// Helper class for all PyModuleDef_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/extension-modules.html#multi-phase-initialization">See the article about Multi-phase initialization.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  TPyModuleDef = class
    public
      /// <summary>
      /// <para>Ensure a module definition is a properly initialized Python
      /// object that correctly reports its type and a reference count.</para>
      /// <para>Return def cast to PPyObject, or nil if an error occurred.</para>
      /// <para>Calling this function is required for Multi-phase
      /// initialization. It should not be used in other contexts.</para>
      /// <para>Note that Python assumes that PyModuleDef structures are
      /// statically allocated. This function may return either a new reference
      /// or a borrowed one; this reference must not be released.</para>
      /// </summary>
      class function Init(const def: PyModuleDef): PPyObject;
  end;

implementation

class function TPyModuleDef.Init(const def: PyModuleDef): PPyObject;
begin
  if assigned(PyModuleDef_Init) then
    Result := PyModuleDef_Init(@def)
   else
    Result := nil;
end;

end.
