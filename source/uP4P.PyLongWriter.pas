unit uP4P.PyLongWriter;

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
  /// A Python int writer instance.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#c.PyLongWriter">See the article about PyLongWriter.</see></para>
  /// </remarks>
  TPyLongWriter = class(TInterfacedObject, IPyLongWriter)
    protected
      FPyLongWriter : PPyLongWriter;

      function GetInitialized: boolean;
      /// <summary>
      /// <para>Discard a PyLongWriter created by PyLongWriter_Create().</para>
      /// <para>If writer is nil, no operation is performed.</para>
      /// <para>The writer instance and the digits array are invalid after the
      /// call.</para>
      /// </summary>
      procedure Discard;

    public
      constructor Create(writer: PPyLongWriter);
      destructor  Destroy; override;
      /// <summary>
      /// <para>Finish a PyLongWriter created by PyLongWriter_Create().</para>
      /// <para>On success, return a Python int object. On error, set an
      /// exception and return nil.</para>
      /// <para>The function takes care of normalizing the digits and converts
      /// the object to a compact integer if needed.</para>
      /// <para>The writer instance and the digits array are invalid after the
      /// call.</para>
      /// </summary>
      function    Finish: IPyObject;

      /// <summary>
      /// <para>Create a PyLongWriter.</para>
      /// <para>On success, allocate *digits and return a writer. On error, set
      /// an exception and return nil.</para>
      /// <para>negative is True if the number is negative, or False
      /// otherwise.</para>
      /// <para>ndigits is the number of digits in the digits array. It must be
      /// greater than 0.</para>
      /// <para>digits must not be nil.</para>
      /// <para>After a successful call to this function, the caller should fill
      /// in the array of digits digits and then call PyLongWriter_Finish() to
      /// get a Python int. The layout of digits is described by
      /// PyLong_GetNativeLayout().</para>
      /// <para>Digits must be in the range [0; (1 << bits_per_digit) - 1]
      /// (where the bits_per_digit is the number of bits per digit).
      /// Any unused most significant digits must be set to 0.</para>
      /// <para>Alternately, call PyLongWriter_Discard() to destroy the writer
      /// instance without creating an int object.</para>
      /// </summary>
      class function New(negative: boolean; ndigits: Py_ssize_t; var digits: Pointer): IPyLongWriter;
      /// <summary>
      /// Returns true if this class is fully initialized.
      /// </summary>
      property Initialized : boolean read GetInitialized;
  end;

implementation

constructor TPyLongWriter.Create(writer: PPyLongWriter);
begin
  inherited Create;
  FPyLongWriter := writer;
end;

destructor TPyLongWriter.Destroy;
begin
  Discard;
  inherited Destroy;
end;

function TPyLongWriter.GetInitialized: boolean;
begin
  Result := (FPyLongWriter <> nil);
end;

function TPyLongWriter.Finish: IPyObject;
var
  TempObject : PPyObject;
begin
  Result := nil;
  if Initialized and assigned(PyLongWriter_Finish) then
    begin
      TempObject := PyLongWriter_Finish(FPyLongWriter);

      if assigned(TempObject) then
        begin
          Result        := TPyObject.Wrap(TempObject);
          FPyLongWriter := nil;
        end;
    end;
end;

procedure TPyLongWriter.Discard;
begin
  if Initialized and assigned(PyLongWriter_Discard) then
    begin
      PyLongWriter_Discard(FPyLongWriter);
      FPyLongWriter := nil;
    end;
end;

class function TPyLongWriter.New(negative: boolean; ndigits: Py_ssize_t; var digits: Pointer): IPyLongWriter;
begin
  if assigned(PyLongWriter_Create) then
    Result := Create(PyLongWriter_Create(ord(negative), ndigits, digits))
   else
    Result := nil;
end;

end.
