

unit FrameBarraInformacionOrganizacionUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uniGUITypes, uniGUIFrame, DBCtrls,
  UniDBText,  StdCtrls, UniLabel, uniGUIAbstractClasses,
  uniGUIForm, uniGUIBaseClasses,
  uniDBEdit, uniDBMemo, uniDBLookupComboBox, uniDBDateTimePicker, uniCanvas,
  uniGUIClasses;

type
  TFmeBarraInformacionOrganizacionUsuario = class(TUniFrame)
    lblEtiquetaOrganizacion: TUniLabel;
    lblEtiquetaUsuario: TUniLabel;
    lblOrganizacion: TUniDBText;
    lblUsuario: TUniDBText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  DataModulePrincipal;

{ TFmeBarraInformacionOrganizacionUsuario }


end.
