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
  /// <summary>
  /// Helper class for all PyCodec_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/codec.html#codec-registry-and-support-functions">See the article about Codec registry and support functions.</see></para>
  /// </remarks>
  TPyCodec = class
    public
      /// <summary>
      /// <para>Register a new codec search function.</para>
      /// <para>As a side effect, this tries to load the encodings package,
      /// if not yet done, to make sure that it is always first in the list of
      /// search functions.</para>
      /// </summary>
      class function Register_(const search_function: IPyObject): boolean;
      /// <summary>
      /// <para>Unregister a codec search function and clear the registry's
      /// cache. If the search function is not registered, do nothing.
      /// Return True on success. Raise an exception and return False on
      /// error.</para>
      /// </summary>
      class function Unregister(const search_function: IPyObject): boolean;
      /// <summary>
      /// <para>Return True or False depending on whether there is a registered
      /// codec for the given encoding. This function always succeeds.</para>
      /// </summary>
      class function KnownEncoding(const encoding: string): boolean;
      /// <summary>
      /// <para>Generic codec based encoding API.</para>
      /// <para>object_ is passed through the encoder function found for the
      /// given encoding using the error handling method defined by errors.
      /// errors may be nil to use the default method defined for the codec.
      /// Raises a LookupError if no encoder can be found.</para>
      /// </summary>
      class function Encode(const object_: IPyObject; const encoding, errors: string): IPyObject;
      /// <summary>
      /// <para>Generic codec based decoding API.</para>
      /// <para>object_ is passed through the decoder function found for the
      /// given encoding using the error handling method defined by errors.
      /// errors may be nil to use the default method defined for the codec.
      /// Raises a LookupError if no decoder can be found.</para>
      /// </summary>
      class function Decode(const object_: IPyObject; const encoding, errors: string): IPyObject;
      /// <summary>
      /// <para>Get an encoder function for the given encoding.</para>
      /// </summary>
      class function Encoder(const encoding: string): IPyObject;
      /// <summary>
      /// <para>Get a decoder function for the given encoding.</para>
      /// </summary>
      class function Decoder(const encoding: string): IPyObject;
      /// <summary>
      /// <para>Get an IncrementalEncoder object for the given encoding.</para>
      /// </summary>
      class function IncrementalEncoder(const encoding, errors: string): IPyObject;
      /// <summary>
      /// <para>Get an IncrementalDecoder object for the given encoding.</para>
      /// </summary>
      class function IncrementalDecoder(const encoding, errors: string): IPyObject;
      /// <summary>
      /// <para>Get a StreamReader factory function for the given
      /// encoding.</para>
      /// </summary>
      class function StreamReader(const encoding: string; const stream: IPyObject; const errors: string): IPyObject;
      /// <summary>
      /// <para>Get a StreamWriter factory function for the given
      /// encoding.</para>
      /// </summary>
      class function StreamWriter(const encoding: string; const stream: IPyObject; const errors: string): IPyObject;
      /// <summary>
      /// <para>Register the error handling callback function error under the
      /// given name. This callback function will be called by a codec when it
      /// encounters unencodable characters/undecodable bytes and name is
      /// specified as the error parameter in the call to the encode/decode
      /// function.</para>
      /// <para>The callback gets a single argument, an instance of
      /// UnicodeEncodeError, UnicodeDecodeError or UnicodeTranslateError that
      /// holds information about the problematic sequence of characters or
      /// bytes and their offset in the original string (see Unicode Exception
      /// Objects for functions to extract this information). The callback must
      /// either raise the given exception, or return a two-item tuple
      /// containing the replacement for the problematic sequence, and an
      /// integer giving the offset in the original string at which
      /// encoding/decoding should be resumed.</para>
      /// <para>Return True on success, False on error.</para>
      /// </summary>
      class function RegisterError(const name_: string; const error: IPyObject): boolean;
      /// <summary>
      /// <para>Lookup the error handling callback function registered under
      /// name. As a special case nil can be passed, in which case the error
      /// handling callback for "strict" will be returned.</para>
      /// </summary>
      class function LookupError(const name_: string): IPyObject;
      /// <summary>
      /// <para>Raise exc as an exception.</para>
      /// </summary>
      class function StrictErrors(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Ignore the unicode error, skipping the faulty input.</para>
      /// </summary>
      class function IgnoreErrors(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Replace the unicode encode error with ? or U+FFFD.</para>
      /// </summary>
      class function ReplaceErrors(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Replace the unicode encode error with XML character
      /// references.</para>
      /// </summary>
      class function XMLCharRefReplaceErrors(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Replace the unicode encode error with backslash escapes
      /// (\x, \u and \U).</para>
      /// </summary>
      class function BackslashReplaceErrors(const exc: IPyObject): IPyObject;
      /// <summary>
      /// <para>Replace the unicode encode error with \N{...} escapes.</para>
      /// </summary>
      class function NameReplaceErrors(const exc: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

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
