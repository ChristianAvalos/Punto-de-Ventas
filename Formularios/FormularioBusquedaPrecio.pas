unit FormularioBusquedaPrecio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioBusquedaMaestro, uniButton, uniBitBtn,
  uniEdit, uniMultiItem, uniComboBox, uniLabel, uniGUIBaseClasses, uniBasicGrid,
  uniDBGrid, Vcl.Menus, uniMainMenu, uniMenuButton;

type
  TFrmBusquedaPrecio = class(TFrmBusquedaMaestro)
    procedure btnBuscarClick(Sender: TObject);
    procedure btnIraRegistroClick(Sender: TObject);
    procedure UniFormActivate(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmBusquedaPrecio: TFrmBusquedaPrecio;

implementation

{$R *.dfm}


uses
  MainModule, uniGUIApplication, DataModulePrecios;

function FrmBusquedaPrecio: TFrmBusquedaPrecio;
begin
  Result := TFrmBusquedaPrecio(UniMainModule.GetFormInstance(TFrmBusquedaPrecio));
end;


procedure TFrmBusquedaPrecio.btnBuscarClick(Sender: TObject);
begin
  inherited;

  case cboParametros.ItemIndex of
    0: // Por Codigo
      begin
        BuscarRegistro(DMPrecios.MSBuscadorPrecio, ['IdPrecio'], DMPrecios.DSBuscadorPrecio, BuscarId);
      end;

    1: // Por Descripción
      begin
        BuscarRegistro(DMPrecios.MSBuscadorPrecio, ['Descripcion'], DMPrecios.DSBuscadorPrecio, BuscarStringParcial);
      end;

  end;

end;


procedure TFrmBusquedaPrecio.btnIraRegistroClick(Sender: TObject);
begin
  inherited;
  // Dependiendo de la ventana donde se solicito la busqueda
  case AnsiIndexStr(Self.EnviadoDesdeFrm, ['FrmDefinicionPrecio']) of
    0:
      begin
        IrRegistro(DMPrecios.MSPrecio, DMPrecios.DSBuscadorPrecio, 'IdPrecio');
      end;

    -1: // Devuelvo otros resultados
      begin
        ModalResult := DevolverModalResultOK(DMPrecios.DSBuscadorPrecio);
      end;

  end;

end;


procedure TFrmBusquedaPrecio.UniFormActivate(Sender: TObject);
begin
  inherited;

  // Dependiendo de donde se envia los datos
  if Self.EnviadoDesdeFrm = 'FrmDefinicionPrecio' then
  begin
    btnIraRegistro.Caption := 'Ir a registro';
  end
  else
    begin
      btnIraRegistro.Caption := 'Seleccionar';
    end;

end;

procedure TFrmBusquedaPrecio.UniFormCreate(Sender: TObject);
begin
  inherited;
  // Parametro por defecto de busqueda
  cboParametros.ItemIndex := 0;
end;

procedure TFrmBusquedaPrecio.UniFormShow(Sender: TObject);
begin
  inherited;
//  if Parametro.ObtenerValor('PrecargaBusqueda') = 'SI' then
//  begin
//    PrecargaBusquedas(DMPrecios.MSBuscadorPrecio);
//  end;

end;

end.
