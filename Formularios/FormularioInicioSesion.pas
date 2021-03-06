unit FormularioInicioSesion;
{$INCLUDE 'compilador.inc'}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniCheckBox, uniEdit, uniButton,
  Vcl.Imaging.pngimage, uniImage, uniGUIBaseClasses, uniLabel;

type
  TFrmLogin = class(TUniLoginForm)
    lblTituloPrincipal: TUniLabel;
    ImagenTitular: TUniImage;
    btnIniciarSesion: TUniButton;
    txtPassword: TUniEdit;
    txtUsuario: TUniEdit;
    imgPassword: TUniImage;
    imgUsuario: TUniImage;
    imgMayuscula: TUniImage;
    chkRecordarMisCredenciales: TUniCheckBox;
    lnkOlvideMiContrasena: TUniLabel;
    lnkRegistroUsuario: TUniLabel;
    lblVersion: TUniLabel;
    procedure UniLoginFormShow(Sender: TObject);
    procedure UniLoginFormCreate(Sender: TObject);
    procedure btnIniciarSesionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, UnitVersion, DataModulePrincipal, UnitVerificarModulo, UnitValidaciones, UnitRecursoString, UnitValidarUsuario;

function FrmLogin: TFrmLogin;
begin
  Result := TFrmLogin(UniMainModule.GetFormInstance(TFrmLogin));
end;

procedure TFrmLogin.btnIniciarSesionClick(Sender: TObject);
var
Resultado: Boolean;
begin
 {$IFDEF DEBUG}
  // CARGO USUARIO Admin Y CONTRASENA SI NO PUSE NADA
  if (txtUsuario.Text = '') and (txtPassword.Text = '') then
  begin
    txtUsuario.Text := DMPrincipal.CargarUsuarioContrasena.Usuario;
    txtPassword.Text := DMPrincipal.CargarUsuarioContrasena.Password;
  end;
  {$ENDIF}
    ValidarVacios(txtUsuario, EEscribaNombreUsuario);
    ValidarVacios(txtPassword, EEscribaPass);

    // Capturo el resultado
    Resultado := ValidarUsuario(txtUsuario.Text, txtPassword.Text);

    if Resultado = True then
    begin

      // Devuelvo el OK, del result para iniciar sesion
      ModalResult := mrOk;

    end
    else
      begin
        ModalResult := mrNone;
      end;
end;

procedure TFrmLogin.UniLoginFormCreate(Sender: TObject);
var
  RecuperarCredencial, RegistroUsuario: Boolean;
begin
  // Hago visualizar recuperar Credencial
  if LeerParametrosConfiguracionINI('APLICACION', 'RecuperarCredencial', False) = 'SI' then
  begin
    RecuperarCredencial := True;
    lnkOlvideMiContrasena.Visible := True;
  end
  else
    begin
      RecuperarCredencial := False;
      lnkOlvideMiContrasena.Visible := False;
    end;

    //desde la ventana inicio se puede agregar usuario
    if LeerParametrosConfiguracionINI('APLICACION', 'RegistroUsuario', False) = 'SI' then
  begin
    RegistroUsuario := True;
    lnkRegistroUsuario.Visible := True;
  end
  else
    begin
      RegistroUsuario := False;
      lnkRegistroUsuario.Visible := False;
    end;

       // Establezco el tamano de la ventana
  if (RecuperarCredencial = True) and (RegistroUsuario = True) then
  begin
    Self.Height := 270;
  end;

  // Si es uno solo hago que se centre y cambio el top
  if ((RecuperarCredencial = True) and (RegistroUsuario = False)) or
     ((RecuperarCredencial = False) and (RegistroUsuario = True)) then
  begin
    lnkOlvideMiContrasena.Top := 190;
    lnkOlvideMiContrasena.Alignment := taCenter;

    lnkRegistroUsuario.Top := 190;
    lnkRegistroUsuario.Alignment := taCenter;

    Self.Height := 270;
  end;

  if (RecuperarCredencial = False) and (RegistroUsuario = False) then
  begin
    lblVersion.Top := 185;
    Self.Height := 245;
  end;
end;

procedure TFrmLogin.UniLoginFormShow(Sender: TObject);
var
  varAplicionTitulo: string;
begin
  lblVersion.Caption := 'Versi?n ' + ObtenerVersionApp;

  // Autofoco del nombre de usuario
  txtUsuario.SetFocus;

  {$IFDEF DEBUG}
  {$IFDEF UNIGUI_VCL}
  varAplicionTitulo := 'Conectado a <b>' + DMPrincipal.MSConnection.Database + '</b>';
  lblTituloPrincipal.TextConversion := txtHTML;
  {$ENDIF}
  {$ENDIF}
    if not ((varAplicionTitulo = '') or (LowerCase(varAplicionTitulo) = 'ninguno')) then
  begin
    lblTituloPrincipal.Caption := varAplicionTitulo;

    case Length(lblTituloPrincipal.Caption) of
      24 .. 30:
        begin
          lblTituloPrincipal.Font.Size := lblTituloPrincipal.Font.Size - 1;
        end;

      31 .. 60:
        begin
          lblTituloPrincipal.Font.Size := lblTituloPrincipal.Font.Size - 2;
        end;

      61 .. 90:
        begin
          lblTituloPrincipal.Font.Size := lblTituloPrincipal.Font.Size - 3;
        end;

    end;
  end;


end;

initialization
  RegisterAppFormClass(TFrmLogin);

end.
