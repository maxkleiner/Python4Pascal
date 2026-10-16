unit uP4P.PyMemberDef;

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
  TPyMemberDef = class
    protected
      FMemberDef  : PyMemberDef;
      FName       : AnsiString;
      FDoc        : AnsiString;

      function  GetName: AnsiString;
      function  GetType: integer;
      function  GetOffset: Py_ssize_t;
      function  GetFlags: integer;
      function  GetDoc: AnsiString;
      function  GetMemberDef: PyMemberDef;
      function  GetIsSentinel: boolean;

      procedure SetName(const aValue: AnsiString);
      procedure SetType(aValue: integer);
      procedure SetOffset(aValue: Py_ssize_t);
      procedure SetFlags(aValue: integer);
      procedure SetDoc(const aValue: AnsiString);

    public
      constructor Create(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t);

      property Name_      : AnsiString    read  GetName        write SetName;
      property Type_      : integer       read  GetType        write SetType;
      property Offset     : Py_ssize_t    read  GetOffset      write SetOffset;
      property Flags      : integer       read  GetFlags       write SetFlags;
      property Doc        : AnsiString    read  GetDoc         write SetDoc;
      property MemberDef  : PyMemberDef   read  GetMemberDef;
      property IsSentinel : boolean       read  GetIsSentinel;
  end;

implementation

uses
  uP4P.MiscFunctions;

constructor TPyMemberDef.Create(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t);
begin
  inherited Create;

  Name_  := StringToPyUTF8(aName);
  Type_  := aType;
  Offset := aOffset;
  Flags  := aFlags;
  Doc    := StringToPyUTF8(aDocStrings);
end;

function TPyMemberDef.GetDoc: AnsiString;
begin
  Result := FDoc;
end;

function TPyMemberDef.GetFlags: integer;
begin
  Result := FMemberDef.flags;
end;

function TPyMemberDef.GetMemberDef: PyMemberDef;
begin
  Result := FMemberDef;
end;

function TPyMemberDef.GetIsSentinel: boolean;
begin
  Result := not(assigned(FMemberDef.name)) and
            (FMemberDef.type_  = 0) and
            (FMemberDef.offset = 0) and
            (FMemberDef.flags  = 0) and
            not(assigned(FMemberDef.doc));
end;

function TPyMemberDef.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyMemberDef.GetOffset: Py_ssize_t;
begin
  Result := FMemberDef.offset;
end;

function TPyMemberDef.GetType: integer;
begin
  Result := FMemberDef.type_;
end;

procedure TPyMemberDef.SetDoc(const aValue: AnsiString);
begin
  FDoc           := aValue;
  FMemberDef.doc := PAnsiChar(FDoc);
end;

procedure TPyMemberDef.SetFlags(aValue: integer);
begin
  FMemberDef.flags := aValue;
end;

procedure TPyMemberDef.SetName(const aValue: AnsiString);
begin
  FName           := aValue;
  FMemberDef.name := PAnsiChar(FName);
end;

procedure TPyMemberDef.SetOffset(aValue: Py_ssize_t);
begin
  FMemberDef.offset := aValue;
end;

procedure TPyMemberDef.SetType(aValue: integer);
begin
  FMemberDef.type_ := aValue;
end;

end.
