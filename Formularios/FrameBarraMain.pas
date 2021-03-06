
unit FrameBarraMain;

{$INCLUDE 'compilador.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniButton, uniBitBtn,
  uniPanel;

type
  TFmeBarraMain = class(TUniFrame)
    btnCambiarMiContrasena: TUniBitBtn;
    btnCerrarSesion: TUniBitBtn;
    btnAyuda: TUniBitBtn;
    procedure btnCambiarMiContrasenaClick(Sender: TObject);
    procedure btnCerrarSesionClick(Sender: TObject);
    procedure btnAyudaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  FormularioInicioSesion, ServerModule, UniGUIApplication, uniGUIForm,
  //FormularioMiUsuarioCambiarContrasena,
  {$IFDEF DOCUMENTAL}
  DataModuleBusquedaDocumento,
  {$ENDIF}
  DataModuleUsuario, DataModulePrincipal,
  //FormularioAyuda,
  UnitRecursoString, FormularioUsuarioCambiarContrasena, FormularioMiUsuarioCambiarContrasena;

{$R *.dfm}



procedure TFmeBarraMain.btnAyudaClick(Sender: TObject);
begin
  //FrmAyuda.ShowModal();
end;


procedure TFmeBarraMain.btnCambiarMiContrasenaClick(Sender: TObject);
begin

    // Muestro el form de cambio de password
   // FrmUsuarioCambiarContrasena.ShowModal;
   FrmMiUsuarioCambiarContrasena.ShowModal;

end;


procedure TFmeBarraMain.btnCerrarSesionClick(Sender: TObject);
begin
  UniApplication.Cookies.SetCookie('_loginname', '', Date - 1);
  UniApplication.Cookies.SetCookie('_pwd', '', Date - 1);
  UniApplication.UniSession.Logout;
  UniApplication.Restart;
end;

end.
