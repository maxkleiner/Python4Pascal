unit uCustomThread;

interface

uses
  uP4P.Thread;

type
  TCustomThread = class(TP4PThread)
    protected
      FCode : string;
      procedure ExecuteWithPython; override;

    public
      property Code : string read FCode write FCode;
  end;

implementation

uses
  uP4P.PyRun;

procedure TCustomThread.ExecuteWithPython;
begin
  TPyRun.SimpleString(FCode);
end;

end.
