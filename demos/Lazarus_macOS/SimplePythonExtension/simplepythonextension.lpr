library simplepythonextension;

{$mode objfpc}{$H+}

uses         
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, umain, uextensionmodule
  { you can add units after this };  

exports
  PyInit_simplepythonextension,
  PyModExport_simplepythonextension;

begin
  //
end.

