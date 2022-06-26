

unit UnitAuditoria;

{$INCLUDE 'compilador.inc'}

interface

uses
  Windows, IniFiles, System.SysUtils, Forms, Vcl.Dialogs, Data.DB;

  procedure CargarValoresAuditoria(Dataset: TDataSet);

implementation

uses
    {$IFNDEF DSSERVER}
    DataModuleUsuario,
    {$ENDIF}

    {$IFDEF WEB}
    ServerModule, uniGUIApplication,
    {$ENDIF}

   // UnitLog,
     UnitRecursoString;


procedure CargarValoresAuditoria(DataSet: TDataSet);
begin
  // Utilizo este procedimiento para cargar los valores de usuario y fecha hora actual a modo de aditoria
  try
    {$IFDEF SDAC}
       //Urev-Usuario
      if (DataSet.FindField('UrevUsuario') <> nil) then
      begin
        if Dataset.State = dsInsert then
        begin
           DataSet.FieldByName('UrevUsuario').AsString := DMUsuario.UsuarioRecord.LoginUsuario;
        end
        else if Dataset.State = dsEdit then
          begin
             DataSet.FieldByName('UrevUsuario').AsString := 'Editado - ' + DMUsuario.UsuarioRecord.LoginUsuario;;
          end;
      end;

      //Urev-FechaHora
      if Dataset.State in dsEditModes then
      begin
        if ((DataSet.FindField('UrevFechaHora') <> nil)) then
        begin
          DataSet.FieldByName('UrevFechaHora').AsDateTime := Now();
        end;
      end;
    {$ENDIF}


    {$IFDEF DEBUG}
      //Log('UnitAuditoria.CargarValoresAuditoria ' + Dataset.Name);
    {$ENDIF}

  except
    on E: Exception do
    begin

      {$IF (DEFINED(DESKTOP) OR DEFINED(SERVICE))}
      Log(EExcepcion + 'Error al cargar auditoria '+ DataSet.Name);
      {$ENDIF}

      {$IFDEF WEB}
     // UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + 'Error al cargar auditoria '+ DataSet.Name);
      {$ENDIF}

      Abort;
    end;
  end;

end;



end.
