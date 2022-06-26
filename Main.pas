unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, Vcl.Menus, uniMainMenu,
  uniGUIFrame, FrameBarraMain, uniLabel, Vcl.Imaging.pngimage, uniImage,
  uniGUIBaseClasses, uniPanel, uniPageControl, uniTreeView, uniTreeMenu,
  uniImageList, Vcl.Imaging.jpeg;

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
    PanelVentanaTitulo: TUniPanel;
    lblTituloPanelVentana: TUniLabel;
    UniContainerPanel: TUniContainerPanel;
    imgFotoUsuario: TUniImage;
    UniMenuItems1: TUniMenuItems;
    HolaMundo1: TUniMenuItem;
    lblCerrarSesion: TUniLabel;
    imgLogout: TUniImage;
    mnuHerramientas: TUniMenuItem;
    mnuHerramientasFicheroUsuario: TUniMenuItem;
    UniNativeImageList: TUniNativeImageList;
    procedure UniFormShow(Sender: TObject);
    procedure mnuHerramientasUsuariosClick(Sender: TObject);
    procedure mnuHerramientasOrganizacionClick(Sender: TObject);
    procedure Usuarios1Click(Sender: TObject);
    procedure UniFormAfterShow(Sender: TObject);
    procedure Organizacin1Click(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure mnuHerramientasFicheroUsuarioClick(Sender: TObject);
    procedure lblCerrarSesionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, FormularioUsuario, FormularioCRUDMaestro, UnitCodigosComunesFormulario, FormularioOrganizacion, UnitArchivos, UnitVersion, DataModuleUsuario;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.lblCerrarSesionClick(Sender: TObject);
begin
  UniApplication.UniSession.Logout;
  UniApplication.Restart;
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
end;

procedure TMainForm.Usuarios1Click(Sender: TObject);
begin
FrmUsuario.Show();
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
