unit FormularioBusquedaCondicionPago;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioBusquedaMaestro, Vcl.Menus, uniMainMenu,
  uniMenuButton, uniButton, uniBitBtn, uniEdit, uniMultiItem, uniComboBox,
  uniLabel, uniGUIBaseClasses, uniBasicGrid, uniDBGrid, System.StrUtils;

type
  TFrmBusquedaCondicionPago = class(TFrmBusquedaMaestro)
    procedure btnBuscarClick(Sender: TObject);
    procedure btnIraRegistroClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmBusquedaCondicionPago: TFrmBusquedaCondicionPago;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModuleCondiciondePago;

function FrmBusquedaCondicionPago: TFrmBusquedaCondicionPago;
begin
  Result := TFrmBusquedaCondicionPago(UniMainModule.GetFormInstance(TFrmBusquedaCondicionPago));
end;

procedure TFrmBusquedaCondicionPago.btnBuscarClick(Sender: TObject);
begin
  inherited;
  case cboParametros.ItemIndex of
    0: // Por Codigo
      begin
       BuscarRegistro(DMCondiciondePago.MSBuscadorCondicionPago, ['IdCondicionPago'], DMCondiciondePago.DSBuscadorCondicionPago, BuscarId);
      end;

    1: // Por Descripción
      begin
        BuscarRegistro(DMCondiciondePago.MSBuscadorCondicionPago, ['Descripcion'], DMCondiciondePago.DSBuscadorCondicionPago, BuscarStringParcial);
      end;

    2: // Por Tipo
      begin
        BuscarRegistro(DMCondiciondePago.MSBuscadorCondicionPago, ['TipoCondicionPago'], DMCondiciondePago.DSBuscadorCondicionPago, BuscarStringParcial);
      end;
  end;
end;

procedure TFrmBusquedaCondicionPago.btnCerrarClick(Sender: TObject);
begin
  inherited;
//ModalResult := mrCancel;
end;

procedure TFrmBusquedaCondicionPago.btnIraRegistroClick(Sender: TObject);
begin
  // Dependiendo de la ventana donde se solicito la busqueda
  case AnsiIndexStr(Self.EnviadoDesdeFrm, ['FrmCondiciondePago']) of
    0:
      begin
        IrRegistro(DMCondiciondePago.MSCondicionPago, DMCondiciondePago.DSBuscadorCondicionPago, 'IdCondicionPago');
      end;

    -1: // Devuelvo otros resultados
      begin
        ModalResult := DevolverModalResultOK(DMCondiciondePago.DSBuscadorCondicionPago);
      end;

  end;

end;

end.
