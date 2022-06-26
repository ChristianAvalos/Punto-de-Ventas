

unit UnitCodigosComunesFormulario;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, System.Classes, Vcl.Forms, System.TypInfo, Vcl.Controls,
  Vcl.Graphics, System.StrUtils, System.IOUtils, System.Math,
  System.DateUtils, Data.DB, MSAccess, System.Variants,

  {$IFDEF WEB}
  MainModule, ServerModule, UniGuiApplication, Main, uniFileUpload,
  uniGUIForm, uniDBMemo,uniDBGrid, uniDBCheckBox, uniLabel, uniMenuButton,
  UniDBEdit, UniDBLookupComboBox, UniDBDateTimePicker, uniDBComboBox,
  uniImage, FormularioCRUDMaestro, uniStatusBar,uniButton,
  uniEdit, uniCombobox, uniMemo, uniCheckBox, uniGUIFrame,
  uniDateTimePicker, uniGuiTypes, UniRadioButton, uniGroupBox,
  uniGUIAbstractClasses, uniPanel, uniGuiClasses, uniImageList,
  UniSpinEdit, uniPageControl, uniBitBtn,  uniListBox,
  UniDBText,
  {$ENDIF}

  {$IF DEFINED(DESKTOP) OR
       DEFINED(SERVICE)}
  Vcl.StdCtrls, cxTextEdit, cxCalendar, cxCheckBox, cxLabel, cxDropDownEdit,
  cxDBLookupComboBox, cxButtonEdit, cxButtons, cxDBData, cxSpinEdit, cxDBEdit,
  cxDBLabel, Vcl.ExtCtrls, cxEdit, cxMemo, cxTimeEdit,
  {$ENDIF}

  {$IFDEF AUTOSERVICIODESKTOP}
  scGPControls, scGPExtControls,
  {$ENDIF}

  Rtti, System.SysUtils;

type
  TControlProc = reference to procedure (const AControl: TControl);

  {$IF DEFINED(DESKTOP) OR
       DEFINED(SERVICE)}
  TClasePanel = class(TPanel);
  {$ENDIF}

  {$IFDEF WEB}
  TClasePanel = class(TUniPanel);
  {$ENDIF}

  {$IFDEF WEB}
  procedure EstablecerTag(Formulario: TUniForm; Controles: TArray<string>; Valor: integer);

  procedure HabilitarControles(Formulario: TUniForm); overload;
  procedure DeshabilitarControles(Formulario: TUniForm); overload;

  procedure FormularioFlat(Formulario: TUniForm);
  procedure FormularioWhite(Formulario: TUniForm);
  procedure DestacarCampos(Formulario: TUniForm);

  procedure SetFocusControl(Control : TUniDBEdit);

  procedure AjustarVentanaPantallaCompleta(Formulario: TUniForm);
  procedure FrameWhite(Frame: TUniFrame);
  procedure CerrarFormulariosAbiertos(Formulario: TUniForm);
  procedure EventoClienteMenuPanel(ArregloPanel: array of TUniPanel);

  procedure EstablecerDesdeHastaSegunCombo (combo: TUniComboBox; dtpDesde, dtpHasta: TUniDateTimePicker);

  procedure GuardarFilasSeleccionadas (grilla: TUniDBGrid;var ListaDondeGuardar: TStringList; NombreDelCampoAGuardar: string);

  procedure PermitirEnterMemo(Memo : array of TControl);
  {$ENDIF}

  procedure LimpiarControles(Controles: array of TControl);
  procedure HabilitarControles(Controles: array of TControl; PropiedadEnabled: Boolean = False); overload;
  procedure DeshabilitarControles(Controles: array of TControl; PropiedadEnabled: Boolean = False); overload;

  procedure EstadoControles(Checked: Boolean; Controles: array of TControl; PropiedadEnabled: Boolean = False);
  procedure CargarIndicadorDemo(Panel: TClasePanel);

  function GetWebColor(pColor: string): string;
  procedure ModificarControl(const AControl: TControl; const ARef: TControlProc);


  {$IFDEF WEB}
  procedure colorButtons(pForm: TUniForm); overload;
  procedure colorButtons(pForm: TUniFrame); overload;

  procedure MoveAnimation_FORM( moveobj: TUniForm; leftfrom: Integer; leftto: Integer; topfrom: Integer; topto, duration, opacity: Integer);
  function GetParentTab(Control: TControl; TopForm: Boolean = True): TUniTabSheet;
  procedure LocalizarEspanolUniFileUpload(Formulario: TUniForm);
  {$ENDIF}

  {$IFDEF AUDITORIA}
  procedure Mensaje(pMensaje: string = ''; pTipo: string = 'info');
  procedure MensajeError(pMensaje: string);
  procedure MensajeSiNo(pMensaje: string);
  {$ENDIF}

  {$IFDEF AUTOSERVICIODESKTOP}
  procedure TipeoTexto(Sender: TObject; Control: TWinControl);
  {$ENDIF}

  {$IFDEF DESKTOP}
  procedure ScaleForm(F: TForm);
  function CentreLeft(fw: integer): integer;
  function CentreTop(fh: integer): integer;
  procedure DestacarCampos(Formulario: TForm);
  {$ENDIF}

{$IFDEF AUTOSERVICIODESKTOP}
var
  ControlSeleccionado: TWinControl;
{$ENDIF}

const
  ColorTotal = $009BFFFF;
  MENU_COLOR = '$00373737';

var
  varC_Temp1: string;


implementation

uses
{$IFDEF WEB}
  FrameBarraNavegacionPrincipal,
{$ENDIF}

  {$IFDEF AUDITORIA}
  FormularioMensaje,
  {$ENDIF}

  UnitCodigosComunesString, UnitRecursoString, UnitVerificarModulo, //UnitLog,
   UnitCodigosComunes, FormularioPopupCRUDMaestro;


{$IFDEF WEB}
procedure EstablecerTag(Formulario: TUniForm; Controles: TArray<string>; Valor: integer);
var
  i, j: integer;
begin
  // Esta funcion recorre un formulario y asigna propiedades tag a los componentes del mismo
  for i := 0 to Formulario.ComponentCount - 1 do
    for j := High(Controles) downto Low(Controles) do
      if (Formulario.Components[i] is TControl) and (Formulario.Components[i].Name = Controles[j]) then
        TControl(Formulario.Components[i]).Tag := Valor;
end;


procedure DeshabilitarControles(Formulario: TUniForm);
// Desabilita los formularios para TUniForm
var
  i: integer;
begin

  // Permite las llamadas para TFrmCrudMaestro
  if Formulario is TFrmCRUDMaestro then
  begin
    TFrmCRUDMaestro(Formulario).uniStatusBar.Panels.Clear;
  end;

  // recorrer los controles
  for i := 0 to (Formulario.ComponentCount - 1) do
  begin

    case AnsiIndexStr(Formulario.Components[i].ClassName, [TUniDBEdit.ClassName, //0
                                                           TUniDBLookupComboBox.ClassName, //1
                                                           TUniDBDateTimePicker.ClassName, //2
                                                           TUniDBMemo.ClassName, //3
                                                           TUniDBCheckBox.ClassName, //4
                                                           TUniDBComboBox.ClassName, //5
                                                           TUniDBNumberEdit.ClassName, //6
                                                           TUniDBFormattedNumberEdit.ClassName, //7
                                                           TUniComboBox.ClassName, //8
                                                           TUniSpinEdit.ClassName, //9
                                                           TUniCheckBox.ClassName, //10
                                                           TUniDBHTMLMemo.ClassName , //11
                                                           TUniNumberEdit.ClassName //12
                                                           ]) of

      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12: // Todos los controles Uni
      begin

        // Establezco la propiedad ReadOnly de componentes
        case Formulario.Components[i].Tag of
          1, 2, 3, 0: SetPropAsString(Formulario.Components[i], 'ReadOnly', '1'); //True
        end;

        // Establezco los colores
        case Formulario.Components[i].Tag of
          1: // Usado principalmente para Ids
          begin
            SetPropAsString(Formulario.Components[i], 'Color', 'clMenu');
          end;

          2: // Color rojo de fondo
          begin
            SetPropAsString(Formulario.Components[i], 'Color', 'clRed');
          end;

          3: // Color amarillo para totalizadores
          begin
            SetPropAsString(Formulario.Components[i], 'Color', IntToStr(ColorTotal));
          end;

          0: // Color blanco para otros casos
          begin
            //SetPropAsString(Formulario.Components[i], 'Color', 'clWindow');
            // Por ahora es la unica manera de restaurar los eventos
            TUniControl(Formulario.Components[i]).JSInterface.JSCallDefer('inputEl.setStyle', ['background-color', ''], 10);
          end;
        end;
      end;

    end;

  end;
end;


procedure HabilitarControles(Formulario: TUniForm);
var
  i: integer;
begin
  // Permite las llamadas para TFrmCrudMaestro
  if Formulario is TFrmCRUDMaestro then
  begin
    TFrmCRUDMaestro(Formulario).uniStatusBar.Panels.Clear;
  end;

  // recorrer los controles 1
  for i := 0 to (Formulario.ComponentCount - 1) do
  begin

    case AnsiIndexStr(Formulario.Components[i].ClassName, [TUniDBEdit.ClassName, //0
                                                           TUniDBLookupComboBox.ClassName, //1
                                                           TUniDBDateTimePicker.ClassName, //2
                                                           TUniDBMemo.ClassName, //3
                                                           TUniDBCheckBox.ClassName, //4
                                                           TUniDBComboBox.ClassName, //5
                                                           TUniDBNumberEdit.ClassName, //6
                                                           TUniDBFormattedNumberEdit.ClassName, //7
                                                           TUniSpinEdit.ClassName, //8
                                                           TUniComboBox.ClassName, //9
                                                           TUniCheckBox.ClassName, //10
                                                           TUniDBHTMLMemo.ClassName, //11
                                                           TUniNumberEdit.ClassName //12
                                                           ]) of

      0 .. 12: // Todos los controles Uni
      begin
        SetPropAsString(Formulario.Components[i], 'ReadOnly', '0'); //False

        // Para los controles que son ID, siempre sera readonly
        if Formulario.Components[i].Tag = 1 then
        begin
          SetPropAsString(Formulario.Components[i], 'ReadOnly', '1'); //True
        end;

        if Formulario.Components[i].Tag = 4 then
        begin
          SetPropAsString(Formulario.Components[i], 'ReadOnly', '1'); //True
        end;
      end;

    end;

  end;
end;


procedure SetFocusControl(Control : TUniDBEdit);
begin
  UniSession.AddJS('setTimeout(function(){' + TUniFormControl(Control).JSName + '.focus()}, 100)');
end;

procedure FormularioFlat(Formulario: TUniForm);
begin
  {$IF DEFINED(RAPY) OR
       DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE)
       DEFINED(DOCUMENTALTRACK)}
       Formulario.Color := clWhite;
       FormularioWhite(Formulario);
  {$ENDIF}

  if Formulario.FindComponent('FmeBarraInformacionOrganizacionUsuario') <> nil then
  begin
    TUniFrame(Formulario.FindComponent('FmeBarraInformacionOrganizacionUsuario')).Visible := False;
  end;

  Formulario.BorderStyle := bsNone;

  // Personalizo la barra de navegacion
  {$IF DEFINED(RAPY) OR
       DEFINED(AUTOSERVICIOWEB) OR
       DEFINED(TRAMITEWEB) OR
       DEFINED(DOCUMENTALLITE)
       DEFINED(DOCUMENTALTRACK)}
  if Formulario.FindComponent('FmeBarraNavegacionPrincipal') <> nil then
  begin
    TFmeBarraNavegacionPrincipal(Formulario.FindComponent('FmeBarraNavegacionPrincipal')).UniDBNavigator.Width := 730;
    TFmeBarraNavegacionPrincipal(Formulario.FindComponent('FmeBarraNavegacionPrincipal')).tbtnBuscar.Left := 750;
    TFmeBarraNavegacionPrincipal(Formulario.FindComponent('FmeBarraNavegacionPrincipal')).SetupHackedNavigator(
    TFmeBarraNavegacionPrincipal(Formulario.FindComponent('FmeBarraNavegacionPrincipal')).UniDBNavigator,
    TFmeBarraNavegacionPrincipal(Formulario.FindComponent('FmeBarraNavegacionPrincipal')).UniImageList);
  end;
  {$ENDIF}


  Formulario.ClientEvents.ExtEvents.Add(
      'window.afterrender=function window.afterrender(sender, eOpts)'#13#10'{' +
      #13#10'  Ext.get(sender.id).el.setStyle("padding", 0);'#13#10'  Ext.get(sen' +
      'der.id).el.setStyle("border-width", 0); '#13#10'}');

end;


procedure AjustarVentanaPantallaCompleta(Formulario: TUniForm);
begin
      // Ajusto la pantalla del formulario
  Formulario.Top := 30;
  Formulario.Left := 10;
  Formulario.Height := MainForm.Height - 85;
  Formulario.Width := MainForm.Width - 30;
end;


procedure FormularioWhite(Formulario: TUniForm);
var
  i, x: integer;
begin
  // Establezco el color de fondo
  Formulario.Color := clWhite;

  // Recorro los componentes del formulario
  for i := 0 to (Formulario.ComponentCount - 1) do
  begin

    //
    case AnsiIndexStr(Formulario.Components[i].ClassName, [TUniGroupBox.ClassName, // 0
                                                           TUniPanel.ClassName, // 1
                                                           TUniFrame.ClassName, // 2
                                                           TUniContainerPanel.ClassName, // 3
                                                           TUniPageControl.ClassName]) of //4

      0, 1, 2, 3: // Todos los componentes
      begin
        SetPropAsString(Formulario.Components[i], 'Color', 'clWhite');
      end;

      4: // Uni Page
      begin
        // Recorro todas las paginas y pinto en blanco
        for x := 0 to TUniPageControl(Formulario.Components[i]).PageCount - 1 do
        begin
          TUniPageControl(Formulario.Components[i]).Pages[x].Color := clWhite;
        end
      end;
    end;

  end;
end;


procedure FrameWhite(Frame: TUniFrame);
var
  i: integer;
begin
  Frame.Color := clWhite;

  // Recorro los componentes del formulario
  for i := 0 to (Frame.ComponentCount - 1) do
  begin
    // Si es un Unipanel
    if (Frame.Components[i] is TUniPanel) then
    begin
      // Cambio de color
      TUniPanel(Frame.Components[i]).Color := clWhite;
    end;
  end;
end;


procedure DestacarCampos(Formulario: TUniForm);
var
  i: integer;
const
  FocoControl = 'function beforeinit(sender, config)'+
       '{config.focusCls=''myfield-focus''; '+
       '}';

  FocoControlFecha = 'function beforeinit(sender, config)'+
        '{config.focusCls=''myfield-focus''; '+
        'config.altFormats="dmY|m/d/Y|n/j/Y|n/j/y|m/j/y|n/d/y|m/j/Y|n/d/Y|m-d-y|m-d-Y|m/d|m-d|md|mdy|mdY|d|Y-m-d|n-j|n/j";}';

begin

  for i := 0 to Formulario.ComponentCount - 1 do
  begin

    try

      case AnsiIndexStr(Formulario.components[i].ClassName, [TUniNumberEdit.ClassName, //0
                                                             TUniFormattedNumberEdit.ClassName, //1
                                                             TUniEdit.ClassName, //2
                                                             TUniMemo.ClassName, //3
                                                             TUniComboBox.ClassName, //4
                                                             TUniDBLookupComboBox.ClassName, //5
                                                             TUniDBEdit.ClassName, //6
                                                             TUniDBComboBox.ClassName, //7
                                                             TUniDateTimePicker.ClassName, //8
                                                             TUniRadioButton.ClassName, //9
                                                             TUniDBMemo.ClassName, //10
                                                             TUniDBDateTimePicker.ClassName, //11
                                                             TUniDBNumberEdit.ClassName, // 12
                                                             TUniDBFormattedNumberEdit.ClassName, //13
                                                             TUniDBGrid.ClassName,  //14
                                                             TUniSpinEdit.ClassName //15
                                                             ]) of
        //TUniNumberEdit
        0: TUniNumberEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniFormattedNumberEdit
        1: TUniFormattedNumberEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniEdit
        2: TUniEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniMemo
        3: TUniMemo(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniComboBox
        4: TUniComboBox(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniDBLookupComboBox
        5: TUniDBLookupComboBox(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniDBEdit
        6: TUniDBEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniDBComboBox
        7: TUniDBComboBox(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniDateTimePicker
        8:
        begin
          if TUniDateTimePicker(Formulario.components[i]).Kind = tUniDate then
          begin
            TUniDateTimePicker(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;
          end
          else
            begin
              TUniDateTimePicker(Formulario.components[i]).ClientEvents.UniEvents.Values['date.beforeinit'] := FocoControlFecha;
              TUniDateTimePicker(Formulario.components[i]).ClientEvents.UniEvents.Values['time.beforeinit'] := FocoControl;
            end;
        end;

        //TUniRadioButton
        9: TUniRadioButton(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        // TUniDBMemo
        10: TUniDBMemo(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        // TUniDBDateTimePicker
        11:
        begin
          if TUniDBDateTimePicker(Formulario.components[i]).Kind = tUniDate then
          begin
            TUniDBDateTimePicker(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;
          end
          else
            begin
              TUniDBDateTimePicker(Formulario.components[i]).ClientEvents.UniEvents.Values['date.beforeInit'] := FocoControlFecha;
              TUniDBDateTimePicker(Formulario.components[i]).ClientEvents.UniEvents.Values['time.beforeInit'] := FocoControl;
            end;
        end;

        //TUniDBNumberEdit
        12: TUniDBNumberEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniDBFormattedNumberEdit
        13: TUniDBFormattedNumberEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;

        //TUniDBGrid
        //14: TUniDBGrid(Formulario.Components[i]).LoadMask.Message := EAguarde;

        //TUniDBGrid
        15: TUniSpinEdit(Formulario.components[i]).ClientEvents.UniEvents.Values['beforeinit'] := FocoControl;
      end;
    except
      on E: Exception do
      begin
         {$IFDEF DEBUG}
        // Log('UnitCodigosComunesFormulario - DestacarCampos - '+ Formulario.Name + ' - '+ Formulario.components[i].Name);
         {$ENDIF}
        // UniServerModule.Logger.AddLog(EExcepcion + ' - '+ Formulario.Name,'UnitCodigosComunesFormulario.DestacarCampos - '+Formulario.components[i].Name + ' - '+ UniApplication.RemoteAddress + E.ClassName + ' - ' + E.Message);
      end
    end;
  end;
end;


procedure CerrarFormulariosAbiertos(Formulario: TUniForm);
const
  FormulariosEstandares: TArray<string> = ['MainForm', 'FrmOrganizacion', 'FrmUsuario'];
var
  i: integer;
begin

  for i := 0 to UniSession.FormsList.Count - 1 do
  begin
    // Si el formulario que se esta llamando es el main o el propio formulario
    if (StrInArray(TUniBaseForm(UniSession.FormsList[i]).Name, FormulariosEstandares) = True)
        or
       (TUniBaseForm(UniSession.FormsList[i]).Name = Formulario.Name) then
    begin
      // No pasa nada, no cierro ningun form, porque no esta en la lista de formularios estandarizados
      // o esta llamandose a si mismo
    end
    else
      begin
        // Cierro el formulario
        TUniBaseForm(UniSession.FormsList[i]).Close;
      end;

  end;

end;


procedure EstablecerDesdeHastaSegunCombo(combo: TUniComboBox; dtpDesde, dtpHasta: TUniDateTimePicker);
begin
  {
    Este mes
    Mes pasado
    Esta semana
    Semana pasada
    Ultimos 7 días
    Ultimos 15 días
  }

  case AnsiIndexStr(combo.Text, ['Este mes', 'Mes pasado', 'Esta semana',
    'Semana pasada', 'Ultimos 7 días', 'Ultimos 15 días']) of
    0: // Este mes
      begin
        dtpDesde.DateTime := StartOfTheMonth(Now());
        dtpHasta.DateTime := EndOfTheMonth(Now());
      end;

    1: // Mes pasado
      begin
        dtpDesde.DateTime := StartOfTheMonth(IncMonth(Now(), -1));
        dtpHasta.DateTime := EndOfTheMonth(IncMonth(Now(), -1));
      end;

    2: // Esta semana
      begin
        dtpDesde.DateTime := StartOfTheWeek(Now());
        dtpHasta.DateTime := EndOfTheWeek(Now());
      end;

    3: // Semana pasada
      begin
        dtpDesde.DateTime := StartOfTheWeek(IncWeek(Now(), -1));
        dtpHasta.DateTime := EndOfTheWeek(IncWeek(Now(), -1));
      end;

    4: // Ultimos 7 días
      begin
        dtpDesde.DateTime := StartOfTheDay(IncDay(Now(), -6));
        dtpHasta.DateTime := EndOfTheDay(Now());
      end;

    5: // Ultimos 15 días
      begin
        dtpDesde.DateTime := StartOfTheDay(IncDay(Now(), -14));
        dtpHasta.DateTime := EndOfTheDay(Now());
      end;

  end;
end;

procedure GuardarFilasSeleccionadas (grilla: TUniDBGrid;var ListaDondeGuardar: TStringList; NombreDelCampoAGuardar: string);
var
i: Integer;
bm: TBookmark;
begin

  if ListaDondeGuardar = nil then ListaDondeGuardar := TStringList.Create;

  ListaDondeGuardar.Clear;

  grilla.DataSource.DataSet.DisableControls;
  if grilla.DataSource.DataSet is TMSQuery then TMSQuery(grilla.DataSource.DataSet).FetchAll := True;

  // Guardo el bookmark
  bm := grilla.DataSource.DataSet.Bookmark;

  for i := 0 to grilla.SelectedRows.Count - 1 do
  begin
    grilla.DataSource.DataSet.Bookmark := grilla.SelectedRows[i];
    ListaDondeGuardar.Add(VarToStr(grilla.DataSource.DataSet.FieldByName(NombreDelCampoAGuardar).Value));
  end;

  grilla.DataSource.DataSet.GotoBookmark(bm);

  if grilla.DataSource.DataSet is TMSQuery then TMSQuery(grilla.DataSource.DataSet).FetchAll := False;
  grilla.DataSource.DataSet.EnableControls;
end;

procedure PermitirEnterMemo(Memo : array of TControl) ;
var
  i: integer;
begin
  // se le pasa TUniMemo o TUniDBMemo
  // Asigno los eventos
  for i := Low(Memo) to High(Memo) do
  begin
    case AnsiIndexStr(Memo[i].ClassName, [TuniMemo.ClassName, TuniDBMemo.ClassName]) of
      0 , 1 :
      begin
        // Asigno los eventos
        TuniMemo(Memo[i]).ClientEvents.ExtEvents.Values['afterrender'] :=
                   'function afterrender(sender, eOpts)                    '  +
                   ' {                                                     ' +
                   '     sender.bodyEl.dom.addEventListener(               ' +
                   '     '#39'keydown'#39',                                ' +
                   '     function(e) {if (e.key=='#39'Enter'#39') {e.stopPropagation()}}       ' +
                   '     );                                                ' +
                   ' }                                                     ' ;
      end;
    end;
  end;
end;

procedure EventoClienteMenuPanel(ArregloPanel: array of TUniPanel);
var
  i: integer;
begin

  for i := 0 to High(ArregloPanel) do
    begin

      ArregloPanel[i].ClientEvents.ExtEvents.Add('mouseover=function mouseover(sender, eOpts)'#13#10'{'#13#10'   sender.addCls' +
                                                '('#39'menu_selected'#39'); '#13#10'}');

      ArregloPanel[i].ClientEvents.ExtEvents.Add('mouseout=function mouseout(sender, eOpts)'#13#10'{'#13#10'  sender.removeCls' +
                                                '('#39'menu_selected'#39'); '#13#10'}');

    end;
end;
{$ENDIF}


procedure LimpiarControles(Controles: array of TControl);
var
  i: integer;
begin
  // Recorro el arreglo y limpio los labels
  for i := 0 to High(Controles) do
  begin

    if Controles[i] <> nil then
    begin
      {$IFDEF WEB}
      // Limpio los controles
      case AnsiIndexStr(Controles[i].ClassName, [TUniLabel.ClassName, TUniEdit.ClassName,
                                                 TUniNumberEdit.ClassName, TUniComboBox.ClassName,
                                                 TUniMemo.ClassName, TUniDBEdit.ClassName,
                                                 TUniDBText.ClassName, TUniFormattedNumberEdit.ClassName]) of
        0 , 6: // TUniLabel  , TUniDBText
        begin
          TUniLabel(Controles[i]).Caption := '';
        end;

        1 , 5: // TUniEdit , TUniDBEdit
        begin
          TUniEdit(Controles[i]).Text := '';
          TUniEdit(Controles[i]).Color := clWindow;
        end;

        2, 7: // TUniNumberEdit
        begin
          TUniNumberEdit(Controles[i]).Value := 0;
          TUniNumberEdit(Controles[i]).Color := clWindow;
        end;

        3: // TUniComboBox
        begin
          TUniComboBox(Controles[i]).Text := '';
          TUniComboBox(Controles[i]).Color := clWindow;
        end;

        4: // TUniMemo
        begin
          TUniMemo(Controles[i]).Text := EmptyStr;
          TUniMemo(Controles[i]).Color := clWindow;
        end;

      end;
      {$ENDIF}


      {$IFDEF DESKTOP}
      case AnsiIndexStr(Controles[i].ClassName, [TLabel.ClassName, TcxLabel.ClassName]) of
        0: // TLabel
        begin
          TLabel(Controles[i]).Caption := '';
        end;

        1: // TcxLabel
        begin
          TcxLabel(Controles[i]).Caption := '';
        end;

      end;
      {$ENDIF}

    end;

  end;
end;


procedure HabilitarControles(Controles: array of TControl; PropiedadEnabled: Boolean = False);
var
  i: integer;
begin

  // Recorro el array y cambio las propiedades
  for i := 0 to High(Controles) do
  begin

    {$IFDEF WEB}
    case AnsiIndexStr(Controles[i].ClassName, [TUniLabel.ClassName, //0
                                               TUniEdit.ClassName, //1
                                               TUniDateTimePicker.ClassName, //2
                                               TUniButton.ClassName, //3
                                               TUniCheckBox.ClassName, //4
                                               TUniComboBox.ClassName, //5
                                               TUniDBLookupComboBox.ClassName, //6
                                               TUniMemo.ClassName, //7
                                               TUniSpinEdit.ClassName, //8
                                               TUniDBEdit.ClassName, //9
                                               TUniDBDateTimePicker.ClassName, //10
                                               TUniDBCheckBox.ClassName, //11
                                               TUniBitBtn.ClassName, //12
                                               TUniFormattedNumberEdit.ClassName, //13
                                               TUniGroupBox.ClassName ,//14
                                               TUniDBGrid.ClassName, //15
                                               TUniDBMemo.ClassName, // 16
                                               TUniMenuButton.ClassName, //17,
                                               TUniDateTimePicker.ClassName, //18
                                               TUniDBText.ClassName , //19
                                               TUniNumberEdit.ClassName, //20
                                               TUniDBFormattedNumberEdit.ClassName //21
                                               ]) of
      0: // TUniLabel
      begin
        // En caso que se trate de un link
        if TUniLabel(Controles[i]).Cursor = crHandPoint then
        begin
          TUniLabel(Controles[i]).Font.Color := clBlue;
        end
        else
          begin
            TUniLabel(Controles[i]).Font.Color := clBlack;
          end;
      end;

      1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 18, 19, 20, 21: // TUniEdit
      begin
        SetPropAsString(Controles[i], 'ReadOnly', '0'); // True

        // Si va a tocar tambien la propiedad enabled
        if PropiedadEnabled = True then
        begin
          SetPropAsString(Controles[i], 'Enabled', '1');
        end;
      end;

      3: // TUniButton
      begin
        SetPropAsString(Controles[i], 'Enabled', '1');
      end;

      14: // TUniGroupBox
      begin
        TUniGroupBox(Controles[i]).Enabled := True;
        TUniGroupBox(Controles[i]).Font.Color := clBlack;
      end;

      17: // TUniMenuButton
      begin
        TUniMenuButton(Controles[i]).Enabled := True;
        TUniMenuButton(Controles[i]).Font.Color := clBlack;
      end;

    end;
    {$ENDIF}


    {$IFDEF DESKTOP}
    case AnsiIndexStr(Controles[i].ClassName, [TLabel.ClassName, //0
                                               TcxTextEdit.ClassName, //1
                                               TcxDateEdit.ClassName, //2
                                               TcxButton.ClassName, //3
                                               TcxCheckBox.ClassName, //4
                                               TcxComboBox.ClassName, //5
                                               TcxLookupComboBox.ClassName, //6
                                               TcxButtonEdit.ClassName, //7
                                               TcxDBTextEdit.ClassName, //8
                                               TcxDBMemo.ClassName, //9
                                               TcxDBSpinEdit.ClassName, //10
                                               TcxDBCheckBox.ClassName, //11
                                               TcxDBComboBox.ClassName, //12
                                               TcxDBLookupComboBox.ClassName, //13
                                               TcxSpinEdit.ClassName, //14
                                               TcxLabel.ClassName, //15
                                               TcxDBLabel.ClassName]) of //16
      0: // TLabel
      begin
        // En caso que se trate de un link
        if TLabel(Controles[i]).Cursor = crHandPoint then
        begin
          TLabel(Controles[i]).Font.Color := clBlue;
        end
        else
          begin
            TLabel(Controles[i]).Font.Color := clBlack;
          end;
      end;

      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14: // Todos los controles
      begin
        SetPropAsString(Controles[i], 'ReadOnly', '0'); // True

        // Si va a tocar tambien la propiedad enabled
        if PropiedadEnabled = True then
        begin
          SetPropAsString(Controles[i], 'Enabled', '1');
        end;
      end;

      15, 16: // TcxLabel, TcxDBLabel
      begin
        TcxCustomEdit(Controles[i]).Style.Font.Color := clBlack;
      end;

    end;
    {$ENDIF}
  end;

end;


procedure DeshabilitarControles(Controles: array of TControl; PropiedadEnabled: Boolean = False);
var
  i: integer;
begin

  for i := 0 to High(Controles) do
  begin

    {$IFDEF WEB}
    case AnsiIndexStr(Controles[i].ClassName, [TUniLabel.ClassName, //0
                                               TUniEdit.ClassName, //1
                                               TUniDateTimePicker.ClassName, //2
                                               TUniButton.ClassName, //3
                                               TUniCheckBox.ClassName, //4
                                               TUniComboBox.ClassName, //5
                                               TUniDBLookupComboBox.ClassName, //6
                                               TUniMemo.ClassName, //7
                                               TUniSpinEdit.ClassName, //8
                                               TUniDBEdit.ClassName, //9
                                               TUniDBDateTimePicker.ClassName, //10
                                               TUniDBCheckBox.ClassName, //11
                                               TUniBitBtn.ClassName, //12
                                               TUniFormattedNumberEdit.ClassName, //13
                                               TUniGroupBox.ClassName,  //14
                                               TUniDBGrid.ClassName, //15
                                               TUniDBMemo.ClassName, //16
                                               TUniMenuButton.ClassName, // 17
                                               TUniDateTimePicker.ClassName, //18
                                               TUniDBText.ClassName , //19
                                               TUniNumberEdit.ClassName, //20
                                               TUniDBFormattedNumberEdit.ClassName //21
                                               ]) of

      0: // TUniLabel
      begin
        TUniLabel(Controles[i]).Font.Color := clSilver;
      end;

      1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 18, 19, 20, 21: // TUniEdit
      begin
        SetPropAsString(Controles[i], 'ReadOnly', '1'); // False

        // Si tambien es necesario tocar la propiedad enabled
        if PropiedadEnabled = True then
        begin
          SetPropAsString(Controles[i], 'Enabled', '0'); //
        end;

      end;

      3: // TuniButton
      begin
        SetPropAsString(Controles[i], 'Enabled', '0');
      end;

      14: //TUniGroupBox
      begin
        TUniGroupBox(Controles[i]).Enabled := False;
        TUniGroupBox(Controles[i]).Font.Color := clSilver;
      end;

      17: // TUniMenuButton
      begin
        SetPropAsString(Controles[i], 'Enabled', '0');
      end;
    end;
    {$ENDIF}


    {$IFDEF DESKTOP}
    case AnsiIndexStr(Controles[i].ClassName, [TLabel.ClassName, //0
                                               TcxTextEdit.ClassName, //1
                                               TcxDateEdit.ClassName, //2
                                               TcxButton.ClassName, //3
                                               TcxCheckBox.ClassName, //4
                                               TcxComboBox.ClassName, //5
                                               TcxLookupComboBox.ClassName, //6
                                               TcxButtonEdit.ClassName, //7
                                               TcxDBTextEdit.ClassName, //8
                                               TcxDBMemo.ClassName, //9
                                               TcxDBSpinEdit.ClassName, //10
                                               TcxDBCheckBox.ClassName, //11
                                               TcxDBComboBox.ClassName, //12
                                               TcxDBLookupComboBox.ClassName, //13
                                               TcxSpinEdit.ClassName, //14
                                               TcxLabel.ClassName, //15
                                               TcxDBLabel.ClassName]) of //16
      0: // TLabel
      begin
        TLabel(Controles[i]).Font.Color := clSilver;
      end;

      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14: // TcxTextEdit
      begin
        SetPropAsString(Controles[i], 'ReadOnly', '1'); // False

        // Si tambien es necesario tocar la propiedad enabled
        if PropiedadEnabled = True then
        begin
          SetPropAsString(Controles[i], 'Enabled', '0'); //
        end;
      end;

      15, 16: // TcxLabel, TcxDBLabel
      begin
        TcxCustomEdit(Controles[i]).Style.Font.Color := clSilver;
      end;

    end;
    {$ENDIF}

  end;
end;



procedure EstadoControles(Checked: Boolean; Controles: array of TControl; PropiedadEnabled: Boolean = False);
begin
  // Verifico si la posicion del checked
  if Checked = True then
  begin
    HabilitarControles(Controles, PropiedadEnabled);
  end
  else
    begin
      DeshabilitarControles(Controles, PropiedadEnabled);
    end;
end;


procedure CargarIndicadorDemo(Panel: TClasePanel);
var
  sConfiguracionPath: string;
  ModoDemoAux: string;
begin

  // Establezco nombre de archivo para forzar la conexion
  sConfiguracionPath := TPath.GetDirectoryName(ParamStr(0)) + TPath.DirectorySeparatorChar + 'configuracion.ini';

  if TFile.Exists(sConfiguracionPath) = True then
  begin

    // Aplicacion
    ModoDemoAux := LeerParametrosConfiguracionINI('APLICACION','ModoDemo', False);

    {$IFDEF DEBUG}
   // Log('ConfiguracionINI - CargarIndicadorDemo : ' + ModoDemoAux);
    {$ENDIF}

    Panel.Visible := False;

    if (ModoDemoAux <> '') then
    begin
      if (UpperCase(ModoDemoAux) = 'SI') then
      begin
        Panel.Visible := True;
      end;
    end;
  end;

  {$IFDEF WEB}
    {$IFDEF DEBUG}

  { Solo en Local mostrar estos datos }
  if (TUniLabel(Panel.Controls[1]).Name = 'lblModoDemo1') then
  begin
    TUniLabel(Panel.Controls[1]).Text := 'Server : ' + LeerParametrosConfiguracionINI('MSSQLSERVER', 'server', False);
    TUniLabel(Panel.Controls[2]).Text := 'Conectado a : ' + LeerParametrosConfiguracionINI('MSSQLSERVER', 'database', False);
  end;

  Panel.Visible := True;

    {$ENDIF}
  {$ENDIF}


  Panel.Align := alBottom;
end;


function GetWebColor(pColor: string): string;
var
   s1, s2, s3, s4 : string;
begin

  // $00334455
  s1 := Copy( pColor, 2, 2 );
  s2 := Copy( pColor, 4, 2 );
  s3 := Copy( pColor, 6, 2 );

  if Length( pColor ) >= 8 then
     s4 := Copy( pColor, 8, 2 )
  else
     s4 := '00';

  Result := '#' + s4 + s3 + s2;
end;


procedure ModificarControl(const AControl: TControl; const ARef: TControlProc);
var
  i : Integer;
begin
  if AControl=nil then
    Exit;
  if AControl is TWinControl then begin
    for i := 0 to TWinControl(AControl).ControlCount-1 do
      ModificarControl(TWinControl(AControl).Controls[i], ARef);
  end;
   ARef(AControl);
end;


{$IFDEF WEB}
function GetParentTab(Control: TControl; TopForm: Boolean = True): TUniTabSheet;
begin
  while (TopForm or not (Control is TUniTabSheet)) and (Control.Parent <> nil) do
    Control := Control.Parent;
  if Control is TUniTabSheet then
    Result := TUniTabSheet(Control) else
    Result := nil;
end;


procedure colorButtons(pForm : TUniForm ); overload;
var
   i: integer;
   pTipoBotao: string;
begin

     for i := 0 to pForm.ComponentCount - 1 do
     begin


       // bitBtn
       if ( pForm.Components[i] is TUniBitBtn ) then
       begin

          pTipoBotao := TUniBitBtn( pForm.Components[i] ).Caption;

          if Pos( '__' , pTipoBotao ) > 0 then
          begin

            TUniControl( pForm.Components[i] ).Caption := Copy( pTipoBotao , 1, Pos( '__' , pTipoBotao ) - 1 );

            pTipoBotao := Copy( pTipoBotao , Pos( '__' , pTipoBotao ) + 2, 50 );

            TUniBitBtn( pForm.Components[i] ).JSInterface.JSCall( 'removeCls' , [ 'disabled' ]);
            TUniBitBtn( pForm.Components[i] ).JSInterface.JSCall( 'addCls' , [ pTipoBotao ]);

            if not TUniBitBtn( pForm.Components[i] ).Enabled then
            begin
              TUniBitBtn( pForm.Components[i] ).JSInterface.JSCall( 'addCls' , [ 'disabled' ]);
            end;

          end;
       end
       else

       //button
       if ( pForm.Components[i] is TUniButton ) then
       begin

          pTipoBotao := TUniButton( pForm.Components[i] ).Caption;

          if Pos( '__' , pTipoBotao ) > 0 then
          begin

            TUniControl( pForm.Components[i] ).Caption := Copy( pTipoBotao , 1, Pos( '__' , pTipoBotao ) - 1 );

            pTipoBotao := Copy( pTipoBotao , Pos( '__' , pTipoBotao ) + 2, 50 );

            TUniButton( pForm.Components[i] ).JSInterface.JSCall( 'removeCls' , [ 'disabled' ]);
            TUniButton( pForm.Components[i] ).JSInterface.JSCall( 'addCls' , [ pTipoBotao ]);

            if not TUniButton( pForm.Components[i] ).Enabled then
            begin
              TUniButton( pForm.Components[i] ).JSInterface.JSCall( 'addCls' , [ 'disabled' ]);
            end;

          end;
       end
       else

       if ( pForm.Components[i] is TUniContainerPanel ) or ( pForm.Components[i] is TUniPanel )  then
       begin

          if Pos( 'layout' , lowercase( TUniControl( pForm.Components[i] ).Name ) ) > 0 then
          begin
            TUniControl( pForm.Components[i] ).Color := StringToColor( MENU_COLOR );
          end;

          // ajustar ARREDONDAMENTO de panels...
          //
          if ( Pos( 'padash' , lowercase( pForm.Components[i].Name ) ) > 0 ) or
             ( Pos( 'searchedit' , lowercase( pForm.Components[i].Name ) ) > 0 ) then
          begin

            if ( Pos( 'searchedit' , lowercase( pForm.Components[i].Name ) ) > 0 ) then
                varC_Temp1 := varC_Temp1;

            TUniContainerPanel( pForm.Components[i] ).JSInterface.JSCall( 'addCls' , ['clsRoundPanel']);

          end;

          if ( Pos( 'round_' , lowercase( TUniControl( pForm.Components[i] ).Hint ) ) > 0 ) then
          begin
            varC_Temp1 := Copy( lowercase( TUniControl( pForm.Components[i] ).Hint ), Pos( '_' , lowercase( TUniControl( pForm.Components[i] ).Hint ) ) + 1 , 100 );

            if varC_Temp1 = 'all' then
              varC_Temp1 := '';

            TUniContainerPanel( pForm.Components[i] ).JSInterface.JSCall( 'addCls' , ['clsRoundPanel' + varC_Temp1 ]);
          end;
       end;

     end;
end;
{$ENDIF}


{$IFDEF WEB}
procedure LocalizarEspanolUniFileUpload(Formulario: TUniForm);
var
  i: integer;
begin

  // Busco los uniUpload, y si existe alguno, voy a localizar en espanol
  for i := 0 to Formulario.ComponentCount - 1 do
  begin
    // Recorro los compoentes del formulario y si conciden con el fileupload
    if Formulario.Components[i].ClassType = TUniFileUpload then
    begin

      // Dentro de un bloque try para capturar errores
      try
        TUniFileUpload(Formulario.Components[i]).Messages.BrowseText := 'Buscar...';
        TUniFileUpload(Formulario.Components[i]).Messages.Cancel := 'Cancelar';
        TUniFileUpload(Formulario.Components[i]).Messages.MaxFilesError := 'Puede subir un máximo %d archivos';
        TUniFileUpload(Formulario.Components[i]).Messages.MaxSizeError := 'El archivo es superior al limite permitido';
        TUniFileUpload(Formulario.Components[i]).Messages.NoFileError := 'Seleccione el archivo';
        TUniFileUpload(Formulario.Components[i]).Messages.PleaseWait := 'Por favor espere...';
        TUniFileUpload(Formulario.Components[i]).Messages.Processing := 'Procesando...';
        TUniFileUpload(Formulario.Components[i]).Messages.Upload := 'Subir';
        TUniFileUpload(Formulario.Components[i]).Messages.UploadError := 'Error al Subir';
        TUniFileUpload(Formulario.Components[i]).Messages.Uploading := 'Subiendo archivo...';
        TUniFileUpload(Formulario.Components[i]).Messages.UploadTimeout := 'Tiempo de espera agotado...'

      except
        on E: Exception do
        begin
          // capturo el error
         // Log(E.Message);
        end;
      end;

    end;
  end;

end;
{$ENDIF}

{$IFDEF WEB}
procedure colorButtons( pForm : TUniFrame ); overload;
var
   I, F : integer;

   pTipoBotao : string;

begin

     for I := 0 to pForm.ComponentCount - 1 do
     begin

       if ( pForm.Components[I] is TUniBitBtn ) then
       begin

            pTipoBotao := TUniBitBtn( pForm.Components[I] ).Caption;

            if Pos( '__' , pTipoBotao ) > 0 then
            begin

                 TUniBitBtn( pForm.Components[I] ).Caption := Copy( pTipoBotao , 1, Pos( '__' , pTipoBotao ) - 1 );

                 pTipoBotao := Copy( pTipoBotao , Pos( '__' , pTipoBotao ) + 2, 50 );

                 TUniBitBtn( pForm.Components[I] ).JSInterface.JSCall( 'removeCls' , [ 'disabled' ]);
                 TUniBitBtn( pForm.Components[I] ).JSInterface.JSCall( 'addCls' , [ pTipoBotao ]);

                 if not TUniBitBtn( pForm.Components[I] ).Enabled then
                 begin
                      TUniBitBtn( pForm.Components[I] ).JSInterface.JSCall( 'addCls' , [ 'disabled' ]);
                 end;
            end;
       end
       else
       if ( pForm.Components[I] is TUniButton ) then
       begin

            pTipoBotao := TUniButton( pForm.Components[I] ).Caption;

            if Pos( '__' , pTipoBotao ) > 0 then
            begin

                 TUniButton( pForm.Components[I] ).Caption := Copy( pTipoBotao , 1, Pos( '__' , pTipoBotao ) - 1 );

                 pTipoBotao := Copy( pTipoBotao , Pos( '__' , pTipoBotao ) + 2, 50 );

                 TUniButton( pForm.Components[I] ).JSInterface.JSCall( 'removeCls' , [ 'disabled' ]);
                 TUniButton( pForm.Components[I] ).JSInterface.JSCall( 'addCls' , [ pTipoBotao ]);

                 if not TUniButton( pForm.Components[I] ).Enabled then
                 begin
                      TUniButton( pForm.Components[I] ).JSInterface.JSCall( 'addCls' , [ 'disabled' ]);
                 end;
            end;
       end
       else
       if ( pForm.Components[I] is TUniContainerPanel ) or ( pForm.Components[I] is TUniPanel ) then
       begin

          if Pos( 'layout' , lowercase( TUniControl( pForm.Components[I] ).Name ) ) > 0 then
          begin

                TUniControl( pForm.Components[I] ).Color := StringToColor( MENU_COLOR );

          end;

          // ajustar ARREDONDAMENTO de panels...
          //
          if ( Pos( 'padash' , lowercase( pForm.Components[I].Name ) ) > 0 ) or
             ( Pos( 'searchedit' , lowercase( pForm.Components[I].Name ) ) > 0 ) then
          begin

               if ( Pos( 'searchedit' , lowercase( pForm.Components[I].Name ) ) > 0 ) then
                  varC_Temp1 := varC_Temp1;


                TUniContainerPanel( pForm.Components[I] ).JSInterface.JSCall( 'addCls' , ['clsRoundPanel']);

          end;

          if ( Pos( 'round_' , lowercase( TUniControl( pForm.Components[I] ).Hint ) ) > 0 ) then
          begin

                varC_Temp1 := Copy( lowercase( TUniControl( pForm.Components[I] ).Hint ), Pos( '_' , lowercase( TUniControl( pForm.Components[I] ).Hint ) ) + 1 , 100 );

                if varC_Temp1 = 'all' then
                   varC_Temp1 := '';

                TUniContainerPanel( pForm.Components[I] ).JSInterface.JSCall( 'addCls' , ['clsRoundPanel' + varC_Temp1 ]);

          end;
       end;

     end;
end;
{$ENDIF}


{$IFDEF WEB}
procedure MoveAnimation_FORM( moveobj: TUniForm; leftfrom: Integer; leftto: Integer; topfrom: Integer; topto, duration, opacity: Integer);
var
  iDuration,
  iOpacity: Integer;
begin

  iDuration := duration;
  iOpacity  := opacity;

  UniSession.AddJS( moveobj.WebForm.JSName +
                   '.animate({ duration: ' + inttostr( iDuration ) +
                   //', to: {      x:' + inttostr( leftto  ) +            // horizontal
                   ', to: {      y:' + inttostr( topto  ) +            // vertical
                   ',      opacity: ' + inttostr( iOpacity  ) + ' } } );');
end;
{$ENDIF}

{$IFDEF AUDITORIA}
procedure Mensaje(pMensaje: string = ''; pTipo: string = 'info');
var
  cTipoMens: string;
begin

  pMensaje := '<div class="centerTxt">' + pMensaje + '</div>';
  pMensaje := StringReplace( pMensaje, #13#10 , '<br>' , [rfReplaceAll] );

  FrmMensaje.btnOk.Caption := 'Ok__BotaoAzulEscuro';
  FrmMensaje.btnNo.visible := (pTipo = 'question') or (pTipo = 'error');
  FrmMensaje.btnTicketSoporte.visible := (pTipo = 'error');

                            //  0        1        2         3         4
  case AnsiIndexStr(pTipo, ['warning', 'info', 'success', 'error', 'question']) of
    0: cTipoMens := 'Aviso';
    1: cTipoMens := 'Mensaje';
    2: cTipoMens := 'Éxito';

    3: // error
    begin
      cTipoMens := 'Ops! Error...';
      FrmMensaje.btnOk.Caption := 'Continuar__BotaoAzul';
      FrmMensaje.btnNo.Caption := 'Cancelar__BotaoVermelho';
    end;

    4: // question
    begin
      cTipoMens := 'Confirmación!';
      FrmMensaje.btnOk.Caption := 'Si__BotaoVerde';
    end;
  end;


  // Establezco el titulo
  FrmMensaje.lblTitulo.Caption := cTipoMens;

  // Cargo la imagen
  FrmMensaje.imgTipo.Picture.LoadFromFile( UniServerModule.FilesFolderPath + 'images\mensagem\' + pTipo + '.png' );


  // Formateo el HTML
  FrmMensaje.memoMensaje.HTML.Clear;
  FrmMensaje.memoMensaje.HTML.Add( '<html>' );
  FrmMensaje.memoMensaje.HTML.Add( '<body>' );
  FrmMensaje.memoMensaje.HTML.Add( '<style>' );
  FrmMensaje.memoMensaje.HTML.Add( '.centerTxt{' );

  if FrmMensaje.memoMensaje.Alignment = taLeftJustify then
    FrmMensaje.memoMensaje.HTML.Add( '  text-align: center;' )
  else
     if FrmMensaje.memoMensaje.Alignment = taRightJustify then
        FrmMensaje.memoMensaje.HTML.Add( '  text-align: right;' )
     else
        if FrmMensaje.memoMensaje.Alignment = taCenter then
          FrmMensaje.memoMensaje.HTML.Add( '  text-align: center;' );

  FrmMensaje.memoMensaje.HTML.Add( '  font-size: 14px;' );
  FrmMensaje.memoMensaje.HTML.Add( '  color: gray;' );
  FrmMensaje.memoMensaje.HTML.Add( '}' );
  FrmMensaje.memoMensaje.HTML.Add( '</style>' );

  // Agrego el mensaje en formato html
  FrmMensaje.memoMensaje.HTML.Add( pMensaje );

  // Cierro el formateo
  FrmMensaje.memoMensaje.HTML.Add( '</body>' );
  FrmMensaje.memoMensaje.HTML.Add( '</html>' );


  // En caso del tipo question, muestro em modal, caso contrario, en modal
  if pTipo = 'question' then
    FrmMensaje.ShowModal
  else
    FrmMensaje.ShowModal( procedure(Sender: TComponent; Result:Integer)
                            begin
                                //callback....nesse caso, não é necessário tratar o retorno
                            end
                            );
end;



procedure MensajeSiNo(pMensaje: string);
begin
  Mensaje(pMensaje, 'question');
end;


procedure MensajeError(pMensaje: string);
begin
  Mensaje(pMensaje, 'error');
end;
{$ENDIF}


{$IFDEF AUTOSERVICIODESKTOP}
procedure TipeoTexto(Sender: TObject; Control: TWinControl);
begin

  if Control <> nil then
  begin

    // Dependiendo de la opcion seleccionada
    case AnsiIndexStr(TWinControl(Sender).Name, ['btnBackspace', 'btnBorrar']) of
      0: // btnBackspace
      begin
        case AnsiIndexStr(Control.ClassName, ['TscGPEdit', 'TscGPPasswordEdit']) of
          0: // TscGPEdit
          begin
            TCustomEdit(Control).Text :=  Copy(TCustomEdit(Control).Text, 0, (Length(TCustomEdit(Control).Text) - 1));
          end;

          1: // TscGPPasswordEdit
          begin
            TscGPPasswordEdit(Control).Text :=  Copy(TscGPPasswordEdit(Control).Text, 0, (Length(TscGPPasswordEdit(Control).Text) - 1));
          end;
        end;
      end;

      1: // btnBorrar
      begin
        case AnsiIndexStr(Control.ClassName, ['TscGPEdit', 'TscGPPasswordEdit']) of
          0: // TscGPEdit
          begin
            TCustomEdit(Control).Text := '';
          end;

          1: // TscGPPasswordEdit
          begin
            TscGPPasswordEdit(Control).Text := '';
          end;
        end;
      end;

      else
      begin
        // Cargo el texto presionado
        case AnsiIndexStr(Control.ClassName, ['TscGPEdit', 'TscGPPasswordEdit']) of
          0: // TscGPEdit
          begin
            TCustomEdit(Control).Text := TCustomEdit(Control).Text + TscGPButton(Sender).Caption;
          end;

          1: // TscGPPasswordEdit
          begin
            if ExisteInt(TscGPButton(Sender).Caption) = True then
            begin
              TscGPPasswordEdit(Control).Text := TscGPPasswordEdit(Control).Text + TscGPButton(Sender).Caption;
            end;
          end;
        end;
      end;

    end;

    // Establezco el cursor al final del texto
    case AnsiIndexStr(Control.ClassName, ['TscGPEdit', 'TscGPPasswordEdit']) of
      0: // TscGPEdit
      begin
        TscGPEdit(Control).SelStart := Length(TscGPEdit(Control).Text);
      end;

      1: // TscGPPasswordEdit
      begin
        TscGPPasswordEdit(Control).SelStart := Length(TscGPPasswordEdit(Control).Text);
      end;
    end;

  end;
end;
{$ENDIF}


{$IFDEF DESKTOP}
procedure ScaleForm (F: TForm);
var
  scrx, scry, k:integer;
  ratio: double;
  ScreenAncho, ScreenAlto: integer;
begin
  // Obtengo los parametros del archivo de configuracion
  ScreenAncho := StrToIntDef(LeerParametrosConfiguracionINI('AUTOSERVICIO', 'ScreenAncho', False), 1024);
  ScreenAlto := StrToIntDef(LeerParametrosConfiguracionINI('AUTOSERVICIO', 'ScreenAlto', False), 768);

  scrx := GetSystemMetrics(SM_CXSCREEN); //Obtengo la resolucion de la pantalla usando X
  scry := (GetSystemMetrics(SM_CYSCREEN)); //Obtengo la resolucion de la pantalla usando Y

  // Calculo el ratio
  ratio := Min(scrx/ScreenAncho, scry/ScreenAlto);

  // Escalo a la proporcion más pequeña para que la ventana no salga de proporcion
  F.scaleby( Trunc(ratio * 100) ,100);

  // Escalo los controles y ubico en el centro del formulario
  F.Left := centreleft(F.width);
  F.Top := centretop(F.Height);
end;


function CentreLeft(fw: integer): integer;
var
  smcx: integer;
begin
  smcx := GetSystemMetrics(SM_CXSCREEN);
  CentreLeft := (smcx - fw) div 2;
end;


function CentreTop(fh: integer): integer;
// Calcula el top
var
  smcy: integer;
begin
  smcy := GetSystemMetrics(SM_CYSCREEN);
  CentreTop := (smcy - fh) div 2;
end;


procedure DestacarCampos(Formulario: TForm);
const
  ColorDestacado = $00FFFFE0;
begin

  ModificarControl(Formulario,
    procedure (const AControl: TControl)
    begin
      case AnsiIndexStr(AControl.ClassName, [TcxDBTextEdit.ClassName,    {0}
                                             TcxDBLookupComboBox.ClassName,  {1}
                                             TcxDBDateEdit.ClassName,   {2}
                                             TcxDBTimeEdit.ClassName,   {3}
                                             TcxDBMemo.ClassName,       {4}
                                             TcxDBCheckBox.ClassName,   {5}
                                             TcxDBSpinEdit.ClassName,   {6}
                                             TcxDBComboBox.ClassName,   {7}
                                             TcxDBButtonEdit.ClassName, {8}
                                             TcxTextEdit.ClassName,     {9}
                                             TcxComboBox.ClassName,     {10}
                                             TcxButtonEdit.ClassName,   {11}
                                             TcxCheckBox.ClassName,     {12}
                                             TcxMemo.ClassName,         {13}
                                             TcxDateEdit.ClassName,     {14}
                                             TcxTimeEdit.ClassName,     {15}
                                             TcxLookupComboBox.ClassName]) {16} of

        0 .. 16:
        begin
          TcxCustomTextEdit(AControl).StyleFocused.Color := ColorDestacado;
        end;

      end;
    end);

end;

{$ENDIF}

end.
