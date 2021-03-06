unit UnitServerModule;

interface

uses
  Vcl.Dialogs, Winapi.ShellAPI;
procedure ExploreWeb(page: PChar);

implementation

procedure ExploreWeb(page: PChar);
var
  Returnvalue: integer;
begin
  Returnvalue := ShellExecute(0, 'open', page, nil, nil, 1);
  if Returnvalue <= 32 then
  begin
    case Returnvalue of
      0:
        Showmessage('Error: Sin memoria');
      2:
        Showmessage('Error: Archivo no encontrado');
      3:
        Showmessage('Error: Diretório no encontrado');
      11:
        Showmessage('Error: Archivo corrompido o inválido');
    end;
  end;
end;
end.
