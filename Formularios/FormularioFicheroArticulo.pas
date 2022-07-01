unit FormularioFicheroArticulo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniLabel;

type
  TFrmFicheroArticulos = class(TUniForm)
    UniLabel1: TUniLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FrmFicheroArticulos: TFrmFicheroArticulos;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function FrmFicheroArticulos: TFrmFicheroArticulos;
begin
  Result := TFrmFicheroArticulos(UniMainModule.GetFormInstance(TFrmFicheroArticulos));
end;

end.
