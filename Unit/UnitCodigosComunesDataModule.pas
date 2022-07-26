

unit UnitCodigosComunesDataModule;

{$INCLUDE 'compilador.inc'}

interface

uses

  System.Classes, System.StrUtils, System.Variants, System.DateUtils, Vcl.Controls, Vcl.Graphics,
  Vcl.Dialogs, Vcl.Forms,

  {$IFDEF DESKTOP}
  // Unit de DevExpress
  {$ENDIF}

  {$IFDEF WEB}
  ServerModule, UniGuiApplication, uniGUIForm, uniGUIDialogs,
  {$ENDIF}

  MSAccess, DBAccess, Data.DB,

  System.Contnrs, System.SysUtils, System.TypInfo;

type
  TSimpleProcedure = reference to procedure;

  // Eventos estandares DM
  procedure DMBeforeUpdateExecute(Sender: TCustomMSDataSet; Params: TMSParams);
  {$IFDEF WEB}
  procedure DMBeforeInsert(Formulario: TUniForm = nil);
  procedure DMBeforeEdit(Formulario: TUniForm = nil; MSQuery: TMSQuery = nil; VerificarFiniquitado: Boolean = False);
  function DMBeforeDelete(Formulario: TUniForm = nil; MSQuery: TMSQuery = nil; Tabla: string=''; PrimaryField: TField = nil; VerificarDatoRelacionado: Boolean = False; ConfirmarBorrado: Boolean = False; VerificarPermiso: Boolean = False; VerificarFiniquitado: Boolean = False; Menu: string =''): Boolean;
  {$ENDIF}

  procedure DMCalcFields(DataSet: TDataSet);
  procedure DMAfterCancel(Formulario: TCustomForm = nil);
  procedure DMAfterPost(Formulario: TCustomForm = nil);
  procedure DMBeforePost(DataSet: TDataSet);




  {$IFDEF WEB}
  procedure DMPostError(Formulario: TUniForm; E: EDatabaseError; var Action: TDataAction);
  {$ENDIF}
  procedure AsignarPrincipal(DataModule: string; DataSet: TArray<TDataSet>); overload;
  procedure AsignarPrincipal(DataModule: TDataModule); overload;

  procedure ActivarCacheUpdate(Datasets: TArray<TCustomMSDataSet>); overload;
  procedure ActivarCacheUpdate(DataModule: TDataModule); overload;

  procedure ActivarDataSets(DataModule: string; DataSet: TArray<TDataSet>; CerrarDataset: Boolean = true);
  {$REGION 'Documentation'}
  /// <summary>
  ///   Activa los datasets de detalles utilizando un campo del maestro como
  ///   referencia
  /// </summary>
  /// <param name="DataSet">
  ///   Un arreglo de datasets que contiene una lista
  /// </param>
  /// <param name="CampoIdDetalle">
  ///   El campo de maestro utilizado
  /// </param>
  /// <example>
  ///   <para>
  ///     ActivarDataSetsDetalle([MSPersonalFuncionCategoria,
  ///     MSPersonalFuncionContrato, MSHistoricoAntiguedad, <br />
  ///     MSPersonalFuncionBonificacion, MSPersonalFuncionHistorico,
  ///     MSHistoricoPersonalOrganigrama, <br />MSHistoricoCargaHoraria,
  ///     MSHistoricoDesvinculacionFuncion],
  ///   </para>
  ///   <para>
  ///     Aqui el campo que se utiliza del dataset maestro <br />
  ///     MSPersonalFuncionIdPersonalFuncion);
  ///   </para>
  /// </example>
  {$ENDREGION}
  procedure ActivarDataSetsDetalle(DataSet: TArray<TDataSet>; CampoIdDetalle: TField);
  {$IFDEF WEB}
  {$REGION 'Documentation'}
  /// <summary>
  ///   <para>
  ///     Mueve al ultimo registro antes de mostrar en formulario, solo
  ///     funciona cuando se llama desde el MainForm y se utiliza un
  ///     formulario del tipo TFrmCrudMaestro.
  ///   </para>
  ///   <para>
  ///     Lo ideal es usar en el evento show o beforeshow
  ///   </para>
  /// </summary>
  /// <param name="Dataset">
  ///   El dataset principal que que contiene la referencia
  /// </param>
  /// <param name="Formulario">
  ///   El formulario desde donde se llama
  /// </param>
  {$ENDREGION}
  procedure IrUltimoRegistro(Dataset: TMSQuery; Formulario: TUniForm);
  {$ENDIF}

  function OmitirEventos_y_Ejecutar(Dataset: TDataSet; Procedimiento: TSimpleProcedure): Boolean;

  procedure DMVerificarEstadoEdicion(DataSet: TDataSet);


implementation

uses
//UnitLog,
UnitCodigosComunes,
DataModulePrincipal,

  {$IFDEF WEB}
  FormularioCRUDMaestro,
  {$ENDIF}
  UnitRecursoString,

  {$IFDEF SDAC}
  DataModuleUsuario,
  //UnitOrganizacionSeleccionada,
  {$ENDIF}

  UnitValidaciones, UnitCodigosComunesFormulario, UnitAuditoria, FormularioUsuario;//,
  //UnitAuditoria,
  //UnitDatos,
  //UnitLogParametro,



function OmitirEventos_y_Ejecutar(Dataset: TDataSet; Procedimiento: TSimpleProcedure): Boolean;
{ Ejemplo
  // Agrego el movimiento de los documentos de la entrada
  OmitirEventos_y_Ejecutar(Dataset,
    procedure
      begin
            //Intrucir bloque de codigo
      end);
}
begin
  try
    // en caso de no activar
    if not(Dataset.Active) then
    begin
      Dataset.Open;
    end;

    {$IFDEF WEB}
    // Guardo temporalmente los metodos del dataset
    DMPrincipal.MSQuerySQL.AfterCancel := Dataset.AfterCancel;
    DMPrincipal.MSQuerySQL.BeforePost := Dataset.BeforePost;
    DMPrincipal.MSQuerySQL.AfterPost := Dataset.AfterPost;
    DMPrincipal.MSQuerySQL.BeforeInsert := Dataset.BeforeInsert;
    DMPrincipal.MSQuerySQL.BeforeEdit := Dataset.BeforeEdit;
    DMPrincipal.MSQuerySQL.AfterScroll := Dataset.AfterScroll;
    {$ENDIF}

    Dataset.BeforePost := nil;
    Dataset.AfterPost := nil;
    Dataset.BeforeInsert := nil;
    Dataset.BeforeEdit := nil;
    Dataset.AfterScroll := nil;
    Dataset.AfterCancel := nil;

    // Ejecuto el procedimiento, sin parametro alguno
    // Puede ser usado generalmente un metodo anonino
    Procedimiento;

    {$IFDEF WEB}
    // Restauro los eventos, del dataset, para que funcione normalmente
    Dataset.AfterCancel :=  DMPrincipal.MSQuerySQL.AfterCancel;
    Dataset.BeforePost := DMPrincipal.MSQuerySQL.BeforePost;
    Dataset.AfterPost := DMPrincipal.MSQuerySQL.AfterPost;
    Dataset.BeforeInsert := DMPrincipal.MSQuerySQL.BeforeInsert;
    Dataset.BeforeEdit := DMPrincipal.MSQuerySQL.BeforeEdit;
    Dataset.AfterScroll := DMPrincipal.MSQuerySQL.AfterScroll;

    {$ENDIF}
  except // En caso que ocurra una excepcion
    on E: Exception do
    begin
      {$IFDEF DESKTOP}
        Messagedlg(EExcepcion + ' - ' + E.Message, mtError, [mbOK], 0);
      {$ENDIF}

      {$IFDEF WEB}
      //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + Dataset.Name + ' - ' + E.ClassName + ' - ' + E.Message);
      //Log(EExcepcion + ' - ' + Dataset.Name +' - ' + E.ClassName + ' - ' + E.Message );
      Abort;
      {$ENDIF}
    end;

  end;

end;


procedure DMBeforeUpdateExecute(Sender: TCustomMSDataSet; Params: TMSParams);
// Ej. DMBeforeUpdateExecute(Sender,Params);
var
  i: integer;
begin
  // Activo este parametro solo cuando producto insert
  if Sender.State = dsInsert then
  begin
    try
      // Estas dos lineas no estoy tan seguro que deban de implementarse asi
      Sender.RefreshOptions := [roAfterInsert, roAfterUpdate, roBeforeEdit];
      Sender.Options.ReturnParams := True;

      for i := 0 to Params.Count - 1 do
      begin
        if (Params[i].DataType in [ftInteger, ftString, ftWideString]) then
        begin
          Params[i].ParamType := ptInputOutput;
        end;
      end;

    except
      on E: Exception do
      begin
        //Log('DMBeforeUpdateExecute ' + Sender.Name + ' ' + E.Message);
        Abort;
      end;
    end;
  end;
end;


{$IFDEF WEB}
procedure DMBeforeInsert(Formulario: TUniForm = nil);
//EJ.  DMBeforeInsert(FrmDefincion);

begin
  if Formulario <> nil then
  begin
    HabilitarControles(Formulario);
  end;
end;



procedure DMBeforeEdit(Formulario: TUniForm = nil; MSQuery: TMSQuery = nil; VerificarFiniquitado: Boolean = False);
//Ej.  DMBeforeEdit(FrmDefincion);
//     DMBeforeEdit(FrmDefincion,TMSQuery(DataSet),True);
begin
  if Formulario <> nil then
  begin
//    if VerificarFiniquitado = true then
//    begin
//      //VerificarFiniquidoTransaccion(MSQuery, Formulario, true, False);
//    end;

    HabilitarControles(Formulario);

    // Si es crud maestro escribo registro guardado
    if Formulario is TFrmCRUDMaestro then
    begin
      TFrmCRUDMaestro(Formulario).uniStatusBar.Panels.Clear;
      TFrmCRUDMaestro(Formulario).uniStatusBar.Panels.Add.Text := 'Edicion';
    end;
  end;
end;
{$ENDIF}


procedure DMBeforePost(DataSet: TDataSet);
// Ej.DMBeforePost(DataSet);
begin
//  // cargo los valores de auditoria Urev
  CargarValoresAuditoria(DataSet);
//  AsignarIdOrganizacion(DataSet);
end;


{$IFDEF WEB}
function DMBeforeDelete(Formulario: TUniForm = nil; MSQuery: TMSQuery = nil;
  Tabla: string = ''; PrimaryField: TField = nil;
  VerificarDatoRelacionado: Boolean = False; ConfirmarBorrado: Boolean = False;
  VerificarPermiso: Boolean = False; VerificarFiniquitado: Boolean = False;
  Menu: string = ''): Boolean;
// Ej. DMBeforeDelete(FrmMultas, TMSQuery(DataSet),'Salario.Multa', MSMultaIdMulta, True, True);

var
  isBorradoConfirmado, isNoFueAbortadoPermiso, isNoFueAbortadoFiniquito, isNoFueAbortadoRelacionado, ResultAux: Boolean;
begin
  // Reinicio el valor
  Result := False;
  ResultAux := False;

  isNoFueAbortadoPermiso := true;
  isNoFueAbortadoFiniquito := true;
  isNoFueAbortadoRelacionado := true;

  //si el dataset que mando tiene datos
  if MSQuery.RecordCount > 0 then
  begin
    // Este codigo para evitar el borrado, guardo el evento temporalmente
    DMPrincipal.MSQuerySQL.BeforeDelete := MSQuery.BeforeDelete;
    MSQuery.BeforeDelete := nil;

    if Formulario <> nil then
    begin

      if ConfirmarBorrado = True then
      begin

        // Pregunto si validara     ESeguroContinuar
        Formulario.MessageDlg(EBorrarRegistro, mtConfirmation, mbYesNo,
          procedure(Sender: TComponent; AResult: integer)
          begin
            isBorradoConfirmado := true;
            // Si el usuario elige si
            if AResult = mrYes then
            begin

              // Verifico si datos relacionados
              if VerificarDatoRelacionado = True then
              begin
                isNoFueAbortadoRelacionado := VerificarDatoTablaRelacionada(Tabla, PrimaryField, Formulario, false);
              end;

              if VerificarPermiso = True then
              begin
                //isNoFueAbortadoPermiso := DMUsuario.VerificarPrivilegios(Menu, True , True , False);
                 isNoFueAbortadoPermiso:=True;
              end;

              if VerificarFiniquitado = True then
              begin
                isNoFueAbortadoFiniquito := VerificarFiniquidoTransaccion(MSQuery, Formulario, False);
              end;

              //aborto - pero despues de haber colocado nuevamente el evento del beforeDelete al datasource
              if ((isNoFueAbortadoPermiso = False) or (isNoFueAbortadoFiniquito  = False) or (isNoFueAbortadoRelacionado  = False) ) then
              begin
                // Restauro el evento, al dataset original
                MSQuery.BeforeDelete := DMPrincipal.MSQuerySQL.BeforeDelete;
                Abort;
              end
              else
                begin
                  // Borro finalmente
                  MSQuery.Delete;

                  // Devuelvo el valor verdadero, a una variable auxiliar,
                  // porque no permite dentro de una messagedlg que devuelve datos
                  ResultAux := True;

                  // Restauro el evento, al dataset original
                  MSQuery.BeforeDelete := DMPrincipal.MSQuerySQL.BeforeDelete;
                end;

            end;

            if AResult = mrNO then
            begin
              // Restauro el evento, al dataset original
              MSQuery.BeforeDelete := DMPrincipal.MSQuerySQL.BeforeDelete;
            end;
            if AResult <> mrNO and mrYes then
            begin
              // Restauro el evento, al dataset original
              MSQuery.BeforeDelete := DMPrincipal.MSQuerySQL.BeforeDelete;
            end;


          end);

      end
      else // Si no hay confirmacion de eliminacion
        begin

          if VerificarDatoRelacionado = True then
          begin
            isNoFueAbortadoRelacionado := VerificarDatoTablaRelacionada(Tabla, PrimaryField, Formulario, false);
          end;

          if VerificarPermiso = True then
          begin
            //isNoFueAbortadoPermiso := DMUsuario.VerificarPrivilegios(Menu, True , True , False);
            isNoFueAbortadoPermiso:=True;
          end;

          if VerificarFiniquitado = True then
          begin
            isNoFueAbortadoFiniquito := VerificarFiniquidoTransaccion(MSQuery, Formulario, False);
          end;

          // Restauro el evento, al dataset original
          MSQuery.BeforeDelete := DMPrincipal.MSQuerySQL.BeforeDelete;

          //aborto - pero despues de haber colocado nuevamente el evento del beforeDelete al datasource
          if ((isNoFueAbortadoPermiso = False) or (isNoFueAbortadoFiniquito  = False) or (isNoFueAbortadoRelacionado  = False) ) then
          begin
            Abort;
          end;

        end;
    end;

    // Aborto  al final solo cuando es con confirmacion, y aun no selecciono si o no
    if (ConfirmarBorrado = True and isBorradoConfirmado = false) then
    begin
      Abort;
    end;

    // Devuelvo el result Auxiliar
    Result := ResultAux;
  end;
end;
{$ENDIF}


procedure DMCalcFields(DataSet: TDataSet);
//Carga el estado del formulario Urev y EstadoTransaccion  a medida que cambiamos de registro
// Ejemplo DMCalcFields(DataSet);
begin

  if DataSet.State in [dsBrowse] then
  begin
    {$IFDEF SDAC}
    if (TCustomMSDataSet(Dataset).FindField('UrevUsuario') <> nil) and
       (TCustomMSDataSet(DataSet).FindField('UrevFechaHora') <> nil) then
    begin
       //   CargarEstadoyURev(TCustomMSDataSet(Dataset));
    end;
    {$ENDIF}


  end;
end;



{$IFDEF WEB}
procedure DMPostError(Formulario: TUniForm; E: EDatabaseError;
  var Action: TDataAction);
//EJ.  DMPostError(FrmDefincion, E, Action);
begin
  // Muestro mensajes de error en caso que se produzca
  Formulario.MessageDlg(E.Message, mtError, [mbOK]);
  // Capturo en el archivo de log, el error
  UniServerModule.Logger.AddLog('PostError', UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
  Action := daAbort;
end;
{$ENDIF}




procedure DMAfterCancel(Formulario: TCustomForm = nil);
//Ej. DMAfterCancel(FrmDefincion);
begin
  if Formulario <> nil then
  begin
    {$IFDEF WEB}
    DeshabilitarControles(TUniForm(Formulario));
    {$ENDIF}

    {$IFDEF DESKTOP}
    RecorrerPintarRestaurarControlesVisuales(Formulario);
    {$ENDIF}
  end;
end;


procedure DMAfterPost(Formulario: TCustomForm = nil);
// Ej. DMAfterPost(FrmDefincion);
begin
  // desabilito los controles en caso de no estar en modo de insert o edit
  if Formulario <> nil then
  begin

    try

      {$IFDEF WEB}
      DeshabilitarControles(TUniForm(Formulario));
      // Si es crud maestro escribo registro guardado
      if Formulario is TFrmCRUDMaestro then
      begin
        TFrmCRUDMaestro(Formulario).uniStatusBar.Panels.Clear;
        TFrmCRUDMaestro(Formulario).uniStatusBar.Panels.Add.Text := 'Registro Guardado';
      end;
      {$ENDIF}

    except
      on E: Exception do
      begin
        {$IFDEF DESKTOP}
       // Log(EExcepcion + 'Error en el DMAfterPost: Formulario ' + Formulario.Name + ' - ' + E.Message + ' - ' + E.ClassName);
        {$ENDIF}

        {$IFDEF WEB}
        //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + 'Error en el DMAfterPost: Formulario ' + Formulario.Name + ' - ' + E.Message + ' - ' + E.ClassName);
        {$ENDIF}
      end;
    end;
  end;
end;


procedure AsignarPrincipal(DataModule: string; DataSet: TArray<TDataSet>);
// Ej.    AsignarPrincipal(Self.Name, DataSet);
var
  i: integer;
  {$IFDEF SDAC}
  CustomConnection: TCustomMSConnection;
  {$ENDIF}
begin

  {$IFDEF SDAC}


  if DMPrincipal <> nil then
  begin
    try
      if not (DMPrincipal.MSConnection.Connected) then
      begin
        DMPrincipal.MSConnection.Connect;
      end;

    except
      on E: Exception do
      begin
       // Log(EExcepcion + 'Error al AsignarPrincipal - al activar conectar DMPrincipal: ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);

        {$IFDEF WEB}
        //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + 'Error AsignarPrincipal: Al conectar el DMPrincipal ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);
        {$ENDIF}
      end;
    end;

    for i := 0 to High(DataSet) do
    begin
      try
          if (DataSet[i] is TMSQuery) or (DataSet[i] is TMSStoredProc) then
          begin
            TCustomMSDataSet(DataSet[i]).Options.StrictUpdate := False;

            if TCustomMSDataSet(DataSet[i]).Connection = nil then
            begin
              TCustomMSDataSet(DataSet[i]).Connection := DMPrincipal.MSConnection;
            end;
          end;

      except
        on E: Exception do
        begin
          //Log(EExcepcion + 'Error al AsignarPrincipal dataset: ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);
          {$IFDEF WEB}
          //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + 'Error al AsignarPrincipal dataset: ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);
          {$ENDIF}
        end;
      end;
    end;
  end;
  {$ENDIF}

end;


procedure AsignarPrincipal(DataModule: TDataModule);
var
  i: integer;
begin

  // Recorro los objetos
  for i := 0 to DataModule.ComponentCount - 1 do
  begin

    // En caso que sean objetos de SDAC
    if ((DataModule.Components[i].ClassType = TMSQuery) or (DataModule.Components[i].ClassType = TMSStoredProc)) then
    begin

      // Siempre que la conexion principal este establecida
      if Assigned(DMPrincipal.MSConnection) = True then
      begin
        // Establezco la propiedad de conexion
        try
          TCustomMSDataSet(DataModule.Components[i]).Connection := DMPrincipal.MSConnection;
        except
          on E: Exception do
          begin
            //Log(EExcepcion + E.Message);

            {$IFDEF DESKTOP}
            MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
            {$ENDIF}
          end;
        end;
      end;

    end;
  end
end;


procedure ActivarCacheUpdate(Datasets: TArray<TCustomMSDataSet>);
var
  i: integer;
begin
  try
    for i := Low(Datasets) to High(Datasets) do
    begin
      TCustomMSDataSet(Datasets[i]).CachedUpdates := True;
    end;

  except
    on E: Exception do
    begin
     // Log(EExcepcion + E.Message);

      {$IFDEF DESKTOP}
      MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
      {$ENDIF}
    end;
  end;
end;


procedure ActivarCacheUpdate(DataModule: TDataModule); overload;
var
  i: integer;
begin

  // Recorro los objetos
  for i := 0 to DataModule.ComponentCount - 1 do
  begin

    // En caso que sean objetos de SDAC
    if ((DataModule.Components[i].ClassType = TMSQuery) or (DataModule.Components[i].ClassType = TMSStoredProc)) then
    begin

      // Establezco la propiedad de cache updates
      try
        TCustomMSDataSet(DataModule.Components[i]).CachedUpdates := True;
      except
        on E: Exception do
        begin
         // Log(EExcepcion + E.Message);

          {$IFDEF DESKTOP}
          MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
          {$ENDIF}
        end;
      end;

    end;
  end;

end;


procedure ActivarDataSets(DataModule: string; DataSet: TArray<TDataSet>; CerrarDataset: Boolean = True);
// se debe pasar el nombre del datamodule y los dataset a activar
// EJ.:   ActivarDataSets(self.name,[DataSet1,DataSet2]);
var
  i: integer;
begin

  {$IFDEF SDAC}
  if DMPrincipal <> nil then
  begin
    try
      if not(DMPrincipal.MSConnection.Connected) then
      begin
        DMPrincipal.MSConnection.Connect;
      end;

    except
      on E: Exception do
      begin

       // Log(EExcepcion + 'Error al activar el dataset - al activar el DMPrincipal: ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);

        {$IFDEF WEB}
      //  MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
        //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + 'Error ActivarDataSets: Al conectar el DMPrincipal ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);
        {$ENDIF}

        {$IFDEF DEBUG}
        // LogParameter('ActivarDataSets', DataSet[i]);
        {$ENDIF}
      end;
    end;

    for i := 0 to High(DataSet) do
    begin
      try

        if (Dataset[i] is TMSQuery) or (Dataset[i] is TMSStoredProc) then
        begin
          TCustomMSDataSet(Dataset[i]).Options.StrictUpdate := False;

          if TCustomMSDataSet(Dataset[i]).Connection = nil then
          begin
            //CustomConnection := DMPrincipal.MSConnection;
            TCustomMSDataSet(Dataset[i]).Connection := DMPrincipal.MSConnection;
          end;
        end;

        // Desactivo el Dataset los dataset
        if CerrarDataset then
        begin
          Dataset[i].Active := False;
        end
        else
          if (CerrarDataset = False) and (Dataset[i].Active = True) then
          begin
            if (Dataset[i].RecordCount = 0) then
            begin // en caso de no tener registro reactivo
              Dataset[i].Active := False;
            end;
          end;

        // verifico que no este activo el dataset
        if Dataset[i].Active = False then
        begin
          // asigno el valor IdOrganizacion
          //AsignarIdOrganizacion(Dataset[i]);

          // activo los dataset
          Dataset[i].Active := true;
        end;

      except
        on E: Exception do
        begin
          // {$IFDEF DESKTOP}
        //  Log(EExcepcion + 'Error al activar el dataset: ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);
          // {$ENDIF}

          {$IFDEF WEB}
         // UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + 'Error al activar el dataset: ' + DataModule + '.' + DataSet[i].Name + ' - ' + E.Message);
          {$ENDIF}

          //Se Agrega este codigo para saber que parametros paso
          //    y por ende fallo el MSDataset o TMSSproc
          // Mantener esta implementacion  OJO!!!
          case AnsiIndexStr(DataModule, ['DMReporte.ImprimirReporte_v2'{0},
                                         'DMReporte'{1},
                                         'DMReporte.CargarReporteModeloImpresion'{2},
                                         'DMReporte.DataModuleCreate'{3},
                                         '_ImprimirReporte_v2'{4}
                                        ]) of
            0..4:
            begin
           //   LogParameter(EExcepcion + ' Error al imprimir ' + DataModule + ' ' + DataSet[i].Name, DataSet[i]);
            end;
          end;

        end;
      end;
    end;
  end;
  {$ENDIF}

end;



procedure ActivarDataSetsDetalle(DataSet: TArray<TDataSet>; CampoIdDetalle: TField);
//ActivarDataSetsDetalle([DataSet,DataSet],Id)
var
  i: integer;
begin
  // Recorro el array
  for i := 0 to High(DataSet) do
  begin
    try
      // Cierro el dataset
      DataSet[i].Close;

      // Paso los parametros de los campos y abro de vuelta
      if (DataSet[i] is TMSQuery) or (DataSet[i] is TMSStoredProc) then
      begin
        if TCustomMSDataSet(DataSet[i]).FindParam(CampoIdDetalle.FieldName) <> nil then
          begin
            TCustomMSDataSet(DataSet[i]).ParamByName(CampoIdDetalle.FieldName).Value := CampoIdDetalle.Value;
          end
          else
          begin
        //    Log('ActivarDataSetsDetalle : ' + Dataset[i].Name + '. No posee en el where: ' + CampoIdDetalle.FieldName);
          end;
      end;

      AsignarPrincipal('ActivarDataSetsDetalle',[DataSet[i]]);

      DataSet[i].Open;
    except
      on E: Exception do
      begin
       // Log(EExcepcion +'ActivarDataSetsDetalle : ' + Dataset[i].Name + '. campo: ' + CampoIdDetalle.FieldName + '. Valor ' + CampoIdDetalle.AsString);
        //Log(EExcepcion +'ActivarDataSetsDetalle : ' + Dataset[i].Name + ' - '  +E.Message) ;

      end;
    end;
  end;
end;



{$IFDEF WEB}
procedure IrUltimoRegistro(DataSet: TMSQuery; Formulario: TUniForm);
// Ej.  IrUltimoRegistro(Dataset; Formulario)
begin
  //En caso de no esta activo
  try
    if not(Dataset.State in dsEditModes) then
    begin
      ActivarDataSets(Formulario.Name , [Dataset] , False);
    end;

  except
    on E: Exception do
    begin
      Formulario.MessageDlg(E.Message, mtError, [mbOK]);
     // Log(Formulario.Name + ' : ' + Dataset.Name + ' ' + E.Message);
      Formulario.Close;
      Abort;
    end
  end;

  // RefreshOptions
  try
    Dataset.RefreshOptions := [roAfterInsert, roAfterUpdate, roBeforeEdit];
  except
    on E: Exception do
    begin
      Formulario.MessageDlg(E.Message, mtError, [mbOK]);
     // Log(Formulario.Name + ' : ' + Dataset.Name + ' ' + E.Message);
      Formulario.Close;
      Abort;
    end
  end;


  // Encaso de que sea llamado desde el main
  // Obtengo propiedad EnviadoDesdeFrm RTTI
  if (GetPropValue(Formulario, 'EnviadoDesdeFrm', True) = 'MainForm') then
  begin
    //ActualizarDatasetOrganizacionSeleccionada(DataSet);
  end;


  // Si el form ha sido inicializado desde el menu ira al ultimo registro
  // Obtengo propiedad EnviadoDesdeFrm RTTI
  if (GetPropValue(Formulario, 'EnviadoDesdeFrm', True) = 'MainForm') then
  begin
    DeshabilitarControles((TFrmCRUDMaestro(Formulario)));

    DeshabilitarControles(Formulario);

    if not(Dataset.State in dsEditModes) then
    begin
      DataSet.Last;
    end;
  end;

   // Deshabilito si no está en modo de edición o inserción
  if Dataset.State = dsBrowse then
  begin
    DeshabilitarControles((TFrmCRUDMaestro(Formulario)));
  end;

  //WTF??
//  if not((TFrmCRUDMaestro(Formulario)).EnviadoDesdeFrm = 'MainForm') then
//  begin
//    // Reseteo la propiedad
//    // (TFrmCRUDMaestro(Formulario)).EnviadoDesdeFrm := '';
//  end;
end;
{$ENDIF}


procedure DMVerificarEstadoEdicion(DataSet: TDataSet);
begin
  if DataSet.State in dsEditModes then
  begin
    DataSet.Post;
  end;

  //refresco el registro
  TCustomMSDataSet(DataSet).RefreshRecord;
end;


end.
