unit uP4P.PyCodec;

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
  TPyCodec = class
    public
      class function Register_(const search_function: IPyObject): boolean;
      class function Unregister(const search_function: IPyObject): boolean;
      class function KnownEncoding(const encoding: string): boolean;
      class function Encode(const object_: IPyObject; const encoding, errors: string): IPyObject;
      class function Decode(const object_: IPyObject; const encoding, errors: string): IPyObject;
      class function Encoder(const encoding: string): IPyObject;
      class function Decoder(const encoding: string): IPyObject;
      class function IncrementalEncoder(const encoding, errors: string): IPyObject;
      class function IncrementalDecoder(const encoding, errors: string): IPyObject;
      class function StreamReader(const encoding: string; const stream: IPyObject; const errors: string): IPyObject;
      class function StreamWriter(const encoding: string; const stream: IPyObject; const errors: string): IPyObject;
      class function RegisterError(const name_: string; const error: IPyObject): boolean;
      class function LookupError(const name_: string): IPyObject;
      class function StrictErrors(const exc: IPyObject): IPyObject;
      class function IgnoreErrors(const exc: IPyObject): IPyObject;
      class function ReplaceErrors(const exc: IPyObject): IPyObject;
      class function XMLCharRefReplaceErrors(const exc: IPyObject): IPyObject;
      class function BackslashReplaceErrors(const exc: IPyObject): IPyObject;
      class function NameReplaceErrors(const exc: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCodec.Register_(const search_function: IPyObject): boolean;
begin
  Result := assigned(PyCodec_Register) and
            TPyObject.IsInitialized(search_function) and
            (PyCodec_Register(search_function.PyObject) = 0);
end;

class function TPyCodec.Unregister(const search_function: IPyObject): boolean;
begin
  Result := assigned(PyCodec_Unregister) and
            TPyObject.IsInitialized(search_function) and
            (PyCodec_Unregister(search_function.PyObject) = 0);
end;

class function TPyCodec.KnownEncoding(const encoding: string): boolean;
var
  TempEncoding : AnsiString;
begin
  Result := False;

  if assigned(PyCodec_KnownEncoding) then
    begin
      TempEncoding := StringToPyUTF8(encoding);
      Result       := (PyCodec_KnownEncoding(PAnsiChar(TempEncoding)) <> 0);
    end;
end;

class function TPyCodec.Encode(const object_: IPyObject; const encoding, errors: string): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
  TempErrorsPtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_Encode) and
     TPyObject.IsInitialized(object_) then
    begin
      TempEncoding := StringToPyUTF8(encoding);

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      Result := TPyObject.Wrap(PyCodec_Encode(object_.PyObject, PAnsiChar(TempEncoding), TempErrorsPtr));
    end;
end;

class function TPyCodec.Decode(const object_: IPyObject; const encoding, errors: string): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
  TempErrorsPtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_Decode) and
     TPyObject.IsInitialized(object_) then
    begin
      TempEncoding := StringToPyUTF8(encoding);

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      Result := TPyObject.Wrap(PyCodec_Decode(object_.PyObject, PAnsiChar(TempEncoding), TempErrorsPtr));
    end;
end;

class function TPyCodec.Encoder(const encoding: string): IPyObject;
var
  TempEncoding : AnsiString;
begin
  Result := nil;

  if assigned(PyCodec_Encoder) then
    begin
      TempEncoding := StringToPyUTF8(encoding);
      Result       := TPyObject.Wrap(PyCodec_Encoder(PAnsiChar(TempEncoding)));
    end;
end;

class function TPyCodec.Decoder(const encoding: string): IPyObject;
var
  TempEncoding : AnsiString;
begin
  Result := nil;

  if assigned(PyCodec_Decoder) then
    begin
      TempEncoding := StringToPyUTF8(encoding);
      Result       := TPyObject.Wrap(PyCodec_Decoder(PAnsiChar(TempEncoding)));
    end;
end;

class function TPyCodec.IncrementalEncoder(const encoding, errors: string): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
  TempErrorsPtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_IncrementalEncoder) then
    begin
      TempEncoding := StringToPyUTF8(encoding);

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      Result := TPyObject.Wrap(PyCodec_IncrementalEncoder(PAnsiChar(TempEncoding), TempErrorsPtr));
    end;
end;

class function TPyCodec.IncrementalDecoder(const encoding, errors: string): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
  TempErrorsPtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_IncrementalDecoder) then
    begin
      TempEncoding := StringToPyUTF8(encoding);

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      Result := TPyObject.Wrap(PyCodec_IncrementalDecoder(PAnsiChar(TempEncoding), TempErrorsPtr));
    end;
end;

class function TPyCodec.StreamReader(const encoding: string; const stream: IPyObject; const errors: string): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
  TempErrorsPtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_StreamReader) and
     TPyObject.IsInitialized(stream) then
    begin
      TempEncoding := StringToPyUTF8(encoding);

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      Result := TPyObject.Wrap(PyCodec_StreamReader(PAnsiChar(TempEncoding), stream.PyObject, TempErrorsPtr));
    end;
end;

class function TPyCodec.StreamWriter(const encoding: string; const stream: IPyObject; const errors: string): IPyObject;
var
  TempEncoding, TempErrors : AnsiString;
  TempErrorsPtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_StreamWriter) and
     TPyObject.IsInitialized(stream) then
    begin
      TempEncoding := StringToPyUTF8(encoding);

      if (length(errors) > 0) then
        begin
          TempErrors    := StringToPyUTF8(errors);
          TempErrorsPtr := PAnsiChar(TempErrors);
        end
       else
        TempErrorsPtr := nil;

      Result := TPyObject.Wrap(PyCodec_StreamWriter(PAnsiChar(TempEncoding), stream.PyObject, TempErrorsPtr));
    end;
end;

class function TPyCodec.RegisterError(const name_: string; const error: IPyObject): boolean;
var
  TempName : ANsiString;
begin
  Result := False;

  if assigned(PyCodec_RegisterError) and
     TPyObject.IsInitialized(error) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyCodec_RegisterError(PAnsiChar(TempName), error.PyObject) = 0);
    end;
end;

class function TPyCodec.LookupError(const name_: string): IPyObject;
var
  TempName    : ANsiString;
  TempNamePtr : PAnsiChar;
begin
  Result := nil;

  if assigned(PyCodec_LookupError) then
    begin
      if (length(name_) > 0) then
        begin
          TempName    := StringToPyUTF8(name_);
          TempNamePtr := PAnsiChar(TempName);
        end
       else
        TempNamePtr := nil;

      Result := TPyObject.Wrap(PyCodec_LookupError(TempNamePtr));
    end;
end;

class function TPyCodec.StrictErrors(const exc: IPyObject): IPyObject;
begin
  if assigned(PyCodec_StrictErrors) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyCodec_StrictErrors(exc.PyObject))
   else
    Result := nil;
end;

class function TPyCodec.IgnoreErrors(const exc: IPyObject): IPyObject;
begin
  if assigned(PyCodec_IgnoreErrors) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyCodec_IgnoreErrors(exc.PyObject))
   else
    Result := nil;
end;

class function TPyCodec.ReplaceErrors(const exc: IPyObject): IPyObject;
begin
  if assigned(PyCodec_ReplaceErrors) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyCodec_ReplaceErrors(exc.PyObject))
   else
    Result := nil;
end;

class function TPyCodec.XMLCharRefReplaceErrors(const exc: IPyObject): IPyObject;
begin
  if assigned(PyCodec_XMLCharRefReplaceErrors) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyCodec_XMLCharRefReplaceErrors(exc.PyObject))
   else
    Result := nil;
end;

class function TPyCodec.BackslashReplaceErrors(const exc: IPyObject): IPyObject;
begin
  if assigned(PyCodec_BackslashReplaceErrors) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyCodec_BackslashReplaceErrors(exc.PyObject))
   else
    Result := nil;
end;

class function TPyCodec.NameReplaceErrors(const exc: IPyObject): IPyObject;
begin
  if assigned(PyCodec_NameReplaceErrors) and
     TPyObject.IsInitialized(exc) then
    Result := TPyObject.Wrap(PyCodec_NameReplaceErrors(exc.PyObject))
   else
    Result := nil;
end;

end.
