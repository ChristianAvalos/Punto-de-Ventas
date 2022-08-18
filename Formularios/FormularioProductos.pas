unit FormularioProductos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, FormularioCRUDMaestro, uniGUIBaseClasses,
  uniImageList, uniStatusBar, FrameBarraNavegacionPrincipal, uniGUIFrame,
  FrameBarraInformacionOrganizacionUsuario;

type
  TFrmProductos = class(TFrmCRUDMaestro)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmProductos: TFrmProductos;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function FrmProductos: TFrmProductos;
begin
  Result := TFrmProductos(UniMainModule.GetFormInstance(TFrmProductos));
end;

end.
