unit FrmDefinicionListaPrecios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioCRUDMaestro, uniGUIBaseClasses,
  uniImageList, uniStatusBar, FrameBarraNavegacionPrincipal, uniGUIFrame,
  FrameBarraInformacionOrganizacionUsuario, uniEdit, uniDBEdit, uniLabel,
  FrameBarraUltimaRevision;

type
  TFrmDefinicionPrecio = class(TFrmCRUDMaestro)
    UniLabel1: TUniLabel;
    txtCodigo: TUniDBEdit;
    UniLabel3: TUniLabel;
    txtDescripcion: TUniDBEdit;
    UniLabel2: TUniLabel;
    txtMoneda: TUniDBEdit;
    FmeBarraUltimaRevision: TFmeBarraUltimaRevision;
    procedure UniFormShow(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmDefinicionPrecio: TFrmDefinicionPrecio;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModulePrecios, DataModuleOrganizacion, UnitCodigosComunesDataModule;

function FrmDefinicionPrecio: TFrmDefinicionPrecio;
begin
  Result := TFrmDefinicionPrecio(UniMainModule.GetFormInstance(TFrmDefinicionPrecio));
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
