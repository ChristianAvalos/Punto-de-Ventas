﻿
unit FormularioUsuarioCambiarContrasena;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Data.DB,
  System.StrUtils, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes,
  uniGUIClasses, uniGUIForm, DataModulePrincipal, DataModuleUsuario,
  UnitRecursoString, UnitCodigosComunes, uniGUIAbstractClasses,
  uniLabel, uniButton, uniGUIBaseClasses, uniEdit, uniBitBtn, uniCheckBox;

type
  TFrmUsuarioCambiarContrasena = class(TUniForm)
    txtPassword: TUniEdit;
    txtPasswordRepetir: TUniEdit;
    lblContrasena: TUniLabel;
    lblConfirmar: TUniLabel;
    lnkGenerarContrasenaAleatoria: TUniLabel;
    btnAceptar: TUniBitBtn;
    btnCancelar: TUniBitBtn;
    lblFortalezaContrasena: TUniLabel;
    lblAlertaContrasenha: TUniLabel;
    chkNotificar: TUniCheckBox;
    procedure btnAceptarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure lnkGenerarContrasenaAleatoriaClick(Sender: TObject);
    procedure txtPasswordChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmUsuarioCambiarContrasena: TFrmUsuarioCambiarContrasena;

implementation

{$R *.dfm}

uses
  MainModule, FormularioUsuario, UnitValidarUsuario, UnitCodigosComunesString,
  UnitCodigosComunesFormulario, UnitVerificarModulo, UnitEncriptacion, UnitValidaciones;

function FrmUsuarioCambiarContrasena: TFrmUsuarioCambiarContrasena;
begin
  Result := TFrmUsuarioCambiarContrasena
    (UniMainModule.GetFormInstance(TFrmUsuarioCambiarContrasena));
end;

procedure TFrmUsuarioCambiarContrasena.btnAceptarClick(Sender: TObject);
begin
//  if chkNotificar.Checked then
//  begin
//    //ValidarCampo(Self, DMUsuario.MSUsuarioEmail, 'Email no encontrado');
//    //ValidarCampo(Self, DMUsuario.MSUsuarioEmail, 'Email no encontrado', StringVacio);
//
//   // NotificarEmailBienvenida(DMUsuario.MSUsuarioEmail.AsString,  DMUsuario.MSUsuarioNombreUsuario.AsString, txtPassword.Text, DMUsuario.MSUsuarioNombresApellidos.AsString);
//  end;

  CambiarContrasenaUsuarioActual(txtPassword.Text, txtPasswordRepetir.Text);

  // Cierro la ventanaclose;
  ModalResult := mrOk;
end;

procedure TFrmUsuarioCambiarContrasena.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmUsuarioCambiarContrasena.lnkGenerarContrasenaAleatoriaClick
  (Sender: TObject);
begin
  txtPassword.Text := CadenaAleatoria(8);
  txtPasswordRepetir.Text := txtPassword.Text;

  txtPasswordChange(nil);
end;

procedure TFrmUsuarioCambiarContrasena.txtPasswordChange(Sender: TObject);
var
  str1, str2: string;
begin
  VerificarFortalezaContrasena(txtPassword.Text, str2, str1);
  lblFortalezaContrasena.Caption := str1;
  lblAlertaContrasenha.Caption := str2;

  case AnsiIndexStr(str1, ['', 'Débil', 'Medio', 'Fuerte', 'Muy fuerte']) of
    0: // ''
      begin

      end;

    1: // 'Débil'
      begin
        lblFortalezaContrasena.Font.Color := clRed;
      end;

    2: // 'Bueno'
      begin
        lblFortalezaContrasena.Font.Color := $004080FF;
      end;

    3: // 'Fuerte'
      begin
        lblFortalezaContrasena.Font.Color := clGreen;
      end;

    4: // 'Muy fuerte'
      begin
        lblFortalezaContrasena.Font.Color := clOlive;
      end;
  end;

end;

end.
