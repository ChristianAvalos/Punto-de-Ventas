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
    procedure UniFormShow(Sender: TObject);
    procedure mnuHerramientasUsuariosClick(Sender: TObject);
    procedure mnuHerramientasOrganizacionClick(Sender: TObject);
    procedure Usuarios1Click(Sender: TObject);
    procedure UniFormAfterShow(Sender: TObject);
    procedure Organizacin1Click(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure mnuHerramientasFicheroUsuarioClick(Sender: TObject);
    procedure lblCerrarSesionClick(Sender: TObject);
    procedure mnuFicherosArticulosFichaClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, FormularioUsuario, FormularioCRUDMaestro, UnitCodigosComunesFormulario, FormularioOrganizacion, UnitArchivos, UnitVersion, DataModuleUsuario,
  UnitOperacionesFotografia, FormularioFicheroArticulo, FrameFicheroArticulos;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.lblCerrarSesionClick(Sender: TObject);
begin
  UniApplication.UniSession.Logout;
  UniApplication.Restart;
end;

procedure TMainForm.mnuFicherosArticulosFichaClick(Sender: TObject);
var
Ts : TUniTabSheet;
begin
//FrmFicheroArticulos.Parent :=UniContainerPanel1;
//FrmFicheroArticulos.Show();
  Ts := UniTabSheet1.Create(self);
  Ts.PageControl :=UniPageControl1;
  Ts.Closable := True;
  Ts.Caption:='Prueba';
  //FrameArticulos.Create(self);
//  FrameArticulos.Parent:=Ts;

  UniPageControl1.ActivePage:=Ts;
end;

procedure TMainForm.mnuHerramientasFicheroUsuarioClick(Sender: TObject);
begin
FrmUsuario.Show();
end;

procedure TMainForm.mnuHerramientasOrganizacionClick(Sender: TObject);
begin
FrmOrganizacion.Show;
end;

procedure TMainForm.mnuHerramientasUsuariosClick(Sender: TObject);
begin
FrmUsuario.EnviadoDesdeFrm := 'MainForm';
FrmUsuario.show();
end;

procedure TMainForm.Organizacin1Click(Sender: TObject);
begin
FrmOrganizacion.Show;
end;

procedure TMainForm.UniFormAfterShow(Sender: TObject);
begin
     // CargarIndicadorDemo(TClasePanel(PanelModoDemo));
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
//Version de la aplicacion
lblVersion.Caption := 'Versi�n ' + ObtenerVersionApp;
end;

procedure TMainForm.UniFormShow(Sender: TObject);
begin
  // Nombre de usuario
  lblNombreApellidoUsuario.Caption := DMUsuario.UsuarioRecord.NombresApellidos;

  //Ocultos los datos innecesarios por el momento
  lblOrganigramaUsuario.Visible:= False;
  imgOrganigrama.Visible:=False;

  // Cargo la foto de la ficha del personal, si no tiene en formato estandar,
  if Assigned(DMUsuario.UsuarioRecord.Foto) then
  begin
    if DMUsuario.UsuarioRecord.Foto.IsNull = False then
    begin
      CargarFotoPerfil(TImagePerfil(imgFotoUsuario));
    end;
  end
  else
    begin
      CargarFotoPerfil(TImagePerfil(imgFotoUsuario), DMUsuario.UsuarioRecord.IdPersonal);
    end;

end;

procedure TMainForm.Usuarios1Click(Sender: TObject);
begin
FrmUsuario.Show();
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
