object FmeBarraInformacionOrganizacionUsuario: TFmeBarraInformacionOrganizacionUsuario
  Left = 0
  Top = 0
  Width = 900
  Height = 23
  Color = clGradientInactiveCaption
  TabOrder = 0
  ParentColor = False
  ParentBackground = False
  ParentRTL = False
  object lblEtiquetaOrganizacion: TUniLabel
    Left = 7
    Top = 4
    Width = 69
    Height = 13
    Hint = ''
    Caption = 'Organizaci'#243'n'
    TabOrder = 0
  end
  object lblEtiquetaUsuario: TUniLabel
    Left = 396
    Top = 4
    Width = 40
    Height = 13
    Hint = ''
    Caption = 'Usuario'
    ParentFont = False
    TabOrder = 2
  end
  object lblOrganizacion: TUniDBText
    Left = 82
    Top = 4
    Width = 81
    Height = 13
    Hint = ''
    DataField = 'RazonSocial'
    ParentFont = False
    Font.Style = [fsBold]
  end
  object lblUsuario: TUniDBText
    Left = 442
    Top = 3
    Width = 53
    Height = 13
    Hint = ''
    DataField = 'NombreUsuario'
    DataSource = DMPrincipal.DSVerificarUsuario
    ParentFont = False
    Font.Style = [fsBold]
  end
end
