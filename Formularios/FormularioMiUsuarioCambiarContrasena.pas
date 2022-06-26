unit FormularioMiUsuarioCambiarContrasena;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniLabel, uniButton, uniGUIBaseClasses, uniEdit,
  uniBitBtn;

type
  TFrmMiUsuarioCambiarContrasena = class(TUniForm)
    txtPassword: TUniEdit;
    txtPasswordRepetir: TUniEdit;
    lblContrasena: TUniLabel;
    lblConfirmar: TUniLabel;
    txtContrasenaActual: TUniEdit;
    lblContrasenaActual: TUniLabel;
    btnAceptar: TUniBitBtn;
    btnCancelar: TUniBitBtn;
    lblFortalezaContrasena: TUniLabel;
    lblAlertaContrasenha: TUniLabel;
    procedure btnAceptarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure txtPasswordKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmMiUsuarioCambiarContrasena: TFrmMiUsuarioCambiarContrasena;

implementation

{$R *.dfm}


uses
  MainModule, uniGUIApplication, UnitRecursoString, UnitValidarUsuario,
  DataModulePrincipal, DataModuleUsuario, UnitEncriptacion, UnitValidaciones, UnitCodigosComunesFormulario;

function FrmMiUsuarioCambiarContrasena: TFrmMiUsuarioCambiarContrasena;
begin
  Result := TFrmMiUsuarioCambiarContrasena(UniMainModule.GetFormInstance(TFrmMiUsuarioCambiarContrasena));
end;

procedure TFrmMiUsuarioCambiarContrasena.btnAceptarClick(Sender: TObject);
var
  Respuesta: string;
  OK: Boolean;
begin

  ValidarVacios(txtContrasenaActual, EEscribaContrasena);
  ValidarVacios(txtPassword, EEscribaPass);
  ValidarVacios(txtPasswordRepetir, EEscribaPass);

  // Ejecuto la linea de cambio de contrasenas
  OK := CambiarContrasena(txtContrasenaActual.Text, txtPassword.Text, txtPasswordRepetir.Text, Respuesta);

  if OK = True then
  begin
    Close;
  end
  else
    begin
      txtPassword.Text := '';
      txtPasswordRepetir.Text := '';

      lblFortalezaContrasena.Text := '';
      lblAlertaContrasenha.Text := '';
    end;


end;


procedure TFrmMiUsuarioCambiarContrasena.btnCancelarClick(Sender: TObject);
begin
  Close;
end;


procedure TFrmMiUsuarioCambiarContrasena.txtPasswordKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  str1, str2: string;
begin


    VerificarFortalezaContrasena(txtPassword.Text, str2, str1);
    lblFortalezaContrasena.Caption := str1;
    lblAlertaContrasenha.Caption := str2;

    case AnsiIndexStr(str1, ['', 'Débil', 'Medio', 'Fuerte', 'Muy fuerte']) of
      0: //''
      begin

      end;

      1: //'Débil'
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
