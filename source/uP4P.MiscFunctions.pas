unit uP4P.MiscFunctions;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    {$IFDEF MSWINDOWS}WinApi.Windows, System.Classes,{$ENDIF}
    {$IFDEF FMX}FMX.Types, FMX.Platform,{$ENDIF} System.SysUtils,
  {$ELSE}
    {$IFDEF MSWINDOWS}Windows, Classes,{$ENDIF} SysUtils,
    {$IFDEF LINUXFPC}Types,{$ENDIF}
  {$ENDIF}
  uP4P.Types;

/// <summary>
/// Retrieves the fully qualified path for the current module.
/// </summary>
/// <remarks>
/// <para><see href="https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew">See the GetModuleFileNameW article.</see></para>
/// </remarks>
function  GetModulePath : string;
procedure OutputDebugMessage(const aMessage : string);
function  CustomExceptionHandler(const aFunctionName : string; const aException : exception) : boolean;
procedure ShowErrorMessageDlg(const aError : string);

function PyUTF8ToString(aString: PAnsiChar; aFreeMem : boolean = False): string;
function StringToPyUTF8(const aString: string): AnsiString;

{$IFDEF MSWINDOWS}
function UnicodeStringToAnsiString(const aString: UnicodeString): AnsiString;
function AnsiStringToUnicodeString(const aString: AnsiString): UnicodeString;
{$ENDIF}

function PyWCharTStringToString(const aString: WCharTString): string;
function StringToPyWCharTString(const aString: string): WCharTString;

function WCharTArrayToStringList(aItems: PPWCharT; aLength: NativeInt; var aResultSL: TStringList): boolean;
function PyWideStringListToStringList(const aList: PyWideStringList; var aResultSL: TStringList): boolean;

function ErrorToAnsiString(error: TPyCodecErrors): AnsiString;

function PyStartSymbolToInt(start: TPyStartSymbols): integer;

implementation

uses
  {$IFDEF LINUXFPC}lcltype, Forms,{$ENDIF}
  uP4P.Loader, uP4P.LibFunctions, uP4P.PyMem, uP4P.Constants;

function GetModulePath : string;
{$IFDEF MACOSX}
const
  MAC_APP_POSTFIX = '.app/';
  MAC_APP_SUBPATH = 'Contents/MacOS/';
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(GetModuleName(HINSTANCE{$IFDEF FPC}(){$ENDIF})));
  {$ENDIF}

  {$IFDEF LINUX}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
  {$ENDIF}

  {$IFDEF MACOSX}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));

  {$IFDEF FPC}
  if copy(Result, Length(Result) + 1 - Length(MAC_APP_POSTFIX) - Length(MAC_APP_SUBPATH)) = MAC_APP_POSTFIX + MAC_APP_SUBPATH then
    SetLength(Result, Length(Result) - Length(MAC_APP_SUBPATH));

  Result := CreateAbsolutePath(Result, GetCurrentDirUTF8);
  {$ELSE}
  if Result.Contains(MAC_APP_POSTFIX + MAC_APP_SUBPATH) then
    Result := Result.Remove(Result.IndexOf(MAC_APP_SUBPATH));
  {$ENDIF}
  {$ENDIF}
end;

procedure OutputDebugMessage(const aMessage : string);
begin
  {$IFDEF DEBUG}
    {$IFDEF MSWINDOWS}
      {$IFDEF FMX}
        FMX.Types.Log.d(aMessage);
      {$ELSE}
        OutputDebugString({$IFDEF DELPHI12_UP}PWideChar{$ELSE}PAnsiChar{$ENDIF}(aMessage + chr(0)));
      {$ENDIF}
    {$ENDIF}

    {$IFDEF LINUX}
      {$IFDEF FPC}
        // TO-DO: Find a way to write in the error console using Lazarus in Linux
      {$ELSE}
        FMX.Types.Log.d(aMessage);
      {$ENDIF}
    {$ENDIF}
    {$IFDEF MACOSX}
      {$IFDEF FPC}
        // TO-DO: Find a way to write in the error console using Lazarus in MacOS
      {$ELSE}
        FMX.Types.Log.d(aMessage);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function CustomExceptionHandler(const aFunctionName : string; const aException : exception) : boolean;
begin
  OutputDebugMessage(aFunctionName + ' error : ' + aException.message);

  Result := (GlobalP4PLoader <> nil) and GlobalP4PLoader.ReRaiseExceptions;
end;

procedure ShowErrorMessageDlg(const aError : string);
begin
  OutputDebugMessage(aError);

  if (GlobalP4PLoader <> nil) and GlobalP4PLoader.ShowMessageDlg then
    begin
      {$IFDEF MSWINDOWS}
      MessageBox(0, PChar(aError + #0), PChar('Error' + #0), MB_ICONERROR or MB_OK or MB_TOPMOST);
      {$ENDIF}

      {$IFDEF LINUX}
        {$IFDEF FPC}
        Application.MessageBox(PChar(aError + #0), PChar('Error' + #0), MB_ICONERROR or MB_OK)
        {$ELSE}
        // TO-DO: Find a way to show message boxes in FMXLinux
        {$ENDIF}
      {$ENDIF}

      {$IFDEF MACOSX}
        {$IFDEF FPC}
        // TO-DO: Find a way to show message boxes in Lazarus/FPC for MacOS
        {$ELSE}
        ShowMessageCF('Error', aError, 10);
        {$ENDIF}
      {$ENDIF}
    end;
end;

function PyUTF8ToString(aString: PAnsiChar; aFreeMem : boolean): string;
begin
  if assigned(aString) then
    begin
      {$IFDEF FPC}
      Result := aString;
      {$ELSE}
        {$IFDEF DELPHI12_UP}
        Result := UTF8ToString(RawByteString(aString));
        {$ELSE}
        Result := UTF8Decode(UTF8String(aString));
        {$ENDIF}
      {$ENDIF}
      if aFreeMem then
        TPyMem.Free(aString);
    end
   else
    Result := '';
end;

function StringToPyUTF8(const aString: string): AnsiString;
begin
  {$IFDEF FPC}
  Result := aString + #0;
  {$ELSE}
  Result := UTF8Encode(aString) + #0;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}
function UnicodeStringToAnsiString(const aString: UnicodeString): AnsiString;
var
  TempLen : integer;
begin
  TempLen := WideCharToMultiByte(CP_ACP, WC_NO_BEST_FIT_CHARS, PWideChar(aString), length(aString), nil, 0, nil, nil);

  if (TempLen > 0) then
    begin
      SetLength(Result, TempLen);
      WideCharToMultiByte(CP_ACP, WC_NO_BEST_FIT_CHARS, PWideChar(aString), length(aString), @Result[1], TempLen, nil, nil);
    end;
end;

function AnsiStringToUnicodeString(const aString: AnsiString): UnicodeString;
var
  TempLen : integer;
begin
  TempLen := MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, @aString[1], -1, nil, 0);

  if (TempLen > 0) then
    begin
      SetLength(Result, TempLen);
      MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, @aString[1], -1, PWideChar(Result), TempLen);
    end;
end;
{$ENDIF}

function PyWCharTStringToString(const aString: WCharTString): string;
begin
  {$IFDEF POSIX}
  Result := UCS4StringToUnicodeString(aString);
  {$ELSE}
    {$IFDEF FPC}
      Result := UTF8Encode(aString);
    {$ELSE}
      {$IFDEF DELPHI12_UP}
      Result := aString;
      {$ELSE}
      Result := UnicodeStringToAnsiString(aString);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function StringToPyWCharTString(const aString: string): WCharTString;
begin
  {$IFDEF POSIX}
  Result := UnicodeStringToUCS4String(aString);
  {$ELSE}
    {$IFDEF FPC}
      Result := UTF8Decode(aString);
    {$ELSE}
      {$IFDEF DELPHI12_UP}
      Result := aString;
      {$ELSE}
      Result := AnsiStringToUnicodeString(aString);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function WCharTArrayToStringList(aItems: PPWCharT; aLength: NativeInt; var aResultSL: TStringList): boolean;
var
  TempItem : PWCharT;
  i        : NativeInt;
begin
  Result := False;
  if not(assigned(aResultSL)) or (aLength <= 0) then exit;

  aResultSL.Clear;

  for i := 0 to pred(aLength) do
    begin
      TempItem := PWCharT(aItems^);
      aResultSL.Add(PyWCharTStringToString(WCharTString(TempItem)));
      inc(aItems);
    end;

  Result := True;
end;

function PyWideStringListToStringList(const aList: PyWideStringList; var aResultSL: TStringList): boolean;
begin
  Result := WCharTArrayToStringList(aList.items, aList.length, aResultSL);
end;

function ErrorToAnsiString(error: TPyCodecErrors): AnsiString;
begin
  case error of
    pceStrict  : Result := 'strict' + #0;
    pceReplace : Result := 'replace' + #0;
    pceIgnore  : Result := 'ignore' + #0;
    else         Result := 'surrogateescape' + #0;
  end;
end;

function PyStartSymbolToInt(start: TPyStartSymbols): integer;
begin
  case start of
    ssSingle   : Result := Py_single_input;
    ssFile     : Result := Py_file_input;
    ssEval     : Result := Py_eval_input;
    ssFuncType : Result := Py_func_type_input;
    else         Result := Py_file_input;
  end;
end;

end.
