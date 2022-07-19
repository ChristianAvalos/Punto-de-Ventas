unit FormularioUsuarioPermiso;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,Data.DB,
  Vcl.Controls, Vcl.Forms, uniGUITypes, uniGUIAbstractClasses, System.StrUtils,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniBasicGrid, uniDBGrid,
  uniDBTreeGrid, uniButton, uniMultiItem, uniComboBox, uniPanel, Vcl.Menus,
  uniMainMenu, uniLabel, uniCheckBox, uniBitBtn, uniEdit, uniDBCheckBox, uniMemo,
  uniImage;

type
  TFrmUsuarioPermiso = class(TUniForm)
    tgridMenu: TUniDBTreeGrid;
    mnuPopupTipoPermiso: TUniPopupMenu;
    mnuPopupTipoPermisoSoloLectura: TUniMenuItem;
    mnuPopupTipoPermisoCompleto: TUniMenuItem;
    lnkSeleccionarTodos: TUniLabel;
    lnkDesmarcarTodos: TUniLabel;
    btnCopiarPermisoDeOtroUsuario: TUniBitBtn;
    chkOcultarMenuSinAcceso: TUniDBCheckBox;
    UniImageControles: TUniImage;
    btnAccesoControles: TUniBitBtn;
    UniImageControlesPermitidos: TUniImage;
    UniPanelBotonesVertical: TUniPanel;
    UniPanelBotonesHorizontal: TUniPanel;
    btnAceptar: TUniBitBtn;
    btnCancelar: TUniBitBtn;
    txtBusqueda: TUniEdit;
    cboModoPermiso: TUniComboBox;
    procedure UniFormShow(Sender: TObject);
    procedure tgridMenuDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
      Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
    procedure tgridMenuCellContextClick(Column: TUniDBGridColumn; X,
      Y: Integer);
    procedure mnuPopupTipoPermisoSoloLecturaClick(Sender: TObject);
    procedure mnuPopupTipoPermisoCompletoClick(Sender: TObject);
    procedure lnkSeleccionarTodosClick(Sender: TObject);
    procedure lnkDesmarcarTodosClick(Sender: TObject);
    procedure btnCopiarPermisoDeOtroUsuarioClick(Sender: TObject);
    procedure UniFormClose(Sender: TObject; var Action: TCloseAction);
    procedure UniButton2Click(Sender: TObject);
    procedure tgridMenuFieldImage(const Column: TUniDBGridColumn;
      const AField: TField; var OutImage: TGraphic; var DoNotDispose: Boolean;
      var ATransparent: TUniTransparentOption);
    procedure btnAccesoControlesClick(Sender: TObject);
    procedure tgridMenuDblClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure txtBusquedaChange(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
  private
    { Private declarations }
    FEnviadoDesdeFrm: string;
    procedure CargarMenuTipoArbol;
    procedure CargarPermisosUsuario;
    procedure ActualizarControlesPermitidos;
    procedure EstablecerTipoAcceso(TipoAcceso: string);


    procedure VistaPantallaPermisoUsuario;

  public
    { Public declarations }
    property EnviadoDesdeFrm: string read FEnviadoDesdeFrm write FEnviadoDesdeFrm;
  end;

function FrmUsuarioPermiso: TFrmUsuarioPermiso;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, Main, UnitMenuEventos,
  UnitCodigosComunes, FormularioUsuarioPermisoFormulario,
 // UnitLog,
   UnitDatos,
  UnitCodigosComunesString, DataModuleUsuario, UnitCodigosComunesDataModule,
  UnitVerificarModulo, UnitRecursoString, DataModulePrincipal,
 // FormularioUsuarioPermisoCopiarPermiso,
  UnitCodigosComunesFormulario,
  DataModuleComunUsuario, UnitSoporte;


function FrmUsuarioPermiso: TFrmUsuarioPermiso;
begin
  Result := TFrmUsuarioPermiso(UniMainModule.GetFormInstance(TFrmUsuarioPermiso));
end;

procedure TFrmUsuarioPermiso.ActualizarControlesPermitidos;
var
  TieneHijosControlesPermitidos : integer;
begin

  // Cargo los permisos disponibles del usuario y selecciono aquellos que tengan permitido
  VaciarParametros([DMUsuario.MSPermisosDisponibles]);

  DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Value := DMUsuario.MSUsuarioIdUsuario.Value;

  if (Self.EnviadoDesdeFrm = 'FrmFicheroUsuario') then
  begin //en caso de masivo
    DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Clear;
  end;

  DMUsuario.MSPermisosDisponibles.ParamByName('Modulo').Value := ObtenerNombreModulo;
  DMUsuario.MSPermisosDisponibles.ParamByName('TipoComponente').Value := 'Control';

  // Abro el dataset
  DMUsuario.MSPermisosDisponibles.Open;

  // Reseteo las variables de control auxiliar
  TieneHijosControlesPermitidos := 0;

  // Recorro el Arbol para localizar el menu y agrego el control
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    begin

      // Siempre que se trate de un control
      if Item.Data.Control = True then
      begin

        // Siempre y cuando sea dependiente del padre
        //if Item.Parent.Data.MenuItem.Name = DMComunUsuario.VTMenuObjetoComponente.Value then
        if Item.Parent.Data.ObjetoComponente = DMComunUsuario.VTMenuObjetoComponente.Value then
        begin
          // Verifico si los items sigue siendo permitido
          // Verifico si hay datos en los controles
          if DMUsuario.MSPermisosDisponibles.RecordCount > 0 then
          begin
            // Localizo y encuentro los controles permitidos
            if DMUsuario.MSPermisosDisponibles.Locate('ObjetoComponente', Item.Data.Caption, []) then
            begin
              TieneHijosControlesPermitidos := TieneHijosControlesPermitidos + 1;
            end;
          end;


        end;
      end;

    end);

  // Quito el metodo beforepost
  DMComunUsuario.VTAux.AfterPost := DMComunUsuario.VTMenu.AfterPost;
  DMComunUsuario.VTMenu.AfterPost := nil;

  // Edito y cambio los valores
  DMComunUsuario.VTMenu.Edit;
  DMComunUsuario.VTMenuControlesHijosPermitido.Value := TieneHijosControlesPermitidos;
  DMComunUsuario.VTMenu.Post;

  // Restauro los eventos
  DMComunUsuario.VTMenu.AfterPost := DMComunUsuario.VTAux.AfterPost;
end;


procedure TFrmUsuarioPermiso.btnAccesoControlesClick(Sender: TObject);
begin
  with DMComunUsuario do
  begin
    if (VTMenuObjetosHijos.Value = 0) and (VTMenuControlesHijos.Value > 0) then
    begin
      //
      FrmUsuarioPermisoFormulario.EnviadoDesdeFrm := Self.EnviadoDesdeFrm;

      FrmUsuarioPermisoFormulario.ShowModal(
        procedure(Sender: TComponent; Result:Integer)
        begin
          // Al cerrar el formulario de permisos, volver a cargar los permisos
          ActualizarControlesPermitidos;
        end);
    end;
  end;
end;


procedure TFrmUsuarioPermiso.btnAceptarClick(Sender: TObject);
begin
  if (cboModoPermiso.Text = 'Añadir Permiso') then
  begin
    ModalResult := mrYes;
  end
  else
    begin
      ModalResult := mrNone;
    end;

  Close;
end;


procedure TFrmUsuarioPermiso.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrNo;
  Close;
end;


procedure TFrmUsuarioPermiso.btnCopiarPermisoDeOtroUsuarioClick(Sender: TObject);
begin
//  FrmUsuarioPermisoCopiarPermiso.ShowModal(
//    procedure(Sender: TComponent; Result: Integer)
//    begin
//      // Refrescarla grilla
//      CargarPermisosUsuario;
//    end);
end;


procedure TFrmUsuarioPermiso.CargarMenuTipoArbol;
var
  i: integer;
begin
  // Ahora el query con los controles, para buscar en el los controles habilitados
  DMUsuario.MSPermisosDisponibles.Close;
  DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Value := DMUsuario.MSUsuarioIdUsuario.Value;

  if (Self.EnviadoDesdeFrm = 'FrmFicheroUsuario') then
  begin // en caso de masivo
    DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Clear;
  end;

  DMUsuario.MSPermisosDisponibles.ParamByName('Modulo').Value := ObtenerNombreModulo;
  DMUsuario.MSPermisosDisponibles.ParamByName('TipoComponente').Value := 'Control';

  // Abro el dataset
  ActivarDataSets(Self.Name,[DMUsuario.MSPermisosDisponibles]);

  // Cargo el menu definido en el Virtual Table para visualizar
  ActivarTablaVirtual(Self.Name, DMComunUsuario.VTMenu);

  // Quito el metodo beforepost
  DMComunUsuario.VTAux.AfterPost := DMComunUsuario.VTMenu.AfterPost;
  DMComunUsuario.VTMenu.AfterPost := nil;

  // Dehabilito los controles para optimizar
  DMComunUsuario.VTMenu.DisableControls;


  if Arbol = nil then
  begin
     Arbol := TNode<TMenuItemRecord>.Create;
  end;

  // Recorro el arbol de menu, y voy cargando objetos
  Arbol.ForEach(
    procedure(const Item: TNode<TMenuItemRecord>)
    var
      TieneObjetosHijos, TieneHijosControles, TieneHijosControlesPermitidos: integer;
    begin
      // Si no esta omitido como permiso, lo cargo
      if (Item.Data.OmitirPermiso = False) then
      begin

        DMComunUsuario.VTMenu.Append;

        // En caso que el parent no sea el principal
        if Item.Parent.Index <> -1 then
        begin
          // El IdMenu
          DMComunUsuario.VTMenuIdMenu.Value := IntToStr(Item.Level) + IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Index) + NumeroTextoOrden(Item.Index);

          // El IdMenuPadre
          case Item.Level of
            2: // Nivel 2
            begin
              DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Index);
            end;

            3: // Nivel 3 (Se agrega dos niveles de parent)
            begin
              DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Parent.Level) + IntToStr(Item.Parent.Parent.Index) + NumeroTextoOrden(Item.Parent.Index);
            end;

            4: // Nivel 4 (Se agrega tres niveles de parent)
            begin
              DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Level) + IntToStr(Item.Parent.Parent.Level) + IntToStr(Item.Parent.Parent.Index) + NumeroTextoOrden(Item.Parent.Index);
            end;
          end;

        end
        else
          begin
            // En caso que no tenga parent, o sea e principal
            DMComunUsuario.VTMenuIdMenu.Value := IntToStr(Item.Level) + IntToStr(Item.Index);
            DMComunUsuario.VTMenuIdMenuPadre.Value := IntToStr(Item.Parent.Index);
          end;


        DMComunUsuario.VTMenuObjetoComponente.Value := Item.Data.MenuItem.Name;

        DMComunUsuario.VTMenuCaption.Value := Item.Data.Caption;
        DMComunUsuario.VTMenuPermitido.Value := False;
        DMComunUsuario.VTMenuSoportaTipoAcceso.Value := Item.Data.SoportaTipoAcceso;
        DMComunUsuario.VTMenuTipoComponente.Value := TipoComponenteMenu;

        DMComunUsuario.VTMenuNivel.Value := Item.Level;

        // Si se trata del nivel 4, no se contaran los items
        TieneObjetosHijos := 0;
        TieneHijosControles := 0;
        TieneHijosControlesPermitidos := 0;

        Item.ForEach(
          procedure(const SubItem: TNode<TMenuItemRecord>)
          begin

            if SubItem.Data.OmitirPermiso = False then
            begin
              TieneObjetosHijos := TieneObjetosHijos + 1;
            end;

            if SubItem.Data.Control = True then
            begin
              TieneHijosControles := TieneHijosControles + 1;

              // Verifico si hay datos en los controles
              if DMUsuario.MSPermisosDisponibles.RecordCount > 0 then
              begin
                // Localizo y encuentro los controles permitidos
                if DMUsuario.MSPermisosDisponibles.Locate('ObjetoComponente', SubItem.Data.Caption, []) then
                begin
                  TieneHijosControlesPermitidos := TieneHijosControlesPermitidos + 1;
                end;
              end;

            end;

          end);

        DMComunUsuario.VTMenuObjetosHijos.Value := TieneObjetosHijos;
        DMComunUsuario.VTMenuControlesHijos.Value := TieneHijosControles;
        DMComunUsuario.VTMenuControlesHijosPermitido.Value := TieneHijosControlesPermitidos;

        //=================================================
        if DMComunUsuario.VTMenu.State in dsEditModes then
        begin
          DMComunUsuario.VTMenu.Post;
        end;
      end;

    end);

  // Habilito de vuelta
  DMComunUsuario.VTMenu.EnableControls;

  // Restauro los eventos
  DMComunUsuario.VTMenu.AfterPost := DMComunUsuario.VTAux.AfterPost;

end;


procedure TFrmUsuarioPermiso.CargarPermisosUsuario;
begin

  // Cargo los permisos disponibles del usuario y selecciono aquellos que tengan permitido
  DMUsuario.MSPermisosDisponibles.Close;
  DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Value := DMUsuario.MSUsuarioIdUsuario.Value;

//  if (Self.EnviadoDesdeFrm = 'FrmFicheroUsuario') then
//  begin // en caso de masivo
//    DMUsuario.MSPermisosDisponibles.ParamByName('IdUsuario').Clear;
//  end;

  DMUsuario.MSPermisosDisponibles.ParamByName('Modulo').Value := ObtenerNombreModulo;
  DMUsuario.MSPermisosDisponibles.ParamByName('TipoComponente').Value := TipoComponenteMenu;

  // Abro el dataset
  ActivarDataSets(Self.Name,[DMUsuario.MSPermisosDisponibles]);

  // Quito el metodo beforepost
  DMComunUsuario.VTAux.BeforePost := DMComunUsuario.VTMenu.BeforePost;
  DMComunUsuario.VTMenu.BeforePost := nil;

  // Deshabilito el dataset
  DMUsuario.MSPermisosDisponibles.DisableControls;

  if (DMUsuario.EnviadoDesdeFrm = 'FrmUsuario') then
  begin
    // Recorro los permisos disponibles
    while DMUsuario.MSPermisosDisponibles.Eof = False do
    begin

      // En caso de localizar un item dentro de los menus seleccionados, le marco los permisos
      if DMComunUsuario.VTMenu.Locate('ObjetoComponente', DMUsuario.MSPermisosDisponiblesObjetoComponente.Value, []) = True then
      begin

         if DMComunUsuario.VTMenu.State <> dsEdit then
         begin
            try
              DMComunUsuario.VTMenu.Edit;
              DMComunUsuario.VTMenuPermitido.Value := True;
              DMComunUsuario.VTMenuTipoAcceso.Value := DMUsuario.MSPermisosDisponiblesTipoAcceso.Value;
              DMComunUsuario.VTMenu.Post;
            except
              on E: Exception do
              begin
               // Log(EExcepcion + Self.Name + ' CargarMenuPrincipal ' + E.Message);
                MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
              end;
            end;
         end;

      end;

      // Salto al siguiente registro
      DMUsuario.MSPermisosDisponibles.Next;

    end;
  end;

   // habilito el dataset
  DMUsuario.MSPermisosDisponibles.EnableControls;


  // Restauro los eventos
  DMComunUsuario.VTMenu.BeforePost := DMComunUsuario.VTAux.BeforePost;
end;


procedure TFrmUsuarioPermiso.EstablecerTipoAcceso(TipoAcceso: string);
begin
  if DMComunUsuario.VTMenu.State <> dsEdit then
  begin
    DMComunUsuario.VTMenu.Edit;
  end;

  if (DMUsuario.EnviadoDesdeFrm = 'FrmUsuario') then
  begin
    DMComunUsuario.VTMenuPermitido.Value := True;
    DMComunUsuario.VTMenuTipoAcceso.Value := TipoAcceso;
  end;

  if DMComunUsuario.VTMenu.State in dsEditModes then
  begin
    DMComunUsuario.VTMenu.Post;
  end;

end;


procedure TFrmUsuarioPermiso.lnkDesmarcarTodosClick(Sender: TObject);
begin
  with DMComunUsuario do
  begin
    VTMenu.DisableControls;
    SeleccionarRegistros(VTMenuPermitido, False);
    VTMenu.EnableControls;
    tgridMenu.Refresh;
  end;

end;


procedure TFrmUsuarioPermiso.lnkSeleccionarTodosClick(Sender: TObject);
begin
  with DMComunUsuario do
  begin
    VTMenu.DisableControls;
    SeleccionarRegistros(VTMenuPermitido, True);
    VTMenu.EnableControls;
    tgridMenu.Refresh;
  end;
end;


procedure TFrmUsuarioPermiso.mnuPopupTipoPermisoCompletoClick(
  Sender: TObject);
begin
  EstablecerTipoAcceso(TUniMenuItem(Sender).Caption);
end;


procedure TFrmUsuarioPermiso.mnuPopupTipoPermisoSoloLecturaClick(
  Sender: TObject);
begin
  EstablecerTipoAcceso(TUniMenuItem(Sender).Caption);
end;


procedure TFrmUsuarioPermiso.tgridMenuCellContextClick(
  Column: TUniDBGridColumn; X, Y: Integer);
begin
  // Muestro el menu de permisos de acceso
  if DMComunUsuario.VTMenuSoportaTipoAcceso.Value = True then
  begin
    mnuPopupTipoPermiso.Popup(X, Y , Column.Grid);
  end;
end;


procedure TFrmUsuarioPermiso.tgridMenuDblClick(Sender: TObject);
begin
  btnAccesoControles.Click;
end;


procedure TFrmUsuarioPermiso.tgridMenuDrawColumnCell(Sender: TObject; ACol,
  ARow: Integer; Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
begin
  if DMComunUsuario.VTMenuPermitido.Value = True then
  begin
    Attribs.Font.Color := clOlive;
    Attribs.Font.Style := [fsBold];
  end;

  if Column.FieldName = 'TipoAcceso' then
  begin
    if DMComunUsuario.VTMenuSoportaTipoAcceso.Value = True then
    begin
      Attribs.Color := clInfoBk;
    end;
  end;

end;

procedure TFrmUsuarioPermiso.tgridMenuFieldImage(
  const Column: TUniDBGridColumn; const AField: TField; var OutImage: TGraphic;
  var DoNotDispose: Boolean; var ATransparent: TUniTransparentOption);
begin
  DoNotDispose := True;

  if SameText(AField.FieldName, 'Icono') then
  begin
    if AField.AsString = 'S' then
    begin
       OutImage := UniImageControles.Picture.Graphic;
    end
    else
      if AField.AsString = 'X' then
      begin
        OutImage := UniImageControlesPermitidos.Picture.Graphic;
      end;
  end;

end;


procedure TFrmUsuarioPermiso.UniButton2Click(Sender: TObject);
begin
  CargarMenuTipoArbol;
  CargarPermisosUsuario;
end;


procedure TFrmUsuarioPermiso.txtBusquedaChange(Sender: TObject);
begin
  DMComunUsuario.VTMenu.Filter := 'Caption LIKE' + QuotedStr('%' + txtBusqueda.Text + '%');
  DMComunUsuario.VTMenu.Filtered := True;
end;


procedure TFrmUsuarioPermiso.UniFormAjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
begin
  EventoAjax(Sender, Self, EventName, Params);
end;


procedure TFrmUsuarioPermiso.UniFormClose(Sender: TObject;
var Action: TCloseAction);
begin
  //Solo si le da ok
  if  (DMUsuario.EnviadoDesdeFrm = 'FrmUsuario') then
  begin
    // Al cerrar verifico si el dataset de permisos VT quedo en modo edicion
    if DMComunUsuario.VTMenu.State = dsEdit then
    begin
      DMComunUsuario.VTMenu.Post;
    end;

    // Hago post omitiendo los eventos por las dudas
    OmitirEventos_y_Ejecutar(DMUsuario.MSUsuario,
      procedure
      begin
        if DMUsuario.MSUsuario.State = dsEdit then
        begin
          DMUsuario.MSUsuario.Post;

          // Actualizo el record del usuario, si se trata del mismo usuario en edicion
          if DMUsuario.MSUsuarioIdUsuario.Value = DMUsuario.UsuarioRecord.IdUsuario
          then
          begin
            DMUsuario.UsuarioRecord.OcultarMenuSinAcceso := DMUsuario.MSUsuarioOcultarMenuSinAcceso.Value;
          end;

        end;
      end);

    // Si no ejecuta desde Documental lite, AutoservicioWeb, o TramiteWeb (o sea quienes no tengan menu estandar
    {$IF NOT (DEFINED(AUTOSERVICIOWEB) OR
              DEFINED(DOCUMENTALLITE) OR
              DEFINED(DOCUMENTALTRACK) OR
              DEFINED(CONSOLA) OR
              DEFINED(TRAMITEWEB) OR
              DEFINED(AUDITORIA) OR
              DEFINED(RAPY) OR
              DEFINED(DYNAMICSLINK) )}
        if DMUsuario.UsuarioRecord.OcultarMenuSinAcceso = True then
        begin
          OcultarMenuSinAcceso;
          //OcultarLineaMenus(MainForm.MenuPrincipal);
        end
        else
          begin
            // Visualizar todos los menus
           // MostrarTodosMenus(MainForm.UniMenuItems1);
          end;
    {$ENDIF}
  end;
end;



procedure TFrmUsuarioPermiso.UniFormCreate(Sender: TObject);
begin
 // AgregarBotonSoporte(Self);
end;


procedure TFrmUsuarioPermiso.UniFormShow(Sender: TObject);
begin
  // Personalizo la Pantalla
  DMComunUsuario.EnviadoDesdeFrm := Self.name;

  VistaPantallaPermisoUsuario;

  CargarMenuTipoArbol;

  if (DMUsuario.EnviadoDesdeFrm = 'FrmUsuario') then
  begin
    CargarPermisosUsuario;
    // No se debe Activar esta Funcionaliad
    DMComunUsuario.VTBotonAux.Close;
  end;

  if (DMUsuario.EnviadoDesdeFrm = 'FrmFicheroUsuario') then
  begin
    ActivarTablaVirtual(Self.Name, DMComunUsuario.VTBotonAux);
  end;

  // Expando el menu
  tgridMenu.FullExpand;
end;


procedure TFrmUsuarioPermiso.VistaPantallaPermisoUsuario;
begin

  case AnsiIndexStr(FrmUsuarioPermiso.EnviadoDesdeFrm, ['FrmUsuario', 'FrmFicheroUsuario']) of
    0: // FrmUsuario
    begin
      Self.Height := 634;
      UniPanelBotonesVertical.Visible := False;
      Self.BorderIcons := [biSystemMenu, biMinimize, biMaximize];
      cboModoPermiso.Visible := False;
      chkOcultarMenuSinAcceso.Top := 562;
    end;

    1: // FrmFicheroUsuario
    begin
      Self.Height := 670;
      UniPanelBotonesVertical.Visible := True;
      Self.BorderIcons := [biMinimize, biMaximize];
      cboModoPermiso.Visible := True;

      btnCopiarPermisoDeOtroUsuario.Visible := False;
      btnAccesoControles.Left := btnCopiarPermisoDeOtroUsuario.Left;
      chkOcultarMenuSinAcceso.Visible := False;
      cboModoPermiso.Top := 562;
      cboModoPermiso.Left := 393;
      cboModoPermiso.ItemIndex := 0;
    end;
  end;

end;

end.

