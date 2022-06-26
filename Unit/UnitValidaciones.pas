
unit UnitValidaciones;

{$INCLUDE 'compilador.inc'}

interface

uses

  {$IFDEF DESKTOP}
  // Unit de DevExpress
  cxControls, cxDBEdit, Vcl.StdCtrls, Vcl.DBCtrls, cxDBLookupComboBox, cxCalendar, cxTextEdit,
  cxEdit, cxDropDownEdit, cxGroupBox, cxMaskEdit, cxButtonEdit, cxPC, Vcl.ExtCtrls, dxStatusBar,
  cxCheckBox,
  {$ENDIF}

  {$IFDEF WEB}
  ServerModule, UniGuiApplication, UniGuiForm, UniDBGrid, uniGUITypes, uniGUIAbstractClasses,
  UniDBMemo, uniDBCheckBox,  UniDBEdit, UniDBLookupComboBox, UniDBDateTimePicker, uniDBComboBox,
  uniImage, uniStatusBar, uniEdit, uniCombobox, uniMemo,  uniCheckBox, uniPageControl,
  uniDateTimePicker, UniRadioButton, uniGroupBox,uniGUIDialogs, uniPanel, uniGUIClasses,
  uniGUICoreInterfaces, uniListBox,
  {$ENDIF}

  MSAccess, System.Contnrs, Data.DB, System.SysUtils, System.TypInfo, Vcl.Dialogs, Vcl.Forms,
  System.Classes, StrUtils, System.Variants, System.DateUtils, Vcl.Controls, Vcl.Graphics;

type
  TTipoValidacion = (Nulo, StringVacio, EnteroCero);
  TTipoValidacionFecha = (Menor, Menor_o_Igual, Mayor, Mayor_o_Igual);

  TNumeroDocumento = record
    Prefijo: string;
    NumeroAnho: string;
    Numero: integer;
    NumeroAsString: string;
    Anho: integer;
    AnhoAsString: string;
    NumeroDocumento: string;
  end;

const
  ColorRequerido = $009BFFFF;
  STR_EMPTY = '';

{$IFDEF DESKTOP}
function VerificarFiniquidoTransaccion(Dataset: TMSQuery): Boolean;
function VerificarExisteDatos(Dataset: TCustomMSDataSet; Mensaje: string): Boolean;
{$ENDIF}

{$REGION 'Documentation'}
/// <summary>
///   Valida que un campo tenga datos o no, debe usarse en el before post de un
///   dataset
/// </summary>
/// <param name="Formulario">
///   Formulario desde donde se llama
/// </param>
/// <param name="Campo">
///   Campo a ser validado
/// </param>
/// <param name="MensajeValidacion">
///   Mensaje de validacion
/// </param>
/// <param name="TipoValidacion">
///   Tipo de validacion seleccionada
/// </param>
{$ENDREGION}
procedure ValidarCampo(Formulario: TCustomForm; Campo: TField; MensajeValidacion: string; TipoValidacion: TTipoValidacion = Nulo;  Abortar : Boolean= true; MsgDlgType : TMsgDlgType = mtError);
procedure ValidarCampoFecha(Formulario: TCustomForm; CampoFecha: TDateTimeField; FechaComparacion: TDateTime; MensajeValidacion: string; TipoValidacionFecha: TTipoValidacionFecha);

procedure RecorrerPintarControlesVisuales(Formulario: TCustomForm; Campo: TField);
procedure RecorrerPintarRestaurarControlesVisuales(Formulario: TCustomForm);
procedure ValidarVacios(Control: TControl; MensajeValidacion: String; MsgDlgType: TMsgDlgType = mtError); overload;

{$IFDEF WEB}
procedure VerificarAbandonarOperacion(Dataset: TMSQuery; Formulario: TUniForm; var Action: TCloseAction);
function VerificarFiniquidoTransaccion(Dataset: TMSQuery; Formulario: TUniForm = nil ;  Abortar : Boolean= true; HacerPost : Boolean = True): Boolean;
function VerificarExisteDatos(Dataset: TCustomMSDataSet; Formulario: TUniForm; Mensaje: string): Boolean;

procedure ValidarStrVacios(Formulario: TUniForm; Sender: String; MensajeValidacion: String);
procedure ValidarIntVacios(Formulario: TUniForm; Sender: Integer; MensajeValidacion: String);

procedure ValidarCantidadCaracteres(Formulario: TCustomForm; Campo: TField; CantidadCaracteres: integer; MensajeValidacion: string);
function VerificarNominaConStr(IdPeriodoAProcesar :  Integer; Formulario: TUniForm = nil): Boolean;
procedure ValidarFecha(ControlFecha: TUniCustomDateTimePicker; FechaComparacion: TDateTime; MensajeValidacion: string; TipoValidacionFecha: TTipoValidacionFecha);

procedure ValidarRangoNumeros(Formulario: TCustomForm; Campo: TField; CantidadMinima, CantidadMaxima: Double; MensajeValidacion: string);
{$ENDIF}

function VerificarDatoTablaRelacionada(Tabla: string; Campo: TField; Formulario: TCustomForm; Abortar: Boolean = True): Boolean;
function VerificarDatoReferenciado(Tabla: string; Campo: TField; Abortar: Boolean=True): Boolean;
function ValidarDocumentoNumeroAnho(DocumentoNumeroAnho: string): Boolean;
function VerificarValorRepetido(Tabla: string; Parametros: array of TField; Formulario: TCustomForm; Mensaje: string; AbortarSiRepetido: Boolean = True; PoseeIdOrganizacion: Boolean = True; IdNoComparar: TField = nil; MostrarMensaje : Boolean= true) : Boolean;

function NumeroDocumento(DocumentoNumeroAnho: string): TNumeroDocumento;
//function ValidarDocumentoNumeroAnho(DocumentoNumeroAnho: string): Boolean;

implementation




uses
  {$IFDEF SDAC}
    DataModulePrincipal, UnitDatos,
  {$ENDIF}

  {$IFDEF WEB}

    // Solo para Nomina
    {$IFDEF NOMINA}
    DataModuleComunNomina,
    {$ENDIF}

  {$ENDIF}

  UnitRecursoString,// UnitLog,
  UnitCodigosComunesString, UnitCodigosComunes, UnitCodigosComunesFormulario;


{$IFDEF DESKTOP}
function VerificarFiniquidoTransaccion(Dataset: TMSQuery): Boolean;
begin
  if Dataset.FieldByName('IdEstadoTransaccion').Value = 4 then
    begin
        MessageDlg(ETransaccionFiniquitada, mtError, [mbOK], 0);
      Result := False;
      Abort;
    end;
  Result := True;
end;

function VerificarExisteDatos(Dataset: TCustomMSDataSet; Mensaje: string): Boolean;
begin

  // Esta funcion verifica si existen datos y muestra un mensaje de error en un form

  Dataset.Refresh;

  if Dataset.RecordCount = 0 then
    begin
        MessageDlg(Mensaje, mtError, [mbOK], 0);
      Result := False;
      Abort;
    end;

  Result := True;
end;
{$ENDIF}

{$IFDEF WEB}
procedure VerificarAbandonarOperacion(Dataset: TMSQuery; Formulario: TUniForm; var Action: TCloseAction);
//VerificarAbandonarOperacion(DataSet, Self, Action);
begin
  // Evento de determinar estado del dataset, cancelar la inserci�n actual
  if Dataset.State in [dsInsert, dsEdit] then
    begin
      // Consulto las propiedades de los formularios con RTTI
      // En caso que el formulario no tenga cerrar, evitar que cierre
      if (GetPropValue(Formulario, 'EnviadoDesdeFrm', False)) <> 'Cerrar' then
        begin
            Action := caNone;
        end;

      // Consulto si deseo cancelar la operacion
      MessageDlg(EDeseaCancelarOperacion, mtConfirmation, mbYesNo,
        procedure(Sender: TComponent; AResult: Integer)
        begin
          case AResult of
            6:// MRYES
              begin
                // Cancelo la operacion del dataset, envio el valor de form enviado y cierro
                Dataset.Cancel;
                SetPropValue(Formulario, 'EnviadoDesdeFrm', 'Cerrar');
                Formulario.Close;
              end;

            7:  //mrNo
              begin
                // No hago nada
              end;
          end;
        end);
    end;
end;
{$ENDIF}



//procedure VerificarDatoTablaRelacionada(Tabla: string; Campo: TField; Formulario: TCustomForm;  Abortar : Boolean= true);
function VerificarDatoTablaRelacionada(Tabla: string; Campo: TField; Formulario: TCustomForm;  Abortar : Boolean= true): Boolean;
begin

  {$IFDEF SDAC}
  Result := true;

  // Cargo el parametro de tabla y abro el dataset
//  DMPrincipal.MSTablaRelacionada.Close;
//  DMPrincipal.MSTablaRelacionada.Params.ParamByName('tabla').Value := Tabla;
//  DMPrincipal.MSTablaRelacionada.Open;

  // Mientras exista datos en la tabla la recorro
//  while DMPrincipal.MSTablaRelacionada.Eof = False do
//    begin

      // Consulto el campo de referencia
//      DMPrincipal.MSCampoRelacionado.Close;
//      DMPrincipal.MSCampoRelacionado.ParamByName('TablaOrigen').Value := DMPrincipal.MSTablaRelacionadatable_schema.Value + '.' + DMPrincipal.MSTablaRelacionadatable_name.Value;
//      DMPrincipal.MSCampoRelacionado.ParamByName('TablaDestino').Value := Tabla;
//      DMPrincipal.MSCampoRelacionado.Open;


//      // Ejecuto un query consultando si hay datos en la tabla relacionalda
//      try
//        while DMPrincipal.MSCampoRelacionado.Eof = False do
//        begin
//
//          DMPrincipal.MSQuerySQL.Close;
//
//          // Limpio el select del SQL
//          DMPrincipal.MSQuerySQL.SQL.Clear;
//
//          // Cargo el query
//          DMPrincipal.MSQuerySQL.SQL.Add('SELECT ' + DMPrincipal.MSCampoRelacionadoColumnaOrigen.Value + ' FROM ' +
//            DMPrincipal.MSTablaRelacionadatable_schema.Value + '.' + DMPrincipal.MSTablaRelacionadatable_name.Value +
//            ' WHERE ' + DMPrincipal.MSCampoRelacionadoColumnaOrigen.Value + ' = ' + Campo.AsString);
//
//           // Guardo el log
//           Log(DMPrincipal.MSQuerySQL.SQL.Text);
//           // Abro el dataset
//           DMPrincipal.MSQuerySQL.Open;
//
//          // En caso que haya mas de un registro, no se puede eliminar y muestro un mensaje y aborto
//          if DMPrincipal.MSQuerySQL.RecordCount >= 1 then
//            begin
//
//              {$IFDEF WEB}
//              (Formulario as TUniForm).MessageDlg(EErrorEliminarDatosRelacionados + #13 +  'Tabla: ' + DMPrincipal.MSTablaRelacionadatable_schema.Value + '.' + DMPrincipal.MSTablaRelacionadatable_name.Value, mtError, [mbOK]);
//              {$ENDIF}
//
//              {$IFDEF DESKTOP}
//              MessageDlg(EErrorEliminarDatosRelacionados + #13 +  'Tabla: ' + DMPrincipal.MSTablaRelacionadatable_schema.Value + '.' + DMPrincipal.MSTablaRelacionadatable_name.Value, mtError, [mbOK], 0);
//              {$ENDIF}
//              Result := false;
//
//              if (Abortar) then
//              begin
//                Abort;
//              end;
//
//            end;
//
//          // Salto al siguiente registro
//          DMPrincipal.MSCampoRelacionado.Next;
//        end;
//
//      except
//
//        // Muestro una excepcion si se produce
//        on E: Exception do
//          begin
//            //MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
//
//            {$IFDEF WEB}
//              // Cargo la excepcion al log
//            UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
//            {$ENDIF}
//
//            Result := false;
//
//            if (Abortar) then
//            begin
//              Abort;
//            end;
//
//          end;
//
//      end;
//
//      // Sigo a la siguiente tabla
//      DMPrincipal.MSTablaRelacionada.Next;
//
//    end;

   {$ENDIF}
end;


function VerificarDatoReferenciado(Tabla: string; Campo: TField; Abortar: Boolean = True): Boolean;
begin

  Result := True;
  {$IFDEF SDAC}
  try
    // Vacio la consulta del query de consultas
    DMPrincipal.MSQuerySQL.Close;
    DMPrincipal.MSQuerySQL.SQL.Clear;

    // Cargo la consulta y lo ejecuto
    DMPrincipal.MSQuerySQL.SQL.Text := 'SELECT CantidadRegistro = COUNT(*) FROM ' + Tabla + ' WHERE ' + Campo.FieldName + ' = ' + Campo.AsString;
    DMPrincipal.MSQuerySQL.Open;

    // Emito en mensaje de advertencia
    if DMPrincipal.MSQuerySQL.FieldByName('CantidadRegistro').AsInteger <> 0 then
    begin
      MessageDlg(EErrorEliminarDatosRelacionados, mtError, [mbOK], 0);

      // Aborto si es solicitado
      if Abortar = True then
      begin
        Abort;
      end;
    end
    else
      begin
        Result := False;
      end;

  except
    on E: Exception do
    begin

      {$IFDEF WEB}
      // Cargo la excepcion al log
     // UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
      {$ENDIF}

      Result := False;

      if (Abortar) then
      begin
        Abort;
      end;

    end;

  end;

  {$ENDIF}

end;



{$IFDEF WEB}
function VerificarExisteDatos(Dataset: TCustomMSDataSet; Formulario: TUniForm;
Mensaje: string): Boolean;
begin
  // Esta funcion verifica si existen datos y muestra un mensaje de error en un form

  if not(Dataset.Active) then
    Dataset.Open;

  Dataset.Refresh;

  if (Dataset.RecordCount = 0) then
  begin
    Formulario.MessageDlg(Mensaje, mtError, [mbOK]);
    Result := False;
    Abort;
  end;

  Result := True;
end;



function VerificarFiniquidoTransaccion(Dataset: TMSQuery; Formulario: TUniForm = nil ;  Abortar : Boolean= true; HacerPost : Boolean = True): Boolean;
//  Ejemplo VerificarFiniquidoTransaccion(Dataset,Self);
begin
  Result := True;

  // Actulizo el dataset
  // No funcione
  // Dataset.RefreshRecord;

  if Dataset.Active = False then
  begin
      Dataset.Open;
  end;

  if  HacerPost = true  then
  begin
    if Dataset.State in dsEditModes then
    begin
        Dataset.Post;
    end;
  end;

  // Si hay una llamada desde un formulario muestro el mensaje
  if Formulario <> nil then
  begin
    if (Dataset.RecordCount = 0) then
    begin
      Formulario.MessageDlg(ENoExistenDatos, mtError, [mbOK]);
      if (Abortar) then Abort;
    end;
  end;

  // En caso que fuera el estado 4
  if Dataset.FieldByName('IdEstadoTransaccion').Value = 4 then
  begin
    // Si indico el formulario muestro el mensaje de alerta
    if Formulario <> nil then
    begin
      Formulario.MessageDlg(ETransaccionFiniquitada, mtError, [mbOK]);
    end;

    Result := False;
    if (Abortar) then Abort;
  end;


  // En caso que fuera el estado 3
  if Dataset.FieldByName('IdEstadoTransaccion').Value = 3 then
  begin
    // Si indico el formulario muestro el mensaje de alerta
    if Formulario <> nil then
    begin
      Formulario.MessageDlg(ETransaccionAnulado, mtError, [mbOK]);
    end;

    Result := False;
    if (Abortar) then Abort;
  end;

{$IFDEF RAPY}
  // En caso que fuera el estado 3
  if Dataset.FieldByName('IdEstadoTransaccion').AsInteger in [ 30 , 31 ] then
  begin
    // Si indico el formulario muestro el mensaje de alerta
    if Formulario <> nil then
    begin
      Formulario.MessageDlg(ESolicitudFueProcesada, mtError, [mbOK]);
    end;

    Result := False;
    if (Abortar) then Abort;
  end;
{$ENDIF}



end;



procedure ValidarStrVacios(Formulario: TUniForm; Sender: String; MensajeValidacion: String);
begin
  if Sender = '' then
  begin
    // Muestro el mensaje de validacion
    Formulario.MessageDlg(MensajeValidacion, mtError, [mbOK]);
      // Aborto y espero nueva interaccion del usuario
    Abort;
  end;
end;


procedure ValidarIntVacios(Formulario: TUniForm; Sender: Integer; MensajeValidacion: String);
begin
  if ifnull(Sender, 0) < 1 then
  begin
      // Muestro el mensaje de validacion
      Formulario.MessageDlg(MensajeValidacion, mtError, [mbOK]);
      // Aborto y espero nueva interaccion del usuario
      Abort;
  end;

end;



procedure ValidarCantidadCaracteres(Formulario: TCustomForm; Campo: TField; CantidadCaracteres: integer; MensajeValidacion: string);
begin

  // Verifico el tamano del campo
  if Length(Trim(Campo.Value)) <> CantidadCaracteres then
  begin
    // Muestro el mensaje de validacion
    (Formulario as TUniForm).MessageDlg(MensajeValidacion, mtError, [mbOK]);

    // Aborto y espero nueva interaccion del usuario
    Abort;
  end;

end;


function VerificarNominaConStr(IdPeriodoAProcesar: Integer; Formulario: TUniForm = nil): Boolean;
begin
  {$IFDEF NOMINA}
  with DMComunNomina do
  begin
    MSNominaStrPeriodo.Close;
    MSNominaStrPeriodo.ParamByName('IdPeriodoAProcesar').Value := IdPeriodoAProcesar  ;
    MSNominaStrPeriodo.open;


    // Si hay una llamada desde un formulario muestro el mensaje
    if Formulario <> nil then
    begin
      if (MSNominaStrPeriodoProcesado.Value = 0) then
      begin
        Formulario.MessageDlg(ENominaSinStr, mtError, [mbOK]);
        Abort;
      end;
    end;
  end;
   {$ENDIF}
end;

{$ENDIF}




procedure ValidarVacios(Control: TControl; MensajeValidacion: String; MsgDlgType: TMsgDlgType = mtError);
//ValidarVacios(txtRotulado, EEscribaRotulado);
var
  MostrarAlerta: Boolean;
begin

    MostrarAlerta:= False;
   {$IFDEF WEB}
   TUniFormControl(Control).Color := clWhite;

   case AnsiIndexStr(Control.ClassName, [TUniEdit.ClassName, TUniDBEdit.ClassName,
                                         TUniMemo.ClassName, TUniDBMemo.ClassName,
                                         TUniNumberEdit.ClassName, TUniDBNumberEdit.ClassName,
                                         TUniFormattedNumberEdit.ClassName, TUniDBFormattedNumberEdit.ClassName,
                                         TUniDateTimePicker.ClassName, TUniDBDateTimePicker.ClassName,
                                         TUniComboBox.ClassName, TuniDBLookupComboBox.ClassName,
                                         TUniTagField.ClassName]) of

      0, 1, 2, 3, 10, 12: // Textos
      begin

        if TUniFormControl(Control).Text = '' then
        begin
          MostrarAlerta := True;

          TUniFormControl(Control).SetFocus;
          TUniFormControl(Control).Color := ColorRequerido;
        end

      end;

      4, 5, 6, 7: //  Numeros
      begin
        if (TUniCustomNumberEdit(Control).Value = 0) or (TUniCustomNumberEdit(Control).IsBlank) then
        begin
          MostrarAlerta := True;

          // Hacer foco al Control seleccionado
          TUniCustomNumberEdit(Control).SetFocus;
          TUniCustomNumberEdit(Control).Color := ColorRequerido;
        end;
      end;

      8: // TUniDateTimePicker
      begin
        if VarToStr(TUniDateTimePicker(Control).DateTime) = '' then
        begin
          MostrarAlerta := True;
          // Hacer foco al Control seleccionado
          TUniDateTimePicker(Control).SetFocus;
          TUniDateTimePicker(Control).Color := ColorRequerido;
        end;
      end;

      9: // TUniDBDateTimePicker
      begin
        //31/12/1899 -- Es porque sql resuelve esto por defecto en SDAC
        if TUniDBDateTimePicker(Control).Text = '30/12/1899' then
        begin
          MostrarAlerta := True;
          // Hacer foco al Control seleccionado
          TUniDBDateTimePicker(Control).SetFocus;
          TUniDBDateTimePicker(Control).Color := ColorRequerido;
        end;
      end;

      11: // TuniDBLookupComboBox
      begin
        if ((TUniDBLookupComboBox(Control).KeyValue = -1) or
           (TUniDBLookupComboBox(Control).KeyValue = null) or
           (TUniDBLookupComboBox(Control).Text = '')) then
        begin
          MostrarAlerta := True;
          // Hacer foco al Control seleccionado
          TUniDBLookupComboBox(Control).SetFocus;
          TUniDBLookupComboBox(Control).Color := ColorRequerido;
        end;
      end;

   end;
   {$ENDIF}


   {$IFDEF DESKTOP}
   case AnsiIndexStr(Control.ClassName, [TcxLookupComboBox.ClassName, TcxDateEdit.ClassName,
                                         TcxTextEdit.ClassName, TcxMaskEdit.ClassName,
                                         TcxComboBox.ClassName, TcxButtonEdit.ClassName,
                                         TcxDBDateEdit.ClassName, TcxDBMemo.ClassName,
                                         TcxDBLookupComboBox.ClassName, TcxDBTimeEdit.ClassName,
                                         TcxDBComboBox.ClassName]) of
      {0..10: // Todos los controles
      begin

        // Verifico si esta vacio
        if VarToStr(TcxCustomEdit(Control).EditValue) = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxCustomEdit(Control).CanFocus = True then
          begin
            TcxCustomEdit(Control).SetFocus;
          end;

          TcxCustomEdit(Control).Style.Color := ColorRequerido;
        end;
      end;  }

      0: // TcxLookupComboBox
      begin
        if TcxLookupComboBox(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxLookupComboBox(Control).CanFocus = True then
            begin
              TcxLookupComboBox(Control).SetFocus;
            end;

          TcxLookupComboBox(Control).Style.Color := ColorRequerido;
        end;
      end;

      1: // TcxDateEdit
      begin
        if TcxDateEdit(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxDateEdit(Control).CanFocus = True then
            begin
              TcxDateEdit(Control).SetFocus;
            end;
          TcxDateEdit(Control).Style.Color := ColorRequerido;
        end;
      end;

      2: // TcxTextEdit
      begin
        if TcxTextEdit(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxTextEdit(Control).CanFocus = True then
            begin
              TcxTextEdit(Control).SetFocus;
            end;
          TcxTextEdit(Control).Style.Color := ColorRequerido;
        end;
      end;

      3: // TcxMaskEdit
      begin
        if TcxMaskEdit(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxMaskEdit(Control).CanFocus = True then
            begin
              TcxMaskEdit(Control).SetFocus;
            end;
          TcxMaskEdit(Control).Style.Color := ColorRequerido;
        end;
      end;

      4: // TcxComboBox
      begin
        if TcxComboBox(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxComboBox(Control).CanFocus = True then
            begin
              TcxComboBox(Control).SetFocus;
            end;
          TcxComboBox(Control).Style.Color := ColorRequerido;
        end;
      end;

      5: // TcxButtonEdit
      begin
        if TcxButtonEdit(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxButtonEdit(Control).CanFocus = True then
            begin
              TcxButtonEdit(Control).SetFocus;
            end;
          TcxButtonEdit(Control).Style.Color := ColorRequerido;
        end;
      end;

      6: // TcxDBDateEdit
      begin
        if TcxDBDateEdit(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxDBDateEdit(Control).CanFocus = True then
            begin
              TcxDBDateEdit(Control).SetFocus;
            end;
          TcxDBDateEdit(Control).Style.Color := ColorRequerido;
        end;
      end;

      7: // TcxDBMemo
      begin
        if TcxDBMemo(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxDBMemo(Control).CanFocus = True then
            begin
              TcxDBMemo(Control).SetFocus;
            end;
          TcxDBMemo(Control).Style.Color := ColorRequerido;
        end;
      end;

      8: // TcxDBLookupComboBox
      begin
        if TcxDBLookupComboBox(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxDBLookupComboBox(Control).CanFocus = True then
            begin
              TcxDBLookupComboBox(Control).SetFocus;
            end;
          TcxDBLookupComboBox(Control).Style.Color := ColorRequerido;
        end;
      end;

      9: // TcxDBTimeEdit
      begin
        if TcxDBTimeEdit(Control).EditText = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxDBTimeEdit(Control).CanFocus = True then
            begin
              TcxDBTimeEdit(Control).SetFocus;
            end;
          TcxDBTimeEdit(Control).Style.Color := ColorRequerido;
        end;
      end;

      10: // TcxDBComboBox
      begin
        if TcxDBComboBox(Control).Text = '' then
        begin
          MostrarAlerta := True;

          // Hacer foco al control seleccionado
          if TcxDBComboBox(Control).CanFocus = True then
            begin
              TcxDBComboBox(Control).SetFocus;
            end;
          TcxDBComboBox(Control).Style.Color := ColorRequerido;
        end;
      end;

   end;



   {$ENDIF}


   if MostrarAlerta = True then
   begin
      // Muestro el mensaje de validacion
      {$IFDEF WEB}
      MessageDlg(MensajeValidacion, MsgDlgType, [mbOK],
        procedure(Sender: TComponent; Res: Integer)
        begin
          TUniControl(Control).SetFocus;
        end);
      {$ENDIF}

      {$IFDEF DESKTOP}
      MessageDlg(MensajeValidacion, MsgDlgType, [mbOK], 0);
      {$ENDIF}

      // Aborto y espero nueva interaccion del usuario
      Abort;
   end;

end;


{$IFDEF WEB}
procedure ValidarFecha(ControlFecha: TUniCustomDateTimePicker; FechaComparacion: TDateTime; MensajeValidacion: string; TipoValidacionFecha: TTipoValidacionFecha);
var
  ResultadoOK: Boolean;
begin
  // Este procedimiento valida que un campo de fecha no pueda ser menor o mayor a una fecha establecida al campo FechaMenor
  // Una variable auxiliar para validar
  ResultadoOK := True;

  TUniDBDateTimePicker(ControlFecha).Color := clWhite;
  // En caso que el campo fecha no tenga un valor nulo
  if ((ControlFecha.IsBlank = True) or (ControlFecha.text = '30/12/1899')) then
  begin
    {$IFDEF WEB}
    // Muestro el mensaje de validacion
    MessageDlg(ESeleccioneFecha, mtError, [mbOK]);
    {$ENDIF}

    {$IFDEF DESKTOP}
    MessageDlg(MensajeValidacion, mtError, [mbOK], 0);
    {$ENDIF}

    // Recorro y pinto los objetos visuales
    TUniDBDateTimePicker(ControlFecha).SetFocus;
    TUniDBDateTimePicker(ControlFecha).Color := ColorRequerido;

    // Aborto y espero nueva interaccion del usuario
    Abort;

  end
  else
    begin
      case TipoValidacionFecha of
        Menor:
        begin
          // Ahora comparo que no sea mayor a la fecha menor
          if TUniDateTimePicker(ControlFecha).DateTime < FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;

        Menor_o_Igual:
        begin
          // Ahora comparo que no sea menor a la fecha menor o igual
          if TUniDateTimePicker(ControlFecha).DateTime <= FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;

        Mayor_o_Igual :
        begin
          // Ahora comparo que no sea mayor a la fecha mayor o igual
          if TUniDateTimePicker(ControlFecha).DateTime >= FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;

        Mayor :
        begin
          // Ahora comparo que no sea mayor a la fecha mayor
          if TUniDateTimePicker(ControlFecha).DateTime > FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;
      end;


      // Dependiendo del valor del campo auxiliar
      if ResultadoOK = False then
      begin
        {$IFDEF WEB}
        // Muestro el mensaje de validacion
        MessageDlg(MensajeValidacion, mtError, [mbOK]);
        {$ENDIF}

        {$IFDEF DESKTOP}
        MessageDlg(MensajeValidacion, mtError, [mbOK], 0);
        {$ENDIF}

        // Recorro y pinto los objetos visuales
        ControlFecha.SetFocus;
        ControlFecha.Color := ColorRequerido;

        // Aborto y espero nueva interaccion del usuario
        Abort;
      end;
    end;
end;

procedure ValidarRangoNumeros(Formulario: TCustomForm; Campo: TField; CantidadMinima, CantidadMaxima: Double; MensajeValidacion: string);
begin
  ValidarCampo(Formulario, Campo, MensajeValidacion);

  // Verifico el tamano del campo
  if not((Campo.AsFloat >= CantidadMinima ) and (Campo.AsFloat <= CantidadMaxima )) then
  begin
    // Muestro el mensaje de validacion
    (Formulario as TUniForm).MessageDlg('El valor debe estar entre ' + FloatToStr(CantidadMinima) + ' y ' + FloatToStr(CantidadMaxima), mtError, [mbOK]);

    RecorrerPintarControlesVisuales(Formulario, Campo);
    // Aborto y espero nueva interaccion del usuario
    Abort;
  end;
end;
{$ENDIF}


function NumeroDocumento(DocumentoNumeroAnho: string): TNumeroDocumento;
begin

  if Pos('/', DocumentoNumeroAnho) <> 0 then
  begin
    // Obtengo el prefijo del documento
    Result.Prefijo := StripNonConforming(DocumentoNumeroAnho, ['-', 'A' .. 'Z', 'a' .. 'z']);

    // Guardo Auxiliarmente el dato del numero de documento
    Result.NumeroAnho := Trim(StringReplace(DocumentoNumeroAnho, Result.Prefijo, '', []));

    // Obtengo el a�o del la cadena
    Result.Numero := StrToInt(LeftStr(Result.NumeroAnho, Pos('/', Result.NumeroAnho) - 1));
    Result.NumeroAsString := IntToStr(Result.Numero);

    // Obtengo el a�o del la cadena
    Result.AnhoAsString := AnsiRightStr(Result.NumeroAnho, (Length(Result.NumeroAnho) - (Pos('/', Result.NumeroAnho))));
    Result.Anho := StrToInt(Result.AnhoAsString);

    // Refactorizado al final
    // Comento esta linea, por si tenga 00 enfrente
    //Result.NumeroAnho := Trim(Result.NumeroAsString + '/' + Result.AnhoAsString);
    Result.NumeroDocumento := Trim(Result.Prefijo + ' ' + Result.NumeroAnho);
  end;

end;


function ValidarDocumentoNumeroAnho(DocumentoNumeroAnho: string): Boolean;
const
  Digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '/'];
var
  i: integer;
  Anho: string;
begin

  // Establezco el valor inicial
  Result := False;

  // Recorro el string y verifico que contenga los caracteres soportados
  for i := 1 to Length(DocumentoNumeroAnho) do
  begin

    if DocumentoNumeroAnho[i] in Digits then
    begin

      // Verifico que tenga la / del documento
      if Pos('/', DocumentoNumeroAnho) <> 0 then
      begin
        // Obtengo el a�o del la caddena
        Anho := AnsiRightStr(DocumentoNumeroAnho, (Length(DocumentoNumeroAnho) - (Pos('/', DocumentoNumeroAnho))));

        // Verifico que la cadena sea superior al a�o 1990 y menor que cinco a�os adicionales al actual
        if ((StrToInt(Anho)) > 1990) and ((StrToInt(Anho)) < (YearOf(Now) + 5)) then
        begin
           // Esta ok
           Result := True;
        end
        else // Error en el a�o del documento
        begin
          MessageDlg('A�o de documento fuera de rango', mtError, [mbOK], 0);
          Abort;
        end;

      end
      else
      begin
        MessageDlg(EErrorFormatoNumeroDocumento, mtError, [mbOK], 0);
        Abort;
      end;

    end
    else
    begin
      MessageDlg('Error de formato', mtError, [mbOK], 0);
      Abort;
    end;
  end;

end;


function VerificarValorRepetido(Tabla: string; Parametros: array of TField; Formulario: TCustomForm;
                                Mensaje: string; AbortarSiRepetido: Boolean = True;
                                PoseeIdOrganizacion: Boolean = True; IdNoComparar: TField=nil; MostrarMensaje: Boolean = true): Boolean;
var
  i: integer;
  ClavePrimaria: string;
  x: string;
//VerificarValorRepetido('[schema].[table_name]', [Campo1,Campo2], Formulario , Mensaje , Abortar=True,PoseeIdOrganizacion=False);
begin
  // Este procedimiento verifica que no exista entre otras cosas Comprobantes con el mismo numero en la base de datos

  // Cierro el dataset principal de querys libres,
  // tambien lo limpio si hay un select anterior


  result := false;
  {$IFDEF SDAC}
  try
    DMPrincipal.MSQuerySQL.Close;
  except // En caso que ocurra una exepcion
      on E: Exception do
      begin
        {$IFDEF WEB}
          //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
          TUniForm(Formulario).MessageDlg(E.Message, mtError, [mbOK]);
         // Log(EExcepcion + E.Message);
        {$ENDIF}

        {$IFDEF DESKTOP}
          Log(EExcepcion + E.Message);
          MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
        {$ENDIF}
      end;
  end;

  DMPrincipal.MSQuerySQL.SQL.Clear;

  // Obtengo la clave primaria de la tabla en cuestion
  ClavePrimaria := ObtenerClavePrimaria(AnsiLeftStr(Tabla, (Pos('.', Tabla) - 1)), AnsiRightStr(Tabla, (Length(Tabla) - (Pos('.', Tabla)))));

  // Cargo el primer select, utilizo el IndexFieldName o Campo de Indice para seleccionar
  if PoseeIdOrganizacion then
    begin
      DMPrincipal.MSQuerySQL.SQL.Text := 'SELECT ' + ClavePrimaria + ' FROM '  + Tabla + ' WHERE IdOrganizacion = ' + IntToStr(1);

      x := 'SELECT ' + ClavePrimaria + ' FROM ' + Tabla + ' WHERE IdOrganizacion = ' + IntToStr(1);
    end
  else
    begin
        DMPrincipal.MSQuerySQL.SQL.Text:='SELECT ' + ClavePrimaria  + ' FROM ' + Tabla + ' WHERE '+IntToStr(1)+'=' + IntToStr(1);
    end;

  // Recorro el array de Parametros y asigno los valores al query de consulta de verificacion
  for i := 0 to High(Parametros) do
  begin
      // Agrego el nombre del campo correspondiente al query
      x:= x +  ' AND ' + Parametros[i].FieldName + ' = ';
      DMPrincipal.MSQuerySQL.SQL.Text := DMPrincipal.MSQuerySQL.SQL.Text + ' AND ' + Parametros[i].FieldName + ' = ';

      // Dependiendo si es integer o string
      if Parametros[i].DataType in [ ftInteger, ftSmallint] then
      begin
        x:= x + Parametros[i].AsString;
        DMPrincipal.MSQuerySQL.SQL.Text := DMPrincipal.MSQuerySQL.SQL.Text + Parametros[i].AsString;
      end;

      if Parametros[i].DataType = ftString then
      begin
        // En caso que sea un string agrego el #39 para las comillas
        DMPrincipal.MSQuerySQL.SQL.Text := DMPrincipal.MSQuerySQL.SQL.Text + chr(39) +(Parametros[i].AsString) + chr(39);
      end;
  end;


  if IdNoComparar <> nil then
  begin
    // Agrego el nombre del campo correspondiente al query
    DMPrincipal.MSQuerySQL.SQL.Text := DMPrincipal.MSQuerySQL.SQL.Text + ' AND ' + IdNoComparar.FieldName + ' <> ';

    // Dependiendo si es integer o string
    if IdNoComparar.DataType = ftInteger then
    begin
      DMPrincipal.MSQuerySQL.SQL.Text := DMPrincipal.MSQuerySQL.SQL.Text + IdNoComparar.AsString;
    end;

    if IdNoComparar.DataType = ftString then
    begin
      // En caso que sea un string agrego el #39 para las comillas
      DMPrincipal.MSQuerySQL.SQL.Text := DMPrincipal.MSQuerySQL.SQL.Text + chr(39) +(IdNoComparar.AsString) + chr(39);
    end;

  end;

  // Abro el dataset
  try
    DMPrincipal.MSQuerySQL.Open;
  except
    on E: Exception do
      begin
        {$IFDEF WEB}
          //UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
          TUniForm(Formulario).MessageDlg(E.Message, mtError, [mbOK]);
          //Log(EExcepcion + E.Message);
        {$ENDIF}

        {$IFDEF DESKTOP}
          Log(EExcepcion + E.Message);
          MessageDlg(EExcepcion + E.Message, mtError, [mbOK], 0);
        {$ENDIF}

        //Log('VerificarValorRepetido - DMPrincipal.MSQuerySQL '+DMPrincipal.MSQuerySQL.SQL.Text);
      end;
  end;

  // En caso que exista al menos un registro
  if DMPrincipal.MSQuerySQL.RecordCount >= 1 then
    begin

        // Verifico que no se trate de la misma operaci�n que se esta editando
        if (DMPrincipal.MSQuerySQL.FieldByName(ClavePrimaria).Value) <>  (Parametros[0].DataSet.FieldByName(ClavePrimaria).Value) then
        begin

          // En caso del parametro sea verdadero
          if MostrarMensaje= True then
          begin
            // Visualizo mensaje de error y aborto
            {$IFDEF WEB}
            TUniForm(Formulario).MessageDlg(Mensaje, mtError, [mbOK]);
            {$ENDIF}

            {$IFDEF DESKTOP}
            MessageDlg(Mensaje, mtError, [mbOK], 0);
            {$ENDIF}
          end;

          if AbortarSiRepetido = True then
          begin
            Abort;
          end;
           result := True;
        end;
    end;
  {$ENDIF}
end;



procedure ValidarCampo(Formulario: TCustomForm; Campo: TField;
MensajeValidacion: string; TipoValidacion: TTipoValidacion = Nulo;  Abortar: Boolean = True;
MsgDlgType : TMsgDlgType = mtError);
var
  ResultadoOK: Boolean;
begin

  // Una variable auxiliar para validar
  ResultadoOK := True;

  case TipoValidacion of

    Nulo:
    begin
      // En caso que el campo tenga un valor nulo
      if Campo.IsNull = true then
      begin
        ResultadoOK := False;
      end;
    end;

    StringVacio:
    begin
      if Campo.DataType = ftString then
      begin
        if Campo.AsString = '' then
        begin
          ResultadoOK := False;
        end;
      end;
    end;

    EnteroCero:
    begin

      if Campo.DataType = ftInteger then
      begin
        if Campo.AsInteger = 0 then
        begin
          ResultadoOK := False;
        end;
      end;

      if Campo.DataType = ftFloat then
      begin
        if Campo.AsFloat = 0 then
        begin
          ResultadoOK := False;
        end;
      end;

    end;

  end;

  // Dependiendo del resultado esperado
  if ResultadoOK = False then
  begin
    // Recorro y pintos los objetos visuales
    RecorrerPintarControlesVisuales(Formulario, Campo);

    {$IFDEF WEB}
    // Muestro el mensaje de validacion
    (Formulario as TUniForm).MessageDlg(MensajeValidacion, MsgDlgType, [mbOK]);

    {$IFDEF DEBUG}
    //Log('UnitValidaciones - ValidarCampo '+ (Formulario as TUniForm).Name );
    {$ENDIF}
    {$ENDIF}

    {$IFDEF DESKTOP}
    MessageDlg(MensajeValidacion, MsgDlgType, [mbOK], 0);
    {$ENDIF}

    // Aborto y espero nueva interaccion del usuario
    if Abortar = True then
    begin
      Abort;
    end;
  end;

end;


procedure ValidarCampoFecha(Formulario: TCustomForm; CampoFecha: TDateTimeField; FechaComparacion: TDateTime; MensajeValidacion: string; TipoValidacionFecha: TTipoValidacionFecha);
//Ej.
//ValidarCampoFecha(Frm, CampoDesde, CampoHasta.Value, EFechaInicioMayorFin, Mayor);
var
  ResultadoOK: Boolean;
begin
  // Este procedimiento valida que un campo de fecha no pueda ser menor o mayor a una fecha establecida al campo FechaMenor

  // Una variable auxiliar para validar
  ResultadoOK := True;

  // En caso que el campo fecha no tenga un valor nulo
  if CampoFecha.IsNull = True then
  begin
    {$IFDEF WEB}
    // Muestro el mensaje de validacion
    (Formulario as TUniForm).MessageDlg(ESeleccioneFecha, mtError, [mbOK]);
    {$ENDIF}

    {$IFDEF DESKTOP}
    MessageDlg(MensajeValidacion, mtError, [mbOK], 0);
    {$ENDIF}

    // Recorro y pintos los objetos visuales
    RecorrerPintarControlesVisuales(Formulario, CampoFecha);

    // Aborto y espero nueva interaccion del usuario
    Abort;

  end
  else
    begin
      case TipoValidacionFecha of
        Menor:
        begin
          // Ahora comparo que la fecha no sea menor a la fecha de comparacion
          if CampoFecha.Value < FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;

        Menor_o_Igual:
        begin
          // Ahora comparo que la fecha no sea menor o igual a la fecha de comparacion
          if CampoFecha.Value <= FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;

        Mayor:
        begin
          // Ahora comparo que la fecha no sea mayor a la fecha de comparacion
          if CampoFecha.Value > FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;

        Mayor_o_Igual:
        begin
          // Ahora comparo que la fecha no sea mayor o igual a la fecha de comparacion
          if CampoFecha.Value >= FechaComparacion then
          begin
            ResultadoOK := False;
          end;
        end;
      end;


      // Dependiendo del valor del campo auxiliar
      if ResultadoOK = False then
      begin
        {$IFDEF WEB}
        // Muestro el mensaje de validacion
        (Formulario as TUniForm).MessageDlg(MensajeValidacion, mtError, [mbOK]);
        {$ENDIF}

        {$IFDEF DESKTOP}
        MessageDlg(MensajeValidacion, mtError, [mbOK], 0);
        {$ENDIF}

        // Recorro y pintos los objetos visuales
        RecorrerPintarControlesVisuales(Formulario, CampoFecha);

        {$IFDEF DEBUG}
        //Log('ValidarCampoFecha '+MensajeValidacion + ' - '+  Formulario.Name + ' - ' +  CampoFecha.Name + ' :  '+ CampoFecha.AsString );
        {$ENDIF}

        // Aborto y espero nueva interaccion del usuario
        Abort;
      end;
    end;
end;



procedure RecorrerPintarControlesVisuales(Formulario: TCustomForm; Campo: TField);
begin

  ModificarControl(Formulario,
    procedure (const AControl: TControl)
    var
    PropInfo: PPropInfo;
    begin

      {$IFDEF DESKTOP}
      case AnsiIndexStr(AControl.ClassName, [TcxDBTextEdit.ClassName,       {0}
                                             TcxDBLookupComboBox.ClassName, {1}
                                             TcxDBDateEdit.ClassName,       {2}
                                             TcxDBTimeEdit.ClassName,       {3}
                                             TcxDBMemo.ClassName,           {4}
                                             TcxDBCheckBox.ClassName,       {5}
                                             TcxDBSpinEdit.ClassName,       {6}
                                             TcxDBComboBox.ClassName,       {7}
                                             TcxDBButtonEdit.ClassName]) of {8}

        0 .. 8: // TcxDBTextEdit
        begin
          // Obtengo las propiedades llamadas Databinding
          PropInfo := GetPropInfo(AControl.ClassInfo, 'DataBinding');

          // Si la propiedad existe
          if PropInfo <> nil then
          begin

            // Verifico que sea campo igual a la propiedad
            if TcxDBTextEditDataBinding(GetObjectProp(AControl, 'DataBinding')).DataField = Campo.FieldName then
            begin
               // Hacer foco al Control seleccionado
              if TcxCustomEdit(AControl).CanFocus = True then
              begin
                TcxCustomEdit(AControl).SetFocus;
              end;

              // Cambio el Color
              TcxCustomEdit(AControl).Style.Color := ColorRequerido;
            end;

          end;

        end;

      end;
      {$ENDIF}

      {$IFDEF WEB}
      case AnsiIndexStr(AControl.ClassName, [TUniDBEdit.ClassName,            {0}
                                             TUniDBLookupComboBox.ClassName,  {1}
                                             TUniDBDateTimePicker.ClassName,  {2}
                                             TUniDBMemo.ClassName,            {3}
                                             TUniDBCheckBox.ClassName,        {4}
                                             TUniDBNumberEdit.ClassName,      {5}
                                             TUniDBFormattedNumberEdit.ClassName,  {6}
                                             TUniDBComboBox.ClassName]) of         {7}

        0 .. 7: // Todos los controles
        begin

          // Verifico si el Control soporta la interfaz de DB
          if Supports(AControl, IUniDBControl) then
          begin

            // Si el campo es igual
            if (AControl as IUniDBControl).DataField = Campo.FieldName then
            begin

              // En caso que el objeto se encuentre en Tab, se hace que sea activo (funciona para casos que estan
              // inclusive anidados
              // En caso que el objeto se encuentre en Tab, se hace que sea activo
              if AControl.Parent.ClassName = TUniTabSheet.ClassName then
              begin
                (AControl.Parent.Parent as TUniPageControl).ActivePage := (AControl.Parent as TUniTabSheet);
              end;

              // No borrar este codigo, ya que funciona tambien en modo clasico, pero via Javascript es mas rapido
              {if AControl.Parent.Parent.ClassName = TUniTabSheet.ClassName then
              begin
                (AControl.Parent.Parent.Parent as TUniPageControl).ActivePage := (AControl.Parent.Parent as TUniTabSheet);
              end;

              if GetParentTab(AControl, True).ClassName = TUniTabSheet.ClassName then
              begin
                (GetParentTab(AControl, True).Parent as TUniPageControl).ActivePage := GetParentTab(AControl, True);

                // Foco con VCL tradicional y color
                TUniFormControl(AControl).SetFocus;
                TUniFormControl(AControl).Color := ColorRequerido;
              end;}


              // Foco con VCL tradicional y color
              TUniFormControl(AControl).SetFocus;
              TUniFormControl(AControl).Color := ColorRequerido;

              // Foco con JS
              UniSession.AddJS('setTimeout(function(){' + TUniFormControl(AControl).JSName + '.focus()}, 100)');
            end;

          end;

        end;

      end;
      {$ENDIF}

    end);

end;


procedure RecorrerPintarRestaurarControlesVisuales(Formulario: TCustomForm);
begin

  ModificarControl(Formulario,
    procedure (const AControl: TControl)
    begin

      {$IFDEF WEB}
      if AControl.Tag = 0 then
      begin
        case AnsiIndexStr(AControl.ClassName, [TUniDBEdit.ClassName,           {0}
                                               TUniDBLookupComboBox.ClassName, {1}
                                               TUniDBDateTimePicker.ClassName, {2}
                                               TUniDBMemo.ClassName,           {3}
                                               TUniDBCheckBox.ClassName,       {4}
                                               TUniDBNumberEdit.ClassName,     {5}
                                               TUniDBFormattedNumberEdit.ClassName, {6}
                                               TUniDBComboBox.ClassName]) of        {7}

          0 .. 7:
          begin
            TUniFormControl(AControl).Color := clWhite;
          end;
        end;
      end;
      {$ENDIF}

      {$IFDEF DESKTOP}
      case AnsiIndexStr(AControl.ClassName, [TcxDBTextEdit.ClassName,
                                            TcxDBLookupComboBox.ClassName,
                                            TcxDBDateEdit.ClassName,
                                            TcxDBTimeEdit.ClassName,
                                            TcxDBMemo.ClassName,
                                            TcxDBCheckBox.ClassName,
                                            TcxDBComboBox.ClassName,
                                            TcxDBSpinEdit.ClassName,
                                            TcxDBButtonEdit.ClassName]) of

        0..8: //
        begin
          if TcxCustomEdit(AControl).Tag = 0 then
          begin
            TcxCustomEdit(AControl).Style.Color := clWhite;
          end;
        end;

      end;
      {$ENDIF}
    end);

end;


end.
