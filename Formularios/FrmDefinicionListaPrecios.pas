unit FrmDefinicionListaPrecios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioCRUDMaestro, uniGUIBaseClasses,
  uniImageList, uniStatusBar, FrameBarraNavegacionPrincipal, uniGUIFrame,
  FrameBarraInformacionOrganizacionUsuario, uniEdit, uniDBEdit, uniLabel,
  FrameBarraUltimaRevision, uniPanel;

type
  TFrmDefinicionPrecio = class(TFrmCRUDMaestro)
    FmeBarraUltimaRevision: TFmeBarraUltimaRevision;
    txtCodigo: TUniDBEdit;
    txtMoneda: TUniDBEdit;
    UniLabel1: TUniLabel;
    UniLabel3: TUniLabel;
    txtDescripcion: TUniDBEdit;
    UniLabel2: TUniLabel;
    UniPanel: TUniContainerPanel;
    procedure UniFormShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure FmeBarraNavegacionPrincipaltbtnBuscarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmDefinicionPrecio: TFrmDefinicionPrecio;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModulePrecios, DataModuleOrganizacion, UnitCodigosComunesDataModule, FormularioBusquedaPrecio;

function FrmDefinicionPrecio: TFrmDefinicionPrecio;
begin
  Result := TFrmDefinicionPrecio(UniMainModule.GetFormInstance(TFrmDefinicionPrecio));
end;

procedure TFrmDefinicionPrecio.FmeBarraNavegacionPrincipaltbtnBuscarClick(
  Sender: TObject);
begin
  inherited;
  FrmBusquedaPrecio.EnviadoDesdeFrm:=Self.Name;
  FrmBusquedaPrecio.ShowModal;
end;

procedure TFrmDefinicionPrecio.UniFormCreate(Sender: TObject);
begin
  inherited;
  ActivarDataSets(Self.Name, [DMOrganizacion.MSOrganizacion],  False);
end;

procedure TFrmDefinicionPrecio.UniFormShow(Sender: TObject);
begin
  inherited;

  IrUltimoRegistro(DMPrecios.MSPrecio, Self);
end;

end.
