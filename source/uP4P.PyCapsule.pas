unit uP4P.PyCapsule;

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
  TPyCapsule = class
    public
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(pointer_: Pointer; const name_: string; destructor_: PyCapsule_Destructor): IPyObject;
      class function GetPointer(const capsule: IPyObject; const name_: string): Pointer;
      class function GetDestructor(const capsule: IPyObject): PyCapsule_Destructor;
      class function GetName(const capsule: IPyObject): string;
      class function GetContext(const capsule: IPyObject): Pointer;
      class function IsValid(const capsule: IPyObject; const name_: string): boolean;
      class function SetPointer(const capsule: IPyObject; pointer_: Pointer): boolean;
      class function SetDestructor(const capsule: IPyObject; destructor_: PyCapsule_Destructor): boolean;
      class function SetName(const capsule: IPyObject; const name_: string): boolean;
      class function SetContext(const capsule: IPyObject; context: Pointer): boolean;
      class function Import(const name_: string): Pointer;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCapsule.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCapsule_Type);
end;

class function TPyCapsule.New(pointer_: Pointer; const name_: string; destructor_: PyCapsule_Destructor): IPyObject;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_New) and assigned(pointer_) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := TPyObject.Wrap(PyCapsule_New(pointer_, TempNamePtr, destructor_));
    end
   else
    Result := nil;
end;

class function TPyCapsule.GetPointer(const capsule: IPyObject; const name_: string): Pointer;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_GetPointer) and
     TPyObject.IsInitialized(capsule) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := PyCapsule_GetPointer(capsule.PyObject, TempNamePtr);
    end
   else
    Result := nil;
end;

class function TPyCapsule.GetDestructor(const capsule: IPyObject): PyCapsule_Destructor;
begin
  if assigned(PyCapsule_GetDestructor) and
     TPyObject.IsInitialized(capsule) then
    Result := PyCapsule_GetDestructor(capsule.PyObject)
   else
    Result := nil;
end;

class function TPyCapsule.GetName(const capsule: IPyObject): string;
begin
  if assigned(PyCapsule_GetName) and
     TPyObject.IsInitialized(capsule) then
    Result := PyUTF8ToString(PyCapsule_GetName(capsule.PyObject))
   else
    Result := '';
end;

class function TPyCapsule.GetContext(const capsule: IPyObject): Pointer;
begin
  if assigned(PyCapsule_GetContext) and
     TPyObject.IsInitialized(capsule) then
    Result := PyCapsule_GetContext(capsule.PyObject)
   else
    Result := nil;
end;

class function TPyCapsule.IsValid(const capsule: IPyObject; const name_: string): boolean;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_IsValid) and
     TPyObject.IsInitialized(capsule) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := (PyCapsule_IsValid(capsule.PyObject, TempNamePtr) <> 0);
    end
   else
    Result := False;
end;

class function TPyCapsule.SetPointer(const capsule: IPyObject; pointer_: Pointer): boolean;
begin
  Result := assigned(PyCapsule_SetPointer) and
            TPyObject.IsInitialized(capsule) and
            assigned(pointer_) and
            (PyCapsule_SetPointer(capsule.PyObject, pointer_) = 0);
end;

class function TPyCapsule.SetDestructor(const capsule: IPyObject; destructor_: PyCapsule_Destructor): boolean;
begin
  Result := assigned(PyCapsule_SetDestructor) and
            TPyObject.IsInitialized(capsule) and
            (PyCapsule_SetDestructor(capsule.PyObject, destructor_) = 0);
end;

class function TPyCapsule.SetName(const capsule: IPyObject; const name_: string): boolean;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_SetName) and
     TPyObject.IsInitialized(capsule) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := (PyCapsule_SetName(capsule.PyObject, TempNamePtr) = 0);
    end
   else
    Result := False;
end;

class function TPyCapsule.SetContext(const capsule: IPyObject; context: Pointer): boolean;
begin
  Result := assigned(PyCapsule_SetContext) and
            TPyObject.IsInitialized(capsule) and
            (PyCapsule_SetContext(capsule.PyObject, context) = 0);
end;

class function TPyCapsule.Import(const name_: string): Pointer;
var
  TempName : AnsiString;
  TempNamePtr : PAnsiChar;
begin
  if assigned(PyCapsule_Import) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      // Changed in version 3.3: no_block has no effect anymore.
      Result := PyCapsule_Import(TempNamePtr, 0);
    end
   else
    Result := nil;
end;

end.
