unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, Vcl.Menus, uniMainMenu,
  uniGUIFrame, FrameBarraMain, uniLabel, Vcl.Imaging.pngimage, uniImage,
  uniGUIBaseClasses, uniPanel, uniPageControl, uniTreeView, uniTreeMenu,
  uniImageList, Vcl.Imaging.jpeg, FrameBarraNavegacionPrincipal;

type
  TProcedimiento = reference to procedure();
  TMainForm = class(TUniForm)
    PanelGeneralIzquierda: TUniPanel;
    PanelLogotipo: TUniPanel;
    imgLogotipo: TUniImage;
    lblTituloAplicacion: TUniLabel;
    lblVersion: TUniLabel;
    PanelSeparacionMenu0: TUniPanel;
    PanelMenuPrincipal: TUniPanel;
    PanelSeparacionMenu7: TUniPanel;
    UniTreeMenu: TUniTreeMenu;
    MenuPrincipalBotom: TUniPanel;
    PanelLinea: TUniPanel;
    mnuPanelAcerca: TUniPanel;
    lnkAcercaPlataformaTramiteWeb: TUniLabel;
    PanelTopUsuario: TUniPanel;
    lblNombreApellidoUsuario: TUniLabel;
    lblOrganigramaUsuario: TUniLabel;
    imgOrganigrama: TUniImage;
    UniContainerPanel: TUniContainerPanel;
    imgFotoUsuario: TUniImage;
    UniMenuItems1: TUniMenuItems;
    HolaMundo1: TUniMenuItem;
    lblCerrarSesion: TUniLabel;
    imgLogout: TUniImage;
    mnuHerramientas: TUniMenuItem;
    mnuHerramientasFicheroUsuario: TUniMenuItem;
    UniNativeImageList: TUniNativeImageList;
    mnuHerramientasOrganizacion: TUniMenuItem;
    mnuFicheros: TUniMenuItem;
    mnuFicherosArticulos: TUniMenuItem;
    mnuOperaciones: TUniMenuItem;
    Operacionesdeentrada1: TUniMenuItem;
    Operacionesdesalida1: TUniMenuItem;
    mnuFicherosArticulosFicha: TUniMenuItem;
    PanelDerecha: TUniPanel;
    PanelHbox: TUniPanel;
    PanelVbox: TUniPanel;
    PanelVentana: TUniPanel;
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniContainerPanel1: TUniContainerPanel;
    UniImage1: TUniImage;
    UniImageList1: TUniImageList;
    Definiciones1: TUniMenuItem;
    mnuDefinicionesCondiciondePago: TUniMenuItem;
    mnuDefinicionesPrecio: TUniMenuItem;
    procedure UniFormShow(Sender: TObject);
    procedure mnuHerramientasOrganizacionClick(Sender: TObject);
    procedure Usuarios1Click(Sender: TObject);
    procedure UniFormAfterShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure mnuHerramientasFicheroUsuarioClick(Sender: TObject);
    procedure lblCerrarSesionClick(Sender: TObject);
    procedure mnuFicherosArticulosFichaClick(Sender: TObject);
    procedure TabSheetClose(Sender: TObject; var AllowClose: Boolean);
    procedure imgLogotipoClick(Sender: TObject);
    procedure mnuDefinicionesCondiciondePagoClick(Sender: TObject);
    procedure mnuDefinicionesPrecioClick(Sender: TObject);

  private
    { Private declarations }
  procedure CreaMenu(Formulario:TUniForm);
  procedure EjecutarProcedimiento(NombreObjeto: string; Procedimiento: TProcedimiento);
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, FormularioUsuario, FormularioCRUDMaestro, UnitCodigosComunesFormulario, FormularioOrganizacion, UnitArchivos, UnitVersion, DataModuleUsuario,
  UnitOperacionesFotografia, FormularioFicheroArticulo, FrameFicheroArticulos, UnitMenuEventos,
  FormularioCondicionPago, FrmDefinicionListaPrecios;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.CreaMenu(Formulario: TUniForm);
var
Ts : TUniTabSheet;
Nd : TUniTreeNode;
begin
  Nd := UniTreeMenu.Selected;

  if Nd.Count = 0 then
   begin
   Ts := Nd.Data;
   if not Assigned(Ts) then
   Begin
    //Creo el nuevo tab
    Ts := TUniTabSheet.Create(Self);
    Ts.PageControl :=UniPageControl1;
    //le doy los atributos que va a mostrar
    Ts.Name:=Formulario.name;
    Ts.Closable := True;
    Ts.OnClose := TabSheetClose;
    Ts.Tag := NativeInt(Nd);
    Ts.Caption:=Formulario.Caption;
    Ts.ImageIndex := Nd.ImageIndex;

    Formulario.Parent :=TS;
    //Paso esta variable para que no se cree un tab mas si ya esta abierto
    Nd.Data:=Ts;
   end;
   UniPageControl1.ActivePage:=Ts;
   end;
end;

procedure TMainForm.lblCerrarSesionClick(Sender: TObject);
begin
  UniApplication.UniSession.Logout;
  UniApplication.Restart;
end;

procedure TMainForm.mnuFicherosArticulosFichaClick(Sender: TObject);
begin
    EjecutarProcedimiento('mnuFicherosArticulosFicha',
    procedure()
    begin
      CreaMenu(FrmFicheroArticulos);
    end);

end;

procedure TMainForm.mnuHerramientasFicheroUsuarioClick(Sender: TObject);
  procedure CargarHerramientaUsuario;
  begin
    FrmUsuario.EnviadoDesdeFrm := Self.Name;
    FrmUsuario.ShowModal;
  end;

begin

  // Verifico que en caso que sea el admin, salto de largo
  if DMUsuario.UsuarioRecord.LoginUsuario <> 'Admin' then
  begin
    // Se le tiene que pasar el nombre del objeto que se quiere verificar si tiene permiso
    // en este caso es un menu
    if DMUsuario.VerificarPrivilegios('mnuHerramientasFicheroUsuario') = True then
    begin
      CargarHerramientaUsuario;
    end;
  end
  else
    begin
      CargarHerramientaUsuario;
    end;
end;

procedure TMainForm.mnuHerramientasOrganizacionClick(Sender: TObject);
begin
  if DMUsuario.VerificarPrivilegios('mnuHerramientasOrganizacion') = True then
  begin
    FrmOrganizacion.ShowModal;
  end;
end;



procedure TMainForm.TabSheetClose(Sender: TObject; var AllowClose: Boolean);
var
  Ts : TUniTabSheet;
  Nd : TUniTreeNode;
begin
  Ts := Sender as TUniTabSheet;
  Nd := Pointer(Ts.Tag);
  if Assigned(Nd) then
  begin
    Nd.Data := nil;
    if UniTreeMenu.Selected = Nd then
      UniTreeMenu.Selected := nil;
  end;
end;

procedure TMainForm.UniFormAfterShow(Sender: TObject);
begin
     // CargarIndicadorDemo(TClasePanel(PanelModoDemo));
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin

//Version de la aplicacion
lblVersion.Caption := 'Versi?n ' + ObtenerVersionApp;
  // Creo el Arbol de menus
  Arbol := TNode<TMenuItemRecord>.Create;
  CargarMenuEstandar(UniMenuItems1.Items);


end;

procedure TMainForm.UniFormShow(Sender: TObject);
begin
  // Nombre de usuario
  lblNombreApellidoUsuario.Caption := DMUsuario.UsuarioRecord.NombresApellidos;


  //Ocultos los datos innecesarios por el momento
  lblOrganigramaUsuario.Visible:= False;
  imgOrganigrama.Visible:=False;

  // Cargo la foto del usuario, si no tiene en formato estandar,
  if Assigned(DMUsuario.UsuarioRecord.Foto) then
  begin
    if DMUsuario.UsuarioRecord.Foto.IsNull = False then
    begin
      CargarFotoPerfil(TImagePerfil(imgFotoUsuario));
    end;
    end;
  if DMUsuario.UsuarioRecord.OcultarMenuSinAcceso = True then
  begin
   OcultarMenuSinAcceso;
  end;

 //Asigno el tipo de iconito del tab home
 UniTabSheet1.ImageIndex := 31;


end;


procedure TMainForm.Usuarios1Click(Sender: TObject);
begin
FrmUsuario.Show();
end;
procedure TMainForm.EjecutarProcedimiento(NombreObjeto: string; Procedimiento: TProcedimiento);
begin

  if DMUsuario.VerificarPrivilegios(NombreObjeto) = True then
  begin
      /// Ejecuto el procedimiento
      Procedimiento;
  end;

end;

procedure TMainForm.imgLogotipoClick(Sender: TObject);
begin
  if PanelGeneralIzquierda.Width = 230 then
  begin
    PanelGeneralIzquierda.Width := 80;
    UniTreeMenu.Micro := True;
  end
  else
    begin
      PanelGeneralIzquierda.Width := 230;
      UniTreeMenu.Micro := False;
    end;
end;

procedure TMainForm.mnuDefinicionesCondiciondePagoClick(Sender: TObject);
begin
  if DMUsuario.VerificarPrivilegios('mnuDefinicionesCondiciondePago') = True then
  begin
  FrmCondiciondePago.EnviadoDesdeFrm := Self.Name;
  CreaMenu(FrmCondiciondePago);
  end;
end;

procedure TMainForm.mnuDefinicionesPrecioClick(Sender: TObject);
begin
  if DMUsuario.VerificarPrivilegios('mnuDefinicionesPrecio') = True then
  begin
  FrmDefinicionPrecio.EnviadoDesdeFrm := Self.Name;
  CreaMenu(FrmDefinicionPrecio);
  end;
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
