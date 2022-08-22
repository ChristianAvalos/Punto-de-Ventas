unit DataModuleProductos;

interface

uses
  SysUtils, Classes;

type
  TDMProductos = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DMProductos: TDMProductos;

implementation

{$R *.dfm}

uses
  UniGUIVars, uniGUIMainModule, MainModule;

function DMProductos: TDMProductos;
begin
  Result := TDMProductos(UniMainModule.GetModuleInstance(TDMProductos));
end;

initialization
  RegisterModuleClass(TDMProductos);

end.
