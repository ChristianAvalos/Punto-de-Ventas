unit FormularioProductoPrecio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioPopupCRUDMaestro, uniButton, uniBitBtn,
  uniGUIBaseClasses, uniPanel, uniEdit, uniDBEdit, uniLabel, uniMultiItem,
  uniComboBox, uniDBComboBox, uniDBLookupComboBox, uniImageList;

type
  TFrmProductoPrecio = class(TFrmPopupCRUDMaestro)
    cboPrecio: TUniDBLookupComboBox;
    lblPrecio: TUniLabel;
    UniLabel2: TUniLabel;
    cboMoneda: TUniDBLookupComboBox;
    lblMoneda: TUniLabel;
    txtMonto: TUniDBFormattedNumberEdit;
    procedure btnAceptarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmProductoPrecio: TFrmProductoPrecio;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, DataModuleProductos, DataModuleComunComercial, DataModuleComunGlobal;

function FrmProductoPrecio: TFrmProductoPrecio;
begin
  Result := TFrmProductoPrecio(UniMainModule.GetFormInstance(TFrmProductoPrecio));
end;

procedure TFrmProductoPrecio.btnAceptarClick(Sender: TObject);
begin
  inherited;

  DMProductos.MSProductoPrecios.Post;
  Close;

end;

procedure TFrmProductoPrecio.btnCancelarClick(Sender: TObject);
begin
  inherited;
  DMProductos.MSProductoPrecios.Cancel;
  //Cierro el form
  Close;
end;

end.
