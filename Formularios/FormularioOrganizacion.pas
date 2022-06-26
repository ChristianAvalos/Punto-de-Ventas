unit FormularioOrganizacion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniFileUpload, uniDBNavigator,
  uniMemo, uniDBMemo, uniEdit, uniDBEdit, uniImage, uniDBImage, uniPanel,
  uniLabel, uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox,
  uniButton, FrameBarraInformacionOrganizacionUsuario, uniGUIFrame, FrameTitulo, Data.DB;

type
  TFrmOrganizacion = class(TUniForm)
    FmeTitulo: TFmeTitulo;
    btnEliminarFoto: TUniButton;
    btnSubirFoto: TUniButton;
    cboPais: TUniDBLookupComboBox;
    lblCiudad: TUniLabel;
    lblDireccion: TUniLabel;
    lblEmail: TUniLabel;
    lblFax: TUniLabel;
    lblPais: TUniLabel;
    lblRazonSocial: TUniLabel;
    lblSitioWeb: TUniLabel;
    lblTelefono: TUniLabel;
    PanelFoto: TUniPanel;
    BlobFoto: TUniDBImage;
    txtCiudad: TUniDBEdit;
    txtDireccion: TUniDBMemo;
    txtEmail: TUniDBEdit;
    txtFax1: TUniDBEdit;
    txtFax2: TUniDBEdit;
    txtRazonSocial: TUniDBEdit;
    txtSitioWeb: TUniDBEdit;
    txtTelefono1: TUniDBEdit;
    txtTelefono2: TUniDBEdit;
    UniDBNavigator: TUniDBNavigator;
    lblRuc: TUniLabel;
    txtRuc: TUniDBEdit;
    UniFileUpload: TUniFileUpload;
    FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure btnSubirFotoClick(Sender: TObject);
    procedure UniFileUploadCompleted(Sender: TObject; AStream: TFileStream);
    procedure btnEliminarFotoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmOrganizacion: TFrmOrganizacion;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModuleOrganizacion, UnitCodigosComunesDataModule, UnitOperacionesFotografia;

function FrmOrganizacion: TFrmOrganizacion;
begin
  Result := TFrmOrganizacion(UniMainModule.GetFormInstance(TFrmOrganizacion));
end;

procedure TFrmOrganizacion.btnEliminarFotoClick(Sender: TObject);
begin
  with DMOrganizacion do
  begin
    if MSOrganizacion.State = dsBrowse then
    begin
      if MSOrganizacionLogo.RecordCount > 0 then
      begin
      MSOrganizacionLogo.Edit;
      MSOrganizacionLogoLogotipo.Clear;
      MSOrganizacionLogo.Post;
      end;
    end;
  end;

end;

procedure TFrmOrganizacion.btnSubirFotoClick(Sender: TObject);
begin
  with DMOrganizacion do
  begin
    if MSOrganizacion.State = dsBrowse then
    begin
      // Subo el logotipo
      UniFileUpload.Execute;
    end;
  end;
end;

procedure TFrmOrganizacion.UniFileUploadCompleted(Sender: TObject;
  AStream: TFileStream);
begin
  // Hago post, si el dataset esta en modo edicion
  if DMOrganizacion.MSOrganizacion.State in [dsEdit, dsInsert] then
  begin
    DMOrganizacion.MSOrganizacion.Post;
  end;

  //{$IFNDEF DYNAMICSLINK}
  //WTF Separar unit de fotografias e imgenes del tema de reconocimeinto facial
  SubirFotografia(DMOrganizacion.MSOrganizacionLogo, DMOrganizacion.MSOrganizacionIdOrganizacion.Value, 'Logotipo', AStream);
 // {$ENDIF}
end;

procedure TFrmOrganizacion.UniFormCreate(Sender: TObject);
begin
  ActivarDataSets(Self.Name, [DMOrganizacion.MSOrganizacion]);
end;

procedure TFrmOrganizacion.UniFormShow(Sender: TObject);
begin
 ActivarDataSets(Self.Name, [DMOrganizacion.MSPais],  False);
end;

end.
