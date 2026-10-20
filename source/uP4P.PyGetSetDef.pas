unit uP4P.PyGetSetDef;

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
  uP4P.Types;

type
  /// <summary>
  /// Class used to define property-like access for a type. See also description
  /// of the PyTypeObject.tp_getset slot.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyGetSetDef">See the article about PyGetSetDef.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#common-object-structures">See the article about Common Object Structures.</see></para>
  /// </remarks>
  TPyGetSetDef = class
    protected
      FGetSetDef  : PyGetSetDef;
      FName       : AnsiString;
      FDoc        : AnsiString;

      function  GetName: AnsiString;
      function  GetGet_: getter;
      function  GetSet_: setter;
      function  GetClosure: pointer;
      function  GetDoc: AnsiString;
      function  GetGetSetDef: PyGetSetDef;
      function  GetIsSentinel: boolean;

      procedure SetName(const aValue: AnsiString);
      procedure SetGet_(const aValue: getter);
      procedure SetSet_(const aValue: setter);
      procedure SetClosure(const aValue: pointer);
      procedure SetDoc(const aValue: AnsiString);

    public
      constructor Create(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer);
      /// <summary>
      /// attribute name
      /// </summary>
      property Name_      : AnsiString    read  GetName       write SetName;
      /// <summary>
      /// function to get the attribute.
      /// </summary>
      property Get_       : getter        read  GetGet_       write SetGet_;
      /// <summary>
      /// Optional function to set or delete the attribute. If nil, the attribute
      /// is read-only.
      /// </summary>
      property Set_       : setter        read  GetSet_       write SetSet_;
      /// <summary>
      /// optional docstring
      /// </summary>
      property Doc        : AnsiString    read  GetDoc        write SetDoc;
      /// <summary>
      /// Optional user data pointer, providing additional data for getter and
      /// setter.
      /// </summary>
      property Closure    : pointer       read  GetClosure    write SetClosure;
      /// <summary>
      /// Return the PyGetSetDef record.
      /// </summary>
      property GetSetDef  : PyGetSetDef   read  GetGetSetDef;
      /// <summary>
      /// Return True if all the PyGetSetDef fields are nil.
      /// </summary>
      property IsSentinel : boolean       read  GetIsSentinel;
  end;

implementation

uses
  uP4P.MiscFunctions;

constructor TPyGetSetDef.Create(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer);
begin
  inherited Create;

  Name_   := StringToPyUTF8(aName);
  Get_    := aGet;
  Set_    := aSet;
  Closure := aClosure;
  Doc     := StringToPyUTF8(aDocStrings);
end;

function TPyGetSetDef.GetClosure: pointer;
begin
  Result := FGetSetDef.closure;
end;

function TPyGetSetDef.GetDoc: AnsiString;
begin
  Result := FDoc;
end;

function TPyGetSetDef.GetGetSetDef: PyGetSetDef;
begin
  Result := FGetSetDef;
end;

function TPyGetSetDef.GetIsSentinel: boolean;
begin
  Result := not(assigned(FGetSetDef.name)) and
            not(assigned(FGetSetDef.get))  and
            not(assigned(FGetSetDef.set_)) and
            not(assigned(FGetSetDef.doc));
end;

function TPyGetSetDef.GetGet_: getter;
begin
  Result := FGetSetDef.get;
end;

function TPyGetSetDef.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyGetSetDef.GetSet_: setter;
begin
  Result := FGetSetDef.set_;
end;

procedure TPyGetSetDef.SetClosure(const aValue: pointer);
begin
  FGetSetDef.closure := aValue;
end;

procedure TPyGetSetDef.SetDoc(const aValue: AnsiString);
begin
  FDoc           := aValue;
  FGetSetDef.doc := PAnsiChar(FDoc);
end;

procedure TPyGetSetDef.SetGet_(const aValue: getter);
begin
  FGetSetDef.get := aValue;
end;

procedure TPyGetSetDef.SetName(const aValue: AnsiString);
begin
  FName           := aValue;
  FGetSetDef.name := PAnsiChar(FName);
end;

procedure TPyGetSetDef.SetSet_(const aValue: setter);
begin
  FGetSetDef.set_ := aValue;
end;

end.
