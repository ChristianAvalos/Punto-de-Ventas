unit FormularioCondicionPago;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioCRUDMaestro, uniGUIBaseClasses,
  uniImageList, uniStatusBar, FrameBarraNavegacionPrincipal, uniGUIFrame,
  uniEdit, uniDBEdit, uniLabel,
  uniPanel, uniDBText, FrameBarraUltimaRevision,
  FrameBarraInformacionOrganizacionUsuario;

type
  TFrmCondiciondePago = class(TFrmCRUDMaestro)
    FmeBarraUltimaRevision: TFmeBarraUltimaRevision;
    Panel: TUniPanel;
    lblCodigo: TUniLabel;
    txtCodigo: TUniDBEdit;
    lblTipo: TUniLabel;
    txtTipoPago: TUniDBEdit;
    lblDescripcion: TUniLabel;
    txtDescripcion: TUniDBEdit;
    procedure UniFormShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure FmeBarraNavegacionPrincipaltbtnBuscarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmCondiciondePago: TFrmCondiciondePago;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModuleCondiciondePago, DataModuleOrganizacion,
  UnitCodigosComunesDataModule, FormularioBusquedaCondicionPago, UnitMenuEventos;

function FrmCondiciondePago: TFrmCondiciondePago;
begin
  Result := TFrmCondiciondePago(UniMainModule.GetFormInstance(TFrmCondiciondePago));
end;

procedure TFrmCondiciondePago.FmeBarraNavegacionPrincipaltbtnBuscarClick(
  Sender: TObject);
begin
  inherited;
  FrmBusquedaCondicionPago.EnviadoDesdeFrm := Self.Name;
  FrmBusquedaCondicionPago.ShowModal;
end;

procedure TFrmCondiciondePago.UniFormCreate(Sender: TObject);
begin
  inherited;
 ActivarDataSets(Self.Name, [DMOrganizacion.MSOrganizacion],  False);
end;

procedure TFrmCondiciondePago.UniFormShow(Sender: TObject);
begin
  inherited;
  IrUltimoRegistro(DMCondiciondePago.MSCondicionPago, Self);
end;

end.
