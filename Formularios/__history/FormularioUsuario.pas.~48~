unit FormularioUsuario;
{$INCLUDE 'compilador.inc'}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioCRUDMaestro, uniGUIBaseClasses,
  uniImageList, uniStatusBar, FrameBarraNavegacionPrincipal, uniGUIFrame,
  FrameBarraInformacionOrganizacionUsuario, uniButton, uniBitBtn, uniDBText,
  uniMemo, uniDBMemo, uniCheckBox, uniDBCheckBox, uniEdit, uniDBEdit, uniLabel,
  Vcl.Menus, uniMainMenu, uniMenuButton, Data.DB,
  uniImage, uniDBImage, uniFileUpload, FrameBarraUltimaRevision, uniPanel;

type
    TFrmUsuario = class(TFrmCRUDMaestro)
    lblCodigo: TUniLabel;
    txtCodigo: TUniDBEdit;
    txtUsuario: TUniDBEdit;
    lblNombresyApellidos: TUniLabel;
    txtNombresApellidos: TUniDBEdit;
    txtEmail: TUniDBEdit;
    lblElmail: TUniLabel;
    lblDocumentoNro: TUniLabel;
    txtDocumentoNro: TUniDBEdit;
    chkActivo: TUniDBCheckBox;
    lblObservacion: TUniLabel;
    txtObservacion: TUniDBMemo;
    lblContrasena: TUniLabel;
    lblContrasenaEstablecida: TUniDBText;
    btnSubirFoto: TUniBitBtn;
    btnEliminarFoto: TUniBitBtn;
    lblUsuario: TUniLabel;
    btnCambiarContrasena: TUniMenuButton;
    mnuCambiarContrasena: TUniPopupMenu;
    mnuContraseapordefecto: TUniMenuItem;
    UniFileUpload: TUniFileUpload;
    PanelFoto: TUniPanel;
    BlobFoto: TUniDBImage;
    btnPermisos: TUniMenuButton;
    procedure UniFormShow(Sender: TObject);
    procedure mnuContraseapordefectoClick(Sender: TObject);
    procedure btnCambiarContrasenaClick(Sender: TObject);
    procedure UniFormActivate(Sender: TObject);
    procedure UniFileUploadCompleted(Sender: TObject; AStream: TFileStream);
    procedure btnSubirFotoClick(Sender: TObject);
    procedure btnEliminarFotoClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure btnPermisosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmUsuario: TFrmUsuario;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModuleUsuario, DataModulePrincipal, UnitCodigosComunesDataModule, UnitValidarUsuario,
  FormularioUsuarioCambiarContrasena, DataModuleOrganizacion, UnitServerModule, ServerModule,
  {$IFNDEF DYNAMICSLINK}
   UnitOperacionesFotografia,
   {$ENDIF}
  UnitRecursoString, LuxandFaceSDK, FormularioUsuarioPermiso;

function FrmUsuario: TFrmUsuario;
begin
  Result := TFrmUsuario(UniMainModule.GetFormInstance(TFrmUsuario));
end;

procedure TFrmUsuario.btnCambiarContrasenaClick(Sender: TObject);
begin
  inherited;
     if DMUsuario.MSUsuario.State = dsBrowse then
  begin
      // Solo se puede cambiar contrasena de un usuarioa activo
      if DMUsuario.MSUsuarioActivo.Value = True then
      begin
        FrmUsuarioCambiarContrasena.ShowModal;
      end
      else
        begin
          MessageDlg('Solo se puede cambiar usuario activo', mtWarning, [mbOK]);
        end;

  end;
end;

procedure TFrmUsuario.btnEliminarFotoClick(Sender: TObject);
begin
  inherited;
    with DMUsuario do
  begin
    if MSUsuario.RecordCount > 0 then
    begin
      MSUsuario.Edit;
      MSUsuarioFoto.Clear;
      MSUsuario.Post;
    end;
  end;
end;

procedure TFrmUsuario.btnPermisosClick(Sender: TObject);
begin
  inherited;
  // Verificar que no se encuentre en modo edicion o insercion
  if DMUsuario.MSUsuario.State in dsEditModes then
  begin
    DMUsuario.MSUsuario.Post;
  end;
  FrmUsuarioPermiso.EnviadoDesdeFrm := Self.Name;
  FrmUsuarioPermiso.BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  FrmUsuarioPermiso.ShowModal;
end;

procedure TFrmUsuario.btnSubirFotoClick(Sender: TObject);
begin
  inherited;
    // Subo foto
  if DMUsuario.MSUsuario.State in [dsEdit, dsBrowse] then
  begin
    UniFileUpload.Execute;
  end
  else
    begin
      Self.MessageDlg(EModoNoEidicion, mtWarning, [mbOK]);
    end;
end;

procedure TFrmUsuario.mnuContraseapordefectoClick(Sender: TObject);
begin
  inherited;
  if DMUsuario.MSUsuario.State = dsBrowse then
  begin
      // Solo se puede cambiar contrasena de un usuarioa activo
      if DMUsuario.MSUsuarioActivo.Value = True then
      begin
        // 'Admin' & 'Otros Usuarios'
        if (DMUsuario.MSUsuarioNombreUsuario.Value = 'Admin') then
        begin
          CambiarContrasenaUsuarioActual('#password#', '#password#');

          MessageDlg('Cambiado con exito' + Char(13) + 'Admin', mtConfirmation, [mbOK]);
        end
        else
          begin
            CambiarContrasenaUsuarioActual('123456', '123456');

            MessageDlg('Cambiado con exito' + Char(13) + 'Por defecto 123456', mtConfirmation, [mbOK]);
          end;
      end
      else
        begin
          MessageDlg('Solo puede cambiar contrasena usuario activo', mtConfirmation, [mbOK]);
        end;


  end;
end;

procedure TFrmUsuario.UniFileUploadCompleted(Sender: TObject;
  AStream: TFileStream);
{$IFNDEF DYNAMICSLINK}
var
  ArchivoTmpDestino: string;
  FaceRecord: TFaceRecord;
  CampoBlob: TBlobField;
  BlobStream: TStream;
  {$ENDIF}
begin

  {$IFNDEF DYNAMICSLINK}
  if DMUsuario.MSUsuario.RecordCount > 0 then
  begin
    // Establezco donde se guardara el archivo
    ArchivoTmpDestino := UniServerModule.LocalCachePath + UniApplication.UniSession.SessionId + IntToStr(Random(10000));

    // Guardo el archivo en un lugar temporalmente
    CopyFile(PChar(AStream.FileName), PChar(ArchivoTmpDestino + '.jpg'), False);

    // Recorto el rostro del archivo, y guardo el resultante en la base de datos
    if CrearRecorteRostro(ArchivoTmpDestino + '.jpg', ArchivoTmpDestino + 'crop_.jpg') = true then
    begin

      // Edito el dataset y cargo el archivo de foto
      DMUsuario.MSUsuario.Edit;
      DMUsuario.MSUsuarioFoto.LoadFromFile(ArchivoTmpDestino + 'crop_.jpg');

      // Obtengo el template del rostro y guardo en la base de datos
      // Como pudo recortar tambien puedo extraer el template
      FaceRecord := ExtraerTemplate(ArchivoTmpDestino + 'crop_.jpg');

        // Si el template es OK guardo
        if FaceRecord.Mensaje = 'Template OK' then
        begin
          try
            // Guardo el mensaje y el record
            CampoBlob := DMUsuario.MSUsuario.FieldByName('Template') as TBlobField;
            BlobStream := DMUsuario.MSUsuario.CreateBlobStream(CampoBlob, bmWrite);

            // Grabo en Stream con el record
            try
              BlobStream.Write(FaceRecord.Template, SizeOf(FaceRecord.Template));
            finally
              BlobStream.Free;
            end;

          except // Capturo excepcion
            on E: Exception do
            begin
             // UniServerModule.Logger.AddLog(EExcepcion, UniApplication.RemoteAddress + ' - ' + E.ClassName + ' - ' + E.Message);
              FrmUsuario.MessageDlg(EExcepcion + E.Message, mtError, [mbOK]);
            end;

          end;
        end;

      //Hago post al dataset
      DMUsuario.MSUsuario.Post;

    end;

  end;

  {$ENDIF}
end;

procedure TFrmUsuario.UniFormActivate(Sender: TObject);
begin
  inherited;
 DMUsuario.EnviadoDesdeFrm := Self.Name;
end;

procedure TFrmUsuario.UniFormCreate(Sender: TObject);
begin
  inherited;
  {$IFNDEF DYNAMICSLINK}
  // Activo la licencia del recortador de fotos
  InicializarLicencia;
  {$ENDIF}
end;

procedure TFrmUsuario.UniFormShow(Sender: TObject);
begin
  inherited;
  ActivarDataSets(Self.Name, [DMOrganizacion.MSOrganizacion],  False);
  IrUltimoRegistro(DMUsuario.MSUsuario, Self);
end;

end.
